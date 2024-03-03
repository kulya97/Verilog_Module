timeunit 1ns;
timeprecision 1ns;



module sdp_one_clk_tb; 

  parameter AW = 4;
  parameter DW = 4;
  parameter RW_ADDR_COLLISION_VAL = "yes";
  parameter shortreal PERIOD = 5;
  parameter NUM = 16;

  bit clk;
  logic [3 : 0] i;
  logic wen, ren;
  logic [AW - 1 : 0] waddr, raddr;
  logic [DW - 1 : 0] din, dout;

  sdp_one_clk #(.AW(AW), .DW(DW), .RW_ADDR_COLLISION_VAL(RW_ADDR_COLLISION_VAL))
  i_sdp_one_clk
  (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output wen, ren, waddr, raddr, din;
    input dout;
  endclocking

  initial begin
    wen <= '0;
    ren <= '0;
    din <= '0;
    waddr <= '0;
    raddr <= '0;
    for (i = 0; i < NUM; i++) begin
      ##1 cb.wen <= ~i[3];
          cb.ren <= ~i[3];
          cb.waddr <= {1'b0, i[2 : 0]};
          cb.raddr <= {2'b0, i[1 : 0]};
          cb.din   <= $urandom_range(1, 2 ** DW - 1);
    end
  end
endmodule


