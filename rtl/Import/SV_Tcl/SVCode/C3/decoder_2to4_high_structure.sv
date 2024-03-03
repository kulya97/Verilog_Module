//File: decoder_2to4_high_structure.sv
module decoder_2to4_high_structure
(
  input logic [1 : 0] a,
  input logic en,
  output logic [3 : 0] y
);

  logic a0_inv, a1_inv;
  not g0 (a0_inv, a[0]);
  not g1 (a1_inv, a[1]);
  and g2 (y[0], en, a1_inv, a0_inv);
  and g3 (y[1], en, a1_inv, a[0]);
  and g4 (y[2], en, a[1],   a0_inv);
  and g5 (y[3], en, a[1],   a[0]);
endmodule

