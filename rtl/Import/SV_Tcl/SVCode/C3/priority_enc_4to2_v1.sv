//File: priority_enc_4to2_v1.sv
module priority_enc_4to2_v1
(
  input logic [3 : 0] a,
  output logic [1 : 0] y,
  output logic valid_in
);

  always_comb begin
    valid_in = |a;
    if (a[3]) 
      y = 2'b11; 
    else if (a[2])
      y = 2'b10;
    else if (a[1])
      y = 2'b01;
    else if (a[0])
      y = 2'b00;
    else 
      y = 'x;
  end
endmodule
