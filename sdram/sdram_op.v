// define SDRAM command:

`define OP_NOP        4'b0111;
`define OP_PRECHARGE  4'b0010;
`define OP_AUTO_REF   4'b0001;
`define OP_LOAD_MR    4'b0000;
`define OP_ACTIVE     4'b0011;
`define OP_WRITE      4'b0100;
`define OP_READ       4'b0101;
`define OP_BURST_TERM 4'b0110;
