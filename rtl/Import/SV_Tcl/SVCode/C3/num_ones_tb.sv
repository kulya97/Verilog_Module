timeunit 1ns;
timeprecision 1ps;

module num_ones_tb;

  parameter shortreal PERIOD = 5.0;
  parameter DIW = 4;
  parameter DOW = $clog2(DIW) + 1;

  logic [DIW - 1 : 0] din;
  logic [DOW - 1 : 0] ones;

  num_ones #(.DIW(DIW)) i_num_ones (.*);

  initial begin
    for (int i = 0; i < 2 ** DIW; i++) begin
      din <= i;
      #5;
    end
    #5;
    $stop;
  end
endmodule


