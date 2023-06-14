
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
*Revision: 1.0
*Signal description
*1) _i input
*2) _o output
*3) _n activ low
*4) _dg debug signal 
*5) _r delay or register
*6) _s state mechine
*********************************************************************/

`timescale 1 ps / 1 ps

	module uixdmairq #
	(
        parameter integer XMDA_REQ_NUM = 8
	)
	(
		// Users to add ports here
        input  wire [XMDA_REQ_NUM-1 :0] user_irq_req_i,
        //input  wire [XMDA_REQ_NUM-1 :0] xdma_irq_ack_i,
        output wire [XMDA_REQ_NUM-1 :0] xdma_irq_req_o, 
        output wire user_irq_en_o,
		input wire  S_AXI_ACLK,
		input wire  S_AXI_ARESETN,
		input wire [3 : 0] S_AXI_AWADDR,
		input wire [2 : 0] S_AXI_AWPROT,
		input wire  S_AXI_AWVALID,
		output wire  S_AXI_AWREADY,
		input wire [31 : 0] S_AXI_WDATA,  
		input wire [3  : 0] S_AXI_WSTRB,
		input wire  S_AXI_WVALID,
		output wire  S_AXI_WREADY,
		output wire [1 : 0] S_AXI_BRESP,
		output wire  S_AXI_BVALID,
		input wire  S_AXI_BREADY,
		input wire [3 : 0] S_AXI_ARADDR,
		input wire [2 : 0] S_AXI_ARPROT,
		input wire  S_AXI_ARVALID,
		output wire  S_AXI_ARREADY,
		output wire [31 : 0] S_AXI_RDATA,
		output wire [1  : 0] S_AXI_RRESP,
		output wire  S_AXI_RVALID,
		input wire  S_AXI_RREADY
	);
	


reg  [XMDA_REQ_NUM -1 :0] user_irq_req;	
reg  [XMDA_REQ_NUM -1 :0] user_irq_req_r1;
reg  [XMDA_REQ_NUM -1 :0] user_irq_req_r2;
reg  [XMDA_REQ_NUM -1 :0] user_irq_req_r3;
reg  [XMDA_REQ_NUM -1 :0] xdma_irq_ack_r1;
reg  [XMDA_REQ_NUM -1 :0] xdma_irq_ack_r2;
reg  [XMDA_REQ_NUM -1 :0] xdma_irq_ack_r3;
//reg  [XMDA_REQ_NUM -1 :0] xdma_irq_ack;
reg  [XMDA_REQ_NUM -1 :0] xdma_irq_req;
	// AXI4LITE signals
	reg [3:0]	     axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [3:0]	 	axi_araddr;
	reg  	axi_arready;
	reg [31 : 0] 	axi_rdata;
	reg [1  : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = 2;
	localparam integer OPT_MEM_ADDR_BITS = 1;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 4
	reg [31:0]	slv_reg0;
	reg [31:0]	slv_reg1;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [31:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY = axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )begin
	      slv_reg0 <= 0;
		  slv_reg1 <= 0;
	  end 
	  else if(slv_reg_wren)begin 
	       if (axi_awaddr[3:2] == 2'd0)
	         slv_reg0[31:0] <= S_AXI_WDATA[31:0];
	       else if (axi_awaddr[3:2] == 2'd1)
             slv_reg1[31:0] <= S_AXI_WDATA[31:0];   
	  end else begin
	         slv_reg0 <= 0;
	         slv_reg1 <= slv_reg1;
	  end   
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	if(axi_awaddr[3:2] == 2'd0)
	        reg_data_out[31 : 0] <= slv_reg0;
	else if(axi_awaddr[3:2] == 2'd1)
	        reg_data_out[31 : 0] <= slv_reg1;
	else 
            reg_data_out <= reg_data_out;
            
	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden) begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

// Add user logic here
	
reg  [4 :0] i;
reg  [4 :0] j;
reg  [4 :0] k;
assign xdma_irq_req_o = xdma_irq_req;
  
assign user_irq_en_o = slv_reg1[31];

wire [XMDA_REQ_NUM-1:0] xdma_irq_ack = slv_reg0[XMDA_REQ_NUM-1:0];
/*
always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 || user_irq_en_o == 1'b0 )begin
        xdma_irq_ack_r1 <= 0;
        xdma_irq_ack_r2 <= 0;
        xdma_irq_ack_r3 <= 0;
    end
    else begin
        xdma_irq_ack_r1 <= xdma_irq_ack_i;
        xdma_irq_ack_r2 <= xdma_irq_ack_r1;
        xdma_irq_ack_r3 <= xdma_irq_ack_r2;
    end
end
*/
always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 || user_irq_en_o == 1'b0 )begin
        user_irq_req_r1 = 0;
        user_irq_req_r2 = 0;
        user_irq_req_r3 = 0;
    end
    else begin
        user_irq_req_r1 <= user_irq_req_i;
        user_irq_req_r2 <= user_irq_req_r1;
        user_irq_req_r3 <= user_irq_req_r2;
    end
end

always @( posedge S_AXI_ACLK ) begin
	  if ( S_AXI_ARESETN == 1'b0 || user_irq_en_o == 1'b0)begin
	      j <= 5'd0;
	      user_irq_req <= 0;
	    end 
	    else begin
	      for(j = 0; j <=XMDA_REQ_NUM-1; j = j +1 )
	        user_irq_req[j] <= !user_irq_req_r3[j] & user_irq_req_r2[j];
	    end
end
/*
always @( posedge S_AXI_ACLK ) begin
	  if ( S_AXI_ARESETN == 1'b0 || user_irq_en_o == 1'b0)begin
	      k <= 5'd0;
	      xdma_irq_ack <= 0;
	    end 
	    else begin
	      for(k = 0; k <=XMDA_REQ_NUM-1; k = k +1 )
	        xdma_irq_ack[k] <= !xdma_irq_ack_r2[k] & xdma_irq_ack_r3[k];
	    end
end
*/
always @( posedge S_AXI_ACLK ) begin
	  if ( S_AXI_ARESETN == 1'b0 || user_irq_en_o == 1'b0)begin
	      i <= 5'd0;
	      xdma_irq_req <= 0;
	    end 
	    else begin
	    for(i = 0; i <=XMDA_REQ_NUM-1; i = i +1 )begin
	      if(xdma_irq_ack[i]) begin
	           xdma_irq_req[i] <= 1'b0;
	      end
	      else if(user_irq_req[i])begin
	           xdma_irq_req[i] <= 1'b1; 
	      end
	    end
	    end
end
	// User logic ends

	endmodule
