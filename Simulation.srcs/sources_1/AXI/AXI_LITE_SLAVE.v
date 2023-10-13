
`timescale 1 ns / 1 ps

module myip_v1_0_S00_AXI #(
    // Users to add parameters here

    // User parameters ends
    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH = 4
) (
    // Users to add ports here

    // User ports ends
    // Global Clock Signal
    input wire S_AXI_ACLK,
    input wire S_AXI_ARESETN,

    input  wire [    C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    input  wire [                       2 : 0] S_AXI_AWPROT,
    input  wire                                S_AXI_AWVALID,
    output wire                                S_AXI_AWREADY,
    // Write data (issued by master, acceped by Slave) 
    input  wire [    C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    input  wire                                S_AXI_WVALID,
    output wire                                S_AXI_WREADY,
    // Write response. This signal indicates the status
    // of the write transaction.
    output wire [                       1 : 0] S_AXI_BRESP,
    output wire                                S_AXI_BVALID,
    input  wire                                S_AXI_BREADY,
    // Read address (issued by master, acceped by Slave)
    input  wire [    C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    input  wire [                       2 : 0] S_AXI_ARPROT,
    input  wire                                S_AXI_ARVALID,
    output wire                                S_AXI_ARREADY,
    // Read data (issued by slave)
    output wire [    C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    output wire [                       1 : 0] S_AXI_RRESP,
    output wire                                S_AXI_RVALID,
    input  wire                                S_AXI_RREADY
);

  // AXI4LITE signals
  reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_awaddr;
  reg                            axi_awready;
  reg                            axi_wready;
  reg [                   1 : 0] axi_bresp;
  reg                            axi_bvalid;
  reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_araddr;
  reg                            axi_arready;
  reg [C_S_AXI_DATA_WIDTH-1 : 0] axi_rdata;
  reg [                   1 : 0] axi_rresp;
  reg                            axi_rvalid;

  // Example-specific design signals
  // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
  // ADDR_LSB is used for addressing 32/64 bit registers/memories
  // ADDR_LSB = 2 for 32 bits (n downto 2)
  // ADDR_LSB = 3 for 64 bits (n downto 3)
  localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH / 32) + 1;
  localparam integer OPT_MEM_ADDR_BITS = 1;
  //----------------------------------------------
  //-- Signals for user logic register space example
  //------------------------------------------------
  //-- Number of Slave Registers 4
  reg     [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;
  reg     [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;
  reg     [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
  reg     [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
  wire                             slv_reg_rden;
  wire                             slv_reg_wren;
  reg     [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
  integer                          byte_index;
  reg                              aw_en;

  // I/O Connections assignments

  assign S_AXI_AWREADY = axi_awready;
  assign S_AXI_WREADY  = axi_wready;
  assign S_AXI_BRESP   = axi_bresp;
  assign S_AXI_BVALID  = axi_bvalid;
  assign S_AXI_ARREADY = axi_arready;
  assign S_AXI_RDATA   = axi_rdata;
  assign S_AXI_RRESP   = axi_rresp;
  assign S_AXI_RVALID  = axi_rvalid;
  /****************************************************************************************************/
  //当S_axi_AWVALID和S_axi_WVALID都被断言时，实现axi_aready生成axi_aread被断言一个S_axi_ACLK时钟周期。
  //当重置为低电平时，axi_aready被解除断言。
  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_awready <= 1'b0;
      aw_en       <= 1'b1;
    end else begin
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
        //当在写地址和数据总线上存在有效的写地址和写数据时，slave准备接受写地址。此设计预计没有未完成的交易。
        axi_awready <= 1'b1;
        aw_en       <= 1'b0;
      end else if (S_AXI_BREADY && axi_bvalid) begin
        aw_en       <= 1'b1;
        axi_awready <= 1'b0;
      end else begin
        axi_awready <= 1'b0;
      end
    end
  end

  //实现axi_addr锁存此过程用于在S_axi_AWVALID和S_axi_WVALID都有效时锁存地址。

  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_awaddr <= 0;
    end else begin
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
        axi_awaddr <= S_AXI_AWADDR;
      end
    end
  end
  /****************************************************************************************************/
  //实现axi_ready生成
  //axi_ready在S_axi_AWVALID和S_axi_WVALID都被断言时被断言一个S_axi_ACLK时钟周期。重置为低电平时，axi_ready被取消断言。
  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_wready <= 1'b0;
    end else begin
      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en) begin
        axi_wready <= 1'b1;
      end else begin
        axi_wready <= 1'b0;
      end
    end
  end

  //实现内存映射寄存器选择和写入逻辑生成当axi_awready、S_axi_WVALID、axi_ready和S_axi_WALID断言。
  //写入选通用于在写入时选择从属寄存器的字节启用。
  //当应用复位（低激活）时，这些寄存器被清除。
  //当有效地址和数据可用并且从寄存器准备好接受写入地址和写入数据时，断言从寄存器写入启用。
  assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      slv_reg0 <= 0;
      slv_reg1 <= 0;
      slv_reg2 <= 0;
      slv_reg3 <= 0;
    end else begin
      if (slv_reg_wren) begin
        case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
          2'h0:
          for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1; byte_index = byte_index + 1)
          if (S_AXI_WSTRB[byte_index] == 1) begin
            // 根据写入选通断言相应的字节启用 
             slv_reg0[(byte_index*8)+:8] <= S_AXI_WDATA[(byte_index*8)+:8];//相当于[ (byte_index*8) + 7: (byte_index*8) ]
          end
          2'h1:
          for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1; byte_index = byte_index + 1)
          if (S_AXI_WSTRB[byte_index] == 1) begin
            slv_reg1[(byte_index*8)+:8] <= S_AXI_WDATA[(byte_index*8)+:8];
          end
          2'h2:
          for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1; byte_index = byte_index + 1)
          if (S_AXI_WSTRB[byte_index] == 1) begin
            slv_reg2[(byte_index*8)+:8] <= S_AXI_WDATA[(byte_index*8)+:8];
          end
          2'h3:
          for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1; byte_index = byte_index + 1)
          if (S_AXI_WSTRB[byte_index] == 1) begin
            slv_reg3[(byte_index*8)+:8] <= S_AXI_WDATA[(byte_index*8)+:8];
          end
          default: begin
            slv_reg0 <= slv_reg0;
            slv_reg1 <= slv_reg1;
            slv_reg2 <= slv_reg2;
            slv_reg3 <= slv_reg3;
          end
        endcase
      end
    end
  end

//实现写响应逻辑生成
//当断言axi_ready、S_axi_WVALID、axy_ready和S_axi_WALID时，写入响应和响应有效信号由从设备断言。
//这标志着地址的接受，并指示/写入事务的状态。

  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_bvalid <= 0;
      axi_bresp  <= 2'b0;
    end else begin
      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
        // indicates a valid write response is available
        axi_bvalid <= 1'b1;
        axi_bresp  <= 2'b0;  // 'OKAY' response 
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

  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_arready <= 1'b0;
      axi_araddr  <= 32'b0;
    end else begin
      if (~axi_arready && S_AXI_ARVALID) begin
        // indicates that the slave has acceped the valid read address
        axi_arready <= 1'b1;
        // Read address latching
        axi_araddr  <= S_AXI_ARADDR;
      end else begin
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
  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end else begin
      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
        // Valid read data is available at the read data bus
        axi_rvalid <= 1'b1;
        axi_rresp  <= 2'b0;  // 'OKAY' response
      end else if (axi_rvalid && S_AXI_RREADY) begin
        // Read data is accepted by the master
        axi_rvalid <= 1'b0;
      end
    end
  end

  // Implement memory mapped register select and read logic generation
  // Slave register read enable is asserted when valid address is available
  // and the slave is ready to accept the read address.
  assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
  always @(*) begin
    // Address decoding for reading registers
    case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
      2'h0   : reg_data_out <= slv_reg0;
      2'h1   : reg_data_out <= slv_reg1;
      2'h2   : reg_data_out <= slv_reg2;
      2'h3   : reg_data_out <= slv_reg3;
      default : reg_data_out <= 0;
    endcase
  end

  // Output register or memory read data
  always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      axi_rdata <= 0;
    end else begin
      // When there is a valid read address (S_AXI_ARVALID) with 
      // acceptance of read address by the slave (axi_arready), 
      // output the read dada 
      if (slv_reg_rden) begin
        axi_rdata <= reg_data_out;  // register read data
      end
    end
  end

  // Add user logic here

  // User logic ends

endmodule
