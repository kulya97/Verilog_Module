`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
/*
Company : Liyang Milian Electronic Technology Co., Ltd.
Brand: ������(milianke)
Technical forum:uisrc.com
taobao: milianke.taobao.com  osrc.taobao.com
jd:milianke.jd.com
Create Date: 2021/01/27
Module Name: uitpg
Description: 
Copyright: Copyright (c) milianke
Revision: 1.0
Signal description:
1) _i input
2) _o output
3) _n activ low
4) _dg debug signal 
5) _r delay or register
6) _s state mechine
*/
////////////////////////////////////////////////////////////////////////////////

module uivideo2axism
#(
   parameter W_FIFODEPTH =2048
)
( 
	input	             vid_clk_i,
	input	             vid_rstn_i,
	input                vid_vs_i,
	input                vid_he_i,
	input                vid_de_i,
	input      [23:0]    vid_data_i,
	input      [7:0]     vid_alpha,
	
	// AXI4-Stream signals
	input                m_axis_vid_aclk,     
	output               m_axis_vid_tuser,//frame start  
	output [31:0]        m_axis_vid_tdata,  
	output [3:0]         m_axis_vid_tkeep,   
	output               m_axis_vid_tvalid,   
	input                m_axis_vid_tready,   
	output               m_axis_vid_tlast //line end 

    );

function integer clog2;
  input integer value;
  begin 
    value = value-1;
    for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
    end 
endfunction

localparam W_WR_DATA_COUNT_WIDTH = clog2(W_FIFODEPTH)+1;

assign           m_axis_vid_tkeep = 4'b1111;
wire            s_axis_tvalid;
wire[23:0]      s_axis_tdata;
//reset delay
reg [10:0] rst_cnt;
wire sys_rst = (rst_cnt[10]==1'b0);
always@(posedge vid_clk_i) begin
    if(vid_rstn_i == 1'b0)
        rst_cnt <= 11'd0;
    else if(rst_cnt[10]==0)
       rst_cnt <= rst_cnt + 1'b1;
end

reg [10:0]fifo_rdy_cnt =0;
wire fifo_rdy = (fifo_rdy_cnt[10] == 1'b1);
always@(posedge vid_clk_i) begin
    if(sys_rst == 1'b1)
        fifo_rdy_cnt <= 11'd0;
    else if(fifo_rdy_cnt[10] == 1'b0)
        fifo_rdy_cnt <= fifo_rdy_cnt + 1'b1;
end

reg vid_vs_r1 = 1'b0,vid_vs_r2 = 1'b0;
reg vid_de_r1 = 1'b0,vid_de_r2 = 1'b0;
reg vid_he_r1 = 1'b0;
reg [23:0] vid_data_r1 = 24'd0;
reg [23:0] vid_data_r2 = 24'd0;

always@(posedge vid_clk_i)begin
        vid_vs_r1    <= vid_vs_i;
        vid_vs_r2    <= vid_vs_r1;
        vid_he_r1    <= vid_he_i;
        vid_de_r1    <= vid_de_i;
        vid_de_r2    <= vid_de_r1;
        vid_data_r1  <= vid_data_i;  
        vid_data_r2  <= vid_data_r1;  
end

reg s_axis_tuser = 1'b0;
always@(posedge vid_clk_i) begin
   if(vid_vs_r2 == 1'b0 && vid_vs_r1 == 1'b1)
		s_axis_tuser <= 1'b1;
	else if(s_axis_tuser == 1'b1 && s_axis_tvalid == 1'b1)
		s_axis_tuser <= 1'b0;
end

reg s_axis_tlast = 1'b0;
always@(posedge vid_clk_i) begin
	s_axis_tlast <= (vid_he_r1==1'b1 & vid_he_i==1'b0);
end

wire empty, full;
wire      [23:0]m_axis_vid_tdata1;
wire            s_axis_tready     =  ~full;
assign           s_axis_tvalid     =   vid_de_r2 & s_axis_tready;
assign           s_axis_tdata      =   vid_data_r2;
assign           m_axis_vid_tdata  =   {vid_alpha,m_axis_vid_tdata1};
assign           m_axis_vid_tvalid = ~empty & m_axis_vid_tready;

wire m_axis_vid_tlast1,m_axis_vid_tuser1 ;
reg  m_axis_vid_tlast_r = 1'b0;
reg  m_axis_vid_tuser_r = 1'b0;
always@(posedge m_axis_vid_aclk) begin
    m_axis_vid_tlast_r <= m_axis_vid_tlast1;
    m_axis_vid_tuser_r <= m_axis_vid_tuser1;
end

assign m_axis_vid_tlast = (m_axis_vid_tlast_r == 1'b0) & (m_axis_vid_tlast1 == 1'b1);
assign m_axis_vid_tuser = (m_axis_vid_tuser_r == 1'b0) & (m_axis_vid_tuser1 == 1'b1);

xpm_fifo_async # (

  .FIFO_MEMORY_TYPE          ("auto"),           //string; "auto", "block", or "distributed";
  .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
  .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
  .FIFO_WRITE_DEPTH          (W_FIFODEPTH),      //positive integer
  .WRITE_DATA_WIDTH          (26),               //positive integer
  .WR_DATA_COUNT_WIDTH       (W_WR_DATA_COUNT_WIDTH),               //positive integer
  .PROG_FULL_THRESH          (10),               //positive integer
  .FULL_RESET_VALUE          (0),                //positive integer; 0 or 1
  .USE_ADV_FEATURES          ("0707"),           //string; "0000" to "1F1F"; 
  .READ_MODE                 ("fwft"),            //string; "std" or "fwft";
  .FIFO_READ_LATENCY         (0),                //positive integer;
  .READ_DATA_WIDTH           (26),               //positive integer
  .RD_DATA_COUNT_WIDTH       (W_WR_DATA_COUNT_WIDTH),               //positive integer
  .PROG_EMPTY_THRESH         (10),               //positive integer
  .DOUT_RESET_VALUE          ("0"),              //string
  .CDC_SYNC_STAGES           (2),                //positive integer
  .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;

) xpm_fifo_async_inst (

      .rst              (sys_rst),
      .wr_clk           (vid_clk_i),
      .wr_en            (s_axis_tvalid & fifo_rdy),
      .din              ({s_axis_tdata,s_axis_tuser,s_axis_tlast}),
      .full             (full),
      .overflow         (),
      .prog_full        (),
      .wr_data_count    (),
      .almost_full      (),
      .wr_ack           (),
      .wr_rst_busy      (),
      .rd_clk           (m_axis_vid_aclk),
      .rd_en            (m_axis_vid_tvalid),
      .dout             ({m_axis_vid_tdata1,m_axis_vid_tuser1,m_axis_vid_tlast1}),
      .empty            (empty),
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
endmodule
