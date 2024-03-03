timeunit 1ns;
timeprecision 1ps;

module dynamic_preadd_mult_add_tb;

  parameter AW = 16;
  parameter BW = 16;
  parameter CW = 32;
  parameter PW = 48;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 4;
  parameter MW = AW + 1 + BW;

  bit clk;
  logic subadd;

  logic signed [AW - 1 : 0] ain;
  logic signed [AW - 1 : 0] din;
  logic signed [BW - 1 : 0] bin;
  logic signed [CW - 1 : 0] cin;
  logic signed [MW - 1 : 0] pout;

  dynamic_preadd_mult_add #(.AW(AW), .BW(BW), .CW(CW), .PW(PW)) 
  i_dynamic_preadd_mult_add (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output subadd, ain, bin, din, cin;
    input pout;
  endclocking

  initial begin
    subadd <= '0;
    ain <= '0;
    bin <= '0;
    din <= '0;
    cin <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.subadd <= '0;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
          cb.din <= $urandom_range(-10, 10);
          cb.cin <= $urandom_range(-10, 10);
    end
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.subadd <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
          cb.din <= $urandom_range(-10, 10);
          cb.cin <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule

