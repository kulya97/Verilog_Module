//File: priority_enc_va.sv
module priority_enc_va
(
  input logic [2 : 0] sel,
  output logic [1 : 0] y
);

  always_comb begin
    casez (sel) 
      3'b1?? : y = 2'b11;
      3'b?1? : y = 2'b10;
      3'b??1 : y = 2'b01;
    endcase
  end
endmodule


