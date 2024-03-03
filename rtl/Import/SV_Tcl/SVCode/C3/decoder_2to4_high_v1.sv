//File: decoder_2to4_high_v1.sv
module decoder_2to4_high_v1
(
  input logic [1 : 0] a,
  input logic en,
  output logic [3 : 0] y
);

  always_comb begin
    if (!en) 
      y = '0; 
    else
      case (a)
        2'b00 : y = 4'b0001;
        2'b01 : y = 4'b0010;
        2'b10 : y = 4'b0100;
        2'b11 : y = 4'b1000;
        default : y = '0;
      endcase
  end
endmodule
      
      
