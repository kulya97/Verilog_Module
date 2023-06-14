
/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*WebSite:https://www.milianke.com
*TechWeb:https://www.uisrc.com
*tmall-shop:https://milianke.tmall.com
*jd-shop:https://milianke.jd.com
*taobao-shop1: https://milianke.taobao.com
*Create Date: 2019/12/17
*Module Name:
*File Name:
*Description: 
*The reference demo provided by Milianke is only used for learning. 
*We cannot ensure that the demo itself is free of bugs, so users 
*should be responsible for the technical problems and consequences
*caused by the use of their own products.
*Copyright: Copyright (c) MiLianKe
*All rights reserved.
*Revision: 1.1
*Signal description
*1) _i input
*2) _o output
*3) _n activ low
*4) _dg debug signal 
*5) _r delay or register
*6) _s state mechine
*********************************************************************/
`timescale 1ns / 1ns

module uivtc#
(
parameter H_ActiveSize  =   1980, 
parameter H_FrameSize   =   1920+88+44+148, 
parameter H_SyncStart   =   1920+88, 
parameter H_SyncEnd     =   1920+88+44, 

parameter V_ActiveSize  =   1080, 
parameter V_FrameSize   =   1080+4+5+36, 
parameter V_SyncStart   =   1080+4, 
parameter V_SyncEnd     =   1080+4+5
)
(
input           vtc_rstn_i,
input			vtc_clk_i,
output	reg		vtc_vs_o,
output  reg     vtc_hs_o,
output  reg     vtc_de_o	
);

reg [11:0] hcnt = 12'd0;    
reg [11:0] vcnt = 12'd0;       
reg [2 :0] rst_cnt = 3'd0;
wire rst_sync = rst_cnt[2];

always @(posedge vtc_clk_i)begin
    if(!vtc_rstn_i)
        rst_cnt <= 3'd0;
    else if(rst_cnt[2] == 1'b0)
        rst_cnt <= rst_cnt + 1'b1;
end    


always @(posedge vtc_clk_i)begin
    if(rst_sync == 1'b0)
        hcnt <= 12'd0;
    else if(hcnt < (H_FrameSize - 1'b1))
        hcnt <= hcnt + 1'b1;
    else 
        hcnt <= 12'd0;
end         

always @(posedge vtc_clk_i)begin
    if(rst_sync == 1'b0)
        vcnt <= 12'd0;
    else if(hcnt == (H_ActiveSize  - 1'b1)) begin
           vcnt <= (vcnt == (V_FrameSize - 1'b1)) ? 12'd0 : vcnt + 1'b1;
    end
end 

wire hs_valid  =  hcnt < H_ActiveSize;
wire vs_valid  =  vcnt < V_ActiveSize;
wire vtc_hs   =  (hcnt >= H_SyncStart && hcnt < H_SyncEnd);
wire vtc_vs	   = (vcnt > V_SyncStart && vcnt <= V_SyncEnd);      
wire vtc_de   =  hs_valid && vs_valid;

always @(posedge vtc_clk_i)begin
	if(rst_sync == 1'b0)begin
		vtc_vs_o <= 1'b0;
		vtc_hs_o <= 1'b0;
		vtc_de_o <= 1'b0;
	end
	else begin
		vtc_vs_o <= vtc_vs;
		vtc_hs_o <= vtc_hs;
		vtc_de_o <= vtc_de;	
	end
end

endmodule


