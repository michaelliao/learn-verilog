`timescale 1ns / 1ns

module tb_sdram_core();

    reg clk_100m;
    reg clk_100m_shift;
    reg rst_n;

    initial begin
        rst_n = 1'b0;
        #25
        rst_n = 1'b1;
    end

    // 100 MHz clk and clk_shift:
    initial begin
        clk_100m = 1'b1;
        forever begin
            #5 clk_100m = ~clk_100m;
        end
    end

    initial begin
        clk_100m_shift = 1'b0;
        #2
        forever begin
            #5 clk_100m_shift = ~clk_100m_shift;
        end
    end

    wire [15:0] sdr_dq;
    wire [12:0] sdr_addr;
    wire [1:0] sdr_ba;
    wire [3:0] sdr_cmd;
    wire [1:0] sdr_dqm;

    sdram_core #(
        .SDR_TPOWERUP (200), // speed power up from 200 us to 200 ns
        .SDR_INIT_AREF_COUNT (2), // aref x2 when init
        .SDR_REFRESH_CYCLE_TIME (6_400_000) // set refresh cycle to 6.4 ms to speed up test
    )
    component (
        .clk (clk_100m),
        .rst_n (rst_n),
        .inout_data (sdr_dq),

        .cmd (sdr_cmd),
        .ba (sdr_ba),
        .addr (sdr_addr)
    );

    mt48lc16m16a2 sdr_inst (
        .Dq (sdr_dq),
        .Addr (sdr_addr),
        .Ba (sdr_ba),
        .Clk (clk_100m_shift),
        .Cke (1'b1),
        .Cs_n (sdr_cmd[3]),
        .Ras_n (sdr_cmd[2]),
        .Cas_n (sdr_cmd[1]),
        .We_n (sdr_cmd[0]),
        .Dqm (sdr_dqm)
    );

    initial begin
        $dumpfile("tb_sdram_core.vcd");
        $dumpvars(0, component);
        #3000
        $finish;
    end

endmodule
