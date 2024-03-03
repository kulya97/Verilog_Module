//File: sdp_one_clk.sv
module sdp_one_clk
#(
  parameter AW = 4,
  parameter DW = 2,
  parameter RAM_STYLE_VAL = "distributed",
  parameter RW_ADDR_COLLISION_VAL = "yes"
)
(
  input logic clk,
  input logic wen,
  input logic [AW - 1 : 0] waddr,
  input logic [DW - 1 : 0] din,
  input logic ren,
  input logic [AW - 1 : 0] raddr,
  output logic [DW - 1 : 0] dout
);

  localparam DEPTH = 2 ** AW;
  logic wen_d1, ren_d1;
  logic [AW - 1 : 0] waddr_d1, raddr_d1;
  logic [DW - 1 : 0] din_d1;
  
  (* RW_ADDR_COLLISION = RW_ADDR_COLLISION_VAL *)
  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [DW - 1 : 0] mem [DEPTH] = '{default : '0};

  always_ff @(posedge clk) begin
    wen_d1   <= wen;
    waddr_d1 <= waddr;
    ren_d1   <= ren;
    raddr_d1 <= raddr;
    din_d1   <= din;
  end

  always_ff @(posedge clk) begin
    if (wen_d1) 
      mem[waddr_d1] <= din_d1;
  end

  always_ff @(posedge clk) begin
    if (ren_d1)
      dout <= mem[raddr_d1];
  end
endmodule
      
   
  
