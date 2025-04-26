`include "half_adder.v"

module full_adder(
    input a,
    input b,
    input cin,
    output carry,
    output sum
);

    wire t_carry1;
    wire t_carry2;
    wire t_sum;

    half_adder h1(
        .a(a),
        .b(b),
        .carry(t_carry1),
        .sum(t_sum)
    );

    half_adder h2(
        .a(t_sum),
        .b(cin),
        .carry(t_carry2),
        .sum(sum)
    );

    assign carry = t_carry1 | t_carry2;

endmodule
