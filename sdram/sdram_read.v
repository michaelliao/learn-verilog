/******************************************************************************
SDRAM read: continuous page burst

1. Active selected bank and row
   Command = ACTIVE
   bank = #bank
   row = #row
   Wait tRCD = 2 clock cycles

2. Read bytes (1 ~ 8)
   Command = READ, NOP, NOP, ..., BURST_TERM
   Data = N/A, N/A, byte1, byte2, byte3, ..., Byte(N-1), ByteN

3. Precharge
   Command = PRECHARGE
   bank = #bank
   row = #row
   Wait tRP = 2 clock cycles

******************************************************************************/

`include "sdram_op.v"

module sdram_read #(
    parameter CLK = 100_000_000, // default to 100 MHz
    parameter CAS_LATENCY = 2, // CAS Latency: 1, 2, 3
    parameter TRCD = 20, // tRCD = 20 ns, wait time for active
    parameter TRP = 20 // tRP = 20 ns, wait time for precharge
)
(
    input clk,
    input rst_n,
    input init_end, // 1 = sdram_init ok
    input rd_en,
    input rd_in,
    input [7:0] rd_data, // read data
    input [23:0] rd_addr, // read address
    input [3:0] rd_burst_length, // 1 ~ 8
    output reg [3:0] cmd,
    output reg [1:0] ba, // bank address
    output reg [12:0] addr,
    output reg [7:0] data,
    output reg data_en,
    output reg rd_req,
    output reg rd_end
);

    // time in ns per 1 clock cycle:
    localparam TIME_PER_CLK = 1_000_000_000 / CLK;

    localparam
        CLK_TRP = TRP / TIME_PER_CLK, // tRP clock cycles
        CLK_TRCD = TRCD / TIME_PER_CLK; // tRCD clock cycles

    localparam MR_CAS_LATENCY = CAS_LATENCY == 1 ? 3'b001 :
                               (CAS_LATENCY == 2 ? 3'b010 :
                               (CAS_LATENCY == 3 ? 3'b011 : 3'b011));

    localparam CNT_0 = 4'b0;

    localparam
        STATE_IDLE           = 3'b000,
        STATE_ACTIVE         = 3'b001,
        STATE_ACTIVE_WAIT    = 3'b011,
        STATE_READ           = 3'b010,
        STATE_BURST_TERM     = 3'b110,
        STATE_PRECHARGE      = 3'b111,
        STATE_PRECHARGE_WAIT = 3'b101,
        STATE_DONE           = 3'b100;

    reg [2:0] state;

    // 0 ~ 15:
    reg [3:0] cnt;

    // 0 ~ 7:
    reg [2:0] cnt_burst;

    // rd_end output:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n)
            rd_end <= 1'b0;
        else if (state == STATE_DONE)
            rd_end <= 1'b1;
        else
            rd_end <= 1'b0;
    end

    // fsm:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            state <= STATE_IDLE;
            cnt <= CNT_0;
            cnt_burst <= 3'b0;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (rd_en == 1'b1) begin
                        state <= STATE_ACTIVE;
                    end
                end
                STATE_ACTIVE: begin
                    state <= STATE_ACTIVE_WAIT;
                    cnt <= CNT_0;
                end
                STATE_ACTIVE_WAIT: begin
                    if (cnt == (CLK_TRCD - 1)) begin
                        state <= STATE_READ;
                        cnt <= CNT_0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_READ: begin
                    if (cnt == (rd_burst_length - 1)) begin
                        state <= STATE_BURST_TERM;
                        cnt_burst <= 3'b0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                STATE_BURST_TERM: begin
                    // keep CL clocks for BURST_TERM:
                    if (cnt_burst == (MR_CAS_LATENCY - 1)) begin
                        state <= STATE_PRECHARGE;
                    end else begin
                        cnt <= cnt + 1;
                        cnt_burst <= cnt_burst + 1;
                    end
                end
                STATE_PRECHARGE: begin
                    state <= STATE_PRECHARGE_WAIT;
                    cnt <= CNT_0;
                end
                STATE_PRECHARGE_WAIT: begin
                    if (cnt == (CLK_TRP - 1)) begin
                        state <= STATE_DONE;
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

    // command:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            cmd <= `OP_NOP;
            ba <= 2'b11;
            addr <= 13'h1fff;
        end else begin
            case (state)
                STATE_ACTIVE: begin
                    cmd <= `OP_ACTIVE;
                    ba <= rd_addr[23:22];
                    addr <= rd_addr[21:9];
                end
                STATE_READ: begin
                    if (cnt == 0) begin
                        cmd <= `OP_READ;
                        ba <= rd_addr[23:22];
                        addr <= { 4'b0000, rd_addr[8:0]};
                    end else begin
                        cmd <= `OP_NOP;
                        ba <= 2'b11;
                        addr <= 13'h1fff;
                    end
                end
                STATE_BURST_TERM: begin
                    if (cnt_burst == 0) begin
                        cmd <= `OP_BURST_TERM;
                        ba <= 2'b11;
                        addr <= 13'h1fff;
                    end else begin
                        cmd <= `OP_NOP;
                        ba <= 2'b11;
                        addr <= 13'h1fff;
                    end
                end
                STATE_PRECHARGE: begin
                    cmd <= `OP_PRECHARGE;
                    ba <= rd_addr[23:22];
                    addr <= 13'h0000; // A10 = 0 = selected bank
                end
                default: begin
                    cmd <= `OP_NOP;
                    ba <= 2'b11;
                    addr <= 13'h1fff;
                end
            endcase
        end
    end

    // data output:
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            data <= 8'h0;
        end else if ((state == STATE_READ || state == STATE_BURST_TERM) && (cnt >= MR_CAS_LATENCY) && (cnt < rd_burst_length + MR_CAS_LATENCY)) begin
            data <= rd_data;
        end else begin
            data <= 8'h0;
        end
    end

endmodule
