`timescale 1ns/1ns

module tb_words_static();

    reg clk;
    reg rst;
    wire shcp;
    wire stcp;
    wire ds;
    wire oe;

    initial begin
        clk = 1'b1;
        rst = 1'b0;
        #100
        rst = 1'b1;
        #10000
        $stop;
    end

    always #10 clk = ~clk;

    words_static ins(
        .clk(clk),
        .rst(rst),
        .shcp(shcp),
        .stcp(stcp),
        .ds(ds),
        .oe(oe)
    );

endmodule
