
module counter
#(
    parameter CNT_MAX = 8'd100
)
(
    input clk,
    input rst_n,
    output reg [7:0] out
);

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            out <= 0;
        else
            if (out == CNT_MAX - 8'b1)
                out <= 0;
            else
                out <= out + 8'b1;
    end

endmodule
