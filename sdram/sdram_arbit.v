/******************************************************************************

SDRAM arbit

******************************************************************************/

`include "sdram_op.v"

module sdram_arbit
(
    input clk,
    input rst_n,

    input [3:0] init_cmd,
    input [1:0] init_ba,
    input [12:0] init_addr,
    input init_end,

    input aref_req,
    input [3:0] aref_cmd,
    input [1:0] aref_ba,
    input [12:0] aref_addr,
    input aref_end,

    input wr_req,
    input [3:0] wr_cmd,
    input [1:0] wr_ba,
    input [12:0] wr_addr,
    input wr_end,

    input rd_req,
    input [3:0] rd_cmd,
    input [1:0] rd_ba,
    input [12:0] rd_addr,
    input rd_end,

    output reading,
    output writing,

    output reg aref_en,
    output reg wr_en,
    output reg rd_en,

    output reg [3:0] out_cmd,
    output reg [1:0] out_ba,
    output reg [12:0] out_addr
);

    localparam
        STATE_IDLE  = 3'b000,
        STATE_ARBIT = 3'b001,
        STATE_AREF  = 3'b011,
        STATE_WRITE = 3'b010,
        STATE_READ  = 3'b110;

    reg [2:0] state;

    // fsm:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            state <= STATE_IDLE;
            aref_en <= 1'b0;
            wr_en <= 1'b0;
            rd_en <= 1'b0;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (init_end == 1'b1) begin
                        state <= STATE_ARBIT;
                    end
                end
                STATE_ARBIT: begin
                    if (aref_req == 1'b1) begin
                        state <= STATE_AREF;
                        aref_en <= 1'b1;
                    end else if (wr_req == 1'b1) begin
                        state <= STATE_WRITE;
                        wr_en <= 1'b1;
                    end else if (rd_req == 1'b1) begin
                        state <= STATE_READ;
                        rd_en <= 1'b1;
                    end
                end
                STATE_AREF: begin
                    if (aref_end == 1'b1) begin
                        state <= STATE_ARBIT;
                        aref_en <= 1'b0;
                    end
                end
                STATE_WRITE: begin
                    if (wr_end == 1'b1) begin
                        state <= STATE_ARBIT;
                        wr_en <= 1'b0;
                    end
                end
                STATE_READ: begin
                    if (rd_end == 1'b1) begin
                        state <= STATE_ARBIT;
                        rd_en <= 1'b0;
                    end
                end
                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end

    // cmd, ba, addr output:
    always @ (*) begin
        case (state)
            STATE_IDLE: begin
                out_cmd = init_cmd;
                out_ba = init_ba;
                out_addr = init_addr;
            end
            STATE_AREF: begin
                out_cmd = aref_cmd;
                out_ba = aref_ba;
                out_addr = aref_addr;
            end
            STATE_WRITE: begin
                out_cmd = wr_cmd;
                out_ba = wr_ba;
                out_addr = wr_addr;
            end
            STATE_READ: begin
                out_cmd = rd_cmd;
                out_ba = rd_ba;
                out_addr = rd_addr;
            end
            default: begin
                out_cmd = `OP_NOP;
                out_ba = 2'b11;
                out_addr = 13'h1fff;
            end
        endcase
    end

    assign reading = (state == STATE_READ) ? 1'b1 : 1'b0;

    assign writing = (state == STATE_WRITE) ? 1'b1 : 1'b0;

endmodule
