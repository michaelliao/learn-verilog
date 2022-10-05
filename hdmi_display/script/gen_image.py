#!/usr/bin/env python3

' convert NxN png to binary '

import os

from PIL import Image
from mif import gen_mif


SIZE = 32


def main():
    for name in os.listdir('../sprite'):
        if name.endswith('.png'):
            _generate(f'../sprite/{name}', f'../{name[:-4]}.mif')


def _generate(source, target):
    im = Image.open(source)
    width, height = im.size
    print(f'read {source} size: {width} x {height}')

    addr = 0
    data = b''
    for y in range(0, height):
        for x in range(0, width):
            p = im.getpixel((x, y))
            data = data + \
                p[0].to_bytes(1, 'big') + \
                p[1].to_bytes(1, 'big') + \
                p[2].to_bytes(1, 'big')
    mif_str = gen_mif(data, width=24, format='hex')
    with open(target, 'w') as f:
        print(f'writing {target}...')
        f.write(mif_str)
    print('ok')


if __name__ == '__main__':
    main()
