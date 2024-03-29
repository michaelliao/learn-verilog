#!/usr/bin/env python3

' convert font png to binary '

import argparse

from PIL import Image
from mif import gen_mif

CHAR_START = 0
CHAR_WIDTH = 8
CHAR_HEIGHT = 16


def main():
    parser = argparse.ArgumentParser(
        description='Generate font binary data from png image.')
    parser.add_argument('-i', '--input', required=True, type=str, metavar='font.png',
                        help='png image as input file.')
    parser.add_argument('-o', '--output', required=True, type=str, metavar='font.mif',
                        help='mif binary data as output file.')
    args = parser.parse_args()
    print(f'input file: {args.input}')
    print(f'output file: {args.output}')

    im = Image.open(args.input)
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
    data = b''
    for row in range(0, h_count):
        for col in range(0, w_count):
            bs = get_char(im, row, col)
            data = data + bs
    mif_str = gen_mif(data, width=8, format='bin')

    print(f'writing mif...')
    with open(args.output, 'w') as f:
        f.write(mif_str)
    print('ok')


def get_char(im, row, col):
    x_start = CHAR_WIDTH * col
    x_end = x_start + CHAR_WIDTH
    y_start = CHAR_HEIGHT * row
    y_end = y_start + CHAR_HEIGHT
    bs = b''
    for y in range(y_start, y_end):
        s = ''
        for x in range(x_start, x_end):
            p = im.getpixel((x, y))
            bit = '1' if p > 0 else '0'
            s = s + bit
        n = int(s, base=2)
        b = n.to_bytes(1, 'big')
        bs = bs + b
    return bs


if __name__ == '__main__':
    main()
