`timescale 1ns / 1ps
module DTypeScale (
    input signed [7:0] din,
    input [31:0] scale_bits,
    output signed [7:0] out
);

  wire signed [8:0] exponent = scale_bits[30:23] - 127 - 23;
  wire signed [7:0] ndin = -din;
  wire [8+24:0] vsr;
  wire [8+24:0] tout;
  wire signal;
  wire has_b;
  assign signal = scale_bits[31] ^ din[7];
  assign vsr = ((din[7] ? ndin : din) * {1'b1, scale_bits[22:0]});
  assign has_b = |vsr[32:8];
  wire signed [8:0] nexponent;
  assign nexponent = -exponent;
  assign tout = exponent[8] ? vsr >> nexponent : vsr << exponent;
  assign out = (!exponent[8] && has_b || (!(&tout[32:7] || (~|tout[32:7])))) ? (signal ? -128 : 127) : (signal ? -tout : tout);
endmodule

