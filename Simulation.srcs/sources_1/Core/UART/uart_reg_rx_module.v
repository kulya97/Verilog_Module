`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 21:15:15
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
    input                      clk,       //system clock 50Mhz on board
    input                      rst_n,         //reset ,low active
    input                      uart_rx,
    output     [REG_WIDTH-1:0] uart_rx_reg,   //uart reg 
    output reg                 uart_rx_ack  //if update ready=1
);
  /*******************************************************************/

  wire       rx_data_valid;
  wire       rx_data_ready;
  wire       rx_ack;
  wire       rx_frame_ack;
  wire [7:0] rx_data;
  /***********************************************************************/
  //开启接收数据
  assign rx_data_ready = 1'b1;
  /***********************************************************************/
  uart_bit_rx_module #(
      .CLK_FRE(CLK_FRE),
      .BAUD_RATE(BPS),
      .IDLE_CYCLE(IDLE_CYCLE)
  ) uart_rx_inst (
      .clk          (clk),
      .rst_n        (rst_n),
      .rx_data      (rx_data),
      .rx_data_valid(rx_data_valid),
      .rx_data_ready(rx_data_ready),
      .rx_frame_ack (rx_frame_ack),
      .rx_ack       (rx_ack),
      .rx_pin       (uart_rx)
  );

  wire rx_fifo_empty;
  uart_rx_bit2reg_module #(  //下一步把定时改在里面，或这把他完全模块化
      .WIDTH(REG_WIDTH),
      .DEPTH(128)
  ) u_uart_rx_reg_module (
      .clk   (clk),
      .rst_n (rst_n),
      .wr_en (rx_ack),
      .wr_rst(rx_frame_ack),
      .din   (rx_data[7:0]),
      .rd_en (!rx_fifo_empty),

      .dout    (uart_rx_reg[REG_WIDTH-1:0]),
      .full    (),
      .empty   (rx_fifo_empty),
      .fifo_cnt()
  );

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) uart_rx_ack <= 1'b0;
    else uart_rx_ack <= !rx_fifo_empty;
  end

endmodule
