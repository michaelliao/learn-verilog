`timescale 1ns/1ns

module tb_vga_data ();

    reg clk;
    reg rst_n;
    reg [13:0] pix_x;
    reg [13:0] pix_y;
    reg [13:0] image_addr;

    vga_data component(
        .clk(clk),
        .rst_n(rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .image_addr(image_addr)
    );

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        pix_x = 14'b0;
        pix_y = 14'b0;
        #20
        rst_n = 1'b1;
        #3100000
        $finish;
    end

    always #10 clk = ~clk;

    always #10 pix_x = pix_x < 640 ? pix_x + 1'b1 : 0;
    always #10 pix_y = pix_y < 480 ? pix_y + 1'b1 : 0;

    initial begin
        $dumpfile("tb_vga_data.vcd");
        $dumpvars(0, component);
    end
endmodule
