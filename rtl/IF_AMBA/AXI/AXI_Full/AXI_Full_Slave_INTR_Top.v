
`timescale 1 ns / 1 ps

	module myip_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI_Full
		parameter integer C_S_AXI_Full_ID_WIDTH	= 1,
		parameter integer C_S_AXI_Full_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_Full_ADDR_WIDTH	= 6,
		parameter integer C_S_AXI_Full_AWUSER_WIDTH	= 0,
		parameter integer C_S_AXI_Full_ARUSER_WIDTH	= 0,
		parameter integer C_S_AXI_Full_WUSER_WIDTH	= 0,
		parameter integer C_S_AXI_Full_RUSER_WIDTH	= 0,
		parameter integer C_S_AXI_Full_BUSER_WIDTH	= 0,

		// Parameters of Axi Slave Bus Interface S_AXI_INTR
		parameter integer C_S_AXI_INTR_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_INTR_ADDR_WIDTH	= 5,
		parameter integer C_NUM_OF_INTR	= 1,
		parameter  C_INTR_SENSITIVITY	= 32'hFFFFFFFF,
		parameter  C_INTR_ACTIVE_STATE	= 32'hFFFFFFFF,
		parameter integer C_IRQ_SENSITIVITY	= 1,
		parameter integer C_IRQ_ACTIVE_STATE	= 1
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXI_Full
		input wire  s_axi_full_aclk,
		input wire  s_axi_full_aresetn,
		input wire [C_S_AXI_Full_ID_WIDTH-1 : 0] s_axi_full_awid,
		input wire [C_S_AXI_Full_ADDR_WIDTH-1 : 0] s_axi_full_awaddr,
		input wire [7 : 0] s_axi_full_awlen,
		input wire [2 : 0] s_axi_full_awsize,
		input wire [1 : 0] s_axi_full_awburst,
		input wire  s_axi_full_awlock,
		input wire [3 : 0] s_axi_full_awcache,
		input wire [2 : 0] s_axi_full_awprot,
		input wire [3 : 0] s_axi_full_awqos,
		input wire [3 : 0] s_axi_full_awregion,
		input wire [C_S_AXI_Full_AWUSER_WIDTH-1 : 0] s_axi_full_awuser,
		input wire  s_axi_full_awvalid,
		output wire  s_axi_full_awready,
		input wire [C_S_AXI_Full_DATA_WIDTH-1 : 0] s_axi_full_wdata,
		input wire [(C_S_AXI_Full_DATA_WIDTH/8)-1 : 0] s_axi_full_wstrb,
		input wire  s_axi_full_wlast,
		input wire [C_S_AXI_Full_WUSER_WIDTH-1 : 0] s_axi_full_wuser,
		input wire  s_axi_full_wvalid,
		output wire  s_axi_full_wready,
		output wire [C_S_AXI_Full_ID_WIDTH-1 : 0] s_axi_full_bid,
		output wire [1 : 0] s_axi_full_bresp,
		output wire [C_S_AXI_Full_BUSER_WIDTH-1 : 0] s_axi_full_buser,
		output wire  s_axi_full_bvalid,
		input wire  s_axi_full_bready,
		input wire [C_S_AXI_Full_ID_WIDTH-1 : 0] s_axi_full_arid,
		input wire [C_S_AXI_Full_ADDR_WIDTH-1 : 0] s_axi_full_araddr,
		input wire [7 : 0] s_axi_full_arlen,
		input wire [2 : 0] s_axi_full_arsize,
		input wire [1 : 0] s_axi_full_arburst,
		input wire  s_axi_full_arlock,
		input wire [3 : 0] s_axi_full_arcache,
		input wire [2 : 0] s_axi_full_arprot,
		input wire [3 : 0] s_axi_full_arqos,
		input wire [3 : 0] s_axi_full_arregion,
		input wire [C_S_AXI_Full_ARUSER_WIDTH-1 : 0] s_axi_full_aruser,
		input wire  s_axi_full_arvalid,
		output wire  s_axi_full_arready,
		output wire [C_S_AXI_Full_ID_WIDTH-1 : 0] s_axi_full_rid,
		output wire [C_S_AXI_Full_DATA_WIDTH-1 : 0] s_axi_full_rdata,
		output wire [1 : 0] s_axi_full_rresp,
		output wire  s_axi_full_rlast,
		output wire [C_S_AXI_Full_RUSER_WIDTH-1 : 0] s_axi_full_ruser,
		output wire  s_axi_full_rvalid,
		input wire  s_axi_full_rready,

		// Ports of Axi Slave Bus Interface S_AXI_INTR
		input wire  s_axi_intr_aclk,
		input wire  s_axi_intr_aresetn,
		input wire [C_S_AXI_INTR_ADDR_WIDTH-1 : 0] s_axi_intr_awaddr,
		input wire [2 : 0] s_axi_intr_awprot,
		input wire  s_axi_intr_awvalid,
		output wire  s_axi_intr_awready,
		input wire [C_S_AXI_INTR_DATA_WIDTH-1 : 0] s_axi_intr_wdata,
		input wire [(C_S_AXI_INTR_DATA_WIDTH/8)-1 : 0] s_axi_intr_wstrb,
		input wire  s_axi_intr_wvalid,
		output wire  s_axi_intr_wready,
		output wire [1 : 0] s_axi_intr_bresp,
		output wire  s_axi_intr_bvalid,
		input wire  s_axi_intr_bready,
		input wire [C_S_AXI_INTR_ADDR_WIDTH-1 : 0] s_axi_intr_araddr,
		input wire [2 : 0] s_axi_intr_arprot,
		input wire  s_axi_intr_arvalid,
		output wire  s_axi_intr_arready,
		output wire [C_S_AXI_INTR_DATA_WIDTH-1 : 0] s_axi_intr_rdata,
		output wire [1 : 0] s_axi_intr_rresp,
		output wire  s_axi_intr_rvalid,
		input wire  s_axi_intr_rready,
		output wire  irq
	);
// Instantiation of Axi Bus Interface S_AXI_Full
	myip_v1_0_S_AXI_Full # ( 
		.C_S_AXI_ID_WIDTH(C_S_AXI_Full_ID_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S_AXI_Full_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_Full_ADDR_WIDTH),
		.C_S_AXI_AWUSER_WIDTH(C_S_AXI_Full_AWUSER_WIDTH),
		.C_S_AXI_ARUSER_WIDTH(C_S_AXI_Full_ARUSER_WIDTH),
		.C_S_AXI_WUSER_WIDTH(C_S_AXI_Full_WUSER_WIDTH),
		.C_S_AXI_RUSER_WIDTH(C_S_AXI_Full_RUSER_WIDTH),
		.C_S_AXI_BUSER_WIDTH(C_S_AXI_Full_BUSER_WIDTH)
	) myip_v1_0_S_AXI_Full_inst (
		.S_AXI_ACLK(s_axi_full_aclk),
		.S_AXI_ARESETN(s_axi_full_aresetn),
		.S_AXI_AWID(s_axi_full_awid),
		.S_AXI_AWADDR(s_axi_full_awaddr),
		.S_AXI_AWLEN(s_axi_full_awlen),
		.S_AXI_AWSIZE(s_axi_full_awsize),
		.S_AXI_AWBURST(s_axi_full_awburst),
		.S_AXI_AWLOCK(s_axi_full_awlock),
		.S_AXI_AWCACHE(s_axi_full_awcache),
		.S_AXI_AWPROT(s_axi_full_awprot),
		.S_AXI_AWQOS(s_axi_full_awqos),
		.S_AXI_AWREGION(s_axi_full_awregion),
		.S_AXI_AWUSER(s_axi_full_awuser),
		.S_AXI_AWVALID(s_axi_full_awvalid),
		.S_AXI_AWREADY(s_axi_full_awready),
		.S_AXI_WDATA(s_axi_full_wdata),
		.S_AXI_WSTRB(s_axi_full_wstrb),
		.S_AXI_WLAST(s_axi_full_wlast),
		.S_AXI_WUSER(s_axi_full_wuser),
		.S_AXI_WVALID(s_axi_full_wvalid),
		.S_AXI_WREADY(s_axi_full_wready),
		.S_AXI_BID(s_axi_full_bid),
		.S_AXI_BRESP(s_axi_full_bresp),
		.S_AXI_BUSER(s_axi_full_buser),
		.S_AXI_BVALID(s_axi_full_bvalid),
		.S_AXI_BREADY(s_axi_full_bready),
		.S_AXI_ARID(s_axi_full_arid),
		.S_AXI_ARADDR(s_axi_full_araddr),
		.S_AXI_ARLEN(s_axi_full_arlen),
		.S_AXI_ARSIZE(s_axi_full_arsize),
		.S_AXI_ARBURST(s_axi_full_arburst),
		.S_AXI_ARLOCK(s_axi_full_arlock),
		.S_AXI_ARCACHE(s_axi_full_arcache),
		.S_AXI_ARPROT(s_axi_full_arprot),
		.S_AXI_ARQOS(s_axi_full_arqos),
		.S_AXI_ARREGION(s_axi_full_arregion),
		.S_AXI_ARUSER(s_axi_full_aruser),
		.S_AXI_ARVALID(s_axi_full_arvalid),
		.S_AXI_ARREADY(s_axi_full_arready),
		.S_AXI_RID(s_axi_full_rid),
		.S_AXI_RDATA(s_axi_full_rdata),
		.S_AXI_RRESP(s_axi_full_rresp),
		.S_AXI_RLAST(s_axi_full_rlast),
		.S_AXI_RUSER(s_axi_full_ruser),
		.S_AXI_RVALID(s_axi_full_rvalid),
		.S_AXI_RREADY(s_axi_full_rready)
	);

// Instantiation of Axi Bus Interface S_AXI_INTR
	myip_v1_0_S_AXI_INTR # ( 
		.C_S_AXI_DATA_WIDTH(C_S_AXI_INTR_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_INTR_ADDR_WIDTH),
		.C_NUM_OF_INTR(C_NUM_OF_INTR),
		.C_INTR_SENSITIVITY(C_INTR_SENSITIVITY),
		.C_INTR_ACTIVE_STATE(C_INTR_ACTIVE_STATE),
		.C_IRQ_SENSITIVITY(C_IRQ_SENSITIVITY),
		.C_IRQ_ACTIVE_STATE(C_IRQ_ACTIVE_STATE)
	) myip_v1_0_S_AXI_INTR_inst (
		.S_AXI_ACLK(s_axi_intr_aclk),
		.S_AXI_ARESETN(s_axi_intr_aresetn),
		.S_AXI_AWADDR(s_axi_intr_awaddr),
		.S_AXI_AWPROT(s_axi_intr_awprot),
		.S_AXI_AWVALID(s_axi_intr_awvalid),
		.S_AXI_AWREADY(s_axi_intr_awready),
		.S_AXI_WDATA(s_axi_intr_wdata),
		.S_AXI_WSTRB(s_axi_intr_wstrb),
		.S_AXI_WVALID(s_axi_intr_wvalid),
		.S_AXI_WREADY(s_axi_intr_wready),
		.S_AXI_BRESP(s_axi_intr_bresp),
		.S_AXI_BVALID(s_axi_intr_bvalid),
		.S_AXI_BREADY(s_axi_intr_bready),
		.S_AXI_ARADDR(s_axi_intr_araddr),
		.S_AXI_ARPROT(s_axi_intr_arprot),
		.S_AXI_ARVALID(s_axi_intr_arvalid),
		.S_AXI_ARREADY(s_axi_intr_arready),
		.S_AXI_RDATA(s_axi_intr_rdata),
		.S_AXI_RRESP(s_axi_intr_rresp),
		.S_AXI_RVALID(s_axi_intr_rvalid),
		.S_AXI_RREADY(s_axi_intr_rready),
		.irq(irq)
	);

	// Add user logic here

	// User logic ends

	endmodule
