
module clk_delay #(
    parameter WIDTH = 8
)
(
    input  wire clk,
    input  wire [WIDTH-1:0] in_data,
    output reg [WIDTH-1:0] out_data
);
    always @ (posedge clk) begin
        out_data <= in_data;
    end
endmodule
