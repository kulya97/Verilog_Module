`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/22 00:11:08
// Design Name: 
// Module Name: i2c_master_apb_if
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


module i2c_master_apb_if #(
    parameter integer       APB_ADDR   = 32'h0000_0001,
    parameter integer       APB_ABIT   = 32,
    parameter integer       APB_DBIT   = 32,
    parameter         [6:0] SLAVE_ADDR = 7'b1010000,      //EEPROM从机地址
    parameter integer       CLK_FREQ   = 26'd50_000_000,  //模块输入的时钟频率
    parameter integer       I2C_FREQ   = 18'd250_000,     //IIC_SCL的时钟频率
    parameter integer       WR_BITS    = 8'd1,
    parameter integer       RD_BITS    = 8'd1
) (
    input                 apb_clk,
    input                 apb_rstn,
    //--
    input                 i_apb_psel,
    input                 i_apb_penable,
    input                 i_apb_pwrite,
    input  [APB_ABIT-1:0] i_apb_paddr,
    input  [APB_DBIT-1:0] i_apb_pwdata,
    //--
    input  [         2:0] i_apb_prot,     //APB4 sign unused
    input  [         3:0] i_apb_pstrb,    //APB3 sign unused
    //--
    output                o_apb_pready,   //APB3 sign
    output [APB_DBIT-1:0] o_apb_prdata,
    output                o_apb_slverr,   //APB3 sign unused
    //--
    output                i2c_scl,
    inout                 i2c_sda

);
  //---------------------------------------------------------------
  wire                 apb_valid;
  //--
  wire                 i_i2c_wvalid;
  wire                 i_i2c_wready;
  wire                 i_cmd_bit_ctrl;
  wire                 i_cmd_rh_wl;
  wire [         15:0] i_i2c_addr;
  wire [WR_BITS*8-1:0] i_i2c_wdata;
  wire [RD_BITS*8-1:0] o_i2c_rdata;
  wire                 o_i2c_rvalid;
  wire                 o_i2c_done;
  wire                 o_i2c_ack;
  wire                 o_i2c_busy;
  //---------------------------------------------------------------
  assign apb_valid      = (i_apb_paddr == APB_ADDR);
  assign i_i2c_wvalid   = apb_valid && i_apb_psel && i_apb_psel;
  assign i_cmd_rh_wl    = apb_valid && i_apb_pwrite;
  assign i_cmd_bit_ctrl = 1;
  assign i_i2c_addr     = apb_valid && i_apb_pwdata[31:16];
  assign i_i2c_wdata    = apb_valid && i_apb_pwdata[15:0];
  assign o_apb_pready   = o_i2c_done;

  assign o_apb_slverr   = 0;

  //---------------------------------------------------------------

  parameter REG1_ADDR = 32'h43C0_0000;
  parameter REG2_ADDR = 32'h43C0_0004;
  parameter REG3_ADDR = 32'h43C0_0008;
  parameter REG4_ADDR = 32'h43C0_000c;

  reg  [31:0] r_reg1;
  reg  [31:0] r_reg2;
  reg  [31:0] r_reg3;
  reg  [31:0] r_reg4;  //only read
  reg  [31:0] r_invld_reg;

  wire                  w_apb_write_vld;
  wire                  w_apb_read_vld;
  reg                   r_writedata_vld;
  reg                   r_readdata_vld;

  wire [          63:0] uart_rx_data;
  wire                  uart_rx_valid;
  //---------------------------------------------------------------
  assign PREADY          = 1'b1;
  //   assign PPROT           = 3'b000;
  //   assign PSTRB           = PWRITE ? 4'b0000 : 4'b1111;
  assign PSLVERR         = 1'b0;

  assign w_apb_write_vld = i_apb_pwrite && i_apb_psel && i_apb_penable;
  assign w_apb_read_vld  = (!PWRITE) && PSELx && PENABLE;

  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      r_reg1          <= 32'd0;
      r_reg2          <= 32'd0;
      r_reg3          <= 32'd0;
      r_writedata_vld <= 1'b0;
    end else if (w_apb_write_vld) begin
      case (PADDR[ADDR_WITDH-1:0])
        REG1_ADDR: begin
          r_reg1          <= PWDATA;
          r_writedata_vld <= 1'b1;
        end
        REG2_ADDR: begin
          r_reg2          <= PWDATA;
          r_writedata_vld <= 1'b1;
        end
        REG3_ADDR: begin
          r_reg3          <= PWDATA;
          r_writedata_vld <= 1'b1;
        end
        default: begin
          r_invld_reg     <= PWDATA;
          r_writedata_vld <= 1'b0;
        end
      endcase
    end
  end
  always @(*) begin
    if (w_apb_read_vld) begin
      case (PADDR[ADDR_WITDH-1:0])
        REG1_ADDR: begin
          PRDATA         <= r_reg1;
          r_readdata_vld <= 1'b1;
        end
        REG2_ADDR: begin
          PRDATA         <= r_reg2;
          r_readdata_vld <= 1'b1;
        end
        REG3_ADDR: begin
          PRDATA         <= r_reg3;
          r_readdata_vld <= 1'b1;
        end
        REG4_ADDR: begin
          PRDATA         <= uart_rx_data[31:0];
          r_readdata_vld <= 1'b1;
        end
        default: begin
          PRDATA         <= r_invld_reg;
          r_readdata_vld <= 1'b0;
        end
      endcase
    end else begin
      PRDATA         <= 32'd0;
      r_readdata_vld <= 1'b0;
    end
  end




  //---------------------------------------------------------------
  i2c_master_module #(
      .SLAVE_ADDR(SLAVE_ADDR),
      .CLK_FREQ(CLK_FREQ),
      .I2C_FREQ(I2C_FREQ),
      .WR_BITS(WR_BITS),
      .RD_BITS(RD_BITS)
  ) i2c_master_module_inst (
      .clk           (apb_clk),
      .rst_n         (apb_rstn),
      .i_i2c_wvalid  (i_i2c_wvalid),
      .i_i2c_wready  (i_i2c_wready),
      .i_cmd_bit_ctrl(i_cmd_bit_ctrl),
      .i_cmd_rh_wl   (i_cmd_rh_wl),
      .i_i2c_addr    (i_i2c_addr),
      .i_i2c_wdata   (i_i2c_wdata),
      .o_i2c_rdata   (o_i2c_rdata),
      .o_i2c_rvalid  (o_i2c_rvalid),
      .i2c_scl       (i2c_scl),
      .i2c_sda       (i2c_sda),
      .o_i2c_done    (o_i2c_done),
      .o_i2c_ack     (o_i2c_ack),
      .o_i2c_busy    (o_i2c_busy)
  );
endmodule
