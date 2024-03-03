timeunit 1ns;
timeprecision 1ps;

module gray2bin_tb;

  parameter W = 3;
  parameter NUM = 2 ** W;

  logic [W - 1 : 0] xbin_val, gray_val, bin_val;

  bin2gray #(.W(W)) i_bin2gray (.bin_val(xbin_val), .gray_val(gray_val));
  gray2bin #(.W(W)) i_gray2bin (.gray_val(gray_val), .bin_val(bin_val));

  initial begin
    for (int i = 0; i < NUM; i++) begin
      xbin_val <= i;
      #5;
    end
    #5 $stop;
  end
endmodule
