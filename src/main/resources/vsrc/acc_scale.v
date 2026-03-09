`timescale 1ns / 1ps
module AccScale (
    input signed [31:0] din,
    input [31:0] scale_bits,
    output signed [7:0] out
);

  wire signed [8:0] exponent = scale_bits[30:23] - 127 - 23;
  wire [31+24:0] vsr;
  assign vsr = (din * {1'b1, scale_bits[22:0]});
  wire signed [8:0] nexponent;
  assign nexponent = -exponent;
  assign out = exponent[8] ? vsr >> nexponent : vsr << exponent;
endmodule