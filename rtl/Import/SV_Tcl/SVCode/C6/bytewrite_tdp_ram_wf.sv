//File: bytewrite_tdp_ram_wf.sv
module bytewrite_tdp_ram_wf
#(
  parameter AW = 10,
  parameter NB = 4,
  parameter DW = NB * 8,
  parameter RAM_STYLE_VAL = "block"
)
(
  input logic               clka,
  input logic  [NB - 1 : 0] wea,
  input logic  [AW - 1 : 0] addra,
  input logic  [DW - 1 : 0] dina,
  output logic [DW - 1 : 0] douta,
  input logic               clkb,
  input logic  [NB - 1 : 0] web,
  input logic  [AW - 1 : 0] addrb,
  input logic  [DW - 1 : 0] dinb,
  output logic [DW - 1 : 0] doutb
);

  localparam DEPTH = 2 ** AW;
  logic [NB - 1 : 0] wea_d1;
  logic [AW - 1 : 0] addra_d1;
  logic [DW - 1 : 0] dina_d1;
  logic [NB - 1 : 0] web_d1;
  logic [AW - 1 : 0] addrb_d1;
  logic [DW - 1 : 0] dinb_d1;

  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [DW - 1 : 0] mem [DEPTH] = '{default : '0};

  always_ff @(posedge clka) begin
    wea_d1   <= wea;
    addra_d1 <= addra;
    dina_d1  <= dina;
  end

  always_ff @(posedge clkb) begin
    web_d1   <= web;
    addrb_d1 <= addrb;
    dinb_d1  <= dinb;
  end

  for (genvar i = 0; i < NB; i++) begin
    always_ff @(posedge clka) begin
      if (wea_d1[i]) begin
        mem[addra_d1][i * 8 +: 8] <= dina_d1[i * 8 +: 8];
        douta[i * 8 +: 8] <= dina_d1[i * 8 +: 8];
      end
      else begin
        douta[i * 8 +: 8] <= mem[addra_d1][i * 8 +: 8];
      end
    end
  end

  for (genvar i = 0; i < NB; i++) begin
    always_ff @(posedge clkb) begin
      if (web_d1[i]) begin
        mem[addrb_d1][i * 8 +: 8] <= dinb_d1[i * 8 +: 8];
        doutb[i * 8 +: 8] <= dinb_d1[i * 8 +: 8];
      end
      else begin
        doutb[i * 8 +: 8] <= mem[addrb_d1][i * 8 +: 8];
      end
    end
  end
endmodule

