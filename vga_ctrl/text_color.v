// VGA 16 Color Palette:
// https://en.wikipedia.org/wiki/Color_Graphics_Adapter

module text_color (
    input  wire [3:0] color_index,
    output wire [15:0] color_rgb
);
    always @ (*) begin
        case (color_index)
            4'd0: color_rgb = 16'b0000000000000000; // #000000 = black
            4'd1: color_rgb = 16'b0000000000010101; // #0000aa = blue
            4'd2: color_rgb = 16'b0000010101000000; // #00aa00 = green
            4'd3: color_rgb = 16'b0000010101010101; // #00aaaa = cyan
            4'd4: color_rgb = 16'b1010100000000000; // #aa0000 = red
            4'd5: color_rgb = 16'b1010100000010101; // #aa00aa = magenta
            4'd6: color_rgb = 16'b1010101010100000; // #aa5500 = brown
            4'd7: color_rgb = 16'b1010110101010101; // #aaaaaa = light gray
            4'd8: color_rgb = 16'b0101001010101010; // #555555 = dark gray
            4'd9: color_rgb = 16'b0101001010111111; // #5555ff = light blue
            4'd10: color_rgb = 16'b0101011111101010; // #55ff55 = light green
            4'd11: color_rgb = 16'b0101011111111111; // #55ffff = light cyan
            4'd12: color_rgb = 16'b1111101010101010; // #ff5555 = light red
            4'd13: color_rgb = 16'b1111101010111111; // #ff55ff = light magenta
            4'd14: color_rgb = 16'b1111111111101010; // #ffff55 = yellow
            4'd15: color_rgb = 16'b1111111111111111; // #ffffff = white
        endcase
    end
endmodule
