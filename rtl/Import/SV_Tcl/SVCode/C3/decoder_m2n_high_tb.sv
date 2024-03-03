timeunit 1ns;
timeprecision 1ps;

module decoder_m2n_high_tb;

  parameter M = 2;
  parameter N = 2 ** M;

  logic [M - 1 : 0] a;
  logic [N - 1 : 0] y;
  logic en;

  //decoder_m2n_high_v2 #(.M(M)) i_decoder_m2n_high(.a(a), .en(en), .y(y));
  decoder_m2n_high_v2 #(.M(M)) i_decoder_m2n_high(.a(a), .en(en), .y(y));
  //decoder_2to4_high_dataflow i_decoder_m2n_high(.a(a), .en(en), .y(y));
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
       
