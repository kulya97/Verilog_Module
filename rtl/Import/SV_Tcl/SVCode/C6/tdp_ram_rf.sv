//File: tdp_ram_rf.sv
module tdp_ram_rf
#(
  parameter AW = 10,
  parameter DW = 16
)
(
  input logic               clka,
  input logic  [AW - 1 : 0] addra,
  input logic               wea,
  input logic  [DW - 1 : 0] dina,
  output logic [DW - 1 : 0] douta,
  input logic               clkb,
  input logic  [AW - 1 : 0] addrb,
  input logic               web,
  input logic  [DW - 1 : 0] dinb,
  output logic [DW - 1 : 0] doutb
);

  localparam DEPTH = 2 ** AW;

  logic [DW - 1 : 0] mem [DEPTH] = '{default : '0};

  logic              wea_d1;
  logic [AW - 1 : 0] addra_d1;
  logic [DW - 1 : 0] dina_d1;
  logic              web_d1;
  logic [AW - 1 : 0] addrb_d1;
  logic [DW - 1 : 0] dinb_d1;

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

  always_ff @(posedge clka) begin
    if (wea_d1) begin
      mem[addra_d1] <= dina_d1;
    end
    douta <= mem[addra_d1];
  end

  always_ff @(posedge clkb) begin
    if (web_d1) begin
      mem[addrb_d1] <= dinb_d1;
    end
    doutb <= mem[addrb_d1];
  end

endmodule

