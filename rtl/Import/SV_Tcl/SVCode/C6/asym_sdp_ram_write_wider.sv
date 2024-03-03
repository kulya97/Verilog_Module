//File: asym_sdp_ram_write_wider.sv
//AWA : address width of port A
//DWA : data width of port A
//AWB : address width of port B
//DWB : data width of port B
//DEPTHA : 2 ** AWA
//DEPTHB : 2 ** AWB
//DEPTHA * DWA = DEPTHB * DWB
module asym_sdp_ram_write_wider
#(
  parameter AWA = 8,
  parameter DWA = 16,
  parameter AWB = 10,
  parameter DWB = 4
)
(
  input logic clka,
  input logic wea,
  input logic [AWA - 1 : 0] addra,
  input logic [DWA - 1 : 0] dina,
  input logic clkb,
  input logic reb,
  input logic [AWB - 1 : 0] addrb,
  output logic [DWB - 1 : 0] doutb
);

  `define max(a,b) {(a) > (b) ? (a) : (b)}
  `define min(a,b) {(a) < (b) ? (a) : (b)}
  
  localparam DEPTHA     = 2 ** AWA;
  localparam DEPTHB     = 2 ** AWB;
  localparam MAX_DEPTH  = `max(DEPTHA, DEPTHB);
  localparam MAX_DW     = `max(DWA, DWB);
  localparam MIN_DW     = `min(DWA, DWB);
  localparam RATIO      = MAX_DW / MIN_DW;
  localparam LOG2_RATIO = $clog2(RATIO);

  logic [MIN_DW - 1 : 0] mem [MAX_DEPTH] = '{default : '0};

  logic wea_d1;
  logic [AWA - 1 : 0] addra_d1;
  logic [DWA - 1 : 0] dina_d1;
  logic reb_d1;
  logic [AWB - 1 : 0] addrb_d1;

  always_ff @(posedge clka) begin
    wea_d1   <= wea;
    addra_d1 <= addra;
    dina_d1  <= dina;
  end

  always_ff @(posedge clkb) begin
    reb_d1   <= reb;
    addrb_d1 <= addrb;
  end

  always_ff @(posedge clka) begin
    logic [LOG2_RATIO - 1 : 0] addra_lsb;
    for (int i = 0; i < RATIO; i++) begin
      addra_lsb = i;
      if (wea_d1) begin
        mem[{addra_d1, addra_lsb}] <= dina_d1[i * MIN_DW +: MIN_DW];
      end
    end
  end

  always_ff @(posedge clkb) begin
    if (reb_d1) begin
      doutb <= mem[addrb_d1];
    end
  end

endmodule
