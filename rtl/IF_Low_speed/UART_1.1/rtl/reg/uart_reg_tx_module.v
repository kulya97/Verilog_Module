`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 21:15:16
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: V1.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module uart_reg_tx_module #(
    parameter CLK_FRE   = 50,      //Mhz
    parameter BPS       = 115200,  //uart bps
    parameter REG_WIDTH = 32
) (
    input                  clk,            //system clock 50Mhz on board
    input                  rst_n,          //reset ,low active
    output                 uart_tx_port,
    input  [REG_WIDTH-1:0] uart_tx_reg,
    input                  uart_tx_valid,
    output                 uart_tx_ready
);
  /*******************************************************************/
  wire [REG_WIDTH-1:0] fifo_din;  // input wire [31 : 0] din
  wire                 fifo_wr_en;  // input wire wr_en
  wire                 fifo_rd_en;  // input wire rd_en

  wire [REG_WIDTH-1:0] fifo_dout;  // output wire [7 : 0] dout
  wire                 fifo_full;  // output wire full
  wire                 fifo_empty;  // output wire empty 
  wire                 fifo_valid;
  wire                 fifo_prog_full;

  wire                 fifo_rd_rst_busy;
  wire                 fifo_wr_rst_busy;
  /**********************************************/
  wire                 par_valid;  // input
  wire [REG_WIDTH-1:0] par_din;  // input
  wire                 ser_ready;  // input
  // Par2Ser Outputs
  wire                 par_ready;
  wire                 ser_valid;
  wire [          7:0] ser_dout;
  /**********************************************/
  wire                 tx_data_valid;
  wire                 tx_data_ready;
  wire                 tx_ack;
  wire [          7:0] tx_data;
  /*******************************************************************/
  //写tx fifo数据
  assign fifo_wr_en    = uart_tx_valid;
  assign fifo_din      = uart_tx_reg;
  assign fifo_rd_en    = par_ready && par_valid;

  assign par_valid     = !fifo_empty;
  assign par_din       = fifo_dout;
  assign ser_ready     = tx_data_ready;

  assign tx_data       = ser_dout;
  assign tx_data_valid = ser_valid;
  assign rd_en         = tx_data_valid && tx_data_ready;

  assign uart_tx_ready = !(fifo_prog_full || fifo_rd_rst_busy || fifo_wr_rst_busy);  //fifo 没满前一直读取数据到fifo中,并且需要复位完成
  /*******************************************************************/

  xpm_fifo_sync #(
      .READ_MODE          ("fwft"),     // fifo 类型 "std", "fwft"
      .FIFO_WRITE_DEPTH   (32),         // fifo 深度
      .WRITE_DATA_WIDTH   (REG_WIDTH),  // 写端口数据宽度
      .READ_DATA_WIDTH    (REG_WIDTH),  // 读端口数据宽度
      .PROG_EMPTY_THRESH  (10),         // 快空水线
      .PROG_FULL_THRESH   (10),         // 快满水线
      .RD_DATA_COUNT_WIDTH(1),          // 读侧数据统计值的位宽
      .WR_DATA_COUNT_WIDTH(1),          // 写侧数据统计值的位宽
      .USE_ADV_FEATURES   ("0707"),     //各标志位的启用控制
      .FULL_RESET_VALUE   (0),          // fifo 复位值
      .DOUT_RESET_VALUE   ("0"),        // fifo 复位值
      .CASCADE_HEIGHT     (0),          // DECIMAL
      .ECC_MODE           ("no_ecc"),   // “no_ecc”,"en_ecc"
      .FIFO_MEMORY_TYPE   ("auto"),     // 指定资源类型，auto，block，distributed
      .FIFO_READ_LATENCY  (1),          // 读取数据路径中的输出寄存器级数，如果READ_MODE=“fwft”，则唯一适用的值为0。
      .SIM_ASSERT_CHK     (0),          // 0=禁用仿真消息，1=启用仿真消息
      .WAKEUP_TIME        (0)           // 禁用sleep
  ) xpm_fifo_sync_inst (
      .rst        (!rst_n),            // 1-bit input: fifo复位
      .wr_clk     (clk),               // 1-bit input:写时钟
      .wr_en      (fifo_wr_en),        // 1-bit input:写使能
      .din        (fifo_din),          // data  input:写数据
      .rd_en      (fifo_rd_en),        // 1-bit input:读使能
      .dout       (fifo_dout),         // data  output读复位
      .data_valid (fifo_valid),        // 1-bit output:数据有效
      .wr_ack     (),                  // 1-bit output:写响应
      .prog_empty (),                  // 1-bit output:快满标志位
      .prog_full  (fifo_prog_full),    // 1-bit output:快空标志位
      .rd_rst_busy(fifo_rd_rst_busy),  // 1-bit output: 写入复位忙：活动高指示FIFO当前处于复位状态
      .wr_rst_busy(fifo_wr_rst_busy),  // 1-bit output: 读取复位忙：活动高指示FIFO当前处于复位状态
      .empty      (fifo_empty),        // 1-bit output:fifo空标志位
      .full       (fifo_full)          // 1-bit output:fifo满标志位
  );

  /*******************************************************************/
  Par2Ser #(
      .SERWIDTH  (8),
      .PARWIDTH  (REG_WIDTH),
      .Data_Order(0)
  ) u_Par2Ser (
      .clk      (clk),
      .rst_n    (rst_n),
      .par_valid(par_valid),
      .par_din  (par_din),
      .ser_ready(ser_ready),

      .par_ready(par_ready),
      .ser_valid(ser_valid),
      .ser_dout (ser_dout)
  );
  /*******************************************************************/
  uart_bit_tx_module #(
      .CLK_FRE  (CLK_FRE),
      .BAUD_RATE(BPS)
  ) u_uart_bit_tx_module (
      .clk          (clk),
      .rst_n        (rst_n),
      .tx_data      (tx_data),
      .tx_data_valid(tx_data_valid),
      .tx_data_ready(tx_data_ready),
      .tx_ack       (tx_ack),
      .tx_pin       (uart_tx_port)
  );
endmodule
