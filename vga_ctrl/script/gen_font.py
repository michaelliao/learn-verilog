#!/usr/bin/env python3

' convert font png to binary '

from PIL import Image

CHAR_START = 0
CHAR_WIDTH = 8
CHAR_HEIGHT = 16


def get_char(im, row, col):
    x_start = CHAR_WIDTH * col
    x_end = x_start + CHAR_WIDTH
    y_start = CHAR_HEIGHT * row
    y_end = y_start + CHAR_HEIGHT
    s = ''
    for y in range(y_start, y_end):
        b = 0
        for x in range(x_start, x_end):
            p = im.getpixel((x, y))
            bit = '1' if p > 0 else '0'
            s = s + bit
    return s


def add_data(lines, addr, bits):
    parts = len(bits) // 8
    line = '%03x :' % addr
    for part in range(parts):
        offset = part * 8
        line = line + ' %s' % bits[offset: offset + 8]
    lines.append(line)


def main():
    im = Image.open('../font/ascii-font.png')
    width, height = im.size
    if width % CHAR_WIDTH != 0:
        print(f'invalid width: {width}')
        exit(1)
    if height % CHAR_HEIGHT != 0:
        print(f'invalid height: {height}')
        exit(1)

    w_count = width // CHAR_WIDTH
    h_count = height // CHAR_HEIGHT
    print(f'characters: {w_count} x {h_count}')

    addr = 0
    char = CHAR_START
    data = ['-- 8x16 font bitmap data', 'WIDTH = 8;',
            f'DEPTH = {width*height//8};', 'ADDRESS_RADIX = HEX;', 'DATA_RADIX = BIN;', 'CONTENT', 'BEGIN']
    for row in range(0, h_count):
        for col in range(0, w_count):
            bits = get_char(im, row, col)
            print(f'{chr(char)} at row {row}, col {col}: ' + bits)
            add_data(data, addr, bits)
            char = char + 1
            addr = addr + len(bits) // 8

    data.append('END;')
    print(f'writing mif...')
    with open('../font/font.mif', 'w') as f:
        f.write('\n'.join(data))
    print('ok')


if __name__ == '__main__':
    main()
