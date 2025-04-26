`include "full_adder.v"

module byte_adder (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output carry,
    output [7:0] sum
);

    wire c7;
    wire c6;
    wire c5;
    wire c4;
    wire c3;
    wire c2;
    wire c1;

    full_adder f0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .carry(c1),
        .sum(sum[0])
    );

    full_adder f1(
        .a(a[1]),
        .b(b[1]),
        .cin(c1),
        .carry(c2),
        .sum(sum[1])
    );

    full_adder f2(
        .a(a[2]),
        .b(b[2]),
        .cin(c2),
        .carry(c3),
        .sum(sum[2])
    );

    full_adder f3(
        .a(a[3]),
        .b(b[3]),
        .cin(c3),
        .carry(c4),
        .sum(sum[3])
    );

    full_adder f4(
        .a(a[4]),
        .b(b[4]),
        .cin(c4),
        .carry(c5),
        .sum(sum[4])
    );

    full_adder f5(
        .a(a[5]),
        .b(b[5]),
        .cin(c5),
        .carry(c6),
        .sum(sum[5])
    );

    full_adder f6(
        .a(a[6]),
        .b(b[6]),
        .cin(c6),
        .carry(c7),
        .sum(sum[6])
    );

    full_adder f7(
        .a(a[7]),
        .b(b[7]),
        .cin(c7),
        .carry(carry),
        .sum(sum[7])
    );

endmodule
