timeunit 1ns;
timeprecision 1ps;

module counter_v2_tb;

  parameter W = 4;
  parameter shortreal PERIOD = 2.5;
  parameter NUM = 32;

  bit clk;
  logic rst, ce, load;
  logic [W - 1 : 0] load_val, cnt;

  counter_v2 #(.W(W)) i_counter_v2 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0.5;
    input cnt;
    output rst, ce, load, load_val;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst <= '1;
    ce  <= '0;
    load_val <= '0;
    load <= '0;
    ##1
    cb.rst <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 
      if (i == 8)
        cb.ce <= '0;
      else 
        cb.ce <= '1;

      if (i == 4 || i == 18) begin 
        cb.load <= '1;
        cb.load_val <= i - 8;
      end
      else begin
        cb.load <= '0;
        cb.load_val <= 0;
      end
    end
    ##1 cb.ce <= '0;
    ##1 $stop;
  end
endmodule


