
module dff(
    input clk,
    input rst_n,
    input d,
    output reg out
);

    // async reset:
    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            out <= 0;
        else
            out <= d;
	 end

endmodule
