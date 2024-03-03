//File: sp_32xn_pmt_tb.sv
timeunit 1ns;
timeprecision 1ps;

module sp_32xn_pmt_tb;
  parameter DW = 4;
  parameter shortreal PERIOD = 5;
  parameter NUM = 16;

  logic [3 : 0] i;
  bit wclk;
  logic we;
  logic [4 : 0]      addr;
  logic [DW - 1 : 0] din;
  logic [DW - 1 : 0] dout;

  sp_32xn_pmt #(.DW(DW))
  i_sp_32xn_pmt (.*);

  initial begin
    wclk = '0;
    forever #(PERIOD / 2) wclk = ~wclk;
  end

  default clocking cb @(posedge wclk);
    default input #1step output #0;
    output we, addr, din;
    input dout;
  endclocking

  initial begin
    we <= '0;
    addr <= '0;
    din  <= '0;
    for (i = 0; i < NUM; i++) begin
      ##1 cb.we   <= ~i[2];
          cb.addr <= {3'b0, i[1 : 0]};
          cb.din  <= $urandom_range(1, 2 ** DW - 1);
    end
  end
endmodule
       

