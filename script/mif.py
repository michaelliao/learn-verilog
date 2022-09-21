#!/usr/bin/env python3

' generate MIF from binary data '


def to_hex(b):
    return '%02x' % b


def to_binary(b):
    s = bin(b)[2:]
    while len(s) < 8:
        s = '0' + s
    return s


def gen_line(addr, max_addr, bs, format):
    n_chars = len(hex(max_addr-1)) - 2
    s = f'%0{n_chars}x : ' % addr
    for b in bs:
        b2s = to_hex(b) if format == 'hex' else to_binary(b)
        s = s + b2s
    s = s + ';'
    return s


def gen_mif(data, width=8, format='hex'):
    '''
    generate MIF as str.

    data: bytes input data.
    width: data width in bits, default to 8.
    format: data format, default to 'hex'. can be 'hex' or 'bin'.
    '''
    if not isinstance(data, bytes):
        raise ValueError('data must be bytes.')
    if width <= 0 or width % 8 != 0 or width > 256:
        raise ValueError('width must be 8, 16, 24, ..., 256.')
    n_bytes = width // 8
    max_addr = len(data) // n_bytes
    if max_addr * n_bytes != len(data):
        raise ValueError(
            f'invalid data length: {len(data)} and width: {width}')
    if format != 'hex' and format != 'bin':
        raise ValueError('invalid format: {format}')

    lines = [f'-- total {len(data)} bytes', f'WIDTH = {width};',
             f'DEPTH = {max_addr};', 'ADDRESS_RADIX = HEX;', f'DATA_RADIX = {format.upper()};', 'CONTENT', 'BEGIN']
    for addr in range(max_addr):
        sub_data = data[addr * n_bytes: (addr+1)*n_bytes]
        line = gen_line(addr, max_addr, sub_data, format)
        lines.append(line)
    lines.append('END;')
    return '\n'.join(lines)
