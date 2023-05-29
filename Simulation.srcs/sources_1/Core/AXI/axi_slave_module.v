module axi_slave_module#
	(
		parameter                                   C_S_AXI_ID_WIDTH	    = 1,
		parameter                                   C_S_AXI_DATA_WIDTH	    = 32,
		parameter                                   C_S_AXI_ADDR_WIDTH	    = 6,
		parameter                                   C_S_AXI_AWUSER_WIDTH	= 0,
		parameter                                   C_S_AXI_ARUSER_WIDTH	= 0,
		parameter                                   C_S_AXI_WUSER_WIDTH	    = 0,
		parameter                                   C_S_AXI_RUSER_WIDTH	    = 0,
		parameter                                   C_S_AXI_BUSER_WIDTH	    = 0
	)
	(
		input wire                                  S_AXI_ACLK      ,
		input wire                                  S_AXI_ARESETN   ,

		input wire [C_S_AXI_ID_WIDTH-1 : 0]         S_AXI_AWID      ,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0]       S_AXI_AWADDR    ,
		input wire [7 : 0]                          S_AXI_AWLEN     ,
		input wire [2 : 0]                          S_AXI_AWSIZE    ,
		input wire [1 : 0]                          S_AXI_AWBURST   ,
		input wire                                  S_AXI_AWLOCK    ,
		input wire [3 : 0]                          S_AXI_AWCACHE   ,
		input wire [2 : 0]                          S_AXI_AWPROT    ,
		input wire [3 : 0]                          S_AXI_AWQOS     ,
		input wire [3 : 0]                          S_AXI_AWREGION  ,
		input wire [C_S_AXI_AWUSER_WIDTH-1 : 0]     S_AXI_AWUSER    ,
		input wire                                  S_AXI_AWVALID   ,
		output wire                                 S_AXI_AWREADY   ,

		input wire [C_S_AXI_DATA_WIDTH-1 : 0]       S_AXI_WDATA     ,
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0]   S_AXI_WSTRB     ,
		input wire                                  S_AXI_WLAST     ,
		input wire [C_S_AXI_WUSER_WIDTH-1 : 0]      S_AXI_WUSER     ,
		input wire                                  S_AXI_WVALID    ,
		output wire                                 S_AXI_WREADY    ,

		output wire [C_S_AXI_ID_WIDTH-1 : 0]        S_AXI_BID       ,
		output wire [1 : 0]                         S_AXI_BRESP     ,
		output wire [C_S_AXI_BUSER_WIDTH-1 : 0]     S_AXI_BUSER     ,
		output wire                                 S_AXI_BVALID    ,
		input wire                                  S_AXI_BREADY    ,

		input wire [C_S_AXI_ID_WIDTH-1 : 0]         S_AXI_ARID      ,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0]       S_AXI_ARADDR    ,
		input wire [7 : 0]                          S_AXI_ARLEN     ,
		input wire [2 : 0]                          S_AXI_ARSIZE    ,
		input wire [1 : 0]                          S_AXI_ARBURST   ,
		input wire                                  S_AXI_ARLOCK    ,
		input wire [3 : 0]                          S_AXI_ARCACHE   ,
		input wire [2 : 0]                          S_AXI_ARPROT    ,
		input wire [3 : 0]                          S_AXI_ARQOS     ,
		input wire [3 : 0]                          S_AXI_ARREGION  ,
		input wire [C_S_AXI_ARUSER_WIDTH-1 : 0]     S_AXI_ARUSER    ,
		input wire                                  S_AXI_ARVALID   ,
		output wire                                 S_AXI_ARREADY   ,

		output wire [C_S_AXI_ID_WIDTH-1 : 0]        S_AXI_RID       ,
		output wire [C_S_AXI_DATA_WIDTH-1 : 0]      S_AXI_RDATA     ,
		output wire [1 : 0]                         S_AXI_RRESP     ,
		output wire                                 S_AXI_RLAST     ,
		output wire [C_S_AXI_RUSER_WIDTH-1 : 0]     S_AXI_RUSER     ,
		output wire                                 S_AXI_RVALID    ,
		input wire                                  S_AXI_RREADY    
);

/**********************参数***************************/

/**********************状态机*************************/

/**********************寄存器*************************/
reg [C_S_AXI_ADDR_WIDTH-1 : 0]  r_awaddr                                ;
reg [7 : 0]                     r_awlen                                 ;
reg                             r_awready                               ;
reg                             r_wready                                ;
reg                             r_arready                               ;
reg [C_S_AXI_ADDR_WIDTH-1 : 0]  r_araddr                                ;
reg [7 : 0]                     r_arlen                                 ;
reg [7 : 0]                     r_read_cnt                              ;
reg                             r_rvalid                                ;
reg                             r_rvalid_1b                             ;
reg                             r_rvalid_2b                             ;
reg                             r_bvalid                                ;

reg [C_S_AXI_DATA_WIDTH-1 : 0]  r_ram[0 : 255]                          ;
reg [7:0]                       r_ram_addr                              ;
reg [7:0]                       r_ram_addr_1b                           ;   
reg [C_S_AXI_DATA_WIDTH-1 : 0]  r_ram_write_data                        ;
reg [C_S_AXI_DATA_WIDTH-1 : 0]  r_ram_read_data                         ;
reg                             r_ram_rh_wl                             ;
reg                             r_ram_en                                ;

/**********************网表型*************************/ 
wire                w_aw_active                                         ;
wire                w_w_active                                          ;
wire                w_b_active                                          ;
wire                w_ar_active                                         ;
wire                w_r_active                                          ;
wire                w_rst                                               ;

/**********************组合逻辑***********************/
assign              w_aw_active     = S_AXI_AWVALID   & S_AXI_AWREADY   ;
assign              w_w_active      = S_AXI_WVALID    & S_AXI_WREADY    ;
assign              w_b_active      = S_AXI_BVALID    & S_AXI_BREADY    ;
assign              w_ar_active     = S_AXI_ARVALID   & S_AXI_ARREADY   ;
assign              w_r_active      = S_AXI_RVALID    & S_AXI_RREADY    ;
assign              S_AXI_AWREADY   = r_awready                         ;
assign              S_AXI_WREADY    = r_wready                          ;
assign              S_AXI_ARREADY   = r_arready                         ;
assign              w_rst           = ~S_AXI_ARESETN                    ;

assign              S_AXI_RID       = 'd0                               ;
assign              S_AXI_RDATA     = r_ram_read_data                   ;
assign              S_AXI_RRESP     = 'd0                               ;
assign              S_AXI_RLAST     = (r_read_cnt == r_arlen - 1) ? 
                                      w_r_active : 1'b0                 ; 
assign              S_AXI_RUSER     = 'd0                               ;
assign              S_AXI_RVALID    = r_rvalid_2b                       ;
assign              S_AXI_BID       = 'd0                               ;
assign              S_AXI_BRESP     = 'd0                               ;
assign              S_AXI_BUSER     = 'd0                               ;
assign              S_AXI_BVALID    = r_bvalid                          ;
/**********************例化***************************/

/**********************进程***************************/
//写地址
always@(posedge S_AXI_ACLK)
    if(w_aw_active)
        r_awaddr <= S_AXI_AWADDR;
    else 
        r_awaddr <= r_awaddr;

//写长度
always@(posedge S_AXI_ACLK)
    if(w_aw_active)
        r_awlen <= S_AXI_AWLEN;
    // else if()
    else 
        r_awlen <= r_awlen;

//写地址准备信号
always@(posedge S_AXI_ACLK)
    if(w_rst || S_AXI_WLAST)
        r_awready <= 'd1;
    else if(w_aw_active)   
        r_awready <= 'd0;
    else    
        r_awready <= r_awready;

//写数据准备信号
always@(posedge S_AXI_ACLK)
    if(w_aw_active)
        r_wready <= 'd1;
    else if(S_AXI_WLAST)
        r_wready <= 'd0;
    else 
        r_wready <= r_wready;

//ram核心写
always@(posedge S_AXI_ACLK)
    if(!r_ram_rh_wl) 
        r_ram[r_ram_addr_1b] <= r_ram_en ? r_ram_write_data : r_ram[r_ram_addr];
    else 
        r_ram[r_ram_addr_1b] <= r_ram[r_ram_addr_1b];

//ram核心读
always@(posedge S_AXI_ACLK)
    if(r_ram_rh_wl)
        r_ram_read_data <= r_ram[r_ram_addr_1b] ;  
    else 
        r_ram_read_data <= r_ram_read_data   ;

//ram地址
always@(posedge S_AXI_ACLK)
    if(w_rst || S_AXI_WLAST || S_AXI_RLAST)
        r_ram_addr <= 'd0;
    else if(w_aw_active)
        r_ram_addr <= S_AXI_AWADDR[7:0];
    else if(w_ar_active)
        r_ram_addr <= S_AXI_ARADDR[7:0];
    else if(w_w_active || (r_rvalid & S_AXI_RREADY))
        r_ram_addr <= r_ram_addr + 1;
    else 
        r_ram_addr <= r_ram_addr;

//ram地址打一拍
always@(posedge S_AXI_ACLK)
    r_ram_addr_1b <= r_ram_addr;

//ram写端口
always@(posedge S_AXI_ACLK)
    if(w_w_active)
        r_ram_write_data <= S_AXI_WDATA         ;
    else    
        r_ram_write_data <= r_ram_write_data    ;

//ram读写控制
always@(posedge S_AXI_ACLK)
    if(w_ar_active)
        r_ram_rh_wl <= 'd1;
    else if(w_aw_active)
        r_ram_rh_wl <= 'd0;
    else 
        r_ram_rh_wl <= r_ram_rh_wl;

//ram写使能
always@(posedge S_AXI_ACLK)
    if(w_w_active)
        r_ram_en <= 'd1;
    else
        r_ram_en <= 'd0;



always@(posedge S_AXI_ACLK)
    if(w_rst || S_AXI_RLAST)
        r_arready <= 'd1;
    else if(w_ar_active)
        r_arready <= 'd0;
    else 
        r_arready <= r_arready;

 
always@(posedge S_AXI_ACLK)
    if(w_ar_active)
        r_araddr <= S_AXI_ARADDR;
    else 
        r_araddr <= r_araddr;

always@(posedge S_AXI_ACLK)
    if(w_ar_active)
        r_arlen <= S_AXI_ARLEN; 
    else 
        r_arlen <= r_arlen;

always@(posedge S_AXI_ACLK)
    if(w_rst || S_AXI_RLAST)
        r_read_cnt <= 'd0;
    else if(w_r_active)
        r_read_cnt <= r_read_cnt + 1;
    else 
        r_read_cnt <= r_read_cnt;

always@(posedge S_AXI_ACLK)
    if(w_rst || S_AXI_RLAST)
        r_rvalid <= 'd0;
    else if(w_ar_active)
        r_rvalid <= 'd1;
    else 
        r_rvalid <= r_rvalid;

always@(posedge S_AXI_ACLK)
    if(S_AXI_RLAST)
        r_rvalid_1b <= 'd0;
    else 
        r_rvalid_1b <= r_rvalid;

always@(posedge S_AXI_ACLK)
    if(S_AXI_RLAST)
        r_rvalid_2b <= 'd0;
    else 
        r_rvalid_2b <= r_rvalid_1b;

always@(posedge S_AXI_ACLK)
    if(S_AXI_WLAST)
        r_bvalid <= 'd1;
    else if(w_b_active)
        r_bvalid <= 'd0;
    else 
        r_bvalid <= r_bvalid;
endmodule
