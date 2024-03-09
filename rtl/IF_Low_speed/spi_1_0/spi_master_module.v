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
      .READ_MODE          ("std"),       // fifo ���� "std", "fwft"
      .FIFO_WRITE_DEPTH   (ADDR_WIDTH),  // fifo ���
      .WRITE_DATA_WIDTH   (REG_WIDTH),   // д�˿����ݿ��
      .READ_DATA_WIDTH    (REG_WIDTH),   // ���˿����ݿ��
      .PROG_EMPTY_THRESH  (10),          // ���ˮ��
      .PROG_FULL_THRESH   (10),          // ����ˮ��
      .RD_DATA_COUNT_WIDTH(1),           // ��������ͳ��ֵ��λ��
      .WR_DATA_COUNT_WIDTH(1),           // д������ͳ��ֵ��λ��
      .USE_ADV_FEATURES   ("0707"),      //����־λ�����ÿ���
      .FULL_RESET_VALUE   (0),           // fifo ��λֵ
      .DOUT_RESET_VALUE   ("0"),         // fifo ��λֵ
      .CASCADE_HEIGHT     (0),           // DECIMAL
      .ECC_MODE           ("no_ecc"),    // ��no_ecc��,"en_ecc"
      .FIFO_MEMORY_TYPE   ("auto"),      // ָ����Դ���ͣ�auto��block��distributed
      .FIFO_READ_LATENCY  (1),           // ��ȡ����·���е�����Ĵ������������READ_MODE=��fwft������Ψһ���õ�ֵΪ0��
      .SIM_ASSERT_CHK     (0),           // 0=���÷�����Ϣ��1=���÷�����Ϣ
      .WAKEUP_TIME        (0)            // ����sleep
  ) xpm_fifo_sync_inst (
      .rst       (!rst_n),                    // 1-bit input: fifo��λ
      .wr_clk    (clk),                       // 1-bit input:дʱ��
      .wr_en     (app_req),                   // 1-bit input:дʹ��
      .din       (app_din[REG_WIDTH-1:0]),    // data  input:д����
      .rd_en     (fifo_rden),                 // 1-bit input:��ʹ��
      .dout      (fifo_dout[REG_WIDTH-1:0]),  // data  output����λ
      .data_valid(data_valid),                // 1-bit output:������Ч
      .wr_ack    (wr_ack),                    // 1-bit output:д��Ӧ
      .empty     (fifo_empty),                // 1-bit output:fifo�ձ�־λ
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
