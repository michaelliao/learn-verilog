# SDRAM

SDRAM = Synchronized Dynamic RAM

# Hardware

Micron MT48LC16M16A2 - 4 Meg x 16 x 4 banks = 256 Mbit = 32 MB

Refresh count: 8K
Bank addressing: 4 BA[1:0]
Row addressing: 8K A[12:0]
Column addressing: 512 A[8:0]

# Address Mapping

A 32-bit address is mapping to BA, ROW and COL:

```
│31         25│   │22                     10│9               1│0│
├─┬─┬─┬─┬─┬─┬─┼─┬─┼─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┼─┬─┬─┬─┬─┬─┬─┬─┬─┼─┤
└─┴─┴─┴─┴─┴─┴─┼─┴─┼─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┼─┴─┴─┴─┴─┴─┴─┴─┴─┼─┘
            ─▶│BA │◀───────── ROW ─────────▶│◀───── COL ─────▶│
```
