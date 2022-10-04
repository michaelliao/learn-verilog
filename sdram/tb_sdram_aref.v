`timescale 1ns/1ns

module tb_sdram_aref();

    reg clk;
    reg rst_n;
    reg init_end;
    reg aref_en;

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        init_end = 1'b0;
        aref_en = 1'b0;
        #15
        rst_n = 1'b1;
        #15
        init_end = 1'b1;
        #7660
        aref_en = 1'b1;
        #210
        aref_en = 1'b0;
        #10000
        $finish;
    end

    // 100 MHz
    always #5 clk = ~clk;

    sdram_aref component(
        .clk (clk),
        .rst_n (rst_n),
        .init_end (init_end),
        .aref_en (aref_en)
    );

    initial begin
        $dumpfile("tb_sdram_aref.vcd");
        $dumpvars(0, component);
    end

endmodule
