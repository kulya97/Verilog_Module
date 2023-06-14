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

module uidbuf#(
parameter  integer                   VIDEO_ENABLE   = 1,  
parameter  integer                   ENABLE_WRITE   = 1,
parameter  integer                   ENABLE_READ    = 1,

parameter  integer                   AXI_DATA_WIDTH = 128,
parameter  integer                   AXI_ADDR_WIDTH = 32,

parameter  integer                   W_BUFDEPTH     = 2048,
parameter  integer                   W_DATAWIDTH    = 32,
parameter  [AXI_ADDR_WIDTH -1'b1: 0]  W_BASEADDR     = 0,
parameter  integer                   W_DSIZEBITS    = 24,
parameter  integer                   W_XSIZE        = 1920, 
parameter  integer                   W_XSTRIDE      = 1920,
parameter  integer                   W_YSIZE        = 1080,
parameter  integer                   W_XDIV         = 2,
parameter  integer                   W_BUFSIZE      = 3,

parameter  integer                   R_BUFDEPTH     = 2048,
parameter  integer                   R_DATAWIDTH    = 32,
parameter  [AXI_ADDR_WIDTH -1'b1: 0]  R_BASEADDR     = 0,
parameter  integer                   R_DSIZEBITS    = 24,
parameter  integer                   R_XSIZE        = 1920, 
parameter  integer                   R_XSTRIDE      = 1920,
parameter  integer                   R_YSIZE        = 1080,
parameter  integer                   R_XDIV         = 2,
parameter  integer                   R_BUFSIZE      = 3
)
(
input wire                                  ui_clk,
input wire                                  ui_rstn,
//sensor input -W_FIFO--------------
input wire                                  W_wclk_i,
input wire                                  W_FS_i,
input wire                                  W_wren_i,
input wire     [W_DATAWIDTH-1'b1 : 0]       W_data_i,
output reg     [7   :0]                     W_sync_cnt_o =0, 
input  wire    [7   :0]                     W_buf_i,
output wire                                 W_full,
//----------fdma signals write-------       
output wire    [AXI_ADDR_WIDTH-1'b1: 0]     fdma_waddr,
output wire                                 fdma_wareq,
output wire    [15  :0]                     fdma_wsize,                                     
input  wire                                 fdma_wbusy,		
output wire    [AXI_DATA_WIDTH-1'b1:0]      fdma_wdata,
input  wire                                 fdma_wvalid,
output wire                                 fdma_wready,
output reg     [7   :0]                     fmda_wbuf =0,
output wire                                 fdma_wirq,		
//----------fdma signals read-------  
input  wire                                 R_rclk_i,
input  wire                                 R_FS_i,
input  wire                                 R_rden_i,
output wire    [R_DATAWIDTH-1'b1 : 0]       R_data_o,
output reg     [7   :0]                     R_sync_cnt_o =0,
input  wire    [7   :0]                     R_buf_i,
output wire                                 R_empty,

output wire    [AXI_ADDR_WIDTH-1'b1: 0]     fdma_raddr,
output wire                                 fdma_rareq,
output wire    [15: 0]                      fdma_rsize,                                     
input  wire                                 fdma_rbusy,			
input  wire    [AXI_DATA_WIDTH-1'b1:0]      fdma_rdata,
input  wire                                 fdma_rvalid,
output wire                                 fdma_rready,
output reg     [7  :0]                      fmda_rbuf =0,
output wire                                 fdma_rirq	
);    

function integer clog2;
  input integer value;
  begin 
    value = value-1;
    for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
    end 
  endfunction
  
localparam S_IDLE  =  2'd0;  
localparam S_RST   =  2'd1;  
localparam S_DATA1 =  2'd2;   
localparam S_DATA2 =  2'd3; 


generate  if(ENABLE_WRITE == 1)begin : FDMA_WRITE_ENABLE

localparam WFIFO_DEPTH = W_BUFDEPTH;
localparam W_WR_DATA_COUNT_WIDTH = clog2(WFIFO_DEPTH)+1;
localparam W_RD_DATA_COUNT_WIDTH = clog2(WFIFO_DEPTH*W_DATAWIDTH/AXI_DATA_WIDTH)+1;//clog2(WFIFO_DEPTH/(AXI_DATA_WIDTH/W_DATAWIDTH))+1;

localparam WYBUF_SIZE           = (W_BUFSIZE - 1'b1);
localparam WY_BURST_TIMES       = (W_YSIZE*W_XDIV);
localparam FDMA_WX_BURST        = (W_XSIZE*W_DATAWIDTH/AXI_DATA_WIDTH)/W_XDIV;
localparam WX_BURST_ADDR_INC    = (W_XSIZE*(W_DATAWIDTH/8))/W_XDIV;
localparam WX_LAST_ADDR_INC     = (W_XSTRIDE-W_XSIZE)*(W_DATAWIDTH/8) + WX_BURST_ADDR_INC;


(*mark_debug = "true"*) (* KEEP = "TRUE" *) wire  W_wren_ri = W_wren_i; 

assign                                  fdma_wready = 1'b1;
reg                                     fdma_wareq_r= 1'b0;
reg                                     W_FIFO_Rst=0; 
(*mark_debug = "true"*) (* KEEP = "TRUE" *)wire                                    W_FS;
(*mark_debug = "true"*) (* KEEP = "TRUE" *)reg [1 :0]                              W_MS=0; 
reg [W_DSIZEBITS-1'b1:0]                W_addr=0; 
(*mark_debug = "true"*) (* KEEP = "TRUE" *)reg [15:0]                              W_bcnt=0; 
(*mark_debug = "true"*) (* KEEP = "TRUE" *)wire[W_RD_DATA_COUNT_WIDTH-1'b1 :0]     W_rcnt;
(*mark_debug = "true"*) (* KEEP = "TRUE" *)reg                                     W_REQ=0; 
(*mark_debug = "true"*) (* KEEP = "TRUE" *)reg [5 :0]                              wirq_dly_cnt =0;
reg [3 :0]                              wdiv_cnt =0;
reg [7 :0]                              wrst_cnt =0;
reg [7 :0]                              fmda_wbufn;

(*mark_debug = "true"*) (* KEEP = "TRUE" *) wire wirq= fdma_wirq;

assign fdma_wsize = FDMA_WX_BURST;
assign fdma_wirq = (wirq_dly_cnt>0);

assign fdma_waddr = W_BASEADDR + {fmda_wbufn,W_addr};

reg [1:0] W_MS_r =0;
always @(posedge ui_clk) W_MS_r <= W_MS;

always @(posedge ui_clk) begin
    if(ui_rstn == 1'b0)begin
        wirq_dly_cnt <= 6'd0;
        fmda_wbuf <=0;
    end
    else if((W_MS_r == S_DATA2) && (W_MS == S_IDLE))begin
        wirq_dly_cnt <= 60;
        fmda_wbuf <= fmda_wbufn;
    end
    else if(wirq_dly_cnt >0)
        wirq_dly_cnt <= wirq_dly_cnt - 1'b1;
end

fs_cap #
(
.VIDEO_ENABLE(VIDEO_ENABLE)
)
fs_cap_W0
(
 .clk_i(ui_clk),
 .rstn_i(ui_rstn),
 .vs_i(W_FS_i),
 .fs_cap_o(W_FS)
);

assign fdma_wareq = fdma_wareq_r;


 always @(posedge ui_clk) begin
    if(!ui_rstn)begin
        W_MS         <= S_IDLE;
        W_FIFO_Rst   <= 0;
        W_addr       <= 0;
        W_sync_cnt_o <= 0;
        W_bcnt       <= 0;
        wrst_cnt     <= 0;
        wdiv_cnt     <= 0;
        fmda_wbufn    <= 0;
        fdma_wareq_r <= 1'd0;
    end   
    else begin
      case(W_MS)
        S_IDLE:begin
          W_addr <= 0;
          W_bcnt <= 0;
          wrst_cnt <= 0;
          wdiv_cnt <=0;
          if(W_FS) begin
            W_MS <= S_RST;
            if(W_sync_cnt_o < WYBUF_SIZE)
                W_sync_cnt_o <= W_sync_cnt_o + 1'b1; 
            else 
                W_sync_cnt_o <= 0;  
          end
       end
       S_RST:begin
           fmda_wbufn <= W_buf_i;
           wrst_cnt <= wrst_cnt + 1'b1;
           if((VIDEO_ENABLE == 1) && (wrst_cnt < 40))
                W_FIFO_Rst <= 1;
           else if((VIDEO_ENABLE == 1) && (wrst_cnt < 100))
                W_FIFO_Rst <= 0;
           else if(fdma_wirq == 1'b0) begin
                W_MS <= S_DATA1;
           end
       end
        S_DATA1:begin 
          if(fdma_wbusy == 1'b0 && W_REQ )begin
             fdma_wareq_r  <= 1'b1; 
          end 
          else if(fdma_wbusy == 1'b1) begin
             fdma_wareq_r  <= 1'b0;
             W_MS    <= S_DATA2;
          end          
         end
        S_DATA2:begin 
            if(fdma_wbusy == 1'b0)begin
                if(W_bcnt == WY_BURST_TIMES - 1'b1)
                    W_MS <= S_IDLE;
                else begin
                    if(wdiv_cnt < W_XDIV - 1'b1)begin
                        W_addr <= W_addr +  WX_BURST_ADDR_INC;  
                        wdiv_cnt <= wdiv_cnt + 1'b1;
                     end
                    else begin
                        W_addr <= W_addr + WX_LAST_ADDR_INC;
                        wdiv_cnt <= 0;
                    end
                    W_bcnt <= W_bcnt + 1'b1;
                    W_MS    <= S_DATA1;
                end 
            end
         end
         default: W_MS <= S_IDLE; 
       endcase
    end
 end 


wire W_rbusy;
always@(posedge ui_clk)     
     W_REQ  <= (W_rcnt > FDMA_WX_BURST - 2)&&(~W_rbusy); 
     
xpm_fifo_async # (
  .FIFO_MEMORY_TYPE          ("auto"),           //string; "auto", "block", or "distributed";
  .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
  .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
  .FIFO_WRITE_DEPTH          (WFIFO_DEPTH),     //positive integer
  .WRITE_DATA_WIDTH          (W_DATAWIDTH),               //positive integer
  .WR_DATA_COUNT_WIDTH       (W_WR_DATA_COUNT_WIDTH),               //positive integer
  .PROG_FULL_THRESH          (20),               //positive integer
  .FULL_RESET_VALUE          (0),                //positive integer; 0 or 1
  .USE_ADV_FEATURES          ("0707"),           //string; "0000" to "1F1F"; 
  .READ_MODE                 ("fwft"),            //string; "std" or "fwft";
  .FIFO_READ_LATENCY         (0),                //positive integer;
  .READ_DATA_WIDTH           (AXI_DATA_WIDTH),               //positive integer
  .RD_DATA_COUNT_WIDTH       (W_RD_DATA_COUNT_WIDTH),               //positive integer
  .PROG_EMPTY_THRESH         (10),               //positive integer
  .DOUT_RESET_VALUE          ("0"),              //string
  .CDC_SYNC_STAGES           (2),                //positive integer
  .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;
) xpm_fifo_W_inst (
      .rst              ((ui_rstn == 1'b0) || (W_FIFO_Rst == 1'b1)),
      .wr_clk           (W_wclk_i),
      .wr_en            (W_wren_i),
      .din              (W_data_i),
      .full             (W_full),
      .overflow         (),
      .prog_full        (),
      .wr_data_count    (),
      .almost_full      (),
      .wr_ack           (),
      .wr_rst_busy      (),
      .rd_clk           (ui_clk),
      .rd_en            (fdma_wvalid),
      .dout             (fdma_wdata),
      .empty            (),
      .underflow        (),
      .rd_rst_busy      (W_rbusy),
      .prog_empty       (),
      .rd_data_count    (W_rcnt),
      .almost_empty     (),
      .data_valid       (W_dvalid),
      .sleep            (1'b0),
      .injectsbiterr    (1'b0),
      .injectdbiterr    (1'b0),
      .sbiterr          (),
      .dbiterr          ()

);
end
else begin : FDMA_WRITE_DISABLE

//----------fdma signals write-------       
assign fdma_waddr = 0;
assign fdma_wareq = 0;
assign fdma_wsize = 0;                                   	
assign fdma_wdata = 0;
assign fdma_wready = 0;
assign fdma_wirq = 0;	
assign W_full = 0;

end
endgenerate


generate  if(ENABLE_READ == 1)begin : FDMA_READ
localparam RYBUF_SIZE           = (R_BUFSIZE - 1'b1);
localparam RY_BURST_TIMES       = (R_YSIZE*R_XDIV);
localparam FDMA_RX_BURST        = (R_XSIZE*R_DATAWIDTH/AXI_DATA_WIDTH)/R_XDIV;
localparam RX_BURST_ADDR_INC    = (R_XSIZE*(R_DATAWIDTH/8))/R_XDIV;
localparam RX_LAST_ADDR_INC     = (R_XSTRIDE-R_XSIZE)*(R_DATAWIDTH/8) + RX_BURST_ADDR_INC;

localparam RFIFO_DEPTH = R_BUFDEPTH*R_DATAWIDTH/AXI_DATA_WIDTH;//R_BUFDEPTH/(AXI_DATA_WIDTH/R_DATAWIDTH);
localparam R_WR_DATA_COUNT_WIDTH = clog2(RFIFO_DEPTH)+1;
localparam R_RD_DATA_COUNT_WIDTH = clog2(R_BUFDEPTH)+1;

assign                                  fdma_rready = 1'b1;
reg                                     fdma_rareq_r= 1'b0;
reg                                     R_FIFO_Rst=0; 
wire                                    R_FS;
reg [1 :0]                              R_MS=0; 
reg [R_DSIZEBITS-1'b1:0]                R_addr=0; 
reg [15:0]                              R_bcnt=0; 
wire[R_WR_DATA_COUNT_WIDTH-1'b1 :0]     R_wcnt;
reg                                     R_REQ=0; 
reg [5 :0]                              rirq_dly_cnt =0;
reg [3 :0]                              rdiv_cnt =0;
reg [7 :0]                              rrst_cnt =0;
reg [7 :0]                              fmda_rbufn;
assign fdma_rsize = FDMA_RX_BURST;
assign fdma_rirq = (rirq_dly_cnt>0);

assign fdma_raddr = R_BASEADDR + {fmda_rbufn,R_addr};

reg [1:0] R_MS_r =0;
always @(posedge ui_clk) R_MS_r <= R_MS;

always @(posedge ui_clk) begin
    if(ui_rstn == 1'b0)begin
        rirq_dly_cnt <= 6'd0;
        fmda_rbuf <=0;
    end
    else if((R_MS_r == S_DATA2) && (R_MS == S_IDLE))begin
        rirq_dly_cnt <= 60;
        fmda_rbuf <= fmda_rbufn;
    end
    else if(rirq_dly_cnt >0)
        rirq_dly_cnt <= rirq_dly_cnt - 1'b1;
end

fs_cap #
(
.VIDEO_ENABLE(VIDEO_ENABLE)
)
fs_cap_R0
(
  .clk_i(ui_clk),
  .rstn_i(ui_rstn),
  .vs_i(R_FS_i),
  .fs_cap_o(R_FS)
);

assign fdma_rareq = fdma_rareq_r;

 always @(posedge ui_clk) begin
   if(!ui_rstn)begin
        R_MS          <= S_IDLE;
        R_FIFO_Rst   <= 0;
        R_addr       <= 0;
        R_sync_cnt_o <= 0;
        R_bcnt       <= 0;
        rrst_cnt     <= 0;
        rdiv_cnt      <= 0;
        fmda_rbufn    <= 0;
        fdma_rareq_r  <= 1'd0;
    end   
    else begin
      case(R_MS)
        S_IDLE:begin
          R_addr <= 0;
          R_bcnt <= 0;
          rrst_cnt <= 0;
          rdiv_cnt <=0;
          if(R_FS) begin
            R_MS <= S_RST;
            if(R_sync_cnt_o < RYBUF_SIZE)
                R_sync_cnt_o <= R_sync_cnt_o + 1'b1; 
            else 
                R_sync_cnt_o <= 0;  
          end
       end
       S_RST:begin
           fmda_rbufn <= R_buf_i;
           rrst_cnt <= rrst_cnt + 1'b1;
           if((VIDEO_ENABLE == 1) && (rrst_cnt < 40))
                R_FIFO_Rst <= 1;
           else if((VIDEO_ENABLE == 1) && (rrst_cnt < 100))
                R_FIFO_Rst <= 0;
           else if(fdma_rirq == 1'b0) begin
                R_MS <= S_DATA1;
           end
       end
       S_DATA1:begin 
         if(fdma_rbusy == 1'b0 && R_REQ)begin
            fdma_rareq_r  <= 1'b1;  
         end
         else if(fdma_rbusy == 1'b1) begin
            fdma_rareq_r  <= 1'b0;
            R_MS    <= S_DATA2;
         end         
        end
        S_DATA2:begin 
            if(fdma_rbusy == 1'b0)begin
                if(R_bcnt == RY_BURST_TIMES - 1'b1)
                    R_MS <= S_IDLE;
                else begin
                    if(rdiv_cnt < R_XDIV - 1'b1)begin
                        R_addr <= R_addr +  RX_BURST_ADDR_INC;  
                        rdiv_cnt <= rdiv_cnt + 1'b1;
                     end
                    else begin
                        R_addr <= R_addr + RX_LAST_ADDR_INC;
                        rdiv_cnt <= 0;
                    end
                    R_bcnt <= R_bcnt + 1'b1;
                    R_MS    <= S_DATA1;
                end 
            end
         end
         default:R_MS <= S_IDLE;
      endcase
   end
end 

wire R_wbusy;
always@(posedge ui_clk)      
     R_REQ  <= (R_wcnt < FDMA_RX_BURST - 2)&&(~R_wbusy);


xpm_fifo_async # (
  .FIFO_MEMORY_TYPE          ("auto"),           //string; "auto", "block", or "distributed";
  .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
  .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
  .FIFO_WRITE_DEPTH          (RFIFO_DEPTH),     //positive integer
  .WRITE_DATA_WIDTH          (AXI_DATA_WIDTH),               //positive integer
  .WR_DATA_COUNT_WIDTH       (R_WR_DATA_COUNT_WIDTH),               //positive integer
  .PROG_FULL_THRESH          (20),               //positive integer
  .FULL_RESET_VALUE          (0),                //positive integer; 0 or 1
  .USE_ADV_FEATURES          ("0707"),           //string; "0000" to "1F1F"; 
  .READ_MODE                 ("fwft"),            //string; "std" or "fwft";
  .FIFO_READ_LATENCY         (0),                //positive integer;
  .READ_DATA_WIDTH           (R_DATAWIDTH),               //positive integer
  .RD_DATA_COUNT_WIDTH       (R_RD_DATA_COUNT_WIDTH),               //positive integer
  .PROG_EMPTY_THRESH         (10),               //positive integer
  .DOUT_RESET_VALUE          ("0"),              //string
  .CDC_SYNC_STAGES           (2),                //positive integer
  .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;
) xpm_fifo_R_inst (
      .rst              ((ui_rstn == 1'b0) || (R_FIFO_Rst == 1'b1)),
      .wr_clk           (ui_clk),
      .wr_en            (fdma_rvalid),
      .din              (fdma_rdata),
      .full             (),
      .overflow         (),
      .prog_full        (),
      .wr_data_count    (R_wcnt),
      .almost_full      (),
      .wr_ack           (),
      .wr_rst_busy      (R_wbusy),
      .rd_clk           (R_rclk_i),
      .rd_en            (R_rden_i),
      .dout             (R_data_o),
      .empty            (R_empty),
      .underflow        (),
      .rd_rst_busy      (),
      .prog_empty       (),
      .rd_data_count    (),
      .almost_empty     (),
      .data_valid       (),
      .sleep            (1'b0),
      .injectsbiterr    (1'b0),
      .injectdbiterr    (1'b0),
      .sbiterr          (),
      .dbiterr          ()

);
end
else begin : FDMA_READ_DISABLE
   
assign fdma_raddr = 0;
assign fdma_rareq = 0;
assign fdma_rsize = 0;                                   	
assign fdma_rdata = 0;
assign fdma_rready = 0;
assign fdma_rirq = 0;	
assign R_empty = 1'b0;
assign R_data_o =0;
end
endgenerate

endmodule

