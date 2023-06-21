`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 16:05:56
// Design Name: 
// Module Name: spi_master_module
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


module spi_master_module #(
    parameter REG_WIDTH = 16
) (
    input                  clk,
    input                  rst_n,
    output                 SPI_CS,
    output                 SPI_MOSI,
    input                  SPI_MISO,
    output                 SPI_SCLK,
    input  [REG_WIDTH-1:0] app_din,
    input                  app_req,
    output                 app_ack
);
  wire                 fifo_rden;
  wire                 fifo_full;
  wire                 fifo_empty;

  wire [REG_WIDTH-1:0] fifo_dout;
  localparam ADDR_WIDTH = 128;
  xpm_fifo_sync #(
      .READ_MODE          ("std"),       // fifo 类型 "std", "fwft"
      .FIFO_WRITE_DEPTH   (ADDR_WIDTH),  // fifo 深度
      .WRITE_DATA_WIDTH   (REG_WIDTH),   // 写端口数据宽度
      .READ_DATA_WIDTH    (REG_WIDTH),   // 读端口数据宽度
      .PROG_EMPTY_THRESH  (10),          // 快空水线
      .PROG_FULL_THRESH   (10),          // 快满水线
      .RD_DATA_COUNT_WIDTH(1),           // 读侧数据统计值的位宽
      .WR_DATA_COUNT_WIDTH(1),           // 写侧数据统计值的位宽
      .USE_ADV_FEATURES   ("0707"),      //各标志位的启用控制
      .FULL_RESET_VALUE   (0),           // fifo 复位值
      .DOUT_RESET_VALUE   ("0"),         // fifo 复位值
      .CASCADE_HEIGHT     (0),           // DECIMAL
      .ECC_MODE           ("no_ecc"),    // “no_ecc”,"en_ecc"
      .FIFO_MEMORY_TYPE   ("auto"),      // 指定资源类型，auto，block，distributed
      .FIFO_READ_LATENCY  (1),           // 读取数据路径中的输出寄存器级数，如果READ_MODE=“fwft”，则唯一适用的值为0。
      .SIM_ASSERT_CHK     (0),           // 0=禁用仿真消息，1=启用仿真消息
      .WAKEUP_TIME        (0)            // 禁用sleep
  ) xpm_fifo_sync_inst (
      .rst       (!rst_n),                    // 1-bit input: fifo复位
      .wr_clk    (clk),                       // 1-bit input:写时钟
      .wr_en     (app_req),                   // 1-bit input:写使能
      .din       (app_din[REG_WIDTH-1:0]),    // data  input:写数据
      .rd_en     (fifo_rden),                 // 1-bit input:读使能
      .dout      (fifo_dout[REG_WIDTH-1:0]),  // data  output读复位
      .data_valid(data_valid),                // 1-bit output:数据有效
      .wr_ack    (wr_ack),                    // 1-bit output:写响应
      .empty     (fifo_empty),                // 1-bit output:fifo空标志位
      .full      (fifo_full)
  );

  wire wr_ready;
  wire wr_valid;

  assign wr_valid  = !fifo_empty;
  assign fifo_rden = wr_valid && wr_ready;
  localparam CHANNEL = 1;
  u_spi_master_core u_spi_master_core (
      .clk       (clk),
      .rst_n     (rst_n),
      .wr_channel(1),
      .SPI_MISO  (SPI_MISO),
      .SPI_CS    (SPI_CS),
      .SPI_SCLK  (SPI_SCLK),
      .SPI_MOSI  (SPI_MOSI),


      .wr_ready(wr_ready),
      .data_in (fifo_dout[REG_WIDTH-1:0]),

      .wr_valid(wr_valid),
      .data_out()
  );

endmodule
