`timescale 1ns / 1ns

module tb_rx_fsm();

    reg clk_wr;
    reg clk_rd;
    reg rst_n;

    initial begin
        rst_n = 1'b0;
        #25
        rst_n = 1'b1;
    end

    // 50 MHz clk_wr:
    initial begin
        clk_wr = 1'b1;
        forever begin
            #10 clk_wr = ~clk_wr;
        end
    end

    // 100 MHz clk_rd:
    initial begin
        clk_rd = 1'b1;
        #2
        forever begin
            #5 clk_rd = ~clk_rd;
        end
    end

    reg in_rx_data;
    reg in_op_ack;
    wire out_op;
    wire out_address;
    wire out_data;

    rx_fsm #(
        .BAUD (5_000_000) // 波特率是时钟频率的1/10
    )
    component (
        .clk_wr (clk_wr),
        .clk_rd (clk_rd),
        .wr_rst_n (rst_n),
        .rd_rst_n (rst_n),
        .in_rx_data (in_rx_data),
        .op_ack (in_op_ack),
        .op (out_op),
        .address (out_address),
        .data (out_data)
    );

    reg [63:0] in_data;
    reg [7:0] rx_byte;

    initial begin
        in_rx_data = 1'b1;
        in_op_ack = 1'b0;
        // 输入数据: 0xfea1b2c3_6c7d8e9c
        in_data = 64'hfea1b2c3_6c7d8e9c;
        #55;
        repeat (8) begin
            rx_byte = in_data[63:56];
            in_data = in_data << 8;
            in_rx_data = 1'b0; // leading bit 0
            #200;
            repeat (8) begin
                in_rx_data = rx_byte[0];
                rx_byte = rx_byte >> 1;
                #200;
            end
            in_rx_data = 1'b1; // end bit 1
            #200;
        end
        #300;
        in_op_ack = 1'b1;
        #100;
        $finish;
    end

    initial begin
        $dumpfile("tb_rx_fsm.vcd");
        $dumpvars(0, component);
    end

endmodule
