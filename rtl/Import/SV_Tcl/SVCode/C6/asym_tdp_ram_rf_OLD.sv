//File: asym_tdp_ram_rf.sv
//PORTA_WRITE_DW : port A write data width
//PORTA_READ_DW  : port A read data width
//PORTA_MAX_AW   : port A maximum address width 
//--> max(write address width, read address width)
//PORTB_WRITE_DW : port B write data width
//PORTB_READ_DW  : port B read data width
//PORTB_MAX_AW   : port B maximum address width 
//--> max(write address width, read address width)
//DEPTHA = 2 ** PORTA_MAX_AW
//DEPTHB = 2 ** PORTB_MAX_AW
//DEPTHA * PORTA_DW = DEPTHB * PORTB_DW
module asym_tdp_ram_rf
#(
  parameter PORTA_WRITE_DW = 16,
  parameter PORTA_READ_DW  = 32,
  parameter PORTA_MAX_AW   = 10,
  parameter PORTB_WRITE_DW = 32,
  parameter PORTB_READ_DW  = 16,
  parameter PORTB_MAX_AW   = 10
)
(
  input logic                          clka,
  input logic                          wea,
  input logic [PORTA_MAX_AW   - 1 : 0] addra,
  input logic [PORTA_WRITE_DW - 1 : 0] dina,
  output logic [PORTA_READ_DW - 1 : 0] douta,
  input logic                          clkb,
  input logic                          web,
  input logic [PORTB_MAX_AW   - 1 : 0] addrb,
  input logic [PORTB_WRITE_DW - 1 : 0] dinb,
  output logic [PORTB_READ_DW - 1 : 0] doutb
);

  `define max(a,b) {(a) > (b) ? (a) : (b)}
  `define min(a,b) {(a) < (b) ? (a) : (b)}

  localparam DEPTHA             = 2 ** PORTA_MAX_AW;
  localparam DEPTHB             = 2 ** PORTB_MAX_AW;
  localparam MAX_DEPTH          = `max(DEPTHA, DEPTHB);
  localparam MIN_PORTA_DW       = `min(PORTA_WRITE_DW, PORTA_READ_DW);
  localparam MIN_PORTB_DW       = `min(PORTB_WRITE_DW, PORTB_READ_DW);
  localparam MIN_DW             = `min(MIN_PORTA_DW, MIN_PORTB_DW);
  localparam PORTA_W_RATIO      = PORTA_WRITE_DW / MIN_DW;
  localparam PORTA_R_RATIO      = PORTA_READ_DW / MIN_DW;
  localparam PORTB_W_RATIO      = PORTB_WRITE_DW / MIN_DW;
  localparam PORTB_R_RATIO      = PORTB_READ_DW / MIN_DW;
  localparam LOG2_PORTA_W_RATIO = $clog2(PORTA_W_RATIO);
  localparam LOG2_PORTA_R_RATIO = $clog2(PORTA_R_RATIO);
  localparam LOG2_PORTB_W_RATIO = $clog2(PORTB_W_RATIO);
  localparam LOG2_PORTB_R_RATIO = $clog2(PORTB_R_RATIO);
  localparam MAX_AW             = $clog2(MAX_DEPTH);

  logic [MIN_DW - 1 : 0] mem [MAX_DEPTH] = '{default : '0};
  logic [MAX_AW - 1 : 0] addr;
  logic                          wea_d1;
  logic [PORTA_MAX_AW   - 1 : 0] addra_d1;
  logic [PORTA_WRITE_DW - 1 : 0] dina_d1;
  logic                          web_d1;
  logic [PORTA_MAX_AW   - 1 : 0] addrb_d1;
  logic [PORTA_WRITE_DW - 1 : 0] dinb_d1;

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
    logic [LOG2_PORTA_W_RATIO - 1 : 0] addra_w_lsb;
    for (int i = 0; i < PORTA_W_RATIO; i++) begin
      addra_w_lsb = i;
      if (wea_d1) begin
        mem[{addra_d1, addra_w_lsb}] <= dina_d1[i * MIN_DW +: MIN_DW];
      end
    end
  end

  always_ff @(posedge clka) begin
    logic [LOG2_PORTA_R_RATIO - 1 : 0] addra_r_lsb;
    for (int j = 0; j < PORTA_R_RATIO; j++) begin
      addra_r_lsb = j;
      douta[j * MIN_DW +: MIN_DW] <= mem[{addra_d1, addra_r_lsb}];
    end
  end

  always_ff @(posedge clkb) begin
    logic [LOG2_PORTB_W_RATIO - 1 : 0] addrb_w_lsb;
    for (int m = 0; m < PORTB_W_RATIO; m++) begin
      addrb_w_lsb = m;
      if (web_d1) begin
        mem[{addrb_d1, addrb_w_lsb}] <= dinb_d1[m * MIN_DW +: MIN_DW];
      end
    end
  end

  always_ff @(posedge clkb) begin
    logic [LOG2_PORTB_R_RATIO - 1 : 0] addrb_r_lsb;
    for (int n = 0; n <PORTB_R_RATIO; n++) begin
      addrb_r_lsb = n;
      douta[n * MIN_DW +: MIN_DW] <= mem[{addrb_d1, addrb_r_lsb}];
    end
  end
endmodule








  
