#!/usr/bin/env python3

' convert text to RAM init data '

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


def color_of_char(x, y, ch):
    bg, fg = BLACK, WHITE
    if x in (0, 79) or y in (0, 1, 2, 22, 23, 24):
        bg = LIGHT_GRAY
        if ch in '+-|':
            fg = YELLOW
        else:
            fg = RED
    return '%x%x' % (bg, fg)


def add_line(data, y, line):
    chars = len(line)
    if chars > COLS:
        print(f'Error: line {y+1} has too many chars: {chars}')
        exit(1)
    while len(line) < COLS:
        line = line + ' '
    s = '%03x :' % (COLS * 2 * y)
    for x, ch in enumerate(line):
        s = s + ' ' + color_of_char(x, y, ch) + ' %02x' % ord(ch)
    s = s + ';'
    print(f'{s}')
    data.append(s)


def main():
    with open('../font/init-screen.txt', 'r') as f:
        lines = f.readlines()
    if len(lines) > ROWS:
        print(f'Error: too many lines: {lines}')
        exit(1)
    while len(lines) < ROWS:
        lines.append('')
    data = ['-- 80 x 25 character buffer data', 'WIDTH = 8;',
            f'DEPTH = {COLS*ROWS*2};', 'ADDRESS_RADIX = HEX;', 'DATA_RADIX = HEX;', 'CONTENT', 'BEGIN']
    n = 0
    for line in lines:
        add_line(data, n, line.rstrip())
        n = n + 1
    data.append('END;')
    print(f'writing mif...')
    with open('../font/char-buffer.mif', 'w') as f:
        f.write('\n'.join(data))
    print('ok')


if __name__ == '__main__':
    main()
