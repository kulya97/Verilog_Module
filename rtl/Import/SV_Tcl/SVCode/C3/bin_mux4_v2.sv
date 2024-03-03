//File: bin_mux4_v2.sv
module bin_mux4_v2
#(
  parameter W = 1 // data width
)
(
  input logic [1 : 0] sel,
  input logic [W - 1 : 0] a0, a1, a2, a3,
  output logic [W - 1 : 0] y
);

  always_comb begin
    case (sel)
      2'b00 : y = a0;
      2'b01 : y = a1;
      2'b10 : y = a2;
      2'b11 : y = a3;
      default : y = '0;
    endcase
  end
endmodule
