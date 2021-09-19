
module clk_divider (
    input clk,
    output clk2,
    output clk4,
    output clk8
);

    reg [3:0] cnt;

    always @ (posedge clk) begin
        cnt <= cnt + 1;
    end

    assign clk2 = cnt[1];
    assign clk4 = cnt[2];
    assign clk8 = cnt[3];

endmodule
