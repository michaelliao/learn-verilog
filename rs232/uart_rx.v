// receive data
// Baud = 9600, 14400, 19200, 38400, 57600, 115200

module uart_rx #(
    parameter BAUD = 9600, // default to 9600
    parameter SYS_CLK = 50_000_000 // default to 50MHz
)
(
    input wire clk,
    input wire rst_n,
    input wire in_data,
    output wire [7:0] out_data,
    output wire out_parity,
    output reg out_en
);

    parameter [12:0] CNT_0 = 0;
    parameter [12:0] CNT_MAX = SYS_CLK / BAUD / 2 - 1;

    parameter IDLE = 1'b0,
              RECEIVING = 1'b1;

    reg status;
    reg [12:0] cnt;
    reg [4:0] bps_cnt; // count for 0, 1, 2, ..., 15, 16, 17
    reg [7:0] data;
    reg parity;
    reg [2:0] rx_detect;

    assign out_data = out_en == 1'b1 ? data : 8'd0;
    assign out_parity = out_en == 1'b1 ? parity : 8'd0;

    always @ (posedge clk or negedge rst_n) begin
        rx_detect[0] <= in_data;
        rx_detect[1] <= rx_detect[0];
        rx_detect[2] <= rx_detect[1];
        if (rst_n == 1'b0) begin
            status <= IDLE;
            cnt <= CNT_0;
            bps_cnt <= 5'd0;
            data <= 8'd0;
            parity <= 1'b0;
            out_en <= 1'b0;
        end else begin
            if (status == IDLE) begin
                data <= 8'd0;
                parity <= 1'b0;
                out_en <= 1'b0;
                cnt <= CNT_0;
                if (rx_detect[2:1] == 2'b10) begin
                    // start receiving:
                    status <= RECEIVING;
                    bps_cnt <= 5'd1;
                end else begin
                    // keep IDEL status:
                    status <= IDLE;
                    bps_cnt <= 5'd0;
                end
            end else begin
                // receiving data:
                if (cnt == CNT_MAX) begin
                    cnt <= CNT_0;
                    case (bps_cnt)
                        5'd1: begin
                            // start 0 sample point:
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            out_en <= 1'b0;
                        end
                        5'd2, 5'd4, 5'd6, 5'd8, 5'd10, 5'd12, 5'd14, 5'd16, 5'd18, 5'd20: begin
                            // ignore sampling near at edge:
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            out_en <= 1'b0;
                        end
                        5'd3: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[0] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd5: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[1] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd7: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[2] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd9: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[3] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd11: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[4] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd13: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[5] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd15: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[6] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd17: begin
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            data[7] <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd19: begin
                            // parity sample point:
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= RECEIVING;
                            parity <= in_data;
                            out_en <= 1'b0;
                        end
                        5'd21: begin
                            // end 1 sample point:
                            bps_cnt <= 4'd0;
                            status <= IDLE;
                            data <= data;
                            out_en <= 1'b1;
                        end
                        default: begin
                            bps_cnt <= 1'b0;
                            status <= IDLE;
                            data <= 8'd0;
                            out_en <= 1'b0;
                        end
                    endcase
                end else begin
                    cnt <= cnt + 1'b1;
                    bps_cnt <= bps_cnt;
                    status <= RECEIVING;
                    data <= data;
                    out_en <= 1'b0;
                end
            end
        end
    end

endmodule
