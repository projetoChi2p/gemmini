`timescale 1ns / 1ps
module DTypeScale (
    input signed [7:0] din,
    input [31:0] scale_bits,
    output logic signed [7:0] out
);

  logic signed [19:0] adjusted;
  logic [19:0] nadjusted, op1, actual_adj;
  logic [17:0] mantissa;
  logic signed [8:0] exponent;
  logic signed [8:0] out_tmp;
  logic signal;
  logic [23:0] partial_result;
  assign signal = scale_bits[31] ^ din[19];
  assign adjusted = din[19:0];
  assign nadjusted = -adjusted;
  assign mantissa = {1'b1, scale_bits[22:6]};
  assign actual_adj = adjusted[19] ? nadjusted : adjusted;
  assign exponent = scale_bits[30:23] - 127 - 17;


  always_comb begin
    partial_result = actual_adj * mantissa;
    out_tmp = exponent[8] ? partial_result >> (-exponent) : partial_result << exponent;
    out = (out_tmp[8] ^ out_tmp[7]) ? (out_tmp[8] ^ signal ? -128 : 127) : signal ? -out_tmp[7:0] : out_tmp[7:0];
  end
endmodule
