timeunit 1ns;
timeprecision 1ps;

module shift_left_tb;
  parameter DIW = 4;
  parameter SW  = $clog2(DIW);
  parameter DOW = 2 * DIW - 1;
  parameter NUM = 2 ** DIW;

  logic [DIW - 1 : 0] a;
  logic [SW  - 1 : 0] n;
  logic [DOW - 1 : 0] y;

  shift_left #(.DIW(DIW)) i_shift_left (.*);

  initial begin
    for (int i = 1; i < NUM; i++) begin
      a <= i;
      for (int k = 0; k < DIW; k++) begin
        n <= k;
        #5;
      end
    end
  end
endmodule
