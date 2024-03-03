//File: p_case_v4.sv
module p_case_v4
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);

  always_comb begin
    case (1'b1)
      sel[3]: q = d;
      sel[2]: q = c;
      sel[1]: q = b;
      sel[0]: q = a;
      default: q = 'x;
    endcase
  end
endmodule
