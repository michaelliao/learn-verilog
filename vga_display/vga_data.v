module vga_data (
    input  wire clk,
    input  wire rst_n,
    input  wire [9:0] pix_x,
    input  wire [9:0] pix_y,

    output reg [15:0] pix_rgb
);

`define BLACK  16'h0000
`define RED    16'hf800
`define GREEN  16'h07e0
`define BLUE   16'h001f
`define ORANGE 16'hfc00
`define CYAN   16'h07ff
`define GRAY   16'hd69a
`define WHITE  16'hffff

`define H_SIZE 10'd640
`define V_SIZE 10'd480

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            pix_rgb <= `BLACK;
        // (120, 100) - (220, 180)
        else if (pix_x >= 120 && pix_x < 220 && pix_y >= 100 && pix_y < 180)
            pix_rgb <= `RED;
        // (420, 100) - (520, 180)
        else if (pix_x >= 420 && pix_x < 520 && pix_y >= 100 && pix_y < 180)
            pix_rgb <= `RED;
        // (220, 300) - (420, 380)
        else if (pix_x >= 220 && pix_x < 420 && pix_y >= 300 && pix_y < 380)
            pix_rgb <= `BLUE;
        else
            pix_rgb <= `GRAY;
    end

endmodule
