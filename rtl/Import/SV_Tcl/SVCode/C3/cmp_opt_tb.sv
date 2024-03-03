timeunit 1ns;
timeprecision 1ps;

module cmp_opt_tb;
 
  parameter shortreal PERIOD = 5;
  parameter W = 2;
  parameter NUM = 4;

  bit clk;
  logic [1 : 0] sel;
  logic [W - 1 : 0] din;
  logic dout;
  int v = 4;

  cmp_opt_before #(.W(W)) i_cmp_opt_before (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output sel, din;
    input dout;
  endclocking

  initial begin
    sel <= '0;
    din <= '0;
    for (int i = 0; i < NUM; i++) begin
      v--;
      for (int k = 0; k < 4; k++) begin
        ##1 cb.sel <= 2'b10;
            cb.din <= v;
      end
      v--;
      for (int k = 0; k < 4; k++) begin
        ##1 cb.sel <= 2'b01;
            cb.din <= v;
      end
      for (int k = 0; k < 2; k++) begin
        ##1 cb.sel <= 2'b00;
            cb.din <= v;
      end
    end
    repeat (4) @cb;
    $stop;
  end
endmodule
