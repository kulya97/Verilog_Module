timeunit 1ns;
timeprecision 1ns;

module sp_ram_tb;
  parameter AW               = 4;
  parameter DW               = 4;
  parameter WRITE_MODE       = "write_first";
  parameter LATENCY          = 2;
  parameter shortreal PERIOD = 5.0;
  parameter NUM              = 16;

  logic [3 : 0] i;
  bit clk;
  logic we;
  logic [AW - 1 : 0] addr;
  logic [DW - 1 : 0] din;
  logic [DW - 1 : 0] dout;

  sp_ram_v1
  #(
    .AW         (AW        ),
    .DW         (DW        ),
    .WRITE_MODE (WRITE_MODE)
  )
  i_sp_ram
  (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2)
      clk = ~clk;
  end

  default clocking cb @(posedge clk);
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
          cb.addr <= {2'b0, i[1 : 0]};
          cb.din  <= $urandom_range(1, 2 ** DW - 1);
    end
  end
endmodule
       



