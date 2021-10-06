`timescale 1ns/1ns

module tb_counter ();

    reg clk;
    reg rst_n;
    wire [7:0] out;

    counter counter_instance(
        .clk(clk),
        .rst_n(rst_n),
        .out(out)
    );

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        #100
        rst_n = 1'b1;
        #10000
        $finish;
    end

    always #10 clk = ~clk;

    initial begin
        $dumpfile("tb_counter.vcd");
        $dumpvars(0, counter_instance);
    end

endmodule
