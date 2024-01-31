`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/20 16:50:46
// Design Name: 
// Module Name: h_vtc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module h_vtc#
(
parameter H_ActiveSize  =   1980, 
parameter H_FrameSize   =   2500, 
parameter H_SyncStart   =   0, 
parameter H_SyncEnd     =   200, 

parameter V_ActiveSize  =   1080, 
parameter V_FrameSize   =   1300, 
parameter V_SyncStart   =   0, 
parameter V_SyncEnd     =   200
)
(
input           i_vtc_rstn,
input			i_vtc_clk,
output	reg		o_vtc_vs,
output  reg     o_vtc_hs,
output  reg     o_vtc_de	
);

localparam H_Active_Start=H_FrameSize-H_ActiveSize;
localparam H_Active_End=H_FrameSize;

localparam V_Active_Start=V_FrameSize-V_ActiveSize;
localparam V_Active_End=V_FrameSize;

reg [11:0] hcnt = 12'd0;    
reg [11:0] vcnt = 12'd0;       
reg [2 :0] rst_cnt = 3'd0;
wire rst_sync = rst_cnt[2];

always @(posedge i_vtc_clk)begin
    if(!i_vtc_rstn)
        rst_cnt <= 3'd0;
    else if(rst_cnt[2] == 1'b0)
        rst_cnt <= rst_cnt + 1'b1;
end


always @(posedge i_vtc_clk)begin
    if(rst_sync == 1'b0)
        hcnt <= 12'd0;
    else if(hcnt < (H_FrameSize - 1'b1))
        hcnt <= hcnt + 1'b1;
    else 
        hcnt <= 12'd0;
end

always @(posedge i_vtc_clk)begin
    if(rst_sync == 1'b0)
        vcnt <= 12'd0;
    else if(hcnt == (H_FrameSize  - 1'b1)) begin
           vcnt <= (vcnt == (V_FrameSize - 1'b1)) ? 12'd0 : vcnt + 1'b1;
    end
end 

wire hs_valid  =  hcnt >= H_Active_Start;
wire vs_valid  =  vcnt >= V_Active_Start;
wire vtc_hs   =  (hcnt >= H_SyncStart && hcnt < H_SyncEnd);
wire vtc_vs	   = (vcnt >= V_SyncStart && vcnt < V_SyncEnd);      
wire vtc_de   =  hs_valid && vs_valid;



always @(posedge i_vtc_clk)begin
	if(rst_sync == 1'b0)begin
		o_vtc_vs <= 1'b0;
		o_vtc_hs <= 1'b0;
		o_vtc_de <= 1'b0;
	end
	else begin
		o_vtc_vs <= vtc_vs;
		o_vtc_hs <= vtc_hs;
		o_vtc_de <= vtc_de;	
	end
end

endmodule
