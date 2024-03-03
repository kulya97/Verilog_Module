timeunit 1ns;
timeprecision 1ps;

module counter_tb;

  parameter shortreal PERIOD = 5;
  parameter NUM = 2 ** 20;
  parameter K = 4;

  bit clka_0;
  logic enb_0;
  logic [19 : 0] dout_0;

  design_1_wrapper i_counter (.*);

  initial begin
    clka_0 = '0;
    forever #(PERIOD/2) clka_0 = ~clka_0;
  end

  default clocking cb @(posedge clka_0);
    default input #1step output #0;
    output enb_0;
    input dout_0;
  endclocking
   
  initial begin
    enb_0 <= '0;
    for (int i = 0; i < K * NUM; i++) begin
      ##1 cb.enb_0 <= '1;
    end
    repeat (4) @cb;
    cb.enb_0 <= '0;
    $stop;
  end
endmodule



