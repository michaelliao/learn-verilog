`timescale 1ns/1ns

module tb_sdram_init();

    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        #15
        rst_n = 1'b1;
        #10000
        $finish;
    end

    // 100 MHz
    always #5 clk = ~clk;

    sdram_init component(
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        $dumpfile("tb_sdram_init.vcd");
        $dumpvars(0, component);
    end

endmodule
