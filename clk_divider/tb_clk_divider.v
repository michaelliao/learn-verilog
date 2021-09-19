`timescale 1ns/1ns

module tb_clk_divider ();

    reg clk;
    wire clk2;
    wire clk4;
    wire clk8;

    initial begin
        clk = 1'b1;
        #1000
        $finish();
    end

    always #10 clk = ~clk;

    clk_divider ins(
        .clk(clk),
        .clk2(clk2),
        .clk4(clk4),
        .clk8(clk8)
    );

endmodule
