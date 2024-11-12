module counter (
  input clk,
  input ce,
  output [3:0] LEDS
);

    localparam CNT_TARGET = 27'd125_000;

    // --- count 125M for one second ---
    wire [26:0] clk_cnt_in, clk_cnt_out;
    wire cnt_125M;
    REGISTER_R #(.N(27)) clk_cnt (.q(clk_cnt_out), .d(clk_cnt_in), .rst(cnt_125M), .clk(clk));

    wire [13:0] clk_cnt_lo, clk_cnt_hi;
    assign clk_cnt_lo = clk_cnt_out[13:0];
    assign clk_cnt_hi = {1'b0, clk_cnt_out[26:14]};

    wire [14:0] adder_lo_sum, adder_hi_sum;
    behavioral_adder adder_lo (.a(14'b1), .b(clk_cnt_lo), .sum(adder_lo_sum));
    behavioral_adder adder_hi (.a(clk_cnt_hi), .b({13'b0, adder_lo_sum[14]}), .sum(adder_hi_sum));
    assign clk_cnt_in = {adder_hi_sum[12:0], adder_lo_sum[13:0]};

    assign cnt_125M = clk_cnt_out == CNT_TARGET;

    // --- 4-bit counter for LED ---
    wire [3:0] fourbit_cnt_in, fourbit_cnt_out;
    wire [10:0] ignore;

    REGISTER_CE #(.N(4)) fourbit_cnt (.q(fourbit_cnt_out), .d(fourbit_cnt_in), .ce(ce), .clk(clk));
    behavioral_adder adder_sec (.a({13'b0, cnt_125M}), .b({10'b0, fourbit_cnt_out}), .sum({ignore, fourbit_cnt_in}));
    assign LEDS = fourbit_cnt_out;

endmodule

