`timescale 1ns/1ns

module full_adder_tb ();

    reg a;
    reg b;
    reg cin;
    wire carry;
    wire sum;

    full_adder full_adder_instance(
        .a(a),
        .b(b),
        .cin(cin),
        .carry(carry),
        .sum(sum)
    );

    task assert(input a, b, cin, carry, sum);
        begin
            $display("Assert: a = %b, b = %b, cin=%b, carry = %b, sum = %b", a, b, cin, carry, sum);
            if ({1'b0, cin} + {1'b0, a} + {1'b0, b} !== {carry, sum}) begin
                $display("Assert failed!");
                $stop;
            end
        end
    endtask

    initial begin
        a = 1'b0;
        b = 1'b0;
        cin = 1'b0;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b0;
        b = 1'b0;
        cin = 1'b1;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b0;
        b = 1'b1;
        cin = 1'b0;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b0;
        b = 1'b1;
        cin = 1'b1;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b1;
        b = 1'b0;
        cin = 1'b0;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b1;
        b = 1'b0;
        cin = 1'b1;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b1;
        b = 1'b1;
        cin = 1'b0;
        #10
        assert(a, b, cin, carry, sum);
        #10
        a = 1'b1;
        b = 1'b1;
        cin = 1'b1;
        #10
        assert(a, b, cin, carry, sum);
        #10
        $finish;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, full_adder_instance);
    end

endmodule
