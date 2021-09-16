`timescale 1ns/1ns

module tb_counter ();

    reg clk;
    reg rst;
    wire [7:0] out;

    initial begin
        clk = 1'b1;
        rst = 1'b0;
        #100
        rst = 1'b1;
		  #100
		  rst = 1'b0;
        #100
        rst = 1'b1;
        #10000
        $finish();
    end

    always #10 clk = ~clk;

    counter ins(
        .clk(clk),
        .rst(rst),
        .out(out)
    );

endmodule
