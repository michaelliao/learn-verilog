/***********************************************************************************************

VGA Timings: http://martin.hinner.info/vga/timing.html

┌────────────────┬───────────┬────────────────────────────────┬────────────────────────────────┐
│                │           │             H Sync             │             V Sync             │
│  Display Mode  │ Clock/MHz ├───────┬───────┬────────┬───────┼───────┬───────┬────────┬───────┤
│                │           │ Sync  │ Back  │ Active │ Front │ Sync  │ Back  │ Active │ Front │
│                │           │ Pulse │ Porch │ Video  │ Porch │ Pulse │ Porch │ Video  │ Porch │
├────────────────┼───────────┼───────┼───────┼────────┼───────┼───────┼───────┼────────┼───────┤
│ 640 x 480 @ 60 │ 25.175    │ 96    │ 48    │ 640    │ 16    │ 2     │ 33    │ 480    │ 10    │
└────────────────┴───────────┴───────┴───────┴────────┴───────┴───────┴───────┴────────┴───────┘

***********************************************************************************************/

module vga_ctrl (
    input  wire clk,
    input  wire rst_n,
    input  wire [15:0] in_rgb,

    output wire hsync,
    output wire vsync,
    output wire pix_data_req,
    output wire [9:0]  pix_x,
    output wire [9:0]  pix_y,
    output wire [15:0] out_rgb
);

`define DATA_0 10'd0

parameter H_SYNC  = 10'd96,
          H_BACK  = 10'd48,
          H_SIZE  = 10'd640,
          H_FRONT = 10'd16,
          H_TOTAL = H_SYNC + H_BACK + H_SIZE + H_FRONT, // 800
          V_SYNC  = 10'd2,
          V_BACK  = 10'd33,
          V_SIZE  = 10'd480,
          V_FRONT = 10'd10,
          V_TOTAL = V_SYNC + V_BACK + V_SIZE + V_FRONT; // 525

    // 0 ~ 799
    reg [9:0] cnt_h;

    // 0 ~ 524
    reg [9:0] cnt_v;

    wire pix_valid;

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            cnt_h <= `DATA_0;
        else if (cnt_h == H_TOTAL - 1'b1)
            cnt_h <= `DATA_0;
        else
            cnt_h <= cnt_h + 1'b1;
    end

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            cnt_v <= `DATA_0;
        else if (cnt_h == H_TOTAL - 1'b1)
            begin
				if (cnt_v == V_TOTAL - 1'b1)
					cnt_v <= `DATA_0;
				else
					cnt_v <= cnt_v + 1'b1;
            end
        else
            cnt_v <= cnt_v;
    end

    assign pix_valid = rst_n 
			&& (cnt_h >= (H_SYNC + H_BACK))
            && (cnt_h < (H_SYNC + H_BACK + H_SIZE))
            && (cnt_v >= (V_SYNC + V_BACK))
            && (cnt_v < (V_SYNC + V_BACK + V_SIZE))
            ? 1'b1 : 1'b0;

    assign pix_data_req = rst_n 
			&& (cnt_h >= (H_SYNC + H_BACK - 2))
            && (cnt_h < (H_SYNC + H_BACK + H_SIZE - 2))
            && (cnt_v >= (V_SYNC + V_BACK - 2))
            && (cnt_v < (V_SYNC + V_BACK + V_SIZE - 2))
            ? 1'b1 : 1'b0;

    assign pix_x = pix_data_req == 1'b1 ? (cnt_h - (H_SYNC + H_BACK - 2)) : 10'h000;
    assign pix_y = pix_data_req == 1'b1 ? (cnt_v - (V_SYNC + V_BACK - 2)) : 10'h000;

    assign hsync = rst_n & (cnt_h < H_SYNC ? 1'b1 : 1'b0);

    assign vsync = rst_n & (cnt_v < V_SYNC ? 1'b1 : 1'b0);

    assign out_rgb = pix_valid == 1'b1 ? in_rgb : 16'h0000;

endmodule
