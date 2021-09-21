// display words

//     parameter C = 8'b01100011,
//     parameter E = 8'b01100001,
//     parameter F = 8'b01110001,
//     parameter H = 8'b10010001,
//     parameter L = 8'b11100011,
//     parameter O = 8'b00000011,
//     parameter P = 8'b00110001,
//     parameter U = 8'b10000011,
//     parameter NONE = 8'b11111111

module words
(
    input clk,
    input rst,
    input [7:0] seg,
    input [5:0] sel,
    output reg shcp,
    output reg stcp,
    output ds,
    output oe
);

    wire [15:0] data;

    assign data = {seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6], seg[7], sel[5:0]}

    reg [1:0] cnt;
    reg [3:0] cnt_bit;

    always @ (posedge clk) begin
        if (rst == 1'b1)
            cnt <= 2'b0;
            cnt_bit <= 3'b0;
            ds <= 1'b0;
            shcp <= 1'b0;
            stcp <= 1'b0;
        else begin
            cnt <= cnt + 2'b1;
            if (cnt_bit == 3'd13)
                cnt_bit <= 3'b0;
            else
                cnt_bit <= cnt_bit + 3'b1;
            // output ds:
            if (cnt == 2'b0)
                ds <= data[cnt_bit];
            else
                ds <= ds;
            // output shcp:
            if (cnt == 2'h2)
                shcp <= 1'b1;
            else if (cnt == 2'h0)
                shcp <= 1'b0;
            else
                shcp <= shcp;
            // output stcp:
            if (cnt == 2'h0 && cnt_bit == 3'h0)
                stcp <= 1'b1;
            else if (cnt == 2'h2 && cnt_bit == 3'h0)
                stcp <= 1'b0;
            else
                stcp <= stcp;
        end
    end

    assign oe = 1'b0;


    reg [47:0] regs;

    always @ (negedge rst) begin
        if (rst == 1'b0)
            regs <= {H,E,L,L,O,X};
    end

    always @ (posedge clk) begin
        if (rst == 1'b1)
            data <= 8'b0;
            sel <= 6'b0;
        else
            data <= 8'b10010001;
            sel <= 6'b1;
    end

endmodule
