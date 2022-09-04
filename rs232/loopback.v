// receive data
// Baud = 9600, 14400, 19200, 38400, 57600, 115200

module loopback #(
    parameter BAUD = 9600 // default to 9600
)
(
    input wire clk,
    input wire rst_n,
    input wire in_data,
    output wire out_data,
    output wire out_en
);

    wire [7:0] data;
    wire data_en;

    uart_rx #(BAUD) rx_instance (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (in_data),
        .out_data (data),
        .out_en (data_en)
    );

    uart_tx #(BAUD) tx_instance (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (data),
        .in_en (data_en),
        .out_data (out_data),
        .out_en (out_en)
    );

endmodule
