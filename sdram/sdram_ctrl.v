/******************************************************************************

SDRAM ctrl

******************************************************************************/

`include "sdram_op.v"

module sdram_ctrl #(
    parameter CLK = 100_000_000, // default to 100 MHz
    parameter ROWS = 8192, // how many rows should be refreshed in 64 ms
    parameter CAS_LATENCY = 2, // CAS Latency: 1, 2, 3
    parameter TPOWERUP = 200, // tPowerUp = 200 ns, wait time for power up
    parameter TRP = 20, // tRP = 20 ns, wait time for precharge
    parameter TRFC = 70, // tRFC = 70 ns, wait time for auto refresh
    parameter TRCD = 20, // tRCD = 20 ns, wait time for active
    parameter MAX_AUTO_REFRESH = 3'd4 // auto refresh: 2 ~ 7
)
(
    input clk,
    input rst_n,

    // read input:
    input rd_in,
    input [23:0] rd_addr, // read address
    output [63:0] rd_data, // 1 - 8 bytes
    input [3:0] rd_burst_length, // 1 ~ 8

    // write input:
    input wr_in,
    input [23:0] wr_addr, // write address
    input [63:0] wr_data, // 8 bytes
    input [3:0] wr_burst_length, // 1 ~ 8

    // busy output:
    output reading,
    output writing,

    // sdram hardware interface:
    input sdram_rd_req,
    input sdram_rd_addr,

    output [1:0]  sdram_ba,
    output [12:0] sdram_addr,

    output sdram_cs_n,
    output sdram_ras_n,
    output sdram_cas_n,
    output sdram_we_n,
    output sdram_cke
);
    wire [3:0] sdram_cmd;

    wire [3:0] init_cmd;
    wire [1:0] init_ba;
    wire [12:0] init_addr;
    wire init_end;

    wire aref_req;
    wire [3:0] aref_cmd;
    wire [1:0] aref_ba;
    wire [12:0] aref_addr;
    wire aref_end;

    wire wr_req;
    wire [3:0] wr_cmd;
    wire [1:0] wr_ba;
    wire [12:0] wr_addr;
    wire wr_end;

    wire rd_req;
    wire [3:0] rd_cmd;
    wire [1:0] rd_ba;
    wire [12:0] rd_addr;
    wire rd_end;

    wire aref_en;
    wire wr_en;
    wire rd_en;

    // init module:
    sdram_init #(
        CLK, CAS_LATENCY, TPOWERUP, TRP, TRFC, MAX_AUTO_REFRESH
    )
    sdram_init_inst (
        .clk (clk),
        .rst_n (rst_n),
        .cmd (init_cmd),
        .ba (init_ba),
        .addr (init_addr),
        .init_end (init_end)
    );

    // aref module:
    sdram_aref #(
        CLK, ROWS, TRP, TRFC
    ) sdram_aref_inst (
        .clk (clk),
        .rst_n (rst_n),
        .init_end (init_end),

        .aref_en (aref_en),
        .aref_req (aref_req),
        .aref_end (aref_end),

        .cmd (aref_cmd),
        .ba (aref_ba),
        .addr (aref_addr)
    );

    // write module:
    sdram_write #(
        CLK, CAS_LATENCY, TRCD, TRP
    ) sdram_write_inst (
        .clk (clk),
        .rst_n (rst_n),
        .init_end (init_end),

        .wr_en (wr_en),
        .wr_req (wr_req),
        .wr_end (wr_end),

        .cmd (wr_cmd),
        .ba (wr_ba),
        .addr (wr_addr)
    );

    // read module:
    sdram_read #(
        CLK, CAS_LATENCY, TRCD, TRP
    ) sdram_read_inst (
        .clk (clk),
        .rst_n (rst_n),
        .init_end (init_end),

        .rd_en (rd_en),
        .rd_req (rd_req),
        .rd_end (rd_end),

        .cmd (rd_cmd),
        .ba (rd_ba),
        .addr (rd_addr)
    );

    // arbit module:
    sdram_arbit sdram_arbit_inst (
        .clk (clk),
        .rst_n (rst_n),

        .init_cmd (init_cmd),
        .init_ba (init_ba),
        .init_addr (init_addr),
        .init_end (init_end),

        .aref_cmd (aref_cmd),
        .aref_ba (aref_ba),
        .aref_addr (aref_addr),
        .aref_end (aref_end),

        .wr_cmd (wr_cmd),
        .wr_ba (wr_ba),
        .wr_addr (wr_addr),
        .wr_end (wr_end),

        .rd_cmd (rd_cmd),
        .rd_ba (rd_ba),
        .rd_addr (rd_addr),
        .rd_end (rd_end),

        .reading (reading),
        .writing (writing),

        .out_cmd (sdram_cmd),
        .out_ba (sdram_ba),
        .out_addr (sdram_addr)
    );

    assign { sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n } = sdram_cmd;

    assign sdram_cke = 1'b1;

endmodule
