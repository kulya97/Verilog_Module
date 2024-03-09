`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/03 00:31:33
// Design Name: 
// Module Name: i2c_master_tb
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



module i2c_master_tb;



  reg         clk = 1;
  reg         rst;
  wire [ 6:0] s_axis_cmd_address;
  wire        s_axis_cmd_start;
  wire        s_axis_cmd_read;
  wire        s_axis_cmd_write;
  wire        s_axis_cmd_write_multiple;
  wire        s_axis_cmd_stop;
  wire        s_axis_cmd_valid;
  wire        s_axis_cmd_ready;
  wire [ 7:0] s_axis_data_tdata;
  wire        s_axis_data_tvalid;
  wire        s_axis_data_tready;
  wire        s_axis_data_tlast;
  wire [ 7:0] m_axis_data_tdata;
  wire        m_axis_data_tvalid;
  wire        m_axis_data_tready;
  wire        m_axis_data_tlast;
  reg         scl_i = 1;
  wire        scl_o;
  wire        scl_t;
  reg         sda_i = 1;
  wire        sda_o;
  wire        sda_t;
  wire        busy1;
  wire        busy2;
  wire        bus_control;
  wire        bus_active;
  wire        missed_ack;
  reg  [15:0] prescale = 256;
  reg         stop_on_idle = 1;

  reg         start;
  always #5 clk = !clk;
  initial begin
    rst   = 1;
    start = 0;
    #20000;
    rst   = 0;
    start = 1;
    wait (bus_control == 1);
    start = 0;
    wait (bus_control == 0);
    #20;
    start = 1;
    wait (bus_control == 1);
    start = 0;
    wait (bus_control == 0);
  end
  i2c_master i2c_master_inst (
      .clk                      (clk),
      .rst                      (rst),
      .s_axis_cmd_address       (s_axis_cmd_address),
      .s_axis_cmd_start         (s_axis_cmd_start),
      .s_axis_cmd_read          (s_axis_cmd_read),
      .s_axis_cmd_write         (s_axis_cmd_write),
      .s_axis_cmd_write_multiple(s_axis_cmd_write_multiple),
      .s_axis_cmd_stop          (s_axis_cmd_stop),
      .s_axis_cmd_valid         (s_axis_cmd_valid),
      .s_axis_cmd_ready         (s_axis_cmd_ready),
      //--
      .s_axis_data_tdata        (s_axis_data_tdata),
      .s_axis_data_tvalid       (s_axis_data_tvalid),
      .s_axis_data_tready       (s_axis_data_tready),
      .s_axis_data_tlast        (s_axis_data_tlast),
      //--
      .m_axis_data_tdata        (m_axis_data_tdata),
      .m_axis_data_tvalid       (m_axis_data_tvalid),
      .m_axis_data_tready       (m_axis_data_tready),
      .m_axis_data_tlast        (m_axis_data_tlast),
      .scl_i                    (scl_i),
      .scl_o                    (scl_o),
      .scl_t                    (scl_t),
      .sda_i                    (sda_i),
      .sda_o                    (sda_o),
      .sda_t                    (sda_t),
      .busy                     (busy1),
      .bus_control              (bus_control),
      .bus_active               (bus_active),
      .missed_ack               (missed_ack),
      .prescale                 (prescale),
      .stop_on_idle             (stop_on_idle)
  );
  i2c_init i2c_init_inst (
      .clk                      (clk),
      .rst                      (rst),
      .m_axis_cmd_address       (s_axis_cmd_address),
      .m_axis_cmd_start         (s_axis_cmd_start),
      .m_axis_cmd_read          (s_axis_cmd_read),
      .m_axis_cmd_write         (s_axis_cmd_write),
      .m_axis_cmd_write_multiple(s_axis_cmd_write_multiple),
      .m_axis_cmd_stop          (s_axis_cmd_stop),
      .m_axis_cmd_valid         (s_axis_cmd_valid),
      .m_axis_cmd_ready         (s_axis_cmd_ready),
      //--
      .m_axis_data_tdata        (s_axis_data_tdata),
      .m_axis_data_tvalid       (s_axis_data_tvalid),
      .m_axis_data_tready       (s_axis_data_tready),
      .m_axis_data_tlast        (s_axis_data_tlast),
      .busy                     (busy2),
      .start                    (start)
  );






  // reg  sys_clk = 1;
  // wire clk_out;
  // wire scl_pin;
  // wire sda_pin;

  // top_module top_module_inst (
  //     .sys_clk(sys_clk),
  //     .clk_out(clk_out),
  //     .scl_pin(scl_pin),
  //     .sda_pin(sda_pin)
  // );

  // always #5 sys_clk = !sys_clk;


endmodule
