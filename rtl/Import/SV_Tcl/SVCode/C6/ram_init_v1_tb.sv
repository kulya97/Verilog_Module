timeunit 1ns;
timeprecision 1ps;

module ram_init_v1_tb;
  parameter shortreal PERIOD = 5;

  bit clk;
  logic we;
  logic [3 : 0] addr;
  logic [3 : 0] din;
  logic [3 : 0] dout;

  ram_init_v1 i_ram_init_v1 (.*);

  initial begin
    clk = '0;
    forever #(PERIOD/2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output we, addr, din;
    input dout;
  endclocking

  initial begin
    we   <= '0;
    addr <= '0;
    din  <= '0;
    for (int i = 0; i < 4; i++) begin
      ##1 cb.we   <= '0;
          cb.addr <= i;
          cb.din  <= $urandom_range(1, 15);
    end
    for (int k = 0; k < 15; k++) begin
      ##1 cb.we   <= '1;
          cb.addr <= k;
          cb.din  <= $urandom_range(1, 15);
      ##1 cb.we   <= '0;
          cb.addr <= k;
          cb.din  <= $urandom_range(1, 15);
    end
  end
endmodule
