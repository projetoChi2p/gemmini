module Scale (
    input signed [31:0] din,
    input [31:0] scale_bits,
    output signed [7:0] out
);

  wire signed [8:0] exponent = scale_bits[30:23] - 127 - 17;
  wire signed [19:0] ndin = -(din[19:0]);
  wire [20+24:0] vsr;
  wire [20+24:0] tout;
  wire signal;
  wire has_b;
  assign signal = scale_bits[31] ^ din[19];
  assign vsr = ((din[19] ? ndin : din[19:0]) * {1'b1, scale_bits[22:6]});
  assign has_b = |vsr[44:8];
  wire signed [8:0] nexponent;
  assign nexponent = -exponent;
  assign tout = exponent[8] ? vsr >> nexponent : vsr << exponent;
  assign out = (!exponent[8] && has_b || (!(&tout[44:7] || (~|tout[44:7])))) ? (signal ? -128 : 127) : (signal ? -tout : tout);
endmodule

