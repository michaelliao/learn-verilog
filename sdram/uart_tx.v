// send data
// Baud = 9600, 14400, 19200, 38400, 57600, 115200

module uart_tx #(
    parameter BAUD = 9600, // default to 9600
    parameter SYS_CLK = 50_000_000 // default to 50MHz
)
(
    input wire clk,
    input wire rst_n,
    input wire [7:0] in_data,
    input wire in_en,
    output reg out_data,
    output wire out_en
);
    localparam
        MAX = SYS_CLK / BAUD - 1,
        WIDTH = $clog2(MAX + 1);

    localparam [WIDTH-1:0] CNT_0 = 0;
    localparam [WIDTH-1:0] CNT_MAX = MAX;

    localparam
        IDLE = 1'b0,
        TRANSFER = 1'b1;

    reg status;
    reg [3:0] bps_cnt; // count for 0, 1, 2, ..., 7, 8
    reg [WIDTH-1:0] cnt;
    reg [7:0] data;
    reg parity;

    assign out_en = status;

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            status <= IDLE;
            bps_cnt <= 4'd0;
            cnt <= CNT_0;
            data <= 8'b0;
            parity <= 1'b0;
            out_data <= 1'b1;
        end else begin
            if (status == IDLE) begin
                if (in_en == 1'b1) begin
                    // start transfer:
                    status <= TRANSFER;
                    bps_cnt <= 4'd1;
                    cnt <= CNT_MAX;
                    data <= in_data;
                    parity <= ~(^in_data);
                    out_data <= 1'b1;
                end else begin
                    // keep IDLE status:
                    status <= IDLE;
                    bps_cnt <= 4'd0;
                    cnt <= CNT_0;
                    data <= 8'b0;
                    parity <= 1'b0;
                    out_data <= 1'b1;
                end
            end else begin
                data <= data;
                // transfer data:
                if (cnt == CNT_MAX) begin
                    cnt <= CNT_0;
                    case (bps_cnt)
                        4'd1: begin
                            // start 0:
                            out_data <= 1'b0;
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd2: begin
                            out_data <= data[0];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd3: begin
                            out_data <= data[1];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd4: begin
                            out_data <= data[2];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd5: begin
                            out_data <= data[3];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd6: begin
                            out_data <= data[4];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd7: begin
                            out_data <= data[5];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd8: begin
                            out_data <= data[6];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd9: begin
                            out_data <= data[7];
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd10: begin
                            // odd parity:
                            out_data <= parity;
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd11: begin
                            // end 1:
                            out_data <= 1'b1;
                            bps_cnt <= bps_cnt + 1'b1;
                            status <= TRANSFER;
                        end
                        4'd12: begin
                            // done:
                            out_data <= 1'b1;
                            bps_cnt <= 4'd0;
                            status <= IDLE;
                        end
                        default: begin
                            out_data <= 1'b1;
                            bps_cnt <= 4'd0;
                            status <= IDLE;
                        end
                    endcase
                end else begin
                    cnt <= cnt + 1'b1;
                    bps_cnt <= bps_cnt;
                    out_data <= out_data;
                    status <= TRANSFER;
                end
            end
        end
    end

endmodule
