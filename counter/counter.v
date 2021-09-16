
module counter(
    input clk,
    input rst,
    output [7:0] reg out
);

    always @ (posedge clk or negedge rst) begin
        if (rst == 1'b0)
            out <= 8'b0;
        else
            if (out == 8'hff)
                out <= 8'b0;
            else
                out <= out + 8'b1;
    end

endmodule
