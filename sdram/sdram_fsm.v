// read / write sdram

`include "op.v"

module sdram_fsm (
    input clk,
    input clk_for_sdr,
    input rst_n,

    input [7:0] op,
    input [31:0] address,
    input [31:0] data,
    output op_ack,
    output op_data,

    output sdr_clk,
    output sdr_cs_n,
    output sdr_ras_n,
    output sdr_cas_n,
    output sdr_we_n,
    output [1:0] sdr_ba,
    output [12:0] sdr_addr,
    output [1:0] sdr_dqm,
    inout [15:0] inout_sdr_dq
);

    localparam
        IDLE     = 3'b000,
        READING  = 3'b001,
        READ_OK  = 3'b011,
        WRITING  = 3'b100,
        WRITE_OK = 3'b101;

    reg [1:0] state;

    reg sdr_ctrl_rd_req;
    reg sdr_ctrl_wr_req;
    reg [31:0] sdr_ctrl_addr;
    reg [31:0] sdr_ctrl_wr_data;
    wire [31:0] sdr_ctrl_rd_data;

    wire sig_rd_ack;
    wire sig_rd_done;
    wire sig_wr_ack;
    wire sig_wr_done;

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            state <= IDLE;
            sdr_ctrl_rd_req <= 1'b0;
        end else begin
            case (state)
            IDLE: begin
                if (op == `OP_READ) begin
                    sdr_ctrl_rd_req <= 1'b1;
                    sdr_ctrl_addr <= address;
                    state <= READING;
                end
                if (op == `OP_WRITE) begin
                    sdr_ctrl_wr_req <= 1'b1;
                    sdr_ctrl_addr <= address;
                    sdr_ctrl_wr_data <= data;
                    state <= WRITING;
                end
            end
            READING: begin
                if (sig_rd_ack == 1'b1) begin
                    sdr_ctrl_rd_req <= 1'b0;
                end
                if (sig_rd_done == 1'b1) begin
                    state <= READ_OK;
                    op_ack <= 1'b1;
                    op_data <= sdr_ctrl_rd_data;
                end
            end
            READ_OK: begin
                state <= IDLE;
                op_ack <= 1'b0;
                op_data <= 32'b0;
            end
            WRITING: begin
                if (sig_wr_ack == 1'b1) begin
                    sdr_wr_req <= 1'b0;
                end
                if (sig_wr_done == 1'b1) begin
                    state <= WRITE_OK;
                    op_ack <= 1'b1;
                    op_data <= 32'b0;
                end
            end
            WRITE_OK: begin
                state <= IDLE;
                op_ack <= 1'b0;
            end
            default: state <= IDLE;
            endcase
        end
    end

    sdram_ctrl sdram_ctrl_inst (
        .clk (clk),
        .clk_for_sdr (clk_for_sdr),
        .rst_n (rst_n),
        .in_addr (sdr_ctrl_addr),
        .in_rd_req (sdr_ctrl_rd_req),
        .out_rd_ack (sig_rd_ack),
        .out_rd_data (sdr_rd_data),
        .out_rd_done (sig_rd_done),
        .in_wr_req (sdr_ctrl_wr_req),
        .in_wr_dqm (2'b00),
        .in_wr_data (sdr_ctrl_wr_data),
        .out_wr_ack (sig_wr_ack),
        .out_wr_done (sig_wr_done),

        // connect to sdr:
        .sdr_clk (sdr_clk),
        .out_wr_dqm (2'b00),
        .inout_data (inout_sdr_dq),
        .cmd ({sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n}),
        .ba (sdr_ba),
        .addr (sdr_addr)
    );

endmodule
