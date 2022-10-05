module vga_data (
    input clk,
    input rst_n,
    input [13:0] pix_x,
    input [13:0] pix_y,
    output reg [13:0] image_addr
);

    //reg [9:0] image_x;
    //reg [9:0] image_y;

	 localparam image_x = 200, image_y = 300;

	 reg [17:0] cnt;
	 
    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            image_addr <= 14'b0;
        end else begin
            if ((pix_x >= image_x) && (pix_x < (image_x + 128)) && (pix_y >= image_y) && (pix_y < (image_y + 76)))
                image_addr <= ((pix_y - image_y) * 128) + pix_x - image_x;
            else
                image_addr <= 14'b0;
        end
    end

//    always @ (posedge clk or negedge rst_n) begin
//        if (! rst_n) begin
//		      cnt <= 0;
//            image_x <= 10'd100;
//            image_y <= 10'd260;
//        end else begin
//            cnt <= cnt + 1;
//        end
//    end

endmodule
