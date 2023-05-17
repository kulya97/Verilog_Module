`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/16 19:54:19
// Design Name: 
// Module Name: TFT_Ctr_Module
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


module SSD1289_Module #(
    parameter size_x = 16'd240,
    parameter size_y = 16'd320
) (
    input         pixel_clk,
    input         rst_n,
    input  [15:0] pixel_din,
    input         pixel_de,
    input         pixel_vsync,
    input         pixel_hsync,
    /******************/
    output        bus_CS,
    output        bus_DC,
    output        bus_WR,
    output        bus_RD,
    output [15:0] bus_DATA,
    output        bus_RST,
    output        sys_init_done,
    output        sys_plot_done
);
  assign bus_RD = 1'd1;

  wire [16:0] app_data;
  wire [16:0] init_dout;
  wire [16:0] plot_dout;
  wire app_valid, init_valid, polt_valid;

  assign app_valid = (!sys_init_done) ? init_valid : polt_valid;
  assign app_data  = (!sys_init_done) ? init_dout : plot_dout;


  SSD1289_Plot_Module #(
      .size_x(size_x),
      .size_y(size_y)
  ) SSD1289_Plot_Module (
      .sys_clk      (pixel_clk),
      .rst_n        (rst_n),
      .pixel_de     (pixel_de),
      .pixel_vsync  (pixel_vsync),
      .pixel_hsync  (pixel_hsync),
      .pixel_din    (pixel_din),
      .app_valid    (polt_valid),     //数据有效
      .app_dout     (plot_dout),      //数据
      .sys_init_done(sys_init_done),
      .sys_plot_done(sys_plot_done)
  );
  SSD1289_Init_Module SSD1289_Init_Module (
      .sys_clk       (pixel_clk),
      .rst_n         (rst_n),
      .bus_RST       (bus_RST),
      .bus_CS        (bus_CS),
      .app_init_valid(init_valid),
      .app_init_dout (init_dout),
      .app_init_done (sys_init_done)
  );
  intel_8080 inte_l8080 (
      .sys_clk  (pixel_clk),  //50M
      .rst_n    (rst_n),
      .bus_DC   (bus_DC),
      .bus_WR   (bus_WR),
      .bus_DATA (bus_DATA),
      .app_valid(app_valid),
      .app_din  (app_data)
  );

  /*******************************************************/
endmodule
