`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/17 22:26:57
// Design Name: 
// Module Name: tb_iic_slave_module
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


module tb_iic_slave_module;
  // Parameters
  localparam integer SLAVE_ADDR = 7'h5a;
  localparam integer CLK_FREQ = 256;
  localparam integer I2C_FREQ = 1;
  localparam integer WR_BITS = 4;
  localparam integer RD_BITS = 4;

  localparam integer period = 10;
  //Ports
  reg                  i_clk;
  reg                  i_rstn;
  reg                  i_i2c_wvalid;
  wire                 o_i2c_done;
  wire                 o_i2c_ack;
  reg                  i_cmd_bit_ctrl = 1;
  reg                  i_cmd_rh_wl = 0;
  reg  [         15:0] i_i2c_addr;
  reg  [WR_BITS*8-1:0] i_i2c_wdata;
  wire [RD_BITS*8-1:0] o_i2c_rdata;
  wire                 i2c_scl;
  wire                 i2c_sda;
  wire                 o_dri_clk;
  wire                 o_i2c_rvalid;

  always #(period / 2) i_clk = !i_clk;
  reg  [7:0] i;
  wire       i_i2c_wready;
  initial begin
    i_clk        = 1;
    i_rstn       = 0;
    i_i2c_wvalid = 0;
    i_i2c_addr   = 16'h0002;
    i_i2c_wdata  = 32'h0102_0304;
    #(period * 20);
    i_rstn = 1;
    #(period * 20);
    for (i = 0; i < 50; i = i + 1) begin
      i_i2c_wvalid = 1;
      i_i2c_addr   = 16'h0002 + i;
      i_i2c_wdata  = 32'h0102_0304 + i;
      #(period * 2);

      i_i2c_wvalid = 0;
      wait (o_i2c_done);
    end
  end
  i2c_master_module #(
      .SLAVE_ADDR(SLAVE_ADDR),
      .CLK_FREQ(CLK_FREQ),
      .I2C_FREQ(I2C_FREQ),
      .WR_BITS(WR_BITS),
      .RD_BITS(RD_BITS)
  ) i2c_master_module_inst (
      .clk           (i_clk),
      .rst_n         (i_rstn),
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
