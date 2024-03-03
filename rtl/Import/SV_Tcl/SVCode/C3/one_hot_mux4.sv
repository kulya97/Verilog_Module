//File: one_hot_mux4.sv
module one_hot_mux4
#(
  parameter W = 4
)
(
  input logic [3 : 0] s,
  input logic [W - 1 : 0] a0, a1, a2, a3,
  output logic [W - 1 : 0] y
);
  
  always_comb begin
    case (s)
      4'b0001 : y = a0;
      4'b0010 : y = a1;
      4'b0100 : y = a2;
      4'b1000 : y = a3;
      default : y = '0;
    endcase
  end
endmodule
