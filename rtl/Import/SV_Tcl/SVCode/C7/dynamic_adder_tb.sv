timeunit 1ns;
timeprecision 1ps;

module dynamic_adder_tb;

  parameter DIW = 4;
  parameter DOW = DIW + 1;
  parameter type DTYPE = logic signed;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 8;

  bit clk;
  logic addsub;
  DTYPE [DIW - 1 : 0] ain;
  DTYPE [DIW - 1 : 0] bin;
  DTYPE [DOW - 1 : 0] sum;

  dynamic_adder #(.DIW(DIW), .DTYPE(DTYPE)) i_dynamic_adder (.*);

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output addsub, ain, bin;
    input sum;
  endclocking

  initial begin
    addsub <= '0;
    ain <= '0;
    bin <= '0;
    for (int i = 0; i < NUM; i++) begin
      if (i < NUM / 2) begin
        ##1 cb.addsub <= '0; 
            cb.ain <= $urandom_range(-8, 7);
            cb.bin <= $urandom_range(-8, 7);
      end
      else begin
        ##1 cb.addsub <= '1; 
            cb.ain <= $urandom_range(-8, 7);
            cb.bin <= $urandom_range(-8, 7);
      end
    end
    repeat (4) @cb;
    $stop;
  end
endmodule
 
