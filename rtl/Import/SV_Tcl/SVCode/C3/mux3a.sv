//File: mux3a.sv
module mux3a
(
  input logic [1 : 0] a, b, c,
  input logic [1 : 0] sel,
  output logic [1 : 0] y
);

  always_comb begin
    case (sel) 
      2'b00 : y = a;
      2'b01 : y = b;
      2'b10 : y = c;
    endcase
  end
endmodule
