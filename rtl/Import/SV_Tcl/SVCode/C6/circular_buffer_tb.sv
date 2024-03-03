timeunit 1ns;
timeprecision 1ns;

module circular_buffer_tb;

  parameter AW = 4;
  parameter DELAY_CYCLE = 6;
  parameter DW = 4;
  parameter shortreal PERIOD = 5;
  parameter NUM = 100;

  bit clk;
  logic rst;
  logic ce;
  logic [DW - 1 : 0] din;
  logic [DW - 1 : 0] dout;

  circular_buffer #(.AW(AW), .DELAY_CYCLE(DELAY_CYCLE), .DW(DW))
  i_circular_buffer (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, ce, din;
    input dout;
  endclocking

  initial begin
    rst <= '0;
    ce  <= '0;
    din <= '0;
    repeat (2) @cb
      cb.rst <= '1;
    repeat (2) @cb
      cb.rst <= '0;
    repeat (NUM) @cb begin
      cb.ce <= '1;
      cb.din  <= $urandom_range(1, 2 ** DW - 1);
    end
    repeat (5) @cb
    $stop;
  end
endmodule


