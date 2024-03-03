//File: incomplete_case0.sv
module incomplete_case0
(
  input logic [1 : 0] s,
  input logic [1 : 0] a,
  output logic q
);
  always_comb begin
    case (s) 
      2'b00: q = a[0];
      2'b01: q = a[1];
    endcase
  end
endmodule

