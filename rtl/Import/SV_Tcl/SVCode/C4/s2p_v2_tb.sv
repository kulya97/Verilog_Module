timeunit 1ns;
timeprecision 1ps;

module s2p_v2_tb;

  parameter shortreal PERIOD = 2.5;
  parameter W = 4;
  parameter NUM = 2 ** W;

  bit clk;
  logic start, sin;
  logic [W - 1 : 0] pout;
  logic done;
  logic [W - 1 : 0] sum;

  s2p_v2 #(.W(W)) i_s2p_v2 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input pout, done;
    output start, sin;
  endclocking

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    start <= '0;
    sin   <= '0;
    for (int i = 0; i < NUM; i++) begin
      sum = i + 6;
      for (int k = 0; k < W; k++) begin
        if (k == 0) begin
          ##1 cb.start <= '1;
              cb.sin   <= sum[W - k - 1];
        end
        else begin
          ##1 cb.start <= '0;
              cb.sin   <= sum[W - k - 1];
        end
      end
    end
    ##1 $stop;
  end
endmodule
              

