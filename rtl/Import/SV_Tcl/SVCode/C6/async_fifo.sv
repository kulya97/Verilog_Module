//File: async_fifo.sv
module async_fifo
#(
  parameter DW = 18,
  parameter AW = 14,
  parameter RAM_STYLE_VAL = "block"
)
(
  input logic               wclk, wrst, wen,
  input logic               rclk, rrst, ren,
  input logic [DW - 1 : 0]  din,
  output logic              wfull,
  output logic              rempty,
  output logic [DW - 1 : 0] dout,
  output logic              dout_valid
);

  logic [AW : 0] wptr, rptr, wq2_rptr, rq2_wptr;
  logic [AW - 1 : 0] mem_waddr, mem_raddr;
  logic [DW - 1 : 0] mem_din;
  logic mem_wen, mem_ren;

  always_ff @(posedge wclk) mem_din <= din;

  cdc_sync #(.AW(AW)) r2w_cdc_sync
  (.clk (wclk), .rst(wrst), .din(rptr), .dout(wq2_rptr));

  cdc_sync #(.AW(AW)) w2r_cdc_sync
  (.clk (rclk), .rst(rrst), .din(wptr), .dout(rq2_wptr));

  wptr_full #(.AW(AW)) i_wptr_full (.*);

  rptr_empty #(.AW(AW)) i_rptr_empty (.*);

  sdp_two_clk #(.AW(AW), .DW(DW), .RAM_STYLE_VAL(RAM_STYLE_VAL))
  i_sdp_two_clk
  (
    .clka  (wclk      ),
    .wea   (mem_wen   ),
    .addra (mem_waddr ),
    .dina  (mem_din   ),
    .clkb  (rclk      ),
    .reb   (mem_ren   ),
    .addrb (mem_raddr ),
    .doutb (dout      )
  );
endmodule
