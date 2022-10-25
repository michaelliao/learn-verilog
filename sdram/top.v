// SDRAM read / write by rs232 port.

module top (
    input clk,
    input rst_n,
    input in_rx_data,
    input out_tx_data,
    output sdr_cs_n,
    output sdr_ras_n,
    output sdr_cas_n,
    output sdr_we_n,
    output [1:0] sdr_ba,
    output [12:0] sdr_addr,
    inout [15:0] inout_sdr_dq
);

    localparam
        WRITE = 16'ha1b2,
        READ = 16'hc3d4;

    wire rx_fifo_out_en;
    wire [7:0] rx_fifo_out;
    reg [32+32+16-1:0] cache;

    reg [7:0] tx_data;

    reg [31:0] addr;
    reg [31:0] data;

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            //
        end else begin
            //
        end
    end

    uart_rx uart_rx_inst (
    (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (in_rx_data),
        .out_data (rx_fifo_out),
        .out_en (rx_fifo_out_en)
    );

    uart_tx uart_tx_inst (
        .clk (clk),
        .rst_n (rst_n),
        .in_data (tx_data),
        .in_en (tx_data_en),
        .out_data (out_tx_data)
    );

    sdram_ctrl sdram_ctrl_inst (
        .clk (clk_100m),
        .rst_n (rst_n),
        .in_addr (addr)
        // connect to sdr:
        .inout_data (inout_sdr_dq)
        .cmd ({sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n}),
        .ba (sdr_ba)
        .addr (sdr_addr)
    );

    // execute write and write into sdram:

    // execute read and write to tx_fifo:

endmodule
