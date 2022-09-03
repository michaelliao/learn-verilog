`timescale 1ns/1ns

module tb_uart_tx ();

    reg clk;
    reg rst_n;
    reg [7:0] in_data;
    reg in_en;
    wire out_data;
    wire out_en;

    uart_tx #(5_000_000) component(
        .clk (clk),
        .rst_n (rst_n),
        .in_data (in_data),
        .in_en (in_en),
        .out_data (out_data),
        .out_en (out_en)
    );

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        in_en = 1'b0;
        in_data = 8'b0;
        #10
        rst_n = 1'b1;
        #10
        in_en = 1'b1;
        in_data = 8'b0011_0001;
        #10
        in_en = 1'b0;
        in_data = 8'b0;
        #3000
        $finish;
    end

    always #1 clk = ~clk;

    initial begin
        $dumpfile("tb_uart_tx.vcd");
        $dumpvars(0, component);
    end
endmodule
