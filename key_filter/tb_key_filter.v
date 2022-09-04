`timescale 1ns/1ns

module tb_key_filter ();

    reg clk;
    reg rst_n;
    reg key_in;
    wire key_out;

    key_filter #(4) component(
        .clk (clk),
        .rst_n (rst_n),
        .key_in (key_in),
        .key_out (key_out)
    );

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        key_in = 1'b1;
        #10
        rst_n = 1'b1;
        #10
        key_in = 1'b0;
        #4
        key_in = 1'b1;
        #5
        key_in = 1'b0;
        #4
        key_in = 1'b1;
        #5
        key_in = 1'b0;
        #4
        key_in = 1'b1;
        #5
        key_in = 1'b0;
        #500
        key_in = 1'b1;
        #5
        key_in = 1'b0;
        #4
        key_in = 1'b1;
        #5
        key_in = 1'b0;
        #4
        key_in = 1'b1;
        #500    
        $finish;
    end

    always #1 clk = ~clk;

    initial begin
        $dumpfile("tb_key_filter.vcd");
        $dumpvars(0, component);
    end
endmodule
