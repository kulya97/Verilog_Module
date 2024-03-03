timeunit 1ns;
timeprecision 1ps;

module dist_sp_ram_tb;
  parameter AW               = 6;
  parameter DW               = 16;
  parameter shortreal PERIOD = 5.0;
  parameter NUM              = 16;
  parameter HIGH             = 4;
  parameter LOW              = 4;

  bit clk;
  logic we;
  logic qspo_srst;
  logic [AW - 1 : 0] addr;
  logic [DW - 1 : 0] din;
  logic [DW - 1 : 0] spo;
  logic [DW - 1 : 0] qspo;

  mydistram i_mydistram
  (
    .a(addr),              
    .d(din),               
    .clk(clk),             
    .we(we),               
    .qspo_srst(qspo_srst), 
    .spo(spo),             
    .qspo(qspo)            
  );

  initial begin
    clk = '0;
    forever #(PERIOD / 2)
      clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output qspo_srst, we, addr, din;
    input spo, qspo;
  endclocking

  initial begin
    qspo_srst <= '1;
    we <= '0;
    addr <= '0;
    din  <= '0;
    repeat (2) @cb;
    for (int k = 0; k < NUM; k = k + HIGH) begin
      for (int i = 0; i < HIGH; i++) begin
        ##1 cb.qspo_srst <= '0;
            cb.we   <= '1;
            cb.addr <= i + k;
            cb.din  <= $urandom_range(1, 2 ** DW - 1);
      end
      for (int j = 0; j < LOW; j++) begin
        ##1 cb.qspo_srst <= '0;
            cb.we   <= '0;
            cb.addr <= j + k;
      end
    end
  end
endmodule
       



