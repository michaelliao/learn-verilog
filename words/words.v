// display words

module words
(
    input clk,
    input rst,
    output reg out
);

    reg [47:0] regs;

    always @ (negedge rst) begin
        if (rst == 1'b0)
            regs <= {H,E,L,L,O,X};
    end

    always @ (posedge clk) begin
        //
    end

endmodule

module data_output
#(
    parameter C = 8'b01100011,
    parameter E = 8'b01100001,
    parameter F = 8'b01110001,
    parameter H = 8'b10010001,
    parameter L = 8'b11100011,
    parameter O = 8'b00000011,
    parameter P = 8'b00110001,
    parameter U = 8'b10000011,
    parameter X = 8'b11111111
)
(
    output reg [47:0] out
);
    assign out = {H,E,L,L,O,X};
endmodule

module hc595driver(
    input clk,
    input rst,
    input [5:0] sel,
    input [7:0] seg,
    output stcp,
    output shcp,
    output ds,
    output oe
);


endmodule
