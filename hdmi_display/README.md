# HDMI Display

Display 80x25 text mode as HDMI output.

# Generate Font for ROM

The ROM file `font.mif` is generated by script:

```
$ ../resources/script/gen_font.py \
  --input ../resources/font/ascii-font.png \
  --output ./font.mif
```

# Generate Buffer for RAM

The RAM file `char-buffer.mif` is generated by script:

```
$ ../resources/script/gen_char_buffer.py \
  --input ../resources/font/init-screen.txt \
  --output ./char-buffer.mif
```

# Generate Index Color to RGB

The source file `index_color_to_rgb.v` is generated by script:

```
$ ../resources/script/gen_index_color_to_rgb.py \
  --width 24 \
  --output ./index_color_to_rgb.v
```
