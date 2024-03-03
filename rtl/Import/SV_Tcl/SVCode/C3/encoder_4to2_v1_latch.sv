//File: encoder_4to2_v1_latch.sv
module encoder_4to2_v1_latch
(
  input logic [3 : 0] a,
  output logic [1 : 0] y
);

  always_comb begin
    if (a == 4'b0001)
      y = 2'b00;
    else if (a == 4'b0010)
      y = 2'b01;
    else if (a == 4'b0100)
      y = 2'b10;
    else if (a == 4'b1000)
      y = 2'b11;
  end
endmodule
    
