//File: decoder_2to4_high_v2.sv
module decoder_2to4_high_v2
(
  input logic [1 : 0] a,
  input logic en,
  output logic [3 : 0] y
);

  always_comb begin
    if (!en) 
      y = '0; 
    else
      if (a == 2'b00) y = 4'b0001;
      else if (a == 2'b01) y = 4'b0010;
      else if (a == 2'b10) y = 4'b0100;
      else if (a == 2'b11) y = 4'b1000;
      else y = '0;
  end
endmodule