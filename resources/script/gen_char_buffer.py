#!/usr/bin/env python3

' convert text to RAM init data '

import argparse

from mif import gen_mif


COLS = 80
ROWS = 25

# Bg/Fg color, 0 = Black, F = White
BLACK = 0
BLUE = 1
GREEN = 2
CYAN = 3
RED = 4
MAGENTA = 5
BROWN = 6
LIGHT_GRAY = 7
DARK_GRAY = 8
LIGHT_BLUE = 9
LIGHT_GREEN = 10
LIGHT_CYAN = 11
LIGHT_RED = 12
LIGHT_MAGENTA = 13
YELLOW = 14
WHITE = 15


def main():
    parser = argparse.ArgumentParser(
        description='Generate ascii binary data from text file.')
    parser.add_argument('-i', '--input', required=True, type=str, metavar='screen.txt',
                        help='multi-line text as input file.')
    parser.add_argument('-o', '--output', required=True, type=str, metavar='screen.mif',
                        help='mif binary data as output file.')
    args = parser.parse_args()
    print(f'input file: {args.input}')
    print(f'output file: {args.output}')
    with open(args.input, 'r') as f:
        lines = f.readlines()
    if len(lines) > ROWS:
        print(f'Error: too many lines: {lines}')
        exit(1)
    while len(lines) < ROWS:
        lines.append('')
    data = b''
    for y, line in enumerate(lines):
        data = data + line_to_data(y, line.rstrip())
    mif_str = gen_mif(data, width=16)

    print(f'writing mif...')
    with open(args.output, 'w') as f:
        f.write(mif_str)
    print('ok')


def color_of_char(x, y, ch):
    bg, fg = BLACK, WHITE
    if x in (0, 79) or y in (0, 1, 2, 22, 23, 24):
        bg = LIGHT_GRAY
        if ch in '+-|':
            fg = YELLOW
        else:
            fg = RED
    bgfg = bg * 16 + fg
    return bgfg.to_bytes(1, 'big')


def line_to_data(y, line):
    chars = len(line)
    if chars > COLS:
        print(f'Error: line {y+1} has too many chars: {chars}')
        exit(1)
    while len(line) < COLS:
        line = line + ' '
    bs = b''
    for x, ch in enumerate(line):
        bs = bs + color_of_char(x, y, ch) + ord(ch).to_bytes(1, 'big')
    return bs


if __name__ == '__main__':
    main()
