
module counter(
    input clk,
    input rst_n,
    output reg [7:0] out
);

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            out <= 8'b0;
        else
            out <= out + 8'b1;
    end

endmodule
