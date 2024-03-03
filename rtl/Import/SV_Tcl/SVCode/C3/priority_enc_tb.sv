timeunit 1ns;
timeprecision 1ps;

module priority_enc_tb;
 
  parameter NUM = 8;

  logic [2 : 0] sel;
  logic [1 : 0] y;

  //priority_enc_va i_priority_enc_va (.*);
  priority_enc_vb i_priority_enc_vb (.*);


  initial begin
    for (int i = 0; i < NUM; i++) begin
      sel <= i;
      #5;
    end
    $stop;
  end
endmodule
