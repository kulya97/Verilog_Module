`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/18 15:49:19
// Design Name: 
// Module Name: i2c_wr_8bit
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


module i2c_wr_8bit #(
    parameter integer CLK_FREQ = 26'd50_000_000,  //模块输入的时钟频率
    parameter integer I2C_FREQ = 18'd250_000      //IIC_SCL的时钟频率
) (
    input            clk,
    input            rst_n,
    //--
    input            i_start,
    input            i_data,
    input            i_stop,
    //--
    input            i_wvalid,
    output reg       o_wready,
    input      [7:0] i_wdata,
    //--
    output reg       o_busy,
    output reg       o_done,
    output reg       o_ack,
    //--
    input            scl_i,
    output reg       scl_o,
    output reg       scl_t,
    input            sda_i,
    output reg       sda_o,
    output reg       sda_t
);

  //----------------------------------------------------------------------------
  localparam ST_IDLE = 8'd0;
  localparam ST_START = 8'd1;
  localparam ST_WDATA = 8'd2;
  localparam ST_RDATA = 8'd3;
  localparam ST_STOP = 8'd4;
  //----------------------------------------------------------------------------
  reg [7:0] state_cur;  //状态机当前状态
  reg [7:0] state_next;  //状态机下一状态
  //----------------------------------------------------------------------------
  reg [7:0] cnt;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) cnt <= 'd0;
    else if (1) cnt <= 'd0;
    else cnt <= 'd0;
  end
  //----------------------------------------------------------------------------
  //(三段式状态机)同步时序描述状态转移
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_cur <= ST_IDLE;
    else state_cur <= state_next;
  end

  //组合逻辑判断状态转移条件
  always @(*) begin
    state_next = ST_IDLE;
    case (state_cur)
      ST_IDLE: begin  //空闲状态
        if (i_i2c_wready && i_i2c_wvalid) state_next = ST_SLADDR;
        else state_next = ST_IDLE;
      end
      ST_SLADDR: begin  //判断是16位还是8位字地址
        if (st_done && bit_ctrl) state_next = ST_ADDR16;
        else if (st_done && !bit_ctrl) state_next = ST_ADDR8;
        else state_next = ST_SLADDR;
      end
      ST_ADDR16: begin  //写16位字地址
        if (st_done) state_next = ST_ADDR8;
        else state_next = ST_ADDR16;
      end
      ST_ADDR8: begin  //8位字地址
        if (st_done && !wr_flag) state_next = ST_WDATA;
        else if (st_done && wr_flag) state_next = ST_SLADDR_RD;
        else state_next = ST_ADDR8;
      end
      ST_WDATA: begin  //写数据(8 bit)
        if (st_done) state_next = ST_STOP;
        else state_next = ST_WDATA;
      end
      ST_SLADDR_RD: begin  //写地址以进行读数据
        if (st_done) state_next = ST_RDATA;
        else state_next = ST_SLADDR_RD;
      end
      ST_RDATA: begin  //读取数据(8 bit)
        if (st_done) state_next = ST_STOP;
        else state_next = ST_RDATA;
      end
      ST_STOP: begin  //结束I2C操作
        if (st_done) state_next = ST_IDLE;
        else state_next = ST_STOP;
      end
      default: state_next = ST_IDLE;
    endcase
  end
  //----------------------------------------------------------------------------

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n);
    else
    if (1);
    else
      case (cnt)
        7'd0: begin
          scl_t <= 1'b1;
          sda_o <= i_wdata[7];  //字地址
        end
        7'd1:    scl_o <= 1'b1;
        7'd3:    scl_o <= 1'b0;
        7'd4:    sda_o <= i_wdata[6];
        7'd5:    scl_o <= 1'b1;
        7'd7:    scl_o <= 1'b0;
        7'd8:    sda_o <= i_wdata[5];
        7'd9:    scl_o <= 1'b1;
        7'd11:   scl_o <= 1'b0;
        7'd12:   sda_o <= i_wdata[4];
        7'd13:   scl_o <= 1'b1;
        7'd15:   scl_o <= 1'b0;
        7'd16:   sda_o <= i_wdata[3];
        7'd17:   scl_o <= 1'b1;
        7'd19:   scl_o <= 1'b0;
        7'd20:   sda_o <= i_wdata[2];
        7'd21:   scl_o <= 1'b1;
        7'd23:   scl_o <= 1'b0;
        7'd24:   sda_o <= i_wdata[1];
        7'd25:   scl_o <= 1'b1;
        7'd27:   scl_o <= 1'b0;
        7'd28:   sda_o <= i_wdata[0];
        7'd29:   scl_o <= 1'b1;
        7'd31:   scl_o <= 1'b0;
        7'd32: begin
            scl_t <= 1'b0;
          sda_o <= 1'b1;
        end
        7'd33:   scl_o <= 1'b1;
        7'd34: begin  //从机应答
            o_done <= 1'b1;
          if (sda_i == 1'b1)  //高电平表示未应答
          o_ack <= 1'b1;  //拉高应答标志位
        end
        7'd35: begin
          scl_o <= 1'b0;
        end
        default: ;
      endcase
    ;
  end

endmodule
