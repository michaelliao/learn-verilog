`timescale 1ns/1ns

module tb_top ();

    reg clk;
    reg rst_n;
    reg in_data;
    wire out_data;
    wire out_en;

    wire [7:0] data;
    wire data_en;

    uart_rx #(2_500_000) rx_instance (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (in_data),
        .out_data (data),
        .out_en (data_en)
    );

    uart_tx #(2_500_000) tx_instance (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (data),
        .in_en (data_en),
        .out_data (out_data),
        .out_en (out_en)
    );

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        in_data = 8'b1;
        #10
        rst_n = 1'b1;
        #20
        // start 0:
        in_data = 1'b0;
        #40
        // 01010101:
        in_data = 1'b1;
        #40
        in_data = 1'b0;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b0;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b0;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b0;
        #40
        // parity:
        in_data = 1'b1;
        #40
        // end 1:
        in_data = 1'b1;
        #100
        // next byte:
        // start 0:
        in_data = 1'b0;
        #40
        // 10111100:
        in_data = 1'b0;
        #40
        in_data = 1'b0;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b1;
        #40
        in_data = 1'b0;
        #40
        in_data = 1'b1;
        #40
        // parity:
        in_data = 1'b0;
        #40
        // end 1:
        in_data = 1'b1;
        #40
        #800
        $finish;
    end

    always #1 clk = ~clk;

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, rx_instance);
        $dumpvars(1, tx_instance);
    end
endmodule
