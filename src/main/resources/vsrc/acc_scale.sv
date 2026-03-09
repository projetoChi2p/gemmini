`timescale 1ns / 1ps
module AccScale (
    input signed [31:0] din,
    input [31:0] scale_bits,
    output signed [7:0] out
);

  wire signed [8:0] exponent = scale_bits[30:23] - 127 - 17;
  wire [32+17:0] vsr;
  wire [32+17:0] tout;
  wire signal;
  wire has_b;
  assign signal = scale_bits[31] ^ din[31];
  assign vsr = (din * {1'b1, scale_bits[22:6]});
  assign has_b = |vsr[32+17:8];
  wire signed [8:0] nexponent;
  assign nexponent = -exponent;
  assign tout = exponent[8] ? vsr >> nexponent : vsr << exponent;
  assign out = (!exponent[8] && has_b || (|tout[32+17:7])) ? (signal ? -128 : 127) : (signal ? -tout : tout);
endmodule

