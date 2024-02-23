`include "spi_defines.v"
`include "timescale.v"

module spi_top
(  
 // APB signals
  pclk,presetn,psel,penable,pwrite,paddr,pwdata,prdata,
 // SPI signals
  ss_pad_o, sclk_pad_o, mosi_pad_o, miso_pad_i
);

  parameter Tp = 1;

  // APB signals
  input           pclk;      // master clock input
  input           presetn;   // synchronous active high reset
  input     [3:0] psel;      // byte select inputs
  input           penable;   // enable
  input           pwrite;    // transmit direction on bus
  input     [4:0] paddr;     // lower address bits
  input    [31:0] pwdata;    // databus input
  output   [31:0] prdata;    // databus output
                                                   
  // SPI signals                                     
  output          [`SPI_SS_NB-1:0] ss_pad_o;         // slave select
  output                           sclk_pad_o;       // serial clock
  output                           mosi_pad_o;       // master out slave in
  input                            miso_pad_i;       // master in slave out
                                                     
  reg                     [32-1:0] prdata;
                                               
  // Internal signals
  reg       [`SPI_DIVIDER_LEN-1:0] divider;          // Divider register
  reg       [`SPI_CTRL_BIT_NB-1:0] ctrl;             // Control and status register
  reg             [`SPI_SS_NB-1:0] ss;               // Slave select register
  reg                     [32-1:0] p_dat;            // apb data out
  wire         [`SPI_MAX_CHAR-1:0] rx;               // Rx register
  wire                             rx_negedge;       // miso is sampled on negative edge
  wire                             tx_negedge;       // mosi is driven on negative edge
  wire    [`SPI_CHAR_LEN_BITS-1:0] char_len;         // char len
  wire                             go;               // go
  wire                             lsb;              // lsb first on line
  wire                             ie;               // interrupt enable
  wire                             ass;              // automatic slave select
  wire                             spi_divider_sel;  // divider register select
  wire                             spi_ctrl_sel;     // ctrl register select
  wire                       [3:0] spi_tx_sel;       // tx_l register select
  wire                             spi_ss_sel;       // ss register select
  wire                             tip;              // transfer in progress
  wire                             pos_edge;         // recognize posedge of sclk
  wire                             neg_edge;         // recognize negedge of sclk
  wire                             last_bit;         // marks last character bit
  
  // Address decoder
  assign spi_divider_sel = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_DEVIDE);
  assign spi_ctrl_sel    = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_CTRL);
  assign spi_tx_sel[0]   = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_TX_0);
  assign spi_tx_sel[1]   = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_TX_1);
  assign spi_tx_sel[2]   = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_TX_2);
  assign spi_tx_sel[3]   = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_TX_3);
  assign spi_ss_sel      = psel & penable & (paddr[`SPI_OFS_BITS] == `SPI_SS);
  
  // Read from registers
  always @(paddr or rx or ctrl or divider or ss)
  begin
    case (paddr[`SPI_OFS_BITS])
`ifdef SPI_MAX_CHAR_128
      `SPI_RX_0:    p_dat = rx[31:0];
      `SPI_RX_1:    p_dat = rx[63:32];
      `SPI_RX_2:    p_dat = rx[95:64];
      `SPI_RX_3:    p_dat = {{128-`SPI_MAX_CHAR{1'b0}}, rx[`SPI_MAX_CHAR-1:96]};
`else
`ifdef SPI_MAX_CHAR_64
      `SPI_RX_0:    p_dat = rx[31:0];
      `SPI_RX_1:    p_dat = {{64-`SPI_MAX_CHAR{1'b0}}, rx[`SPI_MAX_CHAR-1:32]};
      `SPI_RX_2:    p_dat = 32'b0;
      `SPI_RX_3:    p_dat = 32'b0;
`else
      `SPI_RX_0:    p_dat = {{32-`SPI_MAX_CHAR{1'b0}}, rx[`SPI_MAX_CHAR-1:0]};
      `SPI_RX_1:    p_dat = 32'b0;
      `SPI_RX_2:    p_dat = 32'b0;
      `SPI_RX_3:    p_dat = 32'b0;
`endif
`endif
      `SPI_CTRL:    p_dat = {{32-`SPI_CTRL_BIT_NB{1'b0}}, ctrl};
      `SPI_DEVIDE:  p_dat = {{32-`SPI_DIVIDER_LEN{1'b0}}, divider};
      `SPI_SS:      p_dat = {{32-`SPI_SS_NB{1'b0}}, ss};
      default:      p_dat = 32'bx;
    endcase
  end
  
  // apb data out
  always @(posedge pclk or negedge presetn)
  begin
    if (!presetn)
      prdata <= #Tp 32'b0;
    else
      prdata <= #Tp p_dat;
  end
  
  // Divider register
  always @(posedge pclk or negedge presetn)
  begin
    if (!presetn)
        divider <= #Tp {`SPI_DIVIDER_LEN{1'b0}};
    else if (spi_divider_sel && pwrite && !tip)
      begin
      `ifdef SPI_DIVIDER_LEN_8
        if (psel[0])
          divider <= #Tp pwdata[`SPI_DIVIDER_LEN-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_16
        if (psel[0])
          divider[7:0] <= #Tp pwdata[7:0];
        if (psel[1])
          divider[`SPI_DIVIDER_LEN-1:8] <= #Tp pwdata[`SPI_DIVIDER_LEN-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_24
        if (psel[0])
          divider[7:0] <= #Tp pwdata[7:0];
        if (psel[1])
          divider[15:8] <= #Tp pwdata[15:8];
        if (psel[2])
          divider[`SPI_DIVIDER_LEN-1:16] <= #Tp wb_dat_i[`SPI_DIVIDER_LEN-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_32
        if (psel[0])
          divider[7:0] <= #Tp pwdata[7:0];
        if (psel[1])
          divider[15:8] <= #Tp pwdata[15:8];
        if (psel[2])
          divider[23:16] <= #Tp pwdata[23:16];
        if (psel[3])
          divider[`SPI_DIVIDER_LEN-1:24] <= #Tp pwdata[`SPI_DIVIDER_LEN-1:24];
      `endif
      end
  end
  
  // Ctrl register
  always @(posedge pclk or negedge presetn)
  begin
    if (!presetn)
      ctrl <= #Tp {`SPI_CTRL_BIT_NB{1'b0}};
    else if(spi_ctrl_sel && pwrite && !tip)
      begin
        if (psel[0])
          ctrl[7:0] <= #Tp pwdata[7:0] | {7'b0, ctrl[0]};
        if (psel[1])
          ctrl[`SPI_CTRL_BIT_NB-1:8] <= #Tp pwdata[`SPI_CTRL_BIT_NB-1:8];
      end
    else if(tip && last_bit && pos_edge)
      ctrl[`SPI_CTRL_GO] <= #Tp 1'b0;
  end
  
  assign rx_negedge = ctrl[`SPI_CTRL_RX_NEGEDGE];
  assign tx_negedge = ctrl[`SPI_CTRL_TX_NEGEDGE];
  assign go         = ctrl[`SPI_CTRL_GO];
  assign char_len   = ctrl[`SPI_CTRL_CHAR_LEN];
  assign lsb        = ctrl[`SPI_CTRL_LSB];
  assign ie         = ctrl[`SPI_CTRL_IE];
  assign ass        = ctrl[`SPI_CTRL_ASS];
  
  // Slave select register
  always @(posedge pclk or negedge presetn)
  begin
    if (!presetn)
      ss <= #Tp {`SPI_SS_NB{1'b0}};
    else if(spi_ss_sel && pwrite && !tip)
      begin
      `ifdef SPI_SS_NB_8
        if (psel[0])
          ss <= #Tp pwdata[`SPI_SS_NB-1:0];
      `endif
      `ifdef SPI_SS_NB_16
        if (psel[0])
          ss[7:0] <= #Tp pwdata[7:0];
        if (psel[1])
          ss[`SPI_SS_NB-1:8] <= #Tp pwdata[`SPI_SS_NB-1:8];
      `endif
      `ifdef SPI_SS_NB_24
        if (psel[0])
          ss[7:0] <= #Tp pwrite[7:0];
        if (psel[1])
          ss[15:8] <= #Tp pwdata[15:8];
        if (psel[2])
          ss[`SPI_SS_NB-1:16] <= #Tp pwdata[`SPI_SS_NB-1:16];
      `endif
      `ifdef SPI_SS_NB_32
        if (psel[0])
          ss[7:0] <= #Tp pwdata[7:0];
        if (psel[1])
          ss[15:8] <= #Tp pwdata[15:8];
        if (psel[2])
          ss[23:16] <= #Tp pwdata[23:16];
        if (psel[3])
          ss[`SPI_SS_NB-1:24] <= #Tp pwdata[`SPI_SS_NB-1:24];
      `endif
      end
  end
  
  assign ss_pad_o = ~((ss & {`SPI_SS_NB{tip & ass}}) | (ss & {`SPI_SS_NB{!ass}}));
  
  spi_clgen clgen (.clk_in(pclk), .rst(!presetn), .go(go), .enable(tip), .last_clk(last_bit),
                   .divider(divider), .clk_out(sclk_pad_o), .pos_edge(pos_edge), 
                   .neg_edge(neg_edge));
  
  spi_shift shift (.clk(pclk), .rst(!presetn), .len(char_len[`SPI_CHAR_LEN_BITS-1:0]),
                   .latched(spi_tx_sel[3:0] & {4{pwrite}}), .byte_sel(psel), .lsb(lsb), 
                   .go(go), .pos_edge(pos_edge), .neg_edge(neg_edge), 
                   .rx_negedge(rx_negedge), .tx_negedge(tx_negedge),
                   .tip(tip), .last(last_bit), 
                   .p_in(pwdata), .p_out(rx), 
                   .s_clk(sclk_pad_o), .s_in(miso_pad_i), .s_out(mosi_pad_o));
endmodule
  
