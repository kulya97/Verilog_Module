timeunit 1ns;
timeprecision 1ps;

module parity_checker_tb;
  parameter W = 8;
  parameter NUM = 2 ** W;

  logic [W - 1 : 0] din;
  logic even_parity, odd_parity;

  parity_checker #(.W(W)) i_parity_checker (.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      din <= i;
      #5;
    end
    #5 $stop;
  end
endmodule
