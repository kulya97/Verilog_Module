`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/19 20:29:28
// Design Name: 
// Module Name: tb_wr_8bit
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


module tb_wr_8bit;

  //
  localparam perid = 10;
  // Parameters
  localparam integer CLK_FREQ = 32;
  localparam integer I2C_FREQ = 1;

  //Ports
  reg        clk;
  reg        rst_n;
  reg        i_cmd_start;
  reg        i_cmd_wdata;
  reg        i_cmd_rdata;
  reg        i_cmd_stop;
  reg        i_wvalid;
  wire       o_wready;
  reg  [7:0] i_wdata;
  wire       o_rvalid;
  reg        i_rready = 1;
  wire [7:0] o_rdata;
  wire       o_busy;
  wire       o_done;
  wire       o_ack;
  reg        scl_i;
  wire       scl_o;
  wire       scl_t;
  reg        sda_i;
  wire       sda_o;
  wire       sda_t;


  always #(perid / 2) clk = !clk;
  initial begin
    clk         = 1;
    rst_n       = 0;
    i_cmd_start = 0;
    i_cmd_wdata = 0;
    i_cmd_rdata = 0;
    i_cmd_stop  = 0;
    i_wvalid    = 0;
    i_wdata     = 8'haa;
    #(perid * 20);
    rst_n = 1;
    #(perid * 20);
    i_cmd_start = 0;
    i_cmd_wdata = 1;
    i_cmd_rdata = 0;
    i_cmd_stop  = 0;
    i_wvalid    = 1;
    i_wdata     = 8'haa;
    #(perid * 2);
    i_cmd_start = 0;
    i_cmd_wdata = 0;
    i_cmd_rdata = 0;
    i_cmd_stop  = 0;
    i_wvalid    = 0;
    i_wdata     = 8'haa;
  end

  i2c_wr_8bit #(
      .CLK_FREQ(CLK_FREQ),
      .I2C_FREQ(I2C_FREQ)
  ) i2c_wr_8bit_inst (
      .clk        (clk),
      .rst_n      (rst_n),
      .i_cmd_start(i_cmd_start),
      .i_cmd_wdata(i_cmd_wdata),
      .i_cmd_rdata(i_cmd_rdata),
      .i_cmd_stop (i_cmd_stop),
      .i_wvalid   (i_wvalid),
      .o_wready   (o_wready),
      .i_wdata    (i_wdata),
      .o_rvalid   (o_rvalid),
      .i_rready   (i_rready),
      .o_rdata    (o_rdata),
      .o_busy     (o_busy),
      .o_done     (o_done),
      .o_ack      (o_ack),
      .scl_i      (scl_i),
      .scl_o      (scl_o),
      .scl_t      (scl_t),
      .sda_i      (sda_i),
      .sda_o      (sda_o),
      .sda_t      (sda_t)
  );



endmodule
