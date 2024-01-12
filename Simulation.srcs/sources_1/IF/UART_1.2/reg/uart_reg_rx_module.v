`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 21:15:22
// Design Name: 
// Module Name: 
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
module uart_reg_rx_module #(
    parameter CLK_FRE    = 50,      //Mhz
    parameter BPS        = 115200,  //uart bps
    parameter IDLE_CYCLE = 20,      //idle time
    parameter REG_WIDTH  = 32
) (
    input                  clk,            //system clock 50Mhz on board
    input                  rst_n,          //reset ,low active
    input                  uart_rx_port,
    output [REG_WIDTH-1:0] uart_rx_data,   //uart reg 
    input                  uart_rx_ready,
    output                 uart_rx_valid
);
  /*******************************************************************/

  wire       rx_data_valid;
  wire       rx_data_ready;
  wire       rx_ack;
  wire       rx_frame_ack;
  wire [7:0] rx_data;
  //开启接收数据
  assign rx_data_ready = uart_rx_ready;

  /****************************************/
  uart_bit_rx_module #(
      .CLK_FRE(CLK_FRE),
      .BAUD_RATE(BPS),
      .IDLE_CYCLE(IDLE_CYCLE)
  ) u_uart_bit_rx_module (
      .clk          (clk),
      .rst_n        (rst_n),
      .rx_data      (rx_data),
      .rx_data_valid(rx_data_valid),
      .rx_data_ready(rx_data_ready),
      .rx_frame_ack (rx_frame_ack),
      .rx_ack       (rx_ack),
      .rx_pin       (uart_rx_port)
  );
  /*******************************************************************/
  wire                 reg_dack;
  wire [REG_WIDTH-1:0] reg_dout;
  /****************************************/

  Ser2Par #(
      .SERWIDTH(8),
      .PARWIDTH(REG_WIDTH)
  ) u_bit2reg_module (
      .clk  (clk),
      .rst_n(rst_n && !rx_frame_ack),
      .wr_en(rx_ack),
      .din  (rx_data[7:0]),

      .dack(reg_dack),
      .dout(reg_dout[REG_WIDTH-1:0])
  );
  wire empty;
  xpm_fifo_sync #(
      .READ_MODE          ("fwft"),     // fifo 类型 "std", "fwft"
      .FIFO_WRITE_DEPTH   (16),         // fifo 深度
      .WRITE_DATA_WIDTH   (REG_WIDTH),  // 写端口数据宽度
      .READ_DATA_WIDTH    (REG_WIDTH),  // 读端口数据宽度
      .PROG_EMPTY_THRESH  (5),          // 快空水线
      .PROG_FULL_THRESH   (5),          // 快满水线
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
      .rst       (!rst_n),         // 1-bit input: fifo复位
      .wr_clk    (clk),            // 1-bit input:写时钟
      .wr_en     (reg_dack),       // 1-bit input:写使能
      .din       (reg_dout),       // data  input:写数据
      .rd_en     (uart_rx_ready),  // 1-bit input:读使能
      .dout      (uart_rx_data),   // data  output读复位
      .data_valid(),               // 1-bit output:数据有效
      .empty     (empty),          // 1-bit output:fifo空标志位
      .full      (),               // 1-bit output:fifo满标志位
      .prog_empty(),               // 1-bit output:快满标志位
      .prog_full ()                // 1-bit output:快空标志位
  );
  assign uart_rx_valid = !empty;
endmodule
