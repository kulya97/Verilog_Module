//File: priority_mux_v3.sv
module priority_mux_v3
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);
  always_comb begin
    casex (sel)
      4'b1xxx: q = d;
      4'bx1xx: q = c;
      4'bxx1x: q = b;
      4'bxxx1: q = a;
      default: q = '0;
    endcase
  end
endmodule