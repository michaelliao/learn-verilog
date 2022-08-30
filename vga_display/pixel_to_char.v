module pixel_to_char (
    input  wire clk,
    input  wire rst_n,
    // pixel x of screen: 0 ~ 639:
    input  wire [9:0] pix_x,
    // pixel y of screen: 0 ~ 479:
    input  wire [9:0] pix_y,

    output reg en,
    // char index: 0 ~ 1999:
    output wire [10:0] char_index,
    // pixel x of char: 0 ~ 7:
    output reg [2:0] char_pixel_x,
    // pixel y of char: 0 ~ 15:
    output reg [3:0] char_pixel_y
);

    parameter PIX_Y_START = 10'd32,
              PIX_Y_END = PIX_Y_START + 25 * 16;

    reg [10:0] row;
    reg [10:0] col;

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            en <= 1'b0;
            row <= 11'b0;
            col <= 11'b0;
            char_pixel_x <= 3'b0;
            char_pixel_y <= 4'b0;
        end
        else if (pix_y >= PIX_Y_START && pix_y < PIX_Y_END) begin
            en <= 1'b1;
            row <= (pix_y - PIX_Y_START) >> 4;
            col <= pix_x >> 3;
            char_pixel_x <= pix_x[2:0] & 3'b111;
            char_pixel_y <= pix_y[3:0] & 4'b1111;
        end
        else begin
            en <= 1'b0;
            row <= 11'b0;
            col <= 11'b0;
            char_pixel_x <= 3'b0;
            char_pixel_y <= 4'b0;
        end
    end

    assign char_index = row * 11'd80 + col;
endmodule
