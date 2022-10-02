// display words

module top
(
    input clk,
    input rst_n, 
    output shcp,
    output stcp,
    output ds,
    output oe
);

    localparam C = 8'b01100011;
    localparam E = 8'b01100001;
    localparam F = 8'b01110001;
    localparam H = 8'b10010001;
    localparam L = 8'b11100011;
    localparam O = 8'b00000011;
    localparam P = 8'b00110001;
    localparam S = 8'b01001001;
    localparam U = 8'b10000011;

    wire [7:0] seg;
    wire [5:0] sel;

    digital_tube_data digital_tube_data_inst (
        .clk (clk),
        .rst_n (rst_n),
        .data ({ S, C, H, O, O, L }),
        .seg (seg),
        .sel (sel)
    );

    digital_tube_display digital_tube_display_inst (
        .clk (clk),
        .rst_n (rst_n),
        .seg (seg),
        .sel (sel),
        .shcp (shcp),
        .stcp (stcp),
        .ds (ds),
        .oe (oe)
    );

endmodule
