// display words

module words_static
(
    input clk,
    input rst, 
    output shcp,
    output stcp,
    output ds,
    output oe
);

    wire [7:0] seg;
    wire [5:0] sel;

    disp_driver disp_driver_instance(
        .clk(clk),
        .rst(rst),
        .seg(8'b01100001), // E = 8'b01100001
        .sel(6'b101001), // E_E__E
        .shcp(shcp),
        .stcp(stcp),
        .ds(ds),
        .oe(oe)
    );

endmodule
