//File: p_case_v1.sv
module p_case_v1
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);
  always_comb begin
    casez (sel)
      4'b1???: q = d;
      4'b?1??: q = c;
      4'b??1?: q = b;
      4'b???1: q = a;
      default: q = 'x;
    endcase
  end
endmodule