#!/usr/bin/env python3

' generate address from ba, row, col '

BA_WIDTH = 2
ROW_WIDTH = 13
COL_WIDTH = 9
CELL_WIDTH = 16

DATA_BITS = 32


def main():
    ba = input_int('BA', 0, (1 << BA_WIDTH) - 1)
    row = input_int('ROW', 0, (1 << ROW_WIDTH) - 1)
    col = input_int('COL', 0, (1 << COL_WIDTH) - 1)
    if col % 2 == 1:
        print('col must be odd.')
        exit(1)
    data = input_int('DATA', 0, (1 << 32) - 1)
    addr = bin_width(ba, BA_WIDTH) + '_' + bin_width(row, ROW_WIDTH) + \
        '_' + bin_width(col, COL_WIDTH)
    if CELL_WIDTH > 8:
        addr = addr + '_' + bin_width(0, CELL_WIDTH / 8 - 1)
    dqm_len = DATA_BITS // 8

    print(f'addr = 32\'b{addr}')
    print(f'data = 32\'h{hex_width(data, 8)}')
    print(f'dqm  = {dqm_len}\'b{"1"*dqm_len}')


def bin_width(x, width):
    s = bin(x)[2:]
    while len(s) < width:
        s = '0' + s
    return s


def hex_width(x, width):
    s = hex(x)[2:]
    while len(s) < width:
        s = '0' + s
    return s


def input_int(prompt, min, max):
    n = 0
    s = input(f'{prompt} ({min} ~ {max}): ')
    if s.startswith('0x'):
        n = int(s[2:], 16)
    elif s.startswith('0b'):
        n = int(s[2:], 2)
    else:
        n = int(s)
    if n < min or n > max:
        print('invalid input.')
        exit(1)
    return n


if __name__ == '__main__':
    main()
