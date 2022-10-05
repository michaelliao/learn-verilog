`timescale 1ns/1ns

module tb_vga_data ();

    reg clk;
    reg rst_n;
    reg [13:0] pix_x;
    reg [13:0] pix_y;
    wire [13:0] image_addr;

    integer x;
    integer y;

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
        #20
        for (y=0; y<480; y=y+1) begin
            for (x=0; x<640; x=x+1) begin
                #20
                pix_x = x;
                pix_y = y;
            end
        end
        #20
        $finish;
    end

    always #10 clk = ~clk;


    initial begin
        $dumpfile("tb_vga_data.vcd");
        $dumpvars(0, component);
    end
endmodule
