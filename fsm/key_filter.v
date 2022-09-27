// key filter

module key_filter
#(
    parameter CNT_WIDTH = 20
)
(
    input  wire clk,
    input  wire rst_n,
    input  wire key_in,
    output reg key_out
);

    parameter [CNT_WIDTH-1:0] CNT_MAX = (1 << CNT_WIDTH)-1;

    reg [CNT_WIDTH-1:0] cnt;

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            cnt <= 20'b0;
        else begin
            if (key_in == 1'b1)
                // key unpressed, keep 0:
                cnt <= 20'b0;
            else
                // key pressed, cnt = 0, 1, 2, ... , MAX-1, MAX, MAX, ...
                cnt <= (cnt == CNT_MAX) ? CNT_MAX : cnt + 1'b1;
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            key_out <= 1'b1;
        else
            // key out is triggered at MAX-1:
            key_out <= (cnt == CNT_MAX - 1) ? 1'b0 : 1'b1;
    end
endmodule
