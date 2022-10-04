/******************************************************************************

SDRAM auto refresh

1. Precharge all banks
   A10 = 1
   Wait tRP = 20 ns

2. Auto refresh
   Command = AUTO_REF
   Wait tRFC = 70 ns

3. Auto refresh (2nd)

******************************************************************************/

`include "sdram_op.v"

module sdram_aref #(
    parameter CLK = 100_000_000, // default to 100 MHz
    parameter ROWS = 8192, // how many rows should be refreshed in 64 ms
    parameter TRP = 20, // tRP = 20 ns, wait time for precharge
    parameter TRFC = 70 // tRFC = 70 ns, wait time for auto refresh
)
(
    input clk,
    input rst_n,
    input init_end, // 1 = sdram_init ok
    input aref_en,
    output reg aref_req,
    output reg [3:0] cmd,
    output reg [1:0] ba, // bank address
    output reg [12:0] addr,
    output reg aref_end
);

    // time in ns per 1 clock cycle:
    localparam TIME_PER_CLK = 1_000_000_000 / CLK;

    localparam
        CLK_TRP = TRP / TIME_PER_CLK, // tRP clock cycles
        CLK_TRFC = TRFC / TIME_PER_CLK, // tRFC clock cycles
        CLK_BUFFER = 10; // a buffer clock cycles

    // aref count range:
    localparam CNT_AREF_REQ_MAX = 64_000_000 / TIME_PER_CLK / ROWS - CLK_TRP - 2 * CLK_TRFC - CLK_BUFFER;

    localparam
        CNT_0 = 4'b0,
        CNT_1 = 4'b1,
        CNT_AREF_REQ_0 = 13'b0;

    localparam
        STATE_IDLE           = 3'b000,
        STATE_PRECHARGE      = 3'b001,
        STATE_PRECHARGE_WAIT = 3'b011,
        STATE_AUTO_REF       = 3'b010,
        STATE_AUTO_REF_WAIT  = 3'b110,
        STATE_DONE           = 3'b111;

    reg [2:0] state;

    // 0 ~ 15:
    reg [3:0] cnt;

    // 0 ~ 1: auto refresh count
    reg cnt_aref;

    // counter for 0 ~ 8191:
    reg [12:0] cnt_aref_req;

    // cnt_aref_req loop from 0 ~ CNT_AREF_REQ_MAX:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            cnt_aref_req <= CNT_AREF_REQ_0;
        end else if (init_end == 1'b1) begin
            if (cnt_aref_req == CNT_AREF_REQ_MAX) begin
                cnt_aref_req <= CNT_AREF_REQ_0;
            end else begin
                cnt_aref_req <= cnt_aref_req + 1;
            end
        end else begin
            cnt_aref_req <= CNT_AREF_REQ_0;
        end
    end

    // aref_req output:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            aref_req <= 1'b0;
        end else if (cnt_aref_req == CNT_AREF_REQ_MAX) begin
            aref_req <= 1'b1;
        end else if (state == STATE_DONE) begin
            aref_req <= 1'b0;
        end else begin
            aref_req <= aref_req;
        end
    end

    // aref_end output:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n)
            aref_end <= 1'b0;
        else if (state == STATE_DONE)
            aref_end <= 1'b1;
        else
            aref_end <= 1'b0;
    end

    // fsm:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            state <= STATE_IDLE;
            cnt <= CNT_0;
            cnt_aref <= 1'b0;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (aref_en == 1'b1) begin
                        state <= STATE_PRECHARGE;
                    end
                end
                STATE_PRECHARGE: begin
                    state <= STATE_PRECHARGE_WAIT;
                    cnt <= CNT_0;
                end
                STATE_PRECHARGE_WAIT: begin
                    if (cnt == (CLK_TRP - 1)) begin
                        state <= STATE_AUTO_REF;
                        cnt_aref <= 1'b0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_AUTO_REF: begin
                    state <= STATE_AUTO_REF_WAIT;
                    cnt <= CNT_0;
                end
                STATE_AUTO_REF_WAIT: begin
                    if (cnt == (CLK_TRFC - 1)) begin
                        if (cnt_aref == 1'b1) begin
                            state <= STATE_DONE;
                        end else begin
                            state <= STATE_AUTO_REF;
                            cnt_aref <= 1'b1;
                        end
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_DONE: begin
                    state <= STATE_IDLE;
                end
                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            cmd <= `OP_NOP;
            ba <= 2'b11;
            addr <= 13'h1fff;
        end else begin
            case (state)
                STATE_PRECHARGE: begin
                    cmd <= `OP_PRECHARGE;
                    ba <= 2'b11;
                    addr <= 13'h1fff;
                end
                STATE_AUTO_REF: begin
                    cmd <= `OP_AUTO_REF;
                    ba <= 2'b11;
                    addr <= 13'h1fff;
                end
                default: begin
                    cmd <= `OP_NOP;
                    ba <= 2'b11;
                    addr <= 13'h1fff;
                end
            endcase
        end
    end

endmodule
