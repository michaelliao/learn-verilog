module vga_data (
    input clk,
    input rst_n,
    input [9:0] pix_x,
    input [9:0] pix_y,
    output reg [23:0] pix_rgb
);

`define BLACK  24'h000000
`define RED    24'hff0000
`define GREEN  24'h00ff00
`define BLUE   24'h0000ff
`define ORANGE 24'hff8000
`define CYAN   24'h00ffff
`define GRAY   24'h808080
`define WHITE  24'hffffff

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            pix_rgb <= `BLACK;
        // border:
        else if (pix_x < 1 || pix_y < 1 || pix_x >= 639 || pix_y >= 479)
            pix_rgb <= `RED;
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
