module top(
	input wire clk,
	input wire rst_n,
	output wire hsync,
	output wire vsync,
	output wire [15:0] rgb
);
	wire vga_clk;
	wire pll_locked;
	wire [7:0] font_data;
	wire [15:0] buffer_data;
	wire [15:0] pix_data;
	wire [9:0] pix_x;
	wire [9:0] pix_y;

	pll_vga pll_vga_inst (
		.areset (~rst_n),
		.inclk0 (clk),
		.c0 (vga_clk),
		.locked(pll_locked)
	);

	rom_font rom_font_inst (
		.clock (vga_clk),
		.address (11'b0),
		.q (font_data)
	);
	
	ram_buffer ram_buffer_inst (
	    .rdclock (vga_clk),
	    .wrclock (vga_clk),
	    .data (16'd0),
	    .rdaddress (10'd0),
	    .wraddress (10'd0),
	    .wren (1'b0),
	    .q (buffer_data)
	);

	vga_data vga_data_inst (
		.clk (vga_clk),
		.rst_n (rst_n & pll_locked),
		.pix_x (pix_x),
		.pix_y (pix_y),
		.pix_rgb (pix_data)
	);

	vga_ctrl vga_ctrl_inst (
		.clk (vga_clk),
		.rst_n (rst_n & pll_locked),
		.in_rgb (pix_data),
		.pix_x (pix_x),
		.pix_y (pix_y),
		.hsync (hsync),
		.vsync (vsync),
		.out_rgb (rgb)
	);
endmodule
