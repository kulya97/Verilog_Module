timeunit 1ns;
timeprecision 1ps;

module square_mac_tb;

  parameter  W = 16;
  parameter  PW = 48;
  parameter shortreal PERIOD = 5.0;

  bit clk;
  logic sload;
  logic signed [W - 1 : 0] ain;
  logic signed [W - 1 : 0] bin;
  logic signed [PW - 1 : 0] pout;

  square_mac #(.W(W), .PW(PW))
  i_square_mac (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output sload, ain, bin;
    input pout;
  endclocking

  initial begin
    sload <= '0;
    ain   <= '0;
    bin   <= '0;
    for (int i = 0; i < 4; i++) begin
      ##1 cb.sload <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
      for (int k = 0; k < 3; k++) begin
        ##1 cb.sload <= '0;
            cb.ain <= $urandom_range(-10, 10);
            cb.bin <= $urandom_range(-10, 10);
      end
    end
    repeat (4) @cb;
    $stop;
  end
endmodule

