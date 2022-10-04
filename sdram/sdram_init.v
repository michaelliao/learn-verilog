/******************************************************************************
SDRAM initialization:

1. Power up
   Wait 200 ns

2. Precharge all banks
   A10 = 1
   Wait tRP = 20 ns

3. Auto refresh
   Command = AUTO_REFRESH
   Wait tRFC = 70 ns

4. Auto refresh (repeat 2 ~ 7)

5. Load mode register
   Command = LOAD_MODE_REGISTER
   Wait tMRD = 2 clock cycles

******************************************************************************/

`include "sdram_op.v"

module sdram_init #(
    parameter CLK = 100_000_000, // default to 100 MHz
    parameter CAS_LATENCY = 2, // CAS Latency: 1, 2, 3
    parameter BURST_LENGTH = 4, // burst length: 1, 2, 4, 8
    parameter TPOWERUP = 200, // tPowerUp = 200 ns, wait time for power up
    parameter TRP = 20, // tRP = 20 ns, wait time for precharge
    parameter TRFC = 70, // tRFC = 70 ns, wait time for auto refresh
    parameter MAX_AUTO_REFRESH = 3'd4 // auto refresh: 2 ~ 7
)
(
    input clk,
    input rst_n,
    output reg [3:0] cmd,
    output reg [1:0] ba, // bank address
    output reg [12:0] addr,
    output reg init_end
);

    // time in ns per 1 clock cycle:
    localparam TIME_PER_CLK = 1_000_000_000 / CLK;

    localparam
        CLK_POWER_UP = TPOWERUP / TIME_PER_CLK, // power up clock cycles
        CLK_TRP = TRP / TIME_PER_CLK, // tRP clock cycles
        CLK_TRFC = TRFC / TIME_PER_CLK, // tRFC clock cycles
        CLK_TMRD = 2; // tMRD clock cycles

    localparam MR_CAS_LATENCY = CAS_LATENCY == 1 ? 3'b001 :
                               (CAS_LATENCY == 2 ? 3'b010 :
                               (CAS_LATENCY == 3 ? 3'b011 : 3'b011));

    localparam MR_BURST_LENGTH = BURST_LENGTH == 1 ? 3'b000 : 
                                (BURST_LENGTH == 2 ? 3'b001 :
                                (BURST_LENGTH == 4 ? 3'b010 :
                                (BURST_LENGTH == 8 ? 3'b011 : 3'b111)));

    localparam
        CNT_0 = 8'b0,
        CNT_1 = 8'b1;

    localparam
        STATE_IDLE           = 3'b000,
        STATE_PRECHARGE      = 3'b001,
        STATE_PRECHARGE_WAIT = 3'b011,
        STATE_AUTO_REF       = 3'b010,
        STATE_AUTO_REF_WAIT  = 3'b110,
        STATE_MR_SET         = 3'b111,
        STATE_MR_SET_WAIT    = 3'b101,
        STATE_DONE           = 3'b100;

    reg [2:0] state;

    reg [2:0] cnt_auto_refresh;

    // counter for 0 ~ 255:
    reg [7:0] cnt;

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            state <= STATE_IDLE;
            cnt_auto_refresh <= 3'b0;
            cnt <= CNT_0;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (cnt == (CLK_POWER_UP - 1)) begin
                        state <= STATE_PRECHARGE;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_PRECHARGE: begin
                    state <= STATE_PRECHARGE_WAIT;
                    cnt <= CNT_0;
                end
                STATE_PRECHARGE_WAIT: begin
                    if (cnt == (CLK_TRP - 1)) begin
                        state <= STATE_AUTO_REF;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_AUTO_REF: begin
                    state <= STATE_AUTO_REF_WAIT;
                    cnt <= CNT_0;
                end
                STATE_AUTO_REF_WAIT: begin
                    if (cnt == (CLK_TRFC - 1) && cnt_auto_refresh == (MAX_AUTO_REFRESH - 1)) begin
                        state <= STATE_MR_SET;
                    end else begin
                        if (cnt == (CLK_TRFC - 1)) begin
                            state <= STATE_AUTO_REF;
                            cnt_auto_refresh <= cnt_auto_refresh + 1;
                        end else begin
                            cnt_auto_refresh <= cnt_auto_refresh;
                            cnt <= cnt + 1;
                        end
                    end
                end
                STATE_MR_SET: begin
                    state <= STATE_MR_SET_WAIT;
                    cnt <= CNT_0;
                end
                STATE_MR_SET_WAIT: begin
                    if (cnt == (CLK_TMRD - 1)) begin
                        state <= STATE_DONE;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_DONE: begin
                    state <= STATE_DONE;
                end
                default: begin
                    state <= STATE_DONE;
                end
            endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            cmd <= `OP_NOP;
            ba <= 2'b11;
            addr <= 13'h1fff;
        end else if (state == STATE_PRECHARGE) begin
            cmd <= `OP_PRECHARGE;
            ba <= 2'b11;
            addr <= 13'h1fff;
        end else if (state == STATE_AUTO_REF) begin
            cmd <= `OP_AUTO_REFRESH;
            ba <= 2'b11;
            addr <= 13'h1fff;
        end else if (state == STATE_MR_SET) begin
            cmd <= `OP_LOAD_MR;
            ba <= 2'b00;
            // Reserved         = 000 = Reserved
            // Write Burst Mode = 0   = Programmed Burst Length
            // Operation Mode   = 00  = Standard Operation
            // CAS Latency      = 010 = 2
            // Burst Type       = 0   = Sequential
            // Burst Length     = 010 = 4
            addr <= { 3'b000, 1'b0, 2'b00, MR_CAS_LATENCY, 1'b0, MR_BURST_LENGTH };
        end else begin
            cmd <= `OP_NOP;
            ba <= 2'b11;
            addr <= 13'h1fff;
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n)
            init_end <= 1'b0;
        else if (state == STATE_DONE)
            init_end <= 1'b1;
        else
            init_end <= 1'b0;
    end

endmodule
