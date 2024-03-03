timeunit 1ns;
timeprecision 1ps;

module p2s_v2_tb;

  parameter shortreal PERIOD = 2.5;
  parameter W = 4;
  parameter NUM = 2 ** 4;

  bit clk;
  logic rst, load;
  logic sout, done, rdy, busy;
  logic [W - 1 : 0] pin;

  p2s_v3 #(.W(W)) i_p2s_v3 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input sout, done, rdy, busy;
    output rst, load, pin;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst  <= '1;
    load <= '0;
    pin  <= '0;
    ##1 
    cb.rst  <= '0;
    for (int i = 0; i < 4; i++) begin
      ##1
      cb.load <= '1;
      cb.pin  <= i + 6;
      ##1
      cb.load <= '0;
      ##(W - 3);
    end
    ##4
    $stop;
  end
endmodule
    
