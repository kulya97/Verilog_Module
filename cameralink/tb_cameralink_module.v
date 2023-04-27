`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 10:52:18
// Design Name: 
// Module Name: tb_cameralink_module
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

module tb_cameralink_module;

  // cameralink_module Parameters
  parameter PERIOD = 10;

  parameter Integration_T = 24'd50;

  // Timing_Gen Inputs
  reg         rst_n = 0;
  reg  [15:0] app_image_h = 100;
  reg  [15:0] app_image_w = 100;
  reg         sys_en = 1;

  // Timing_Gen Outputs
  wire        frame_valid;
  wire        line_valid;
  wire        data_valid;
  wire [15:0] dout;
  wire [11:0] line_cnt;
  wire [11:0] pixel_cnt;


  // cameralink_module Inputs
  reg         data_clk = 0;
  reg         cm_data_clk = 0;
  // cameralink_module Outputs
  wire        cm_frame_valid;
  wire        cm_line_valid;
  wire        cm_data_valid;
  wire [15:0] cm_dout;


  initial begin
    forever #(PERIOD) data_clk = ~data_clk;
  end
  initial begin
    forever #(PERIOD / 5) cm_data_clk = ~cm_data_clk;
  end
  initial begin
    #(PERIOD * 2) rst_n = 1;
  end

  cameralink_module u_cameralink_module (
      .rst_n      (rst_n),
      .app_image_h(app_image_h[15:0]),
      .app_image_w(app_image_w[15:0]),
      .data_clk   (data_clk),
      .frame_valid(frame_valid),
      .line_valid (line_valid),
      .data_valid (data_valid),
      .din        (dout[15:0]),
      .cm_data_clk(cm_data_clk),

      .cm_frame_valid(cm_frame_valid),
      .cm_line_valid (cm_line_valid),
      .cm_data_valid (cm_data_valid),
      .cm_dout       (cm_dout[15:0])
  );


  Timing_Gen #(
      .Integration_T(Integration_T)
  ) u_Timing_Gen (
      .clk        (data_clk),
      .rst_n      (rst_n),
      .app_image_h(app_image_h[15:0]),
      .app_image_w(app_image_w[15:0]),
      .sys_en     (sys_en),

      .frame_valid(frame_valid),
      .line_valid (line_valid),
      .data_valid (data_valid),
      .dout       (dout[15:0]),
      .line_cnt   (line_cnt[11:0]),
      .pixel_cnt  (pixel_cnt[11:0])
  );

endmodule
