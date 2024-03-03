
`timescale 1ns / 1ns
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
module uiFDMA#
(
parameter  integer         M_AXI_ID_WIDTH			    = 3		,
parameter  integer         M_AXI_ID			        = 0		    ,
parameter  integer         M_AXI_ADDR_WIDTH			= 32		,
parameter  integer         M_AXI_DATA_WIDTH			= 128		,	
parameter  integer		  M_AXI_MAX_BURST_LEN       = 64
)
(
input   wire [M_AXI_ADDR_WIDTH-1 : 0]      fdma_waddr          ,
input                                       fdma_wareq          ,
input   wire [15 : 0]                      fdma_wsize          ,                                     
output                                      fdma_wbusy          ,
				
input   wire [M_AXI_DATA_WIDTH-1 :0]       fdma_wdata			,
output  wire                               fdma_wvalid         ,
input	wire                               fdma_wready			,

input   wire [M_AXI_ADDR_WIDTH-1 : 0]      fdma_raddr          ,
input                                       fdma_rareq          ,
input   wire [15 : 0]                      fdma_rsize          ,                                     
output                                      fdma_rbusy          ,
				
output  wire [M_AXI_DATA_WIDTH-1 :0]       fdma_rdata			,
output  wire                               fdma_rvalid         ,
input	wire                               fdma_rready			,
		
input 	wire  								M_AXI_ACLK			,
input 	wire  								M_AXI_ARESETN		,
output 	wire [M_AXI_ID_WIDTH-1 : 0]		    M_AXI_AWID			,
output 	wire [M_AXI_ADDR_WIDTH-1 : 0] 	    M_AXI_AWADDR		,
output 	wire [7 : 0]						M_AXI_AWLEN			,
output 	wire [2 : 0] 						M_AXI_AWSIZE		,
output 	wire [1 : 0] 						M_AXI_AWBURST		,
output 	wire  								M_AXI_AWLOCK		,
output 	wire [3 : 0] 						M_AXI_AWCACHE		,
output 	wire [2 : 0] 						M_AXI_AWPROT		,  
output 	wire [3 : 0] 						M_AXI_AWQOS			,
output 	wire  								M_AXI_AWVALID		,
input	wire  								M_AXI_AWREADY		,
output  wire [M_AXI_ID_WIDTH-1 : 0] 		M_AXI_WID			,
output  wire [M_AXI_DATA_WIDTH-1 : 0] 	    M_AXI_WDATA			,
output  wire [M_AXI_DATA_WIDTH/8-1 : 0] 	M_AXI_WSTRB			,
output  wire  								M_AXI_WLAST			, 			
output  wire  								M_AXI_WVALID		,
input   wire  								M_AXI_WREADY		,
input   wire [M_AXI_ID_WIDTH-1 : 0] 		M_AXI_BID			,
input   wire [1 : 0] 						M_AXI_BRESP			,
input   wire  								M_AXI_BVALID		,
output  wire  								M_AXI_BREADY		, 
output  wire [M_AXI_ID_WIDTH-1 : 0] 		M_AXI_ARID			,	 

output  wire [M_AXI_ADDR_WIDTH-1 : 0] 	    M_AXI_ARADDR		,	 	
output  wire [7 : 0] 						M_AXI_ARLEN			,	 
output  wire [2 : 0] 						M_AXI_ARSIZE		,	 
output  wire [1 : 0] 						M_AXI_ARBURST		,	 
output  wire  								M_AXI_ARLOCK		,	 
output  wire [3 : 0] 						M_AXI_ARCACHE		,	 
output  wire [2 : 0] 						M_AXI_ARPROT		,	 
output  wire [3 : 0] 						M_AXI_ARQOS			,	 	   
output  wire  								M_AXI_ARVALID		,	 
input   wire  								M_AXI_ARREADY		,	 
input   wire [M_AXI_ID_WIDTH-1 : 0] 		M_AXI_RID			,	 
input   wire [M_AXI_DATA_WIDTH-1 : 0] 	    M_AXI_RDATA			,	 
input   wire [1 : 0] 						M_AXI_RRESP			,	 
input   wire  								M_AXI_RLAST			,	 
input   wire  								M_AXI_RVALID		,    
output  wire  								M_AXI_RREADY				
	);

function integer clogb2 (input integer bit_depth);              
begin                                                           
	 for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	 bit_depth = bit_depth >> 1;                                 
end                                                           
endfunction 

localparam AXI_BYTES =  M_AXI_DATA_WIDTH/8;
localparam [3:0] MAX_BURST_LEN_SIZE = clogb2(M_AXI_MAX_BURST_LEN -1);         
                                                    
//fdma axi write----------------------------------------------
reg 	[M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr	=0;
reg  						 		axi_awvalid	= 1'b0;
wire 	[M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata	;
wire								axi_wlast	;
reg  								axi_wvalid	= 1'b0;
wire                               w_next      = (M_AXI_WVALID & M_AXI_WREADY);
reg   [8 :0]                       wburst_len  = 1  ; 
reg   [8 :0]                       wburst_cnt  = 0  ; 
reg   [15:0]                       wfdma_cnt   = 0  ;
reg                                axi_wstart_locked  =0;  
wire  [15:0] axi_wburst_size   =   wburst_len * AXI_BYTES;	

assign M_AXI_WID        = 0;
assign M_AXI_AWID		= M_AXI_ID;
assign M_AXI_AWADDR		= axi_awaddr;
assign M_AXI_AWLEN		= wburst_len - 1;
assign M_AXI_AWSIZE		= clogb2(AXI_BYTES-1);
assign M_AXI_AWBURST	= 2'b01;
assign M_AXI_AWLOCK		= 1'b0;
assign M_AXI_AWCACHE	= 4'b0010;
assign M_AXI_AWPROT		= 3'h0;
assign M_AXI_AWQOS		= 4'h0;
assign M_AXI_AWVALID	= axi_awvalid;
assign M_AXI_WDATA		= axi_wdata;
assign M_AXI_WSTRB		= {(AXI_BYTES){1'b1}};
assign M_AXI_WLAST		= axi_wlast;
assign M_AXI_WVALID		= axi_wvalid & fdma_wready;
assign M_AXI_BREADY		= 1'b1;


//----------------------------------------------------------------------------	
//AXI4 FULL Write
assign  axi_wdata        = fdma_wdata;
assign  fdma_wvalid      = w_next;
reg     fdma_wstart_locked = 1'b0;
wire    fdma_wend;
wire    fdma_wstart;
assign   fdma_wbusy = fdma_wstart_locked ;

always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0 || fdma_wend == 1'b1 )
		fdma_wstart_locked <= 1'b0;
	else if(fdma_wstart)
		fdma_wstart_locked <= 1'b1; 		                       
		
assign fdma_wstart = (fdma_wstart_locked == 1'b0 && fdma_wareq == 1'b1);			
//AXI4 write burst lenth busrt addr ------------------------------
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)begin
		axi_awaddr <= 0;
	end
    else if(fdma_wstart)    
        axi_awaddr <= fdma_waddr;
    else if(axi_wlast == 1'b1)
        axi_awaddr <= axi_awaddr + axi_wburst_size ;  	              	
//AXI4 write cycle -----------------------------------------------
reg axi_wstart_locked_r1 = 1'b0, axi_wstart_locked_r2 = 1'b0;
always @(posedge M_AXI_ACLK)begin
	if(M_AXI_ARESETN == 1'b0)begin
		axi_wstart_locked_r1 <= 1'b0;
		axi_wstart_locked_r2 <= 1'b0;
	end
	else begin
		axi_wstart_locked_r1 <= axi_wstart_locked;
		axi_wstart_locked_r2 <= axi_wstart_locked_r1;
	end
end

always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)begin
		axi_wstart_locked <= 1'b0;
	end
	else if((fdma_wstart_locked == 1'b1) &&  axi_wstart_locked == 1'b0)
	    axi_wstart_locked <= 1'b1; 
	else if(axi_wlast == 1'b1 || fdma_wstart == 1'b1)
	    axi_wstart_locked <= 1'b0;
	    
//AXI4 addr valid and write addr-----------------------------------	
always @(posedge M_AXI_ACLK)
	 if(M_AXI_ARESETN == 1'b0)begin
		 axi_awvalid <= 1'b0;
     end
     else if((axi_wstart_locked_r1 == 1'b1) &&  axi_wstart_locked_r2 == 1'b0)
         axi_awvalid <= 1'b1;
     else if((axi_wstart_locked == 1'b1 && M_AXI_AWREADY == 1'b1)|| axi_wstart_locked == 1'b0)
         axi_awvalid <= 1'b0; 		
//AXI4 write data---------------------------------------------------		
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)begin
		 axi_wvalid <= 1'b0;
    end
	else if((axi_wstart_locked_r1 == 1'b1) &&  axi_wstart_locked_r2 == 1'b0)
		axi_wvalid <= 1'b1;
	else if(axi_wlast == 1'b1 || axi_wstart_locked == 1'b0)
		axi_wvalid <= 1'b0;//	
//AXI4 write data burst len counter----------------------------------
always @(posedge M_AXI_ACLK)
	if(axi_wstart_locked == 1'b0)
		wburst_cnt <= 0;
	else if(w_next)
		wburst_cnt <= wburst_cnt + 1'b1;    
		   	
assign axi_wlast = (w_next == 1'b1) && (wburst_cnt == M_AXI_AWLEN);
//fdma write data burst len counter----------------------------------
reg wburst_len_req = 1'b0;
reg [15:0] fdma_wleft_cnt =16'd0;

always @(posedge M_AXI_ACLK)
        wburst_len_req <= fdma_wstart|axi_wlast;
         
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)begin
		wfdma_cnt <= 0;
		fdma_wleft_cnt <= 0;
	end
	else if( fdma_wstart )begin
		wfdma_cnt <= 0;
		fdma_wleft_cnt <= fdma_wsize;
	end
	else if(w_next)begin
		wfdma_cnt <= wfdma_cnt + 1'b1;	
	    fdma_wleft_cnt <= (fdma_wsize - 1'b1) - wfdma_cnt;
    end

assign  fdma_wend = w_next && (fdma_wleft_cnt == 1 );

always @(posedge M_AXI_ACLK)begin
	if(M_AXI_ARESETN == 1'b0)begin
		wburst_len <= 1;
	end
    else if(wburst_len_req)begin
        if(fdma_wleft_cnt[15:MAX_BURST_LEN_SIZE] >0)  
			wburst_len <= M_AXI_MAX_BURST_LEN;
        else 
            wburst_len <= fdma_wleft_cnt[MAX_BURST_LEN_SIZE-1:0];
    end
    else wburst_len <= wburst_len;
end

//fdma axi read----------------------------------------------
reg 	[M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr =0	;
reg  						 		axi_arvalid	 =1'b0;
wire								axi_rlast	;
reg  								axi_rready	= 1'b0;
wire                               r_next      = (M_AXI_RVALID && M_AXI_RREADY);
reg   [8 :0]                       rburst_len  = 1  ; 
reg   [8 :0]                       rburst_cnt  = 0  ; 
reg   [15:0]                       rfdma_cnt   = 0  ;
reg                                axi_rstart_locked =0; 
wire  [15:0] axi_rburst_size   =   rburst_len * AXI_BYTES;	

assign M_AXI_ARID		= M_AXI_ID;
assign M_AXI_ARADDR		= axi_araddr;
assign M_AXI_ARLEN		= rburst_len - 1;
assign M_AXI_ARSIZE		= clogb2((AXI_BYTES)-1);
assign M_AXI_ARBURST	= 2'b01;
assign M_AXI_ARLOCK		= 1'b0;
assign M_AXI_ARCACHE	= 4'b0010;
assign M_AXI_ARPROT		= 3'h0;
assign M_AXI_ARQOS		= 4'h0;
assign M_AXI_ARVALID	= axi_arvalid;
assign M_AXI_RREADY		= axi_rready&&fdma_rready;
assign fdma_rdata       = M_AXI_RDATA;    
assign fdma_rvalid      = r_next;    

//AXI4 FULL Read----------------------------------------- 	

reg     fdma_rstart_locked = 1'b0;
wire    fdma_rend;
wire    fdma_rstart;
assign   fdma_rbusy = fdma_rstart_locked ;

always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0 || fdma_rend == 1'b1)
		fdma_rstart_locked <= 1'b0;
	else if(fdma_rstart)
		fdma_rstart_locked <= 1'b1; 		                       

assign fdma_rstart = (fdma_rstart_locked == 1'b0 && fdma_rareq == 1'b1);	
//AXI4 read burst lenth busrt addr ------------------------------
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)
		axi_araddr <= 0;
    else if(fdma_rstart == 1'b1)    
        axi_araddr <= fdma_raddr;
    else if(axi_rlast == 1'b1)
        axi_araddr <= axi_araddr + axi_rburst_size ;      									        
//AXI4 r_cycle_flag------------------------------------- 	
reg axi_rstart_locked_r1 = 1'b0, axi_rstart_locked_r2 = 1'b0;
always @(posedge M_AXI_ACLK)begin
	if(M_AXI_ARESETN == 1'b0)begin
		axi_rstart_locked_r1 <= 1'b0;
		axi_rstart_locked_r2 <= 1'b0;
	end 
	else begin
		axi_rstart_locked_r1 <= axi_rstart_locked;
		axi_rstart_locked_r2 <= axi_rstart_locked_r1;
	end
end
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)
		axi_rstart_locked <= 1'b0;
	else if((fdma_rstart_locked == 1'b1) &&  axi_rstart_locked == 1'b0)
	    axi_rstart_locked <= 1'b1; 
	else if(axi_rlast == 1'b1 || fdma_rstart == 1'b1)
	    axi_rstart_locked <= 1'b0;
	    
//AXI4 addr valid and read addr-----------------------------------	
always @(posedge M_AXI_ACLK)
	 if(M_AXI_ARESETN == 1'b0)
	     axi_arvalid <= 1'b0;
     else if((axi_rstart_locked_r1 == 1'b1) &&  axi_rstart_locked_r2 == 1'b0)
         axi_arvalid <= 1'b1;
     else if((axi_rstart_locked == 1'b1 && M_AXI_ARREADY == 1'b1)|| axi_rstart_locked == 1'b0)
         axi_arvalid <= 1'b0; 		
//AXI4 read data---------------------------------------------------		
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)
	     axi_rready <= 1'b0;
	else if((axi_rstart_locked_r1 == 1'b1) &&  axi_rstart_locked_r2 == 1'b0)
		axi_rready <= 1'b1;
	else if(axi_rlast == 1'b1 || axi_rstart_locked == 1'b0)
		axi_rready <= 1'b0;//	
		
//AXI4 read data burst len counter----------------------------------
always @(posedge M_AXI_ACLK)
	if(axi_rstart_locked == 1'b0)
		rburst_cnt <= 0;
	else if(r_next)
		rburst_cnt <= rburst_cnt + 1'b1;       		
assign axi_rlast = (r_next == 1'b1) && (rburst_cnt == M_AXI_ARLEN);
//fdma read data burst len counter----------------------------------
reg rburst_len_req = 1'b0;
reg [15:0] fdma_rleft_cnt =16'd0;
  
always @(posedge M_AXI_ACLK)
	    rburst_len_req <= fdma_rstart | axi_rlast;  
        
always @(posedge M_AXI_ACLK)
	if(M_AXI_ARESETN == 1'b0)begin
		rfdma_cnt <= 0;
		fdma_rleft_cnt <=0;
	end
	else if(fdma_rstart )begin
		rfdma_cnt <= 0;
	    fdma_rleft_cnt <= fdma_rsize;
	end
	else if(r_next)begin
		rfdma_cnt <= rfdma_cnt + 1'b1;	
		fdma_rleft_cnt <= (fdma_rsize - 1'b1) - rfdma_cnt;
    end

assign  fdma_rend = r_next && (fdma_rleft_cnt == 1 );
//axi auto burst len caculate-----------------------------------------

always @(posedge M_AXI_ACLK)begin
	 if(M_AXI_ARESETN == 1'b0)begin
		rburst_len <= 1;
	 end
     else if(rburst_len_req)begin
        if(fdma_rleft_cnt[15:MAX_BURST_LEN_SIZE] >0)  
            rburst_len <= M_AXI_MAX_BURST_LEN;
        else 
            rburst_len <= fdma_rleft_cnt[MAX_BURST_LEN_SIZE-1:0];
     end
     else rburst_len <= rburst_len;
end
		

//dbg_wave dbg_wave_inst
//(
//    .trig_out_0(),
//    .data_in_0({rburst_len[7:0],rburst_cnt[8:0],fdma_rleft_cnt[15:0],fdma_rareq,fdma_rstart,fdma_rstart_locked,axi_rstart_locked,axi_rlast,rburst_len_req,M_AXI_ARVALID,M_AXI_ARREADY,M_AXI_RVALID,M_AXI_RREADY,M_AXI_RLAST,wburst_len[7:0],wburst_cnt[8:0],fdma_wleft_cnt[15:0],fdma_wareq,fdma_wstart,fdma_wstart_locked,axi_wstart_locked,axi_wlast,wburst_len_req,M_AXI_AWVALID,M_AXI_AWREADY,M_AXI_WVALID,M_AXI_WREADY,M_AXI_WLAST,M_AXI_ARESETN}),
//    .ref_clk_0(M_AXI_ACLK)
//);		
		
		              		   
endmodule


