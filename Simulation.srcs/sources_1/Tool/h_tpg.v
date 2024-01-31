`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
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


module h_tpg#
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
input           	i_tpg_rstn,
input				i_tpg_clk,
output		reg		o_tpg_vs,
output       reg   	o_tpg_hs,
output       reg   	o_tpg_de,
output [23:0]		o_tpg_data
);
localparam H_Active_Start=H_FrameSize-H_ActiveSize;
localparam H_Active_End=H_FrameSize;

localparam V_Active_Start=V_FrameSize-V_ActiveSize;
localparam V_Active_End=V_FrameSize;

reg [11:0] hcnt = 12'd0;    
reg [11:0] vcnt = 12'd0;       
reg [2 :0] rst_cnt = 3'd0;
wire rst_sync = rst_cnt[2];

always @(posedge i_tpg_clk)begin
    if(!i_tpg_rstn)
        rst_cnt <= 3'd0;
    else if(rst_cnt[2] == 1'b0)
        rst_cnt <= rst_cnt + 1'b1;
end


always @(posedge i_tpg_clk)begin
    if(rst_sync == 1'b0)
        hcnt <= 12'd0;
    else if(hcnt < (H_FrameSize - 1'b1))
        hcnt <= hcnt + 1'b1;
    else 
        hcnt <= 12'd0;
end

always @(posedge i_tpg_clk)begin
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



always @(posedge i_tpg_clk)begin
	if(rst_sync == 1'b0)begin
		o_tpg_vs <= 1'b0;
		o_tpg_hs <= 1'b0;
		o_tpg_de <= 1'b0;
	end
	else begin
		o_tpg_vs <= vtc_vs;
		o_tpg_hs <= vtc_hs;
		o_tpg_de <= vtc_de;	
	end
end

/****************************************************************/
reg[8:0] fcnt = 9'd0;
reg tpg_vs_r = 1'b0;
reg tpg_hs_r = 1'b0;

always @(posedge i_tpg_clk)begin
    tpg_vs_r <= o_tpg_vs;
    tpg_hs_r <= o_tpg_hs;
end

reg [11:0]v_cnt = 12'd0;
reg [11:0]h_cnt = 12'd0;
always @(posedge i_tpg_clk)
  if(o_tpg_vs) 
	v_cnt <= 12'd0; 
  else if((!tpg_hs_r)&&o_tpg_hs) 
	v_cnt <= v_cnt + 1'b1; 
	
always @(posedge i_tpg_clk)
  if(o_tpg_de)
	h_cnt <= h_cnt + 1'b1; 
  else 
    h_cnt <= 12'd0; 
      
reg [7:0] grid_data = 8'd0;
always @(posedge i_tpg_clk) begin
	if((v_cnt[4]==1'b1) ^ (h_cnt[4]==1'b1))
	   grid_data <= 8'h00;
	else
	   grid_data <= 8'hff;
end

reg[23:0]color_bar = 24'd0;
always @(posedge i_tpg_clk)
begin
	if(h_cnt==336)
	color_bar	<=	24'hff0000;
	else if(h_cnt==496)
	color_bar	<=	24'h00ff00;
	else if(h_cnt==656)
	color_bar	<=	24'h0000ff;
	else if(h_cnt==816)
	color_bar	<=	24'hff00ff;
	else if(h_cnt==976)
	color_bar	<=	24'hffff00;
	else if(h_cnt==1136)
	color_bar	<=	24'h00ffff;
	else if(h_cnt==1296)
	color_bar	<=	24'hffffff;
	else if(h_cnt==1432)
	color_bar	<=	24'h000000;
	else
	color_bar	<=	color_bar;
end

reg[9:0]dis_mode = 10'd0;
always @(posedge i_tpg_clk)
    if(!i_tpg_rstn)begin
        dis_mode <= 0;
    end
    else begin
    if((!tpg_vs_r)&&o_tpg_vs) dis_mode <= dis_mode + 1'b1;
    end

reg[7:0]  r_reg = 8'd0;
reg[7:0]  g_reg = 8'd0;
reg[7:0]  b_reg = 8'd0;

always @(posedge i_tpg_clk)begin
    if(!i_tpg_rstn)begin
       	    r_reg <= 0; 
			b_reg <= 0;
			g_reg <= 0; 
    end
    else begin
        case(dis_mode[9:6])
        4'd0:begin
			r_reg <= 0; 
			b_reg <= 0;
			g_reg <= 0;
		end
        4'd1:begin
			r_reg <= 8'b11111111;
            g_reg <= 8'b11111111;
            b_reg <= 8'b11111111;
		end
        4'd2:begin
			r_reg <= 8'b11111111;
            g_reg <= 0;
            b_reg <= 0;  
		end			  
        4'd4:begin
			r_reg <= 0;
            g_reg <= 8'b11111111;
            b_reg <= 0; 
		end				  
        4'd6:begin     
			r_reg <= 0;
            g_reg <= 0;
            b_reg <= 8'b11111111;
		end
        4'd7:begin     
			r_reg <= grid_data;
            g_reg <= grid_data;
            b_reg <= grid_data;
		end					  
        4'd9:begin    
			r_reg <= h_cnt[7:0];
            g_reg <= h_cnt[7:0];
            b_reg <= h_cnt[7:0];
		end
        4'd10:begin     
			r_reg <= v_cnt[7:0];
            g_reg <= v_cnt[7:0];
            b_reg <= v_cnt[7:0];
		end
        4'd12:begin     
			r_reg <= v_cnt[7:0];
            g_reg <= 0;
            b_reg <= 0;
		end
        4'd13:begin     
			r_reg <= 0;
            g_reg <= h_cnt[7:0];
            b_reg <= 0;
		end
        4'd14:begin     
			r_reg <= 0;
            g_reg <= 0;
            b_reg <= h_cnt[7:0];
		end
        4'd15:begin     
			r_reg <= color_bar[23:16];
            g_reg <= color_bar[15:8];
            b_reg <= color_bar[7:0];
		end	
		default:begin
		    r_reg <= r_reg; 
			b_reg <= b_reg;
			g_reg <= g_reg;
		end
        endcase
     end
end

assign o_tpg_data = {r_reg,g_reg,b_reg};



endmodule
