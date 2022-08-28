#!/usr/bin/env python3

# Full CGA 16-color palette:
# https://en.wikipedia.org/wiki/Color_Graphics_Adapter


COLORS = [
    ('BLACK',     0x000000),
    ('BLUE',      0x0000AA),
    ('GREEN',     0x00AA00),
    ('CYAN',      0x00AAAA),
    ('RED',       0xAA0000),
    ('MAGENTA',   0xAA00AA),
    ('BROWN',     0xAA5500),
    ('L_GRAY',    0xAAAAAA),
    ('D_GRAY',    0x555555),
    ('L_BLUE',    0x5555FF),
    ('L_GREEN',   0x55FF55),
    ('L_CYAN',    0x55FFFF),
    ('L_RED',     0xFF5555),
    ('L_MAGENTA', 0xFF55FF),
    ('YELLOW',    0xFFFF55),
    ('WHITE',     0xFFFFFF)
]

template_1 = '''// VGA 16 Color Palette:
// https://en.wikipedia.org/wiki/Color_Graphics_Adapter

module text_color (
    input  wire [3:0] color_index,
    output wire [15:0] color_rgb
);
'''

template_2 = '''
    always @ (*) begin
        case (color_index)
'''

template_3 = '''        endcase
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


def main():
    if len(COLORS) != 16:
        print('Invalid length of COLORS.')
        exit(1)
    s = template_1
    n = 0
    for name, rgb in COLORS:
        r = (rgb & 0xff0000) >> 16
        g = (rgb & 0xff00) >> 8
        b = (rgb & 0xff)
        sr = r * 32 // 256
        sg = g * 64 // 256
        sb = b * 32 // 256
        s = s + '    `define COLOR_%d 16\'b%s%s%s // %s = #%s\n' % (
            n, to_bin(sr, 5), to_bin(sg, 6), to_bin(sb, 5), name, to_rgb(rgb))
        n = n + 1

    s = s + template_2

    for i in range(16):
        s = s + f'            4\'d{i}: color_rgb = COLOR_{i};\n'

    s = s + template_3
    print(s)

    with open('../text_color.v', 'w') as f:
        f.write(s)


if __name__ == '__main__':
    main()
