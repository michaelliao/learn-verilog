`timescale 1ns/1ns

module half_adder_tb ();

    reg a;
    reg b;
    wire carry;
    wire sum;

    half_adder half_adder_instance(
        .a(a),
        .b(b),
        .carry(carry),
        .sum(sum)
    );

    task assert(input a, b, carry, sum);
        begin
            $display("Assert: a = %b, b = %b, carry = %b, sum = %b", a, b, carry, sum);
            if ({1'b0, a} + {1'b0, b} !== {carry, sum}) begin
                $display("Assert failed!");
                $stop;
            end
        end
    endtask

    initial begin
        a = 1'b0;
        b = 1'b0;
        #10
        assert(a, b, carry, sum);
        #10
        a = 1'b1;
        b = 1'b0;
        #10
        assert(a, b, carry, sum);
        #10
        a = 1'b0;
        b = 1'b1;
        #10
        assert(a, b, carry, sum);
        #10
        a = 1'b1;
        b = 1'b1;
        #10
        assert(a, b, carry, sum);
        #10
        a = 1'b0;
        b = 1'b0;
        #10
        $finish;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, half_adder_instance);
    end

endmodule
