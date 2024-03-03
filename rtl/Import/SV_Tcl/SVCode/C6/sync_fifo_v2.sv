//File: sync_fifo_v2.sv
module sync_fifo_v2
#(
  parameter AW            = 15,     //address width
  parameter DW            = 18,     //data width
  parameter RAM_STYLE_VAL = "block"//ram style
)
(
  input logic               clk,
  input logic               rst,
  input logic               wen,
  input logic [DW - 1  : 0] din,
  input logic               ren,
  output logic              full,
  output logic              empty,
  output logic [AW     : 0] room_avail,
  output logic [AW     : 0] data_avail,
  output logic              dout_valid,
  output logic [DW - 1 : 0] dout
);

  logic mem_wen, mem_ren;
  logic [AW - 1 : 0] mem_waddr, mem_raddr;
  logic [DW - 1 : 0] mem_din;

  always_ff @(posedge clk) begin
    mem_din <= din;
  end

  fifo_ctrl #(.AW(AW)) i_fifo_ctrl (.*);

  sdp_one_clk 
  #(
    .AW(AW), 
    .DW(DW), 
    .RAM_STYLE_VAL(RAM_STYLE_VAL)
  )
  i_sdp_one_clk 
  (
    .clk   (clk       ), 
    .wen   (mem_wen   ), 
    .waddr (mem_waddr ), 
    .din   (mem_din   ), 
    .ren   (mem_ren   ),
    .raddr (mem_raddr ),
    .dout  (dout      )
  );
endmodule 
