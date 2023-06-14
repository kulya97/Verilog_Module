`timescale 1ns / 1ps
/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*WebSite:https://www.milianke.com
*TechWeb:https://www.uisrc.com
*tmall-shop:https://milianke.tmall.com
*jd-shop:https://milianke.jd.com
*taobao-shop: https://milianke.taobao.com
*Create Date: 2022/09/25
*Module Name:
*File Name:
*Description: 
*The reference demo provided by Milianke is only used for learning. 
*We cannot ensure that the demo itself is free of bugs, so users 
*should be responsible for the technical problems and consequences
*caused by the use of their own products.
*Copyright: Copyright (c) MiLianKe
*All rights reserved.
*Revision: 3.1
*Signal description
*1) _i input
*2) _o output
*3) _n activ low
*4) _dg debug signal 
*5) _r delay or register
*6) _s state mechine
*********************************************************************/
module uifdma_dbuf#(
parameter  integer                          AXI_Lite       = 1,
parameter  integer                          VIDEO_ENABLE   = 1,  
parameter  integer                          ENABLE_WRITE   = 1,
parameter  integer                          ENABLE_READ    = 1,

parameter  integer                          AXI_DATA_WIDTH = 128,
parameter  integer                          AXI_ADDR_WIDTH = 32,

parameter  integer                          W_BUFDEPTH     = 2048,
parameter  integer                          W_DATAWIDTH    = 32,
parameter  [AXI_ADDR_WIDTH -1'b1: 0]         W_BASEADDR     = 0,
parameter  integer                          W_DSIZEBITS    = 24,
parameter  integer                          W_XSIZE     = 1920, 
parameter  integer                          W_XSTRIDE   = 1920,
parameter  integer                          W_YSIZE     = 1080,
parameter  integer                          W_XDIV      = 2,
parameter  integer                          W_BUFSIZE   = 3,

parameter  integer                          R_BUFDEPTH     = 2048,
parameter  integer                          R_DATAWIDTH    = 32,
parameter  [AXI_ADDR_WIDTH -1'b1: 0]         R_BASEADDR     = 0,
parameter  integer                          R_DSIZEBITS    = 24,
parameter  integer                          R_XSIZE     = 1920, 
parameter  integer                          R_XSTRIDE   = 1920,
parameter  integer                          R_YSIZE     = 1080,
parameter  integer                          R_XDIV      = 2,
parameter  integer                          R_BUFSIZE   = 3
)
(
input  wire                                 S_AXI_ACLK,
input  wire                                 S_AXI_ARESETN,
input  wire  [3 : 0]                        S_AXI_AWADDR,
input  wire  [2 : 0]                        S_AXI_AWPROT,
input  wire                                 S_AXI_AWVALID,
output wire                                 S_AXI_AWREADY,
input  wire  [31: 0]                        S_AXI_WDATA,  
input  wire  [3 : 0]                        S_AXI_WSTRB,
input  wire                                 S_AXI_WVALID,
output wire                                 S_AXI_WREADY,
output wire  [1 : 0]                        S_AXI_BRESP,
output wire                                 S_AXI_BVALID,
input  wire                                 S_AXI_BREADY,
input  wire  [3 : 0]                        S_AXI_ARADDR,
input  wire  [2 : 0]                        S_AXI_ARPROT,
input  wire                                 S_AXI_ARVALID,
output wire                                 S_AXI_ARREADY,
output wire  [31: 0]                        S_AXI_RDATA,
output wire  [1 : 0]                        S_AXI_RRESP,
output wire                                 S_AXI_RVALID,
input  wire                                 S_AXI_RREADY,

input  wire                                 ud_wclk, 
input  wire                                 ud_wvs,
input  wire                                 ud_wde,
input  wire [W_DATAWIDTH - 1'b1: 0]         ud_wdata,
output wire [7 : 0]                         wbuf_sync_o,
input  wire [7 : 0]                         wbuf_sync_i,
output wire                                 ud_wfull,

input  wire                                 ud_rclk, 
input  wire                                 ud_rvs,
input  wire                                 ud_rde,
output wire [R_DATAWIDTH - 1'b1: 0]         ud_rdata,
output wire [7 : 0]                         rbuf_sync_o,
input  wire [7 : 0]                         rbuf_sync_i,
output wire                                 ud_rempty,
//----------fdma signals write-------       
output wire [AXI_ADDR_WIDTH-1'b1: 0]        fdma_waddr,
output wire                                 fdma_wareq,
output wire [15: 0]                         fdma_wsize,                                     
input  wire                                 fdma_wbusy,		
output wire [AXI_DATA_WIDTH-1'b1:0]         fdma_wdata,
input  wire                                 fdma_wvalid,
output wire                                 fdma_wready,
output wire [7 : 0]                         fdma_wbuf,
output wire                                 fdma_wirq,		
//----------fdma signals read-------  
output wire [AXI_ADDR_WIDTH-1'b1: 0]        fdma_raddr,
output wire                                 fdma_rareq,
output wire [15: 0]                         fdma_rsize,                                     
input  wire                                 fdma_rbusy,			
input  wire [AXI_DATA_WIDTH-1'b1:0]         fdma_rdata,
input  wire                                 fdma_rvalid,
output wire                                 fdma_rready	,
output wire [7 : 0]                         fdma_rbuf,
output wire                                 fdma_rirq	
);


uidbuf # (
.VIDEO_ENABLE(VIDEO_ENABLE),  
.ENABLE_WRITE(ENABLE_WRITE), 
.ENABLE_READ(ENABLE_READ), 
.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

.W_BUFDEPTH(W_BUFDEPTH),
.W_DATAWIDTH(W_DATAWIDTH),
.W_BASEADDR(W_BASEADDR),
.W_DSIZEBITS(W_DSIZEBITS),
.W_XSIZE(W_XSIZE),
.W_XSTRIDE(W_XSTRIDE),
.W_YSIZE(W_YSIZE),
.W_XDIV(W_XDIV),
.W_BUFSIZE(W_BUFSIZE),

.R_BUFDEPTH(R_BUFDEPTH),
.R_DATAWIDTH(R_DATAWIDTH),
.R_BASEADDR(R_BASEADDR),
.R_DSIZEBITS(R_DSIZEBITS),
.R_XSIZE(R_XSIZE),
.R_XSTRIDE(R_XSTRIDE),
.R_YSIZE(R_YSIZE),
.R_XDIV(R_XDIV),
.R_BUFSIZE(R_BUFSIZE)
)uidbuf_u0
(
.ui_clk(S_AXI_ACLK),
.ui_rstn(S_AXI_ARESETN),

.W_FS_i(ud_wvs),
.W_wclk_i(ud_wclk),
.W_wren_i(ud_wde),
.W_data_i(ud_wdata), 
.W_sync_cnt_o(wbuf_sync_o),
.W_buf_i(wbuf_sync_i),
.W_full(ud_wfull),

.R_FS_i(ud_rvs),
.R_rclk_i(ud_rclk),
.R_rden_i(ud_rde),
.R_data_o(ud_rdata),
.R_sync_cnt_o(rbuf_sync_o),
.R_buf_i(rbuf_sync_i),
.R_empty(ud_rempty),
       
.fdma_waddr(fdma_waddr)  ,
.fdma_wareq(fdma_wareq)  ,
.fdma_wsize(fdma_wsize)  ,                                     
.fdma_wbusy(fdma_wbusy)  ,			
.fdma_wdata(fdma_wdata)	 ,
.fdma_wvalid(fdma_wvalid),
.fdma_wready(fdma_wready),
.fdma_raddr(fdma_raddr)  ,
.fdma_rareq(fdma_rareq)  ,
.fdma_rsize(fdma_rsize)  ,                                     
.fdma_rbusy(fdma_rbusy)  ,			
.fdma_rdata(fdma_rdata)	 ,
.fdma_rvalid(fdma_rvalid),
.fdma_rready(fdma_rready),
.fmda_wbuf  (fdma_wbuf),	
.fdma_wirq  (fdma_wirq),		
.fmda_rbuf  (fdma_rbuf),	
.fdma_rirq  (fdma_rirq)
 ); 

uidbufirq uidbufirq_inst(
.S_AXI_ACLK     (S_AXI_ACLK),
.S_AXI_ARESETN  (S_AXI_ARESETN),
.S_AXI_AWADDR   (S_AXI_AWADDR),
.S_AXI_AWPROT   (S_AXI_AWPROT),
.S_AXI_AWVALID  (S_AXI_AWVALID),
.S_AXI_AWREADY  (S_AXI_AWREADY),
.S_AXI_WDATA    (S_AXI_WDATA),  
.S_AXI_WSTRB    (S_AXI_WSTRB),
.S_AXI_WVALID   (S_AXI_WVALID),
.S_AXI_WREADY   (S_AXI_WREADY),
.S_AXI_BRESP    (S_AXI_BRESP),
.S_AXI_BVALID   (S_AXI_BVALID),
.S_AXI_BREADY   (S_AXI_BREADY),
.S_AXI_ARADDR   (S_AXI_ARADDR),
.S_AXI_ARPROT   (S_AXI_ARPROT),
.S_AXI_ARVALID  (S_AXI_ARVALID),
.S_AXI_ARREADY  (S_AXI_ARREADY),
.S_AXI_RDATA    (S_AXI_RDATA),
.S_AXI_RRESP    (S_AXI_RRESP),
.S_AXI_RVALID   (S_AXI_RVALID),
.S_AXI_RREADY   (S_AXI_RREADY),	
.fdma_wbuf      (fdma_wbuf),	
.fdma_wirq      (fdma_wirq),
.fdma_rbuf      (fdma_rbuf),
.fdma_rirq      (fdma_rirq)
);   
    
endmodule
