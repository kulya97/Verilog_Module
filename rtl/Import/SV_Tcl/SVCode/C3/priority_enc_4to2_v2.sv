//File: priority_enc_4to2_v2.sv
module priority_enc_4to2_v2
(
  input logic [3 : 0] a,
  output logic [1 : 0] y,
  output logic valid_in
);

  always_comb begin
    valid_in = |a;
   (* parallel_case *)
    casex (a)
      4'b1xxx: y = 2'b11;
      4'b01xx: y = 2'b10;
      4'b001x: y = 2'b01;
      4'b0001: y = 2'b00;
      default: y = 'x;
    endcase
  end
endmodule
