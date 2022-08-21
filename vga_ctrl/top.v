
module top(
	input wire clk,
	input wire rst_n,
	output wire hsync,
	output wire vsync,
	output wire [15:0] rgb
);
	wire vga_clk;
	wire pll_locked;
	pll_ip	pll_inst (
		.areset (~rst_n),
		.inclk0 (clk),
		.c0 (vga_clk),
		.locked(pll_locked)
	);
	vga_ctrl vga_ctrl_inst (
		.clk (vga_clk),
		.rst_n (rst_n & pll_locked),
		.in_rgb (16'hffff),
		.hsync (hsync),
		.vsync (vsync),
		.out_rgb (rgb)
	);
endmodule
