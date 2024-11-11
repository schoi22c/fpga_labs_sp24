module full_adder (
    input a,
    input b,
    input carry_in,
    output sum,
    output carry_out
);
    xor(sum, a, b, carry_in);

    wire ab, ac, bc;
    and(ab, a, b),
       (ac, a, carry_in),
       (bc, b, carry_in);
    or(carry_out, ab, ac, bc);
endmodule
