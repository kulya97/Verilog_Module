//File: sdp_two_clk.sv
module sdp_two_clk
#(
  parameter AW = 11,
  parameter DW = 18,
  parameter RAM_STYLE_VAL = "block",
  parameter RW_ADDR_COLLISION_VAL = "no"
)
(
  input logic clka, 
  input logic wea,
  input logic [AW - 1 : 0] addra,
  input logic [DW - 1 : 0] dina,
  input logic clkb,
  input logic reb,
  input logic [AW - 1 : 0] addrb,
  output logic [DW - 1 : 0] doutb
);

  localparam DEPTH = 2 ** AW;

  (* RW_ADDR_COLLISION = RW_ADDR_COLLISION_VAL *)
  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [DW - 1 : 0] mem [DEPTH] = '{default : '0};

  logic wea_d1;
  logic [AW - 1 : 0] addra_d1;
  logic [DW - 1 : 0] dina_d1;
  logic reb_d1;
  logic [AW - 1 : 0] addrb_d1;

  always_ff @(posedge clka) begin
    wea_d1   <= wea;
    addra_d1 <= addra;
    dina_d1   <= dina;
  end

  always_ff @(posedge clkb) begin
    reb_d1   <= reb;
    addrb_d1 <= addrb;
  end

  always_ff @(posedge clka) begin
    if (wea_d1)
      mem[addra_d1] <= dina_d1;
  end

  always_ff @(posedge clkb) begin
    if (reb_d1)
      doutb <= mem[addrb_d1];
  end
endmodule
  


