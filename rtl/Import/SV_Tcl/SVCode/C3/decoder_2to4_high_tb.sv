timeunit 1ns;
timeprecision 1ps;

module decoder_2to4_high_tb;

  logic [1 : 0] a;
  logic [3 : 0] y;
  logic en;

  //decoder_2to4_high_structure i_decoder_2to4_high (.*);
  decoder_2to4_high_dataflow i_decoder_2to4_high (.a(a), .en(en), .y(y));


  initial begin
    en = 0;
    a = 2'b00;
    #5 en = '1;
    #5 a = 2'b01;
    #5 a = 2'b10;
    #5 a = 2'b11;
    #5 a = 2'b00;
    #5 en = '0;
  end
endmodule
       
