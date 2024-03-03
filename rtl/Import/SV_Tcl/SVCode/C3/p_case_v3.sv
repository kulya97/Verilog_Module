//File: p_case_v3.sv
module p_case_v3
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);
  always_comb begin
    casez (sel)
      4'b1???: q = d;
      4'b01??: q = c;
      4'b001?: q = b;
      4'b0001: q = a;
      default: q = 'x;
    endcase
  end
endmodule
