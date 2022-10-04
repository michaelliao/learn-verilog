`timescale 1ns/1ns

module tb_sdram_write();

    reg clk;
    reg rst_n;
    reg init_end;
    reg wr_en;
    reg [23:0] wr_addr;
    reg [63:0] wr_data;
    reg [3:0] wr_burst_length;

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        init_end = 1'b0;
        wr_en = 1'b0;
        wr_addr = 24'h0;
        wr_data = 64'h0;
        wr_burst_length = 4'h0;
        #15
        rst_n = 1'b1;
        #15
        init_end = 1'b1;
        #60
        wr_en = 1'b1;
        #10
        // write 4 bytes into bank #2, row #a1c, col #10:
        wr_addr = { 2'b10, 13'ha1c, 9'h10 };
        wr_data = 64'hf0_de_bc_9a_78_56_34_12;
        wr_burst_length = 4'h4;
        #120
        wr_en = 1'b0;
        #10000
        $finish;
    end

    // 100 MHz
    always #5 clk = ~clk;

    sdram_write component(
        .clk (clk),
        .rst_n (rst_n),
        .init_end (init_end),
        .wr_en (wr_en),
        .wr_addr (wr_addr),
        .wr_data (wr_data),
        .wr_burst_length (wr_burst_length)
    );

    initial begin
        $dumpfile("tb_sdram_write.vcd");
        $dumpvars(0, component);
    end

endmodule
