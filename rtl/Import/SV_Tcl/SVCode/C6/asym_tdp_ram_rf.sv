//File: asym_tdp_ram_rf.sv
//PORTA_DW: data width of port A
//PORTA_AW: address width of port A
//PORTB_DW: data width of port B
//PORTB_AW: address width of port B
//(2 ** PORTA_AW) * PORTA_DW = (2 ** PORTB_AW) * PORTB_DW
module asym_tdp_ram_rf
#(
  parameter PORTA_DW = 16,
  parameter PORTA_AW = 8,
  parameter PORTB_DW = 4,
  parameter PORTB_AW = 10
)
(
  input logic                     clka,
  input logic                     wea,
  input logic  [PORTA_DW - 1 : 0] dina,
  input logic  [PORTA_AW - 1 : 0] addra,
  output logic [PORTA_DW - 1 : 0] douta,
  input logic                     clkb,
  input logic                     web,
  input logic  [PORTB_DW - 1 : 0] dinb,
  input logic  [PORTB_AW - 1 : 0] addrb,
  output logic [PORTB_DW - 1 : 0] doutb
);

  `define max(a,b) {(a) > (b) ? (a) : (b)}
  `define min(a,b) {(a) < (b) ? (a) : (b)}

  localparam DEPTHA = 2 ** PORTA_AW;
  localparam DEPTHB = 2 ** PORTB_AW;
  localparam MAX_DEPTH = `max(DEPTHA, DEPTHB);
  localparam MAX_DW    = `max(PORTA_DW, PORTB_DW);
  localparam MIN_DW    = `min(PORTA_DW, PORTB_DW);
  localparam RATIO     = MAX_DW / MIN_DW;
  localparam LOG2RATIO = $clog2(RATIO);
  
  logic wea_d1;
  logic [PORTA_AW - 1 : 0] addra_d1;
  logic [PORTA_DW - 1 : 0] dina_d1;
  logic web_d1;
  logic [PORTB_AW - 1 : 0] addrb_d1;
  logic [PORTB_DW - 1 : 0] dinb_d1;
  
  logic [MIN_DW - 1 : 0] mem [MAX_DEPTH] = '{default : '0};

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

  always_ff @(posedge clkb) begin
    if (web_d1) begin
      mem[addrb_d1] <= dinb_d1;
    end
    doutb <= mem[addrb_d1];
  end
  
  always_ff @(posedge clka) begin
    logic [LOG2RATIO - 1 : 0] addra_lsb;
    for (int i = 0; i < RATIO; i++) begin
      addra_lsb = i;
      douta[i * MIN_DW +: MIN_DW] <= mem[{addra_d1, addra_lsb}];
      if (wea_d1) begin
        mem[{addra_d1, addra_lsb}] <= dina_d1[i * MIN_DW +: MIN_DW];
      end
    end
  end
endmodule
  

  
