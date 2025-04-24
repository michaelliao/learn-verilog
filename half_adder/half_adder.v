/*
Half Adder:

a  b  carry sum
---------------
0 + 0  =  0  0
0 + 1  =  0  1
1 + 0  =  0  1
1 + 1  =  1  0

*/

module half_adder(
    input a,
    input b,
    output carry,
    output sum
);
    assign carry = a & b;
    assign sum = a ^ b;
endmodule
