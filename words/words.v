// display words

module words
(
    input clk,
    input rst_n,
    output shcp,
    output stcp,
    output ds,
    output oe
);
    parameter C = 8'b01100011;
    parameter E = 8'b01100001;
    parameter F = 8'b01110001;
    parameter H = 8'b10010001;
    parameter L = 8'b11100011;
    parameter O = 8'b00000011;
    parameter P = 8'b00110001;
    parameter U = 8'b10000011;
    parameter X = 8'b11111111;

    reg [47:0] data;

    reg [15:0] cnt16; // 0 ~ 65535

    reg [25:0] cnt26; // 0 ~ 67108863

    reg [7:0] seg;
    reg [5:0] sel;

    always @ (posedge clk) begin
        if (! rst_n) begin
            cnt16 <= 16'b0;
            cnt26 <= 26'b0;
            sel <= 6'b000_001;
        end else begin
            cnt16 <= cnt16 + 16'b1;
            cnt26 <= cnt26 + 26'b1;
            if (cnt26[25] == 1'b1)
                data <= { H, E, L, L, O, X };
            else
                data <= { X, H, E, L, L, O };
            if (cnt16 == 16'hffff)
                if (sel == 6'b000_001)
                    begin
                        sel <= 6'b000_010;
                        seg <= data[15:8];
                    end
                else if (sel == 6'b000_010)
                    begin
                        sel <= 6'b000_100;
                        seg <= data[23:16];
                    end
                else if (sel == 6'b000_100)
                    begin
                        sel <= 6'b001_000;
                        seg <= data[31:24];
                    end
                else if (sel == 6'b001_000)
                    begin
                        sel <= 6'b010_000;
                        seg <= data[39:32];
                    end
                else if (sel == 6'b010_000)
                    begin
                        sel <= 6'b100_000;
                        seg <= data[47:40];
                    end
                else
                    begin
                        sel <= 6'b000_001;
                        seg <= data[7:0];
                    end
        end
    end

    digital_tube_display digital_tube_display_inst(
        .clk (clk),
        .rst_n (rst_n),
        .seg (seg),
        .sel (sel),
        .shcp (shcp),
        .stcp (stcp),
        .ds (ds),
        .oe (oe)
    );

endmodule
