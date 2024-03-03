`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/05 03:36:56
// Design Name: 
// Module Name: tft_plot_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: de信号需要滞后h信号15个时钟才可以
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SSD1289_Plot_Module #(
    parameter size_x = 16'd240,
    parameter size_y = 16'd320
) (
    input sys_clk,
    input rst_n,

    input        pixel_de,
    input        pixel_vsync,
    input        pixel_hsync,
    input [15:0] pixel_din,

    output reg        app_valid,      //数据有效
    output reg [16:0] app_dout,       //数据
    input             sys_init_done,
    output reg        sys_plot_done
);
  /**********************************/
  localparam REG_CNT = 11;

  reg [3:0] S_STATE, S_STATE_NEXT;
  localparam S_IDLE = 0;  //空闲
  localparam S_WAIT_H = 1;
  localparam S_INIT = 2;  //判断命令/数据
  localparam S_PLOT = 3;  //写入
  localparam S_WRITE = 4;
  localparam S_DONE = 5;
  /***************行转移使能打拍*******************/
  wire plot_en;
  reg plot_en_d0, plot_en_d1;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      plot_en_d0 <= 1'b0;
      plot_en_d1 <= 1'b0;
    end else begin
      plot_en_d0 <= pixel_hsync;
      plot_en_d1 <= plot_en_d0;
    end
  end
  assign plot_en = plot_en_d0 && !plot_en_d1;
  /***************帧转移使能打拍*******************/
  wire rst_en;
  reg rst_en_d0, rst_en_d1;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      rst_en_d0 <= 1'b0;
      rst_en_d1 <= 1'b0;
    end else begin
      rst_en_d0 <= pixel_vsync;
      rst_en_d1 <= rst_en_d0;
    end
  end
  assign rst_en = rst_en_d0 && !rst_en_d1;
  /***************开窗参数锁存****************************************/
  reg [15:0] h_pos;
  reg [15:0] v_pos_start;
  reg [15:0] v_pos_end;
  reg [15:0] x_counter;
  reg [15:0] y_counter;
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
      h_pos       <= 16'b0;
      v_pos_start <= 16'b0;
      v_pos_end   <= size_x - 1'd1;
      x_counter   <= 16'b0;
      y_counter   <= size_x - 1'd1;
    end else if (rst_en) begin
      h_pos       <= 16'b0;
      v_pos_start <= v_pos_start;
      v_pos_end   <= v_pos_end;
      x_counter   <= 16'b0;
      y_counter   <= y_counter;
    end else if (plot_en) begin
      h_pos       <= h_pos + 16'h0101;  //变化
      v_pos_start <= 16'b0;  //恒为0
      v_pos_end   <= size_x - 1'd1;  //
      x_counter   <= x_counter + 1'd1;  //变化
      y_counter   <= size_x - 1'd1;  //
    end else begin
      h_pos       <= h_pos;
      v_pos_start <= v_pos_start;
      v_pos_end   <= v_pos_end;
      x_counter   <= x_counter;
      y_counter   <= y_counter;
    end
  end
  /***************开窗寄存器递增寻址****************************************/
  reg [7:0] plot_reg_cnt;
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) plot_reg_cnt <= 8'b0;
    else if (S_STATE == S_INIT) plot_reg_cnt <= 8'b0;
    else if (S_STATE == S_PLOT) plot_reg_cnt <= plot_reg_cnt + 1'b1;
    else plot_reg_cnt <= 8'b0;
  end
  /***************数据计数****************************************/
  reg [15:0] data_cnt;
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) data_cnt <= 16'd0;
    else if (S_STATE == S_WRITE && pixel_de) data_cnt <= data_cnt + 1'b1;
    else data_cnt <= 16'd0;
  end
  /***************行计数****************************************/
  reg [15:0] line_cnt;
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) line_cnt <= 16'd0;
    else if (rst_en) line_cnt <= 16'd0;
    else if (S_STATE == S_INIT) line_cnt <= line_cnt + 1'b1;
    else line_cnt <= line_cnt;
  end
  /********************状态机***********************************/
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) S_STATE <= S_IDLE;
    else S_STATE <= S_STATE_NEXT;
  end
  reg [31:0] clk_cnt;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) clk_cnt <= 32'd0;
    else if (S_STATE != S_STATE_NEXT) clk_cnt <= 32'd0;
    else clk_cnt <= clk_cnt + 1'd1;
  end
  /**************************/
  always @(*) begin
    case (S_STATE)
      S_IDLE: begin
        if (rst_en && sys_init_done) S_STATE_NEXT = S_WAIT_H;  //lcd初始完成，并且检测到帧头，进入行转移
        else S_STATE_NEXT = S_IDLE;
      end
      S_WAIT_H: begin
        if (plot_en) S_STATE_NEXT = S_INIT;  //检测到有效信号，进入开窗
        else S_STATE_NEXT = S_WAIT_H;
      end
      S_INIT: begin
        if (line_cnt == size_y) S_STATE_NEXT = S_IDLE;  //如果行数到设定值，直接结束
        else S_STATE_NEXT = S_PLOT;
      end
      S_PLOT: begin
        if (plot_reg_cnt == REG_CNT - 1'd1) S_STATE_NEXT = S_WRITE;  //开窗完成后写入数据
        else S_STATE_NEXT = S_PLOT;
      end
      S_WRITE: begin
        if (rst_en) S_STATE_NEXT = S_WAIT_H;  //新的一帧到来，直接跳到空闲状态，清空行计数，等待新行
        else if (plot_en) S_STATE_NEXT = S_INIT;  //新行到来时，重新跳转到开窗状态
        else if (data_cnt == size_x - 1'd1) S_STATE_NEXT = S_WAIT_H;  //数据量到设定值，到下一行     !!!!这个可以直接到init状态
        else S_STATE_NEXT = S_WRITE;
      end
      default: S_STATE_NEXT = S_IDLE;
    endcase
  end
  /**************************开窗完成信号*****************************/
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) sys_plot_done <= 1'b0;
    else if (S_STATE == S_PLOT) sys_plot_done <= 1'b0;
    else sys_plot_done <= 1'b1;
  end
  /**************************数据有效*****************************/
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) app_valid <= 1'b0;
    else if (S_STATE == S_PLOT || (S_STATE == S_WRITE && pixel_de)) app_valid <= 1'b1;
    else app_valid <= 1'b0;
  end
  /**************************寄存器输出*****************************/
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) app_dout <= 17'b0;
    else if (S_STATE == S_PLOT) begin
      case (plot_reg_cnt)
        8'd0: app_dout <= {1'b0, 16'h0044};
        8'd1: app_dout <= {1'b1, h_pos[15:0]};
        8'd2: app_dout <= {1'b0, 16'h0045};
        8'd3: app_dout <= {1'b1, v_pos_start[15:0]};
        8'd4: app_dout <= {1'b0, 16'h0046};  //
        8'd5: app_dout <= {1'b1, v_pos_end[15:0]};
        8'd6: app_dout <= {1'b0, 16'h004e};
        8'd7: app_dout <= {1'b1, x_counter[15:0]};
        8'd8: app_dout <= {1'b0, 16'h004f};
        8'd9: app_dout <= {1'b1, y_counter[15:0]};  //
        8'd10: app_dout <= {1'b0, 16'h0022};  //HSTART 水平起始位置
        //只读存储器,防止在case中没有列举的情况，之前的寄存器被重复改写
        default: app_dout <= {1'b1, 16'hffFF};
      endcase
    end else if (S_STATE == S_WRITE) begin
      app_dout <= {1'b1, pixel_din[15:0]};
    end else begin
      app_dout <= {1'b1, 16'hffFF};
    end
  end
endmodule
