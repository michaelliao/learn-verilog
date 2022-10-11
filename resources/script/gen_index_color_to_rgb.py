#!/usr/bin/env python3

# Full CGA 16-color palette:
# https://en.wikipedia.org/wiki/Color_Graphics_Adapter

import argparse


def main():
    parser = argparse.ArgumentParser(
        description='Generate index_color_to_rgb.v source file.')
    parser.add_argument('-w', '--width', required=True, type=int, metavar='16 or 24',
                        help='output rgb mode.')
    parser.add_argument('-o', '--output', required=True, type=str, metavar='index_color_to_rgb.v',
                        help='verilog source as output file.')
    args = parser.parse_args()
    if (args.width != 16 and args.width != 24):
        print('invalid rgb width.')
        exit(1)
    print(f'using rgb width: {args.width}')
    print(f'output file: {args.output}')

    if len(COLORS) != 16:
        print('Invalid length of COLORS.')
        exit(1)
    s = template_1
    n = 0
    for rgb, name in COLORS:
        sr = (rgb & 0xff0000) >> 16
        sg = (rgb & 0xff00) >> 8
        sb = (rgb & 0xff)
        if args.width == 24:
            s = s + \
                f'            4\'d{n}: color_rgb = 24\'b{to_bin(sr, 8)}_{to_bin(sg, 8)}_{to_bin(sb, 8)}; // #{to_rgb(rgb)} = {name}\n'
        else:
            sr = sr * 32 // 256
            sg = sg * 64 // 256
            sb = sb * 32 // 256
            s = s + \
                f'            4\'d{n}: color_rgb = 16\'b{to_bin(sr, 5)}_{to_bin(sg, 6)}_{to_bin(sb, 5)}; // #{to_rgb(rgb)} = {name}\n'
        n = n + 1

    s = s + template_2
    s = s.replace('WIDTH-1', str(int(args.width) - 1))

    print(s)

    with open(args.output, 'w') as f:
        f.write(s)


COLORS = [
    (0x000000, 'black'),
    (0x0000AA, 'blue'),
    (0x00AA00, 'green'),
    (0x00AAAA, 'cyan'),
    (0xAA0000, 'red'),
    (0xAA00AA, 'magenta'),
    (0xAA5500, 'brown'),
    (0xAAAAAA, 'light gray'),
    (0x555555, 'dark gray'),
    (0x5555FF, 'light blue'),
    (0x55FF55, 'light green'),
    (0x55FFFF, 'light cyan'),
    (0xFF5555, 'light red'),
    (0xFF55FF, 'light magenta'),
    (0xFFFF55, 'yellow'),
    (0xFFFFFF, 'white')
]

template_1 = '''// VGA 16 Color Palette:
// https://en.wikipedia.org/wiki/Color_Graphics_Adapter

module index_color_to_rgb (
    input wire [3:0] color_index,
    output reg [WIDTH-1:0] color_rgb
);
    always @ (*) begin
        case (color_index)
'''

template_2 = '''        endcase
    end
endmodule
'''


def to_bin(n, width):
    s = bin(n)[2:]
    while len(s) < width:
        s = '0' + s
    return s


def to_rgb(n):
    s = hex(n)[2:]
    while len(s) < 6:
        s = '0'+s
    return s


if __name__ == '__main__':
    main()
