`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 21:15:15
// Design Name: 
// Module Name: uart_reg
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


module uart_rx_reg_module #(
    parameter REG_SIZE = 32
) (
    input                 clk,
    input                 rst_n,
    input  [         7:0] rx_data,
    input                 rx_data_valid,
    input                 rx_frame_ack,
    input                 rx_ack,
    output [REG_SIZE-1:0] reg_data,
    output                reg_ready
);
  reg [REG_SIZE-1:0] uart_reg_r;
  /**************************************************************/
  //接收数据
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      uart_reg_r <= 'd0;
    end else if (rx_ack) begin
      uart_reg_r <= {uart_reg_r, rx_data};
    end else if (rx_frame_ack) begin
      uart_reg_r <= uart_reg_r;
    end
  end
  /**************************************************************/
  //计数
  reg [15:0] data_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_cnt <= 'd0;
    end else if (rx_ack) begin
      data_cnt <= data_cnt + 'd8;
    end else if (rx_frame_ack || data_cnt == REG_SIZE) begin
      data_cnt <= 'd0;
    end
  end
  /**************************************************************/
  //生成信号
  reg [REG_SIZE-1:0] reg_data_r;
  reg                reg_ready_r;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reg_data_r  <= 'd0;
      reg_ready_r <= 'd0;
    end else if (data_cnt == REG_SIZE) begin
      reg_data_r  <= uart_reg_r;
      reg_ready_r <= 'd1;
    end else begin
      reg_ready_r <= 'd0;
    end
  end
  /**************************************************************/
  assign reg_ready = reg_ready_r;
  assign reg_data  = reg_data_r;

endmodule
