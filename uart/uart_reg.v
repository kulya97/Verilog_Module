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


module uart_reg #(
    parameter     REG_SIZE       = 32
)(
    input                   clk                 ,
    input                   rst_n               ,
    input  [7:0]            rx_data             ,
    input                   rx_data_valid       ,
    input                   rx_frame_idle       ,
    input                   rx_interrupt        ,
    output  [REG_SIZE-1:0]  reg_data            ,
    output                  reg_ready           
);
reg [REG_SIZE-1:0]uart_reg_r;
/**************************************************************/
//接收数据
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
      uart_reg_r<=255'd0;
    end
    else if(rx_interrupt)begin
      uart_reg_r<={uart_reg_r,rx_data};
    end
    else if(rx_frame_idle)begin
      uart_reg_r<=uart_reg_r;
    end
end
/**************************************************************/
//计数
reg [7:0]data_cnt;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
      data_cnt<=8'd0;
    end
    else if(rx_interrupt)begin
      data_cnt<=data_cnt+1'd1;
    end
    else if(rx_frame_idle||data_cnt==8'd4)begin
      data_cnt<=8'd0;
    end
end
/**************************************************************/
//生成信号
reg [REG_SIZE-1:0]reg_data_r;
reg reg_ready_r;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
      reg_data_r<=255'd0;
      reg_ready_r<=1'd0;
    end
    else if(data_cnt==8'd4)begin
      reg_data_r<=uart_reg_r;
      reg_ready_r<=1'd1;
    end
    else begin
        reg_ready_r<=1'd0;
    end
end
/**************************************************************/
assign reg_ready =reg_ready_r;
assign reg_data   =reg_data_r;

endmodule
