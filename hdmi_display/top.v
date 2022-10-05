module top(
    input wire sys_clk,
    input wire sys_rst_n,
    output ddc_scl,
    output ddc_sda,
    output tmds_clk_p,
    output tmds_clk_n,
    output [2:0] tmds_data_p,
    output [2:0] tmds_data_n
);
    wire clk_1x;
    wire clk_5x;
    wire pll_locked;
    wire rst_n;

    wire [23:0] pix_data;
    wire [9:0] pix_x;
    wire [9:0] pix_y;
    wire pix_valid;

    wire hsync;
    wire vsync;
    wire [23:0] rgb;

    assign rst_n = sys_rst_n & pll_locked;

    assign ddc_scl = 1'b1;
    assign ddc_sda = 1'b1;

    pll pll_inst (
        .areset (~sys_rst_n),
        .inclk0 (sys_clk),
        .c0 (clk_1x),
        .c1 (clk_5x),
        .locked (pll_locked)
    );

    vga_data vga_data_inst (
        .clk (clk_1x),
        .rst_n (rst_n),
        .pix_x (pix_x),
        .pix_y (pix_y),
        .pix_rgb (pix_data)
    );

    vga_ctrl #(1, 24) vga_ctrl_inst (
        .clk (clk_1x),
        .rst_n (rst_n),
        .in_rgb (pix_data),
        .pix_x (pix_x),
        .pix_y (pix_y),
        .hsync (hsync),
        .vsync (vsync),
        .out_rgb (rgb),
        .pix_valid (pix_valid)
    );

    hdmi_ctrl hdmi_ctrl_inst (
        .clk_1x (clk_1x),
        .clk_5x (clk_5x),
        .rst_n (rst_n),
        .rgb_r (rgb[23:16]),
        .rgb_g (rgb[15:8]),
        .rgb_b (rgb[7:0]),
        .hsync (hsync),
        .vsync (vsync),
        .de (pix_valid),
        .hdmi_clk_p (tmds_clk_p),
        .hdmi_clk_n (tmds_clk_n),
        .hdmi_r_p (tmds_data_p[2]),
        .hdmi_r_n (tmds_data_n[2]),
        .hdmi_g_p (tmds_data_p[1]),
        .hdmi_g_n (tmds_data_n[1]),
        .hdmi_b_p (tmds_data_p[0]),
        .hdmi_b_n (tmds_data_n[0])
    );

endmodule
