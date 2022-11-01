`timescale 1ns / 1ns

module tb_tx_fsm();

    reg clk_rd;
    reg clk_wr;
    reg rst_n;

    initial begin
        rst_n = 1'b0;
        #25
        rst_n = 1'b1;
    end

    // 50 MHz clk_rd:
    initial begin
        clk_rd = 1'b1;
        forever begin
            #10 clk_rd = ~clk_rd;
        end
    end

    // 100 MHz clk_wr:
    initial begin
        clk_wr = 1'b1;
        #2
        forever begin
            #5 clk_wr = ~clk_wr;
        end
    end

    reg wr_req;
    reg [31:0] wr_data;
    wire rd_empty;
    wire out_tx_data;
    wire out_tx_en;

    tx_fsm #(
        .BAUD (5_000_000) // 波特率是时钟频率的1/10
    )
    component (
        .clk_wr (clk_wr),
        .clk_rd (clk_rd),
        .wr_rst_n (rst_n),
        .rd_rst_n (rst_n),
        .wr_req (wr_req),
        .wr_data (wr_data),
        .rd_empty (rd_empty),
        .out_tx_data (out_tx_data),
        .out_tx_en (out_tx_en)
    );

    reg [31:0] sdr_data;
    reg [7:0] one_byte;

    initial begin
        wr_req = 1'b0;
        // 输入数据: 0xa1b2c3d4
        wr_data = 32'ha1b2c3d4;
        #55
        repeat (4) begin
            one_byte = wr_data[31:24];
            wr_data = wr_data << 8;
            wr_req <= 1'b1;
            #10;
        end
        wr_req <= 1'b0;
        #30000;
        $finish;
    end

    initial begin
        $dumpfile("tb_tx_fsm.vcd");
        $dumpvars(0, component);
    end

endmodule
