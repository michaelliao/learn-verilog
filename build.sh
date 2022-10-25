#!/bin/bash
cd "$(dirname "$0")"

top_module=`pwd | awk -F/ '{print $NF}'`

if ! [ -z "$1" ]; then
    top_module="$1"
    top_module=${top_module%.v}
fi

src_file="$top_module.v"
src_out_file="$top_module.out"
tb_file="tb_$top_module.v"
tb_out_file="tb_$top_module.out"
wave_out_file="tb_$top_module.vcd"

echo "set top module = $top_module"

if ! [ -e $src_file ]; then
    echo "source file $src_file not found."
    exit 1
fi

echo "compile $src_file -> $src_out_file ..."
iverilog -y . -s $top_module -o $src_out_file $src_file
if ! [ $? -eq 0 ]; then
    exit 1
fi

if ! [ -e $tb_file ]; then
    echo "[WARNING] testbench file $tb_file not found."
else
    echo "compile $tb_file -> $tb_out_file ..."
    iverilog -y . -s tb_$top_module -o $tb_out_file $src_file $tb_file
    if ! [ $? -eq 0 ]; then
        exit 1
    fi

    echo "simulate $tb_out_file ..."
    vvp $tb_out_file
    if ! [ $? -eq 0 ]; then
        exit 1
    fi

    echo "open gtkwave for $wave_out_file ..."
    gtkwave $wave_out_file
fi
