
module pixel_index_color (
    input wire [7:0] font_line_data,
    input wire [2:0] char_pix_x,
    input wire [7:0] bg_fg_index,
    output reg [3:0] color_index
);
    reg bit;

    always @ (*) begin
        case (char_pix_x)
            3'd0: bit = font_line_data[0];
            3'd1: bit = font_line_data[1];
            3'd2: bit = font_line_data[2];
            3'd3: bit = font_line_data[3];
            3'd4: bit = font_line_data[4];
            3'd5: bit = font_line_data[5];
            3'd6: bit = font_line_data[6];
            3'd7: bit = font_line_data[7];
        endcase
    end

    // if bit is 1, return fg color index, otherwise bg color:
    assign color_index = bit == 1'b1 ? bg_fg_index[3:0] : bg_fg_index[7:4]

endmodule
