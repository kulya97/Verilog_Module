`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/30 17:03:50
// Design Name: 
// Module Name: tb_cameralink
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


module tb_cameralink;
  localparam clk_per = 10;

  wire [3:0] data_out_to_pins_p;
  wire [3:0] data_out_to_pins_n;
  wire       clk_to_pins_p;
  wire       clk_to_pins_n;

  reg        clk_in = 1;
  reg        clk_div_in = 1;
  reg        rstn = 0;
  reg        rstn2 = 0;
  reg        rstn3 = 0;

  initial begin

    #(200 * clk_per);
    rstn = 1;
    #(100) rstn2 = 1;
    #(100) rstn3 = 1;

  end


  always #(clk_per / 2) clk_in = !clk_in;
  always begin
    clk_div_in = 1;
    #(clk_per * 4) clk_div_in = 0;
    #(clk_per * 3);
  end
  wire        i_fvld;
  wire        i_lvld;
  wire        i_dvld;
  wire [23:0] o_tpg_data;

  h_tpg #(
      .H_ActiveSize(50),
      .H_FrameSize(60),
      .H_SyncStart(0),
      .H_SyncEnd(5),
      .V_ActiveSize(50),
      .V_FrameSize(60),
      .V_SyncStart(0),
      .V_SyncEnd(5)
  ) h_tpg_inst (
      .i_tpg_rstn(rstn),
      .i_tpg_clk (clk_div_in),
      .o_tpg_vs  (i_fvld),
      .o_tpg_hs  (i_lvld),
      .o_tpg_de  (i_dvld),
      .o_tpg_data(o_tpg_data)
  );

  cameralink_transmitter cameralink_transmitter_inst (
      .i_clk          (clk_div_in),
      .i_clkx7        (clk_in),
      .i_rstn         (rstn),
      .i_fvld         (!i_fvld),
      .i_lvld         (!i_lvld),
      .i_dvld         (i_dvld),
      .i_porta        (o_tpg_data[23:16]),
      .i_portb        (o_tpg_data[15:8]),
      .i_portc        (o_tpg_data[7:0]),
      .o_cmlink_clk_p (clk_to_pins_p),
      .o_cmlink_clk_n (clk_to_pins_n),
      .o_cmlink_data_p(data_out_to_pins_p),
      .o_cmlink_data_n(data_out_to_pins_n)
  );
  wire clk_out1;
  clk_wiz_0 instance_name (
      // Clock out ports
      .clk_out1 (clk_out1),       // output clk_out1
      // Clock in ports
      .clk_in1_p(clk_to_pins_p),  // input clk_in1_p
      .clk_in1_n(clk_to_pins_n)   // input clk_in1_n
  );

  wire        clk_div_out;
  wire [27:0] data_in_to_device;
  // cameralink_receiver_selectio_wiz cameralink_receiver_selectio_wiz_inst (
  //     .data_in_from_pins_p(data_out_to_pins_p),
  //     .data_in_from_pins_n(data_out_to_pins_n),
  //     .data_in_to_device  (data_in_to_device),
  //     .bitslip            (4'b00),
  //     .clk_in_p           (clk_out1),
  //     .clk_in_n           (!clk_out1),
  //     .clk_div_out        (clk_div_out),
  //     .clock_enable       (rstn3),
  //     .clk_reset          (!rstn3),
  //     .io_reset           (!rstn3)
  // );

  cameralink_receiver_selectio_wiz cameralink_receiver_selectio_wiz_inst (
      .data_in_from_pins_p(data_out_to_pins_p),
      .data_in_from_pins_n(data_out_to_pins_n),
      .data_in_to_device  (data_in_to_device),
      .bitslip            (4'b00),
      .clk_in             (rstn3 && clk_in),
      .clk_div_in         (rstn3 && clk_div_in),
      .clock_enable       (rstn3),
      .io_reset           (!rstn3)
  );
  cmlink2dcp cmlink2dcp_inst (
      .i_clk    (clk_div_out),
      .i_rstn   (rstn2),
      .i_cm_data(data_in_to_device),
      .o_fvld   (),
      .o_lvld   (),
      .o_dvld   (),
      .o_porta  (),
      .o_portb  (),
      .o_portc  ()
  );
endmodule
