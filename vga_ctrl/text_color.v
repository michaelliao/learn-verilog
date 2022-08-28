// VGA 16 Color Palette:
// https://en.wikipedia.org/wiki/Color_Graphics_Adapter

module text_color (
    input  wire [3:0] color_index,
    output wire [15:0] color_rgb
);
    `define COLOR_0 16'b0000000000000000 // BLACK = #000000
    `define COLOR_1 16'b0000000000010101 // BLUE = #0000aa
    `define COLOR_2 16'b0000010101000000 // GREEN = #00aa00
    `define COLOR_3 16'b0000010101010101 // CYAN = #00aaaa
    `define COLOR_4 16'b1010100000000000 // RED = #aa0000
    `define COLOR_5 16'b1010100000010101 // MAGENTA = #aa00aa
    `define COLOR_6 16'b1010101010100000 // BROWN = #aa5500
    `define COLOR_7 16'b1010110101010101 // L_GRAY = #aaaaaa
    `define COLOR_8 16'b0101001010101010 // D_GRAY = #555555
    `define COLOR_9 16'b0101001010111111 // L_BLUE = #5555ff
    `define COLOR_10 16'b0101011111101010 // L_GREEN = #55ff55
    `define COLOR_11 16'b0101011111111111 // L_CYAN = #55ffff
    `define COLOR_12 16'b1111101010101010 // L_RED = #ff5555
    `define COLOR_13 16'b1111101010111111 // L_MAGENTA = #ff55ff
    `define COLOR_14 16'b1111111111101010 // YELLOW = #ffff55
    `define COLOR_15 16'b1111111111111111 // WHITE = #ffffff

    always @ (*) begin
        case (color_index)
            4'd0: color_rgb = COLOR_0;
            4'd1: color_rgb = COLOR_1;
            4'd2: color_rgb = COLOR_2;
            4'd3: color_rgb = COLOR_3;
            4'd4: color_rgb = COLOR_4;
            4'd5: color_rgb = COLOR_5;
            4'd6: color_rgb = COLOR_6;
            4'd7: color_rgb = COLOR_7;
            4'd8: color_rgb = COLOR_8;
            4'd9: color_rgb = COLOR_9;
            4'd10: color_rgb = COLOR_10;
            4'd11: color_rgb = COLOR_11;
            4'd12: color_rgb = COLOR_12;
            4'd13: color_rgb = COLOR_13;
            4'd14: color_rgb = COLOR_14;
            4'd15: color_rgb = COLOR_15;
        endcase
    end
endmodule
