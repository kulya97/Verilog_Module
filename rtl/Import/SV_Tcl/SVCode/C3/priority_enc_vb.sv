//File: priority_enc_vb.sv
module priority_enc_vb
(
  input logic [2 : 0] sel,
  output logic [1 : 0] y
);

  always_comb begin
    (* parallel_case *)
    case (sel) 
      3'b100 : y = 2'b11;
      3'b010 : y = 2'b10;
      3'b001 : y = 2'b01;
    endcase
  end
endmodule
