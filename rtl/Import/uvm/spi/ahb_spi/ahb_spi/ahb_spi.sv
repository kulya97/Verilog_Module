//---This is from wechat公众号《芯片验证日记》


`include "spi_defines.v"
`include "timescale.v"
module ahb_spi(
input hclk,
input hresetn,
input hwdata,
input hwrite,
input [2:0] hburst,
input [2:0] hsize,
input [1:0] htrans,
input hsel,
input [AWIDTH-1:0] haddr,
output [DWIDTH-1:0] hrdata,//
output [1:0] hresp,
output hready,

input wb_clk_i,
input wb_rst_i,



output          [`SPI_SS_NB-1:0] ss_pad_o,
output                           sclk_pad_o,
output                           mosi_pad_o,
input                            miso_pad_i
);

//parameter declaration
	parameter AWIDTH = 16;
	parameter DWIDTH = 32;


wire [4:0]  wb_adr;
wire [31:0] wb_data;
wire [31:0] wb_data_o;
wire wb_we_i;
wire wb_stb_i;
wire wb_cyc_i;
wire wb_ack_o;


ahb2wb #(.AWIDTH(AWIDTH),.DWIDTH(DWIDTH)) ahb2wb(
	//wishbone ports		
	.dat_i(wb_dat_o),//input [DWIDTH-1:0]dat_i;						// data input from wishbone slave
	.ack_i(wb_ack_o),//input ack_i;									// acknowledment from wishbone slave
	.clk_i(wb_clk_i),//input clk_i;
	.rst_i(wb_rst_i),//input rst_i;
	
 //AHB ports	
	.hclk(hclk),//input hclk; 									// clock
	.hresetn(hresetn),//input hresetn;									// active low reset
	.hwdata(hwdata),//input [DWIDTH-1:0]hwdata;						// data bus		
	.hwrite(hwrite),//input hwrite;									// write/read enable
	.hburst(hburst),//input [2:0]hburst;								// burst type
	.hsize(hsize),//input [2:0]hsize;								// data size
	.htrans(htrans),//input [1:0]htrans;								// type of transfer
	.hsel(hsel),//input hsel;										// slave select 
	.haddr(haddr),//input [AWIDTH-1:0]haddr;						// address bus

	//wishbone ports
	.adr_o(wb_adr),//output [AWIDTH-1:0]adr_o;						// address to wishbone slave 
	.dat_o(wb_dat_i),//output [DWIDTH-1:0]dat_o;						// data output for wishbone slave
	.cyc_o(wb_cyc_i),//output cyc_o;									// signal to indicate valid bus cycle
	.we_o(wb_we_i),//output we_o;									// write enable
	.stb_o(wb_stb_i),//output stb_o;									// strobe to indicate valid data transfer cycle
		

 // AHB ports
	.hrdata(hrdata),//output [DWIDTH-1:0]hrdata;						// data output for wishbone slave
	.hresp(hresp),//output [1:0]hresp;								// response signal from slave
	.hready(hready)//output hready;									// slave ready
);



spi_top spi_top(
// Wishbone signals
  .wb_clk_i(wb_clk_i),//input                            wb_clk_i;         // master clock input
  .wb_rst_i(wb_rst_i),//input                            wb_rst_i;         // synchronous active high reset
  .wb_adr_i(wb_adr),//input                      [4:0] wb_adr_i;         // lower address bits
  .wb_dat_i(wb_dat),//input                   [32-1:0] wb_dat_i;         // databus input
  .wb_dat_o(wb_dat_o),//output                  [32-1:0] wb_dat_o;         // databus output
  .wb_sel_i(),//input                      [3:0] wb_sel_i;         // byte select inputs
  .wb_we_i(wb_we_i),//input                            wb_we_i;          // write enable input
  .wb_stb_i(wb_stb_i),//input                            wb_stb_i;         // stobe/core select signal
  .wb_cyc_i(wb_cyc_i),//input                            wb_cyc_i;         // valid bus cycle input
  .wb_ack_o(wb_ack_o),//output                           wb_ack_o;         // bus cycle acknowledge output
  .wb_err_o(),//output                           wb_err_o;         // termination w/ error
  .wb_int_o(),//output                           wb_int_o;         // interrupt request signal output
                                                     
  // SPI signals                                     
  .ss_pad_o(ss_pad_o), //output          [`SPI_SS_NB-1:0] ss_pad_o;         // slave select
  .sclk_pad_o(sclk_pad_o),//output                           sclk_pad_o;       // serial clock
  .mosi_pad_o(mosi_pad_o),//output                           mosi_pad_o;       // master out slave in
  .miso_pad_i(miso_pad_i)//input                            miso_pad_i;       // master in slave out
);

endmodule
