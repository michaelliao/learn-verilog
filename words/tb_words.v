`timescale 1ns/1ns

module tb_words();

    reg clk;
    reg rst_n;
    wire shcp;
    wire stcp;
    wire ds;
    wire oe;

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        #100
        rst_n = 1'b1;
        #10000
        $finish;
    end

    always #10 clk = ~clk;

    words component(
        .clk(clk),
        .rst_n(rst_n),
        .shcp(shcp),
        .stcp(stcp),
        .ds(ds),
        .oe(oe)
    );

    initial begin
        $dumpfile("tb_words.vcd");
        $dumpvars(0, component);
    end

endmodule
