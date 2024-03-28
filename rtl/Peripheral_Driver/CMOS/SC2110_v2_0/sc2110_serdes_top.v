`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
// 
// Create Date: 2023/12/02 14:25:32
// Design Name: 
// Module Name: sc2110_serdes_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 2024-03-06
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sc2110_serdes_top (
    input           i_rstn,
    input           i_lvds_clk,
    input  [   7:0] i_lvds_data,
    input           i_cmos_clk,
    output          o_cmos_fvld,
    output          o_cmos_lvld,
    output          o_cmos_dvld,
    output [11 : 0] o_cmos_data
);
  //---------------------------------------------------------------------
  wire [47:0] w_data;
  wire        w_data_valid;
  wire [ 3:0] w_bitslip;
  wire [11:0] w_12bit_data;
  wire        w_12bit_data_valid;
  wire        w_fvld_a;
  wire        w_lvld_a;
  wire        w_dvld_a;
  wire [11:0] w_data_a;

  ila_iddr your_instance_name (
      .clk   (i_lvds_clk),    // input wire clk
      .probe0(w_data_valid),  // input wire [0:0]  probe0  
      .probe1(w_bitslip),     // input wire [3:0]  probe1 
      .probe2(i_lvds_data),   // input wire [7:0]  probe2 
      .probe3(w_data)         // input wire [47:0]  probe3
  );

  //---------------------------------------------------------------------
  sc2110_selectio_module sc2110_selectio_module_inst0 (
      .i_rstn      (i_rstn),
      .i_lvds_clk  (i_lvds_clk),
      .i_lvds_data (i_lvds_data[7:0]),
      .i_bitslip   (w_bitslip),
      .o_data_valid(w_data_valid),
      .o_data      (w_data[47:0])
  );

  //---------------------------------------------------------------------
  sc2110_bitslip_module sc2110_bitslip_module_inst0 (
      .i_clk    (i_lvds_clk),
      .i_rstn   (i_rstn),
      .i_data   (w_data[47:0]),
      .i_dvld   (w_data_valid),
      .o_bitslip(w_bitslip[3:0])
  );

  //---------------------------------------------------------------------
  sc2110_decode_48to12_module sc2110_decode_48to12_module_inst0 (
      .i_clk (i_lvds_clk),
      .i_rstn(i_rstn),
      .i_dvld(w_data_valid),
      .i_data(w_data),
      .o_data(w_12bit_data),
      .o_dvld(w_12bit_data_valid)
  );

  //---------------------------------------------------------------------
  sc2110_sync_gen_module sc2110_sync_gen_module_inst (
      .i_clk      (i_lvds_clk),
      .i_rstn     (i_rstn),
      .i_dvld     (w_12bit_data_valid),
      .i_data     (w_12bit_data[11:0]),
      .o_cmos_fvld(w_fvld_a),
      .o_cmos_lvld(w_lvld_a),
      .o_cmos_dvld(w_dvld_a),
      .O_cmos_data(w_data_a)
  );

  //---------------------------------------------------------------------
  sc2110_genout_module sc2110_genout_module_inst (
      .pclk_a  (i_lvds_clk),
      .rst_n   (i_rstn),
      .i_fvld_a(w_fvld_a),
      .i_lvld_a(w_lvld_a),
      .i_dvld_a(w_dvld_a),
      .i_data_a(w_data_a),
      .pclk_b  (i_cmos_clk),
      .o_fvld_b(o_cmos_fvld),
      .o_lvld_b(o_cmos_lvld),
      .o_dvld_b(o_cmos_dvld),
      .o_data_b(o_cmos_data)
  );

endmodule
