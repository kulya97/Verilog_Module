`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/28 18:10:20
// Design Name: 
// Module Name: audio2axi_stream_master
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

module ui2axi_stream_master #(
    // Users to add parameters here
    parameter integer UI_FRAME_SIZE = 1024,
    parameter integer UI_DATA_WIDTH = 16,
    // User parameters ends
    parameter integer C_M_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M_START_COUNT = 32
) (
    //-- Users to add ports here
    input                                   i_ui_dvld,
    input  [             UI_DATA_WIDTH-1:0] i_ui_data,
    output                                  o_ui_drdy,
    output                                  o_ui_dlast,
    //-- Global ports
    input                                   M_AXIS_ACLK,
    input                                   M_AXIS_ARESETN,
    output                                  M_AXIS_TVALID,
    output [    C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
    output [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
    output                                  M_AXIS_TLAST,
    input                                   M_AXIS_TREADY
);
  //---------------------------------------------------------------------------------------
  //-- 参数定义
  //---------------------------------------------------------------------------------------   
  //-- 一帧数据长度                                             
  localparam NUMBER_OF_OUTPUT_WORDS = UI_FRAME_SIZE;
  localparam UI2AXI_WIDTH = C_M_AXIS_TDATA_WIDTH - UI_DATA_WIDTH;
  function integer clogb2(input integer bit_depth);
    begin
      for (clogb2 = 0; bit_depth > 0; clogb2 = clogb2 + 1) bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer WAIT_COUNT_BITS = clogb2(C_M_START_COUNT - 1);
  localparam bit_num = clogb2(NUMBER_OF_OUTPUT_WORDS);
  //--------------------------------------------------------------------------------------- 
  //-- 状态机
  //---------------------------------------------------------------------------------------                                   
  parameter [1:0] IDLE = 2'b00;
  parameter [1:0] INIT_COUNTER = 2'b01;
  parameter [1:0] SEND_STREAM = 2'b10;
  reg [                       1:0] s_state_nxt;
  reg [                       1:0] s_state_cur;
  //---------------------------------------------------------------------------------------
  //-- 
  //---------------------------------------------------------------------------------------  
  reg [     WAIT_COUNT_BITS-1 : 0] count;
  reg                              r_axis_dvld_d1;
  reg [               bit_num-1:0] r_axis_tdata_cnt;
  reg [C_M_AXIS_TDATA_WIDTH-1 : 0] r_axis_tdata_d1;
  reg                              r_axis_tlast_d1;
  //---------------------------------------------------------------------------------------
  //-- 
  //---------------------------------------------------------------------------------------  
  assign M_AXIS_TVALID = r_axis_dvld_d1;
  assign M_AXIS_TDATA  = r_axis_tdata_d1;
  assign M_AXIS_TLAST  = r_axis_tlast_d1;
  assign M_AXIS_TSTRB  = {(C_M_AXIS_TDATA_WIDTH / 8) {1'b1}};

  assign o_ui_drdy     = (s_state_cur == SEND_STREAM);
  assign o_ui_dlast    = r_axis_tlast_d1;
  //---------------------------------------------------------------------------------------
  //-- 
  //---------------------------------------------------------------------------------------    
  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) s_state_cur <= IDLE;
    else s_state_cur <= s_state_nxt;
  end

  always @(*) begin
    s_state_nxt = IDLE;
    case (s_state_cur)
      IDLE: s_state_nxt = INIT_COUNTER;
      INIT_COUNTER:  //初始化计数
      if (count >= C_M_START_COUNT) s_state_nxt = SEND_STREAM;
      else s_state_nxt = INIT_COUNTER;
      SEND_STREAM:  //当主设备驱动FIFO的输出tdata并且从设备已完成S_AXIS_DATA的存储时，流式传输主设备功能开始                    
      if (o_ui_drdy && i_ui_dvld && r_axis_tdata_cnt == NUMBER_OF_OUTPUT_WORDS - 1) s_state_nxt = IDLE;
      else s_state_nxt = SEND_STREAM;
    endcase
  end


  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) count <= 'd0;
    else if (s_state_cur == INIT_COUNTER) count <= count + 1'b1;
    else count <= 'd0;
  end

  //---------------------------------------------------------------------------------------
  //-- ui data out
  //---------------------------------------------------------------------------------------   
  //-- cnts 
  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) r_axis_tdata_cnt <= 0;
    else if (s_state_cur == SEND_STREAM && o_ui_drdy && i_ui_dvld)  //当FIFO读取信号被启用时，读取指针在每次从FIFO读取之后递增。                          
      r_axis_tdata_cnt <= r_axis_tdata_cnt + 1;
    else if (s_state_cur != SEND_STREAM) r_axis_tdata_cnt <= 0;
    else r_axis_tdata_cnt <= r_axis_tdata_cnt;
  end
  //-- data out
  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) r_axis_tdata_d1 <= 0;
    else if (s_state_cur == SEND_STREAM && o_ui_drdy && i_ui_dvld) r_axis_tdata_d1 <= {{(UI2AXI_WIDTH - 1) {1'b0}}, i_ui_data[UI_DATA_WIDTH-1:0]};
    else r_axis_tdata_d1 <= 0;
  end
  //-- vld out
  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) r_axis_dvld_d1 <= 0;
    else if (s_state_cur == SEND_STREAM && o_ui_drdy && i_ui_dvld) r_axis_dvld_d1 <= 1'b1;
    else r_axis_dvld_d1 <= 0;
  end
  //-- tlast out
  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) r_axis_tlast_d1 <= 0;
    else if (s_state_cur == SEND_STREAM && o_ui_drdy && i_ui_dvld && r_axis_tdata_cnt == NUMBER_OF_OUTPUT_WORDS - 1) r_axis_tlast_d1 <= 1'b1;
    else r_axis_tlast_d1 <= 0;
  end

  // Add user logic here

  // User logic ends

endmodule

