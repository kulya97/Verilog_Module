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
    parameter integer APB_ADDR = 32'h0000_0001,
    parameter integer CLK_FREQ = 26'd50_000_000,  //模块输入的时钟频率
    parameter integer I2C_FREQ = 18'd250_000      //IIC_SCL的时钟频率
) (
    input         apb_clk,
    input         apb_rstn,
    //--
    input         i_apb_psel,
    input         i_apb_penable,
    input         i_apb_pwrite,
    input  [31:0] i_apb_paddr,
    input  [31:0] i_apb_pwdata,
    //--
    input  [ 3:0] i_apb_pstrb,
    // input  [         2:0] i_apb_prot,     //APB4 sign unused
    // input  [         3:0] i_apb_pstrb,    //APB4 sign unused
    //--
    output        o_apb_pready,   //APB3 sign
    output [31:0] o_apb_prdata,
    output        o_apb_slverr,   //APB3 sign unused
    //--
    output        i2c_scl,
    inout         i2c_sda
);

  //---------------------------------------------------------------
  reg         apb_psel;
  reg         apb_penable;
  reg  [ 3:0] apb_pstrb;
  reg         apb_pwrite;
  reg  [31:0] apb_paddr;
  reg  [31:0] apb_pwdata;
  //--
  reg         r_cmd_wvalid;
  wire        w_cmd_wready;
  wire        w_cmd_bit_ctrl;
  wire        w_cmd_rh_wl;
  wire [ 7:0] w_cmd_sladdr;
  wire [15:0] w_cmd_regaddr;
  //--
  wire [ 7:0] w_i2c_wdata;
  wire [ 7:0] w_i2c_rdata;
  wire        w_i2c_rvalid;
  //--
  wire        w_i2c_done;
  wire        w_i2c_ack;
  wire        w_i2c_busy;
  //--  
  wire        w_apb_write_vld;
  wire        w_apb_read_vld;
  //---------------------------------------------------------------
  assign o_apb_slverr    = 0;
  assign o_apb_pready    = w_i2c_done;
  assign w_apb_write_vld = apb_pwrite && apb_psel && apb_penable;
  assign w_apb_read_vld  = (!apb_pwrite) && apb_psel && apb_penable;
  //---------------------------------------------------------------

  always @(negedge apb_rstn or posedge apb_clk) begin
    if (~apb_rstn) begin
      apb_psel    <= 0;
      apb_penable <= 0;
      apb_pstrb   <= 0;
      apb_pwrite  <= 0;
      apb_paddr   <= 0;
      apb_pwdata  <= 0;
    end else begin
      apb_psel    <= i_apb_psel;
      apb_penable <= i_apb_penable;
      apb_pstrb   <= i_apb_pstrb;
      apb_pwrite  <= i_apb_pwrite;
      apb_paddr   <= i_apb_paddr;
      apb_pwdata  <= i_apb_pwdata;
    end
  end
  //---------------------------------------------------------------

  parameter REG1_ADDR = 32'h43C0_0000;
  parameter REG2_ADDR = 32'h43C0_0004;
  parameter REG3_ADDR = 32'h43C0_0008;
  parameter REG4_ADDR = 32'h43C0_000c;

  reg [31:0] r_reg1;
  reg [31:0] r_reg2;
  reg [31:0] r_reg3;
  reg [31:0] r_reg4;  //only read
  reg [31:0] r_invld_reg;

  always @(posedge apb_clk, negedge apb_rstn) begin
    if (!apb_rstn) begin
      r_reg1       <= 32'd0;
      r_reg2       <= 32'd0;
      r_reg3       <= 32'd0;
      r_cmd_wvalid <= 1'b0;
    end else if (w_apb_write_vld) begin
      case (apb_paddr[31:0])
        REG1_ADDR: begin
          r_reg1       <= i_apb_pwdata;
          r_cmd_wvalid <= 1'b1;
        end
        REG2_ADDR: begin
          r_reg2       <= i_apb_pwdata;
          r_cmd_wvalid <= 1'b1;
        end
        REG3_ADDR: begin
          r_reg3       <= i_apb_pwdata;
          r_cmd_wvalid <= 1'b1;
        end
        default: begin
          r_invld_reg  <= i_apb_pwdata;
          r_cmd_wvalid <= 1'b0;
        end
      endcase
    end else if (w_apb_read_vld) begin
      r_cmd_wvalid = 1;
    end else if (r_cmd_wvalid && w_cmd_wready) begin
      r_cmd_wvalid = 0;
    end else begin
      r_cmd_wvalid = r_cmd_wvalid;
    end
  end

  //---------------------------------------------------------------
  i2c_master_module #(
      .CLK_FREQ(CLK_FREQ),
      .I2C_FREQ(I2C_FREQ)
  ) i2c_master_module_inst (
      .i_clk         (apb_clk),
      .i_rst_n       (apb_rstn),
      //--
      .i_cmd_bit_ctrl(w_cmd_bit_ctrl),
      .i_cmd_rh_wl   (w_cmd_rh_wl),
      .i_cmd_sladdr  (w_cmd_sladdr),
      .i_cmd_regaddr (w_cmd_regaddr),
      .i_cmd_wvalid  (w_cmd_wvalid),
      .i_cmd_wready  (w_cmd_wready),
      //--
      .i_i2c_wdata   (w_i2c_wdata),
      .o_i2c_rdata   (w_i2c_rdata),
      .o_i2c_rvalid  (w_i2c_rvalid),
      //--
      .i2c_scl       (i2c_scl),
      .i2c_sda       (i2c_sda),
      //--
      .o_i2c_done    (w_i2c_done),
      .o_i2c_ack     (w_i2c_ack),
      .o_i2c_busy    (w_i2c_busy)
  );
endmodule
