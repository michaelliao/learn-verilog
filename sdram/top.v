// SDRAM read / write by rs232 port.

module top (
    input wire clk,
    input wire rst_n,
    input wire in_rx_data,
    input wire out_tx_data
);

    localparam
        WRITE = 16'ha1b2,
        READ = 16'hc3d4;

    wire rx_fifo_out_en;
    wire [7:0] rx_fifo_out;
    reg [32+32+16-1:0] cache;

    reg [31:0] addr;
    reg [31:0] data;

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            //
        end else begin
            //
        end
    end

    // read data from uart:
    uart_rx uart_rx_inst (
    (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (in_rx_data),
        .out_data (rx_fifo_out),
        .out_en (rx_fifo_out_en)
    );

    // execute write and write into sdram:

    // execute read and write to tx_fifo:

endmodule
