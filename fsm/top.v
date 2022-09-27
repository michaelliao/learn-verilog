// display word by FSM

module top (
    input wire clk,
    input wire rst_n,
    input wire key_in,
    output wire shcp,
    output wire stcp,
    output wire ds,
    output wire oe
);
    parameter C = 8'b01100011;
    parameter E = 8'b01100001;
    parameter F = 8'b01110001;
    parameter H = 8'b10010001;
    parameter L = 8'b11100011;
    parameter O = 8'b00000011;
    parameter P = 8'b00110001;
    parameter U = 8'b10000011;

    wire key1;
    reg [1:0] state;
    reg [47:0] data;

    fsm2 fsm2_inst (
        .clk (clk),
        .rst_n (rst_n),
        .key_in (key1),
        .out (state)
    );

    key_filter key_filter_inst (
        .clk (clk),
        .rst_n (rst_n),
        .key_in (key_in),
        .key_out (key1)
    );

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n) begin
            data <= { E, E, E, E, E, E };
        end else begin
            case (state)
                2'b00: data <= { C, H, O, O, S, E };
                2'b01: data <= { E, P, O, C, H, S };
                2'b10: data <= { P, U, L, S, E, S };
                2'b11: data <= { S, C, H, O, O, L };
            endcase
        end
    end

endmodule
