// fsm2

module fsm2
(
    input clk,
    input rst_n,
    input key_in,
    output [1:0] out
);

    parameter
        S1 = 2'b00,
        S2 = 2'b01,
        S3 = 2'b10,
        S4 = 2'b11;

    // current state, next state:
    reg [1:0] cs;
    reg [1:0] ns;

    assign out = cs;

    always @ (posedge clk or negedge rst_n) begin
        if (! rst_n)
            cs <= S1;
        else
            cs <= ns;
    end

    always @ (*) begin
        case (cs)
            S1: begin
                if (!key_in)
                    ns = S2;
            end
            S2: begin
                if (!key_in)
                    ns = S3;
            end
            S3: begin
                if (!key_in)
                    ns = S4;
            end
            S4: begin
                if (!key_in)
                    ns = S1;
            end
            default: begin
                ns = S1;
            end
        endcase
    end
endmodule
