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

  wire        busy;
  wire        bus_control;
  wire        bus_active;
  wire        missed_ack;
  reg  [15:0] prescale;
  reg         stop_on_idle;
  //--------------------------------------------------------------------------
  wire        scl_pin;
  wire        sda_pin;
  wire        scl_i = 1;
  wire        scl_o;
  wire        scl_t;
  wire        sda_i = 1;
  wire        sda_o;
  wire        sda_t;
  assign scl_i   = scl_pin;
  assign scl_pin = scl_t ? 1'bz : scl_o;
  assign sda_i   = sda_pin;
  assign sda_pin = sda_t ? 1'bz : sda_o;
  //--------------------------------------------------------------------------

  always #(perid / 2) clk = !clk;

  initial begin
    clk                       = 1;
    rst                       = 0;
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
    prescale[15:0]            = 16'd02;
    stop_on_idle              = 0;
    #(perid * 20);
    rst = 1;
    #(perid * 20);
    rst = 0;
    #(perid * 200);
    s_axis_cmd_start          = 0;
    s_axis_cmd_read           = 0;
    s_axis_cmd_write          = 0;
    s_axis_cmd_write_multiple = 1;
    s_axis_cmd_stop           = 1;
    s_axis_cmd_valid          = 1;
    s_axis_data_tdata[7:0]    = 8'd5;
    s_axis_data_tvalid        = 0;
    s_axis_data_tlast         = 0;
    m_axis_data_tready        = 1;
    #(perid * 2);
    s_axis_cmd_start          = 0;
    s_axis_cmd_read           = 0;
    s_axis_cmd_write          = 0;
    s_axis_cmd_write_multiple = 1;
    s_axis_cmd_stop           = 1;
    s_axis_cmd_valid          = 0;
    s_axis_data_tdata[7:0]    = 8'd5;
    s_axis_data_tvalid        = 1;
    s_axis_data_tlast         = 0;
    m_axis_data_tready        = 1;
    #(perid * 20);
    s_axis_cmd_start          = 0;
    s_axis_cmd_read           = 0;
    s_axis_cmd_write          = 0;
    s_axis_cmd_write_multiple = 1;
    s_axis_cmd_stop           = 1;
    s_axis_cmd_valid          = 0;
    s_axis_data_tdata[7:0]    = 8'd5;
    s_axis_data_tvalid        = 1;
    s_axis_data_tlast         = 0;
    m_axis_data_tready        = 1;
    #(perid * 2000);
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

  M24LC04B M24LC04B_inst (
      .A0   (A0),
      .A1   (A1),
      .A2   (A2),
      .WP   (0),
      .SDA  (sda_o),
      .SCL  (scl_o),
      .RESET(rst)
  );

endmodule
