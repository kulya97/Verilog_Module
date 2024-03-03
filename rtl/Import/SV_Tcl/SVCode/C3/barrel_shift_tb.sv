timeunit 1ns;
timeprecision 1ps;

module barrel_shift_tb;

  parameter DW = 4;
  parameter SW = 2;
  parameter NUM = 2 ** DW;
  parameter SN  = 2 ** SW;

  logic [DW - 1 : 0] a;
  logic [SW - 1 : 0] n;
  logic [DW - 1 : 0] y;

 // barrel_shift #(.DW(DW), .SW(SW)) i_barrel_shift (.*);
  barrel_shift_v2 #(.DW(DW)) i_barrel_shift_v2 (.*);
  initial begin
   // a <= '0;
   // n <= '0;
    for (int i = 1; i < NUM; i++) begin
      a <= i;
      for (int k = 0; k < SN; k++) begin
        n <= k;
        #5;
      end
    end
  end
endmodule

