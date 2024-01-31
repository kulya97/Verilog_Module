`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/28 18:10:20
// Design Name: 
// Module Name: ui2axi_stream_master
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
    // User parameters ends
    parameter integer C_M_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M_START_COUNT = 32
) (
    //-- Users to add ports here
    input                                   i_ui_dvld,
    input  [      C_M_AXIS_TDATA_WIDTH-1:0] i_ui_data,
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
  reg  [                       1:0] s_state_nxt;
  reg  [                       1:0] s_state_cur;
  //---------------------------------------------------------------------------------------
  //-- 
  //---------------------------------------------------------------------------------------  
  reg  [     WAIT_COUNT_BITS-1 : 0] count;
  reg                               r_axis_dvld_d1;
  reg  [               bit_num-1:0] r_axis_tdata_cnt;
  wire [C_M_AXIS_TDATA_WIDTH-1 : 0] r_axis_tdata;
  reg                               r_axis_tlast_d1;

  wire                              wr_rst_busy;
  wire                              rd_rst_busy;
  wire                              empty;
  wire                              full;
  //---------------------------------------------------------------------------------------
  //-- 
  //---------------------------------------------------------------------------------------  
  assign M_AXIS_TDATA  = r_axis_tdata;

  assign M_AXIS_TLAST  = r_axis_tlast_d1;
  assign M_AXIS_TVALID = !empty;
  assign o_ui_drdy     = !full;
  assign wr_en         = o_ui_drdy & i_ui_dvld && (!wr_rst_busy);
  assign rd_en         = M_AXIS_TREADY & M_AXIS_TVALID && (!rd_rst_busy);

  assign M_AXIS_TSTRB  = {(C_M_AXIS_TDATA_WIDTH / 8) {1'b1}};
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
      if (M_AXIS_TREADY & M_AXIS_TVALID && r_axis_tdata_cnt == NUMBER_OF_OUTPUT_WORDS - 1) s_state_nxt = IDLE;
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
    else if (s_state_cur == SEND_STREAM && M_AXIS_TREADY & M_AXIS_TVALID)  //当FIFO读取信号被启用时，读取指针在每次从FIFO读取之后递增。                          
      r_axis_tdata_cnt <= r_axis_tdata_cnt + 1;
    else if (s_state_cur != SEND_STREAM) r_axis_tdata_cnt <= 0;
    else r_axis_tdata_cnt <= r_axis_tdata_cnt;
  end
  //-- tlast out
  always @(posedge M_AXIS_ACLK) begin
    if (!M_AXIS_ARESETN) r_axis_tlast_d1 <= 0;
    else if (s_state_cur == SEND_STREAM && M_AXIS_TREADY & M_AXIS_TVALID && r_axis_tdata_cnt == NUMBER_OF_OUTPUT_WORDS - 1) r_axis_tlast_d1 <= 1'b1;
    else r_axis_tlast_d1 <= 0;
  end

  // Add user logic here



  xpm_fifo_sync #(
      .READ_MODE          ("fwft"),    // fifo 类型 "std", "fwft"
      .FIFO_WRITE_DEPTH   (32),        // fifo 深度
      .WRITE_DATA_WIDTH   (32),        // 写端口数据宽度
      .READ_DATA_WIDTH    (32),        // 读端口数据宽度
      .PROG_EMPTY_THRESH  (10),        // 快空水线
      .PROG_FULL_THRESH   (10),        // 快满水线
      .RD_DATA_COUNT_WIDTH(1),         // 读侧数据统计值的位宽
      .WR_DATA_COUNT_WIDTH(1),         // 写侧数据统计值的位宽
      .USE_ADV_FEATURES   ("0707"),    //各标志位的启用控制
      .FULL_RESET_VALUE   (0),         // fifo 复位值
      .DOUT_RESET_VALUE   ("0"),       // fifo 复位值
      .CASCADE_HEIGHT     (0),         // DECIMAL
      .ECC_MODE           ("no_ecc"),  // “no_ecc”,"en_ecc"
      .FIFO_MEMORY_TYPE   ("auto"),    // 指定资源类型，auto，block，distributed
      .FIFO_READ_LATENCY  (0),         // 读取数据路径中的输出寄存器级数，如果READ_MODE=“fwft”，则唯一适用的值为0。
      .SIM_ASSERT_CHK     (0),         // 0=禁用仿真消息，1=启用仿真消息
      .WAKEUP_TIME        (0)          // 禁用sleep
  ) xpm_fifo_sync_inst (
      .rst          (!M_AXIS_ARESETN),  // 1-bit input: fifo复位
      .wr_clk       (M_AXIS_ACLK),      // 1-bit input:写时钟
      .wr_en        (wr_en),            // 1-bit input:写使能
      .din          (i_ui_data),        // data  input:写数据
      .rd_en        (rd_en),            // 1-bit input:读使能
      .dout         (r_axis_tdata),     // data  output读复位
      .data_valid   (),                 // 1-bit output:数据有效
      .wr_ack       (),                 // 1-bit output:写响应
      .empty        (empty),            // 1-bit output:fifo空标志位
      .full         (full),             // 1-bit output:fifo满标志位
      .rd_rst_busy  (rd_rst_busy),      // 1-bit output: 写入复位忙：活动高指示FIFO当前处于复位状态
      .wr_rst_busy  (wr_rst_busy),      // 1-bit output: 读取复位忙：活动高指示FIFO当前处于复位状态
      .injectsbiterr(1'b0),
      .injectdbiterr(1'b0),
      .sleep        (0)                 // 1-bit input: 动态省电：如果睡眠为高，则内存/ffo块处于省电模式。
  );
  // User logic ends

endmodule

