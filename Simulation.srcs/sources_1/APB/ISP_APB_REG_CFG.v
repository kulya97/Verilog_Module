`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/17 16:54:48
// Design Name: 
// Module Name: ISP_APB_REG_CFG
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


module ISP_APB_REG_CFG #(
    parameter CMD_WITDH = 32 + 32 + 2
) (
    input                      i_clk,
    input                      i_rstn,
    output reg                 o_valid,
    input                      i_ready,
    output     [CMD_WITDH-1:0] o_data
);
  localparam REG_NUM = 100;
  reg [9:0] init_reg_cnt;

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) o_valid <= 'd0;
    else if (init_reg_cnt <= REG_NUM - 1) o_valid <= 'd1;
    else o_valid <= 'd0;
  end
  /************************************************/
  //-- 握手成功发送下一个数据
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) init_reg_cnt <= 'd0;
    else if (o_valid && i_ready) init_reg_cnt <= init_reg_cnt + 1'd1;
    else init_reg_cnt <= init_reg_cnt;
  end
  //-- 表
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
    end else begin
      case (init_reg_cnt)
        10'd000: ;
        default: ;
      endcase
    end
  end
endmodule
