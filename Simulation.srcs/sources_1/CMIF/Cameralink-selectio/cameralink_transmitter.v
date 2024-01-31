`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: njust
// Engineer: huangwenjie
// 
// Create Date: 2024/01/30 22:13:23
// Design Name: 
// Module Name: cameralink_transmitter
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


module cameralink_transmitter (
    input        i_clk,
    input        i_clkx7,
    input        i_rstn,
    input        i_fvld,
    input        i_lvld,
    input        i_dvld,
    input  [7:0] i_porta,
    input  [7:0] i_portb,
    input  [7:0] i_portc,
    output       o_cmlink_clk_p,
    output       o_cmlink_clk_n,
    output [3:0] o_cmlink_data_p,
    output [3:0] o_cmlink_data_n

);
  wire [27:0] data_out_from_device;

  wire        io_reset;

  assign io_reset = !i_rstn;
  dvp2cmlink dvp2cmlink_inst (
      .i_clk    (i_clk),
      .i_rstn   (i_rstn),
      .i_fvld   (i_fvld),
      .i_lvld   (i_lvld),
      .i_dvld   (i_dvld),
      .i_porta  (i_porta[7:0]),
      .i_portb  (i_portb[7:0]),
      .i_portc  (i_portc[7:0]),
      .o_cm_data(data_out_from_device[27:0])
  );

  cameralink_transmitter_selectio_wiz cameralink_transmitter_selectio_wiz_inst (
      .data_out_from_device(data_out_from_device[27:0]),
      .data_out_to_pins_p  (o_cmlink_data_p),
      .data_out_to_pins_n  (o_cmlink_data_n),
      .clk_to_pins_p       (o_cmlink_clk_p),
      .clk_to_pins_n       (o_cmlink_clk_n),
      .clk_in              (i_clkx7),
      .clk_div_in          (i_clk),
      .io_reset            (io_reset)
  );
endmodule
