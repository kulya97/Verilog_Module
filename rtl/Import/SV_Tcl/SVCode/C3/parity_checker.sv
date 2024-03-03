//File: parity_checker.sv
module parity_checker
#(
  parameter W = 8 // data width
)
(
  input logic [W - 1 : 0] din,
  output logic even_parity,
  output logic odd_parity
);

  always_comb begin
    even_parity = ^ din;
    odd_parity = ! even_parity;
  end
endmodule
