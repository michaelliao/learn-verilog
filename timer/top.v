// timer

module top (
    input wire clk,
    input wire rst_n,
    output wire shcp,
    output wire stcp,
    output wire ds,
    output wire oe
);
    reg [47:0] data;
    wire [23:0] cnt;

    counter #(10) counter_inst(
        .clk (clk),
        .rst_n (rst_n),
        .cnt (cnt)
    );

    convert convert_0(
        .in (cnt[3:0]),
        .out (data[7:0])
    );

    convert convert_1(
        .in (cnt[7:4]),
        .out (data[15:8])
    );

    convert convert_2(
        .in (cnt[11:8]),
        .out (data[23:16])
    );

    convert convert_3(
        .in (cnt[15:12]),
        .out (data[31:24])
    );

    convert convert_4(
        .in (cnt[19:16]),
        .out (data[39:32])
    );

    convert convert_5(
        .in (cnt[23:20]),
        .out (data[47:40])
    );

	digital_tube_display digital_tube_display_inst (
        .clk (clk),
        .rst_n (rst_n),
        .data_in (data),
        .shcp (shcp),
        .stcp (stcp),
        .ds (ds),
        .oe (oe)
    );

    always @ (*) begin
        case (cnt[7:0])
            8'h0: data[7:0] = N0;
        endcase
    end

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            data <= { E, E, E, E, E, E };
        end else begin
            data <= {

            }
            case (state)
                2'b00: data <= { C, H, O, O, S, E };
                2'b01: data <= { E, P, O, C, H, S };
                2'b10: data <= { P, U, L, S, E, S };
                2'b11: data <= { S, C, H, O, O, L };
            endcase
        end
    end

endmodule
