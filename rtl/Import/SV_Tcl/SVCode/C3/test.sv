//File: test.sv
module test
(
  input logic a, b, c, d,
  input logic [1 : 0] sel,
  output logic q
);
  always_comb begin
    q = '0;
    if (sel==2'b00) q = a;
    if (sel==2'b01) q = b;
    if (sel==2'b10) q = c;
    if (sel==2'b11) q = d;
  end
endmodule
