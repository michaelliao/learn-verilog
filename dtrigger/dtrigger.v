
module dtrigger(
    input d,
    input clk,
    input rst,
    output reg q
);

    // async reset:
    always @ (posedge clk or negedge rst) begin
        if (rst == 1'b1)
            q <= 0;
        else
            q <= d;
    end

    // sync reset:
    /*
    always @ (posedge clk) begin
        if (rst == 1'b1)
            q <= 0;
        else
            q <= d;
    end
    */

endmodule;
