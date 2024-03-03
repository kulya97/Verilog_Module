timeunit 1ns;
timeprecision 1ns;

module sp_ram_3d_tb;
  parameter NUM_RAMS = 2;
  parameter AW       = 4;
  parameter DW       = 4;
  parameter shortreal PERIOD = 5;
  parameter NUM      = 16;

  bit clk;
  logic [NUM_RAMS - 1 : 0] we;
  logic [AW - 1 : 0] addr [NUM_RAMS];
  logic [DW - 1 : 0] din  [NUM_RAMS];
  logic [DW - 1 : 0] dout [NUM_RAMS];

  sp_ram_3d #(.NUM_RAMS(NUM_RAMS), .AW(AW), .DW(DW))
  i_sp_ram_3d (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output we, addr, din;
    input dout;
  endclocking

  initial begin
    we <= '0;
    addr <= '{NUM_RAMS {'{default :'0}}};
    din  <= '{NUM_RAMS {'{default :'0}}};
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.we <= {NUM_RAMS {1'b1}};
          cb.addr <= '{'0, '0};
          cb.din  <= '{4'hA, 4'hB};
      ##1 cb.we <= {NUM_RAMS {1'b1}};
          cb.addr <= '{1, 1};
          cb.din  <= '{4'hC, 4'hD};
      ##1 cb.we <= {NUM_RAMS {1'b1}};
          cb.addr <= '{2, 2};
          cb.din  <= '{4'hE, 4'hF};
      ##1 cb.we <= {NUM_RAMS {1'b0}};
          cb.addr <= '{0, 0};
      ##1 cb.we <= {NUM_RAMS {1'b0}};
          cb.addr <= '{1, 1};
    end
  end
endmodule

