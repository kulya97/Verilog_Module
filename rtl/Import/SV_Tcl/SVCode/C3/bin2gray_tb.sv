timeunit 1ns;
timeprecision 1ps;

module bin2gray_tb;

  parameter W = 3;
  parameter NUM = 2 ** W;

  logic [W - 1 : 0] bin_val, gray_val;

  bin2gray #(.W(W)) i_bin2gray (.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      bin_val <= i;
      #5;
    end
    #5 $stop;
  end
endmodule
