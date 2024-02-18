`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/18 21:15:51
// Design Name: 
// Module Name: tb_i2c_master
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


module tb_i2c_master;
  // Parameters
  localparam perid = 10;
  //Ports
  reg         clk;
  reg         rst;
  reg  [ 6:0] s_axis_cmd_address;
  reg         s_axis_cmd_start;
  reg         s_axis_cmd_read;
  reg         s_axis_cmd_write;
  reg         s_axis_cmd_write_multiple;
  reg         s_axis_cmd_stop;
  reg         s_axis_cmd_valid;
  wire        s_axis_cmd_ready;
  reg  [ 7:0] s_axis_data_tdata;
  reg         s_axis_data_tvalid;
  wire        s_axis_data_tready;
  reg         s_axis_data_tlast;
  wire [ 7:0] m_axis_data_tdata;
  wire        m_axis_data_tvalid;
  reg         m_axis_data_tready;
  wire        m_axis_data_tlast;
  reg         scl_i = 1;
  wire        scl_o;
  wire        scl_t;
  reg         sda_i = 1;
  wire        sda_o;
  wire        sda_t;
  wire        busy;
  wire        bus_control;
  wire        bus_active;
  wire        missed_ack;
  reg  [15:0] prescale;
  reg         stop_on_idle;
  //--------------------------------------------------------------------------

  always #(perid / 2) clk = !clk;

  initial begin
    clk                       = 1;
    rst                       = 1;
    s_axis_cmd_address[6:0]   = 7'h5a;
    s_axis_cmd_start          = 0;
    s_axis_cmd_read           = 0;
    s_axis_cmd_write          = 0;
    s_axis_cmd_write_multiple = 0;
    s_axis_cmd_stop           = 0;
    s_axis_cmd_valid          = 0;
    s_axis_data_tdata[7:0]    = 8'd5;
    s_axis_data_tvalid        = 0;
    s_axis_data_tlast         = 0;
    m_axis_data_tready        = 0;
    prescale[15:0]            = 16'd20;
    stop_on_idle              = 0;
    #(perid * 20);
    rst = 0;
    #(perid * 200);
    s_axis_cmd_start          = 0;
    s_axis_cmd_read           = 0;
    s_axis_cmd_write          = 1;
    s_axis_cmd_write_multiple = 0;
    s_axis_cmd_stop           = 0;
    s_axis_cmd_valid          = 1;
    s_axis_data_tdata[7:0]    = 8'd5;
    s_axis_data_tvalid        = 1;
    s_axis_data_tlast         = 0;
    m_axis_data_tready        = 1;
    #(perid * 20);
    s_axis_cmd_start          = 0;
    s_axis_cmd_read           = 0;
    s_axis_cmd_write          = 0;
    s_axis_cmd_write_multiple = 0;
    s_axis_cmd_stop           = 0;
    s_axis_cmd_valid          = 0;
    s_axis_data_tdata[7:0]    = 8'd5;
    s_axis_data_tvalid        = 0;
    s_axis_data_tlast         = 0;
    m_axis_data_tready        = 1;

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
      .s_axis_data_tdata        (s_axis_data_tdata),
      .s_axis_data_tvalid       (s_axis_data_tvalid),
      .s_axis_data_tready       (s_axis_data_tready),
      .s_axis_data_tlast        (s_axis_data_tlast),
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
      .busy                     (busy),
      .bus_control              (bus_control),
      .bus_active               (bus_active),
      .missed_ack               (missed_ack),
      .prescale                 (prescale),
      .stop_on_idle             (stop_on_idle)
  );



endmodule
