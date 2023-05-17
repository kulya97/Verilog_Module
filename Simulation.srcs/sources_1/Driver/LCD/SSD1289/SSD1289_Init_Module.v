`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/05 01:53:10
// Design Name: 
// Module Name: SSD1289_Init_Module
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


module SSD1289_Init_Module (
    input             sys_clk,
    input             rst_n,
    output reg        bus_RST,
    output reg        bus_CS,
    output reg [16:0] app_init_dout,   //数据
    output reg        app_init_valid,  //数据有效
    output reg        app_init_done    //完成
);
  parameter app_delay = 32'd20_000_00;
  localparam REG_CNT = 39;
  /**********************************/
  reg [7:0] init_reg_cnt;
  /**********************************/
  reg [3:0] S_STATE, S_STATE_NEXT;
  localparam S_IDLE = 0;  //空闲
  localparam S_WAIT1 = 1;
  localparam S_SYSRST = 2;
  localparam S_WAIT2 = 3;
  localparam S_REGRST = 4;
  localparam S_WAIT3 = 5;
  localparam S_INIT = 6;  //判断命令/数据
  localparam S_DONE = 7;  //写入

  /**************************/
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) S_STATE <= S_IDLE;
    else S_STATE <= S_STATE_NEXT;
  end
  /**************************/
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
        S_STATE_NEXT = S_WAIT1;
      end
      S_WAIT1: begin
        if (clk_cnt == app_delay) S_STATE_NEXT = S_SYSRST;
        else S_STATE_NEXT = S_WAIT1;
      end
      S_SYSRST: begin
        S_STATE_NEXT = S_WAIT2;
      end
      S_WAIT2: begin
        if (clk_cnt == app_delay) S_STATE_NEXT = S_REGRST;
        else S_STATE_NEXT = S_WAIT2;
      end
      S_REGRST: begin
        if (init_reg_cnt == 8'd7) S_STATE_NEXT = S_WAIT3;
        else S_STATE_NEXT = S_REGRST;
      end
      S_WAIT3: begin
        if (clk_cnt == app_delay) S_STATE_NEXT = S_INIT;
        else S_STATE_NEXT = S_WAIT3;
      end
      S_INIT: begin
        if (init_reg_cnt == REG_CNT) S_STATE_NEXT = S_DONE;
        else S_STATE_NEXT = S_INIT;
      end
      S_DONE: begin
        S_STATE_NEXT = S_DONE;
      end
      default: S_STATE_NEXT = S_IDLE;
    endcase
  end
  /*******************************************************/
  //复位信号
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) bus_RST <= 1'b0;
    else if (S_STATE == S_SYSRST) bus_RST <= 1'b1;
    else bus_RST <= bus_RST;
  end
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) bus_CS <= 1'b1;
    else if (S_STATE == S_SYSRST) bus_CS <= 1'b0;
    else bus_CS <= bus_CS;
  end
  /******************************************/
  //复位完成标志位
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) app_init_done <= 1'b0;
    else if (S_STATE == S_DONE) app_init_done <= 1'b1;
    else app_init_done <= app_init_done;
  end
  /*******************************************************/
  //数据有效
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) app_init_valid <= 1'b0;
    else if (S_STATE == S_REGRST || S_STATE == S_INIT) app_init_valid <= 1'b1;
    else app_init_valid <= 1'b0;
  end
  //寄存器递增寻址
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) init_reg_cnt <= 8'b0;
    else if (S_STATE == S_REGRST || S_STATE == S_INIT) init_reg_cnt <= init_reg_cnt + 1'b1;
    else init_reg_cnt <= init_reg_cnt;
  end
  //配置寄存器地址与数据
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) app_init_dout <= 17'b0;
    else begin
      case (init_reg_cnt)
        8'd0: app_init_dout <= {1'b0, 16'h0007};
        8'd1: app_init_dout <= {1'b1, 16'h0021};
        8'd2: app_init_dout <= {1'b0, 16'h0000};
        8'd3: app_init_dout <= {1'b1, 16'h0001};
        8'd4: app_init_dout <= {1'b0, 16'h0007};
        8'd5: app_init_dout <= {1'b1, 16'h0023};
        8'd6: app_init_dout <= {1'b0, 16'h0010};
        8'd7: app_init_dout <= {1'b1, 16'h0000};
        //delay
        8'd8: app_init_dout <= {1'b0, 16'h0007};
        8'd9: app_init_dout <= {1'b1, 16'h0033};
        8'd10: app_init_dout <= {1'b0, 16'h0011};
        8'd11: app_init_dout <= {1'b1, 16'h6058};  //6030
        8'd12: app_init_dout <= {1'b0, 16'h0002};
        8'd13: app_init_dout <= {1'b1, 16'h1000};
        8'd14: app_init_dout <= {1'b0, 16'h0002};
        8'd15: app_init_dout <= {1'b1, 16'h0600};
        8'd16: app_init_dout <= {1'b0, 16'h0001};
        8'd17: app_init_dout <= {1'b1, 16'h693f};  //左右翻转
        8'd18: app_init_dout <= {1'b0, 16'h0025};
        8'd19: app_init_dout <= {1'b1, 16'hef00};  //帧率控制
        8'd20: app_init_dout <= {1'b0, 16'h0030};
        8'd21: app_init_dout <= {1'b1, 16'h0007};
        8'd22: app_init_dout <= {1'b0, 16'h0031};
        8'd23: app_init_dout <= {1'b1, 16'h0302};
        8'd24: app_init_dout <= {1'b0, 16'h0032};
        8'd25: app_init_dout <= {1'b1, 16'h0105};
        8'd26: app_init_dout <= {1'b0, 16'h0033};
        8'd27: app_init_dout <= {1'b1, 16'h0206};
        8'd28: app_init_dout <= {1'b0, 16'h0034};
        8'd29: app_init_dout <= {1'b1, 16'h0808};
        8'd30: app_init_dout <= {1'b0, 16'h0035};
        8'd31: app_init_dout <= {1'b1, 16'h0206};
        8'd32: app_init_dout <= {1'b0, 16'h0036};
        8'd33: app_init_dout <= {1'b1, 16'h0504};
        8'd34: app_init_dout <= {1'b0, 16'h0037};
        8'd35: app_init_dout <= {1'b1, 16'h0007};
        8'd36: app_init_dout <= {1'b0, 16'h003a};
        8'd37: app_init_dout <= {1'b1, 16'h0105};
        8'd38: app_init_dout <= {1'b0, 16'h003b};
        8'd39: app_init_dout <= {1'b1, 16'h0808};
        //只读存储器,防止在case中没有列举的情况，之前的寄存器被重复改写
        default: app_init_dout <= {1'b1, 16'hffff};  //MIDH 制造商ID 高8位
      endcase
    end
  end
endmodule
