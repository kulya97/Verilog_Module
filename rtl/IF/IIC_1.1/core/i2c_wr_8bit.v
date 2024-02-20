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
    input            i_cmd_start,
    input            i_cmd_wdata,
    input            i_cmd_rdata,
    input            i_cmd_stop,
    //--
    input            i_wvalid,
    output reg       o_wready,
    input      [7:0] i_wdata,
    //--
    output           o_rvalid,
    input            i_rready,
    output     [7:0] o_rdata,
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
  localparam [7:0] ST_IDLE = 8'd0;
  localparam [7:0] ST_START = 8'd1;
  localparam [7:0] ST_WDATA = 8'd2;
  localparam [7:0] ST_RDATA = 8'd3;
  localparam [7:0] ST_STOP = 8'd4;
  //----------------------------------------------------------------------------
  reg  [7:0] state_cur;  //状态机当前状态
  reg  [7:0] state_next;  //状态机下一状态
  reg        st_done;
  //--
  wire [8:0] clk_divide;  //模块驱动时钟的分频系数
  reg        o_dri_clk;  //驱动I2C操作的驱动时钟
  reg        o_dri_clk_valid;
  //--
  reg  [7:0] cnt;
  reg  [7:0] clk_cnt;
  reg  [7:0] rd_data;

  //----------------------------------------------------------------------------
  //--
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) o_wready <= 1'b0;
    else if (!o_wready && i_wvalid && (state_cur == ST_IDLE)) o_wready <= 1'b1;
    else o_wready <= 1'b0;
  end

  //----------------------------------------------------------------------------
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_cur <= ST_IDLE;
    else state_cur <= state_next;
  end

  always @(*) begin
    state_next = ST_IDLE;
    case (state_cur)
      ST_IDLE: begin  //空闲状态
        if (o_wready && i_wvalid && i_cmd_start) state_next = ST_START;
        else if (o_wready && i_wvalid && i_cmd_wdata) state_next = ST_WDATA;
        else if (o_wready && i_wvalid && i_cmd_rdata) state_next = ST_RDATA;
        else state_next = ST_IDLE;
      end
      ST_START: begin  //start
        if (o_dri_clk_valid && st_done && i_cmd_wdata) state_next = ST_WDATA;
        else if (o_dri_clk_valid && st_done && i_cmd_rdata) state_next = ST_RDATA;
        else if (o_dri_clk_valid && st_done) state_next = ST_IDLE;
        else state_next = ST_START;
      end
      ST_WDATA: begin  //写数据(8 bit)
        if (o_dri_clk_valid && st_done && i_cmd_stop) state_next = ST_STOP;
        else if (o_dri_clk_valid && st_done && !i_cmd_stop) state_next = ST_IDLE;
        else state_next = ST_WDATA;
      end
      ST_RDATA: begin  //读取数据(8 bit)
        if (o_dri_clk_valid && st_done && i_cmd_stop) state_next = ST_STOP;
        else if (o_dri_clk_valid && st_done && !i_cmd_stop) state_next = ST_IDLE;
        else state_next = ST_RDATA;
      end
      ST_STOP: begin  //结束I2C操作
        if (o_dri_clk_valid && st_done) state_next = ST_IDLE;
        else state_next = ST_STOP;
      end
      default: state_next = ST_IDLE;
    endcase
  end
  //----------------------------------------------------------------------------
  assign clk_divide = (CLK_FREQ / I2C_FREQ) >> 2'd2;  //模块驱动时钟的分频系数
  //----------------------------------------------------------------------------


  //生成I2C的SCL的四倍频率的驱动时钟用于驱动i2c的操作
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      clk_cnt         <= 10'd0;
      o_dri_clk_valid <= 1'b0;
    end else if (clk_cnt == clk_divide[8:1] - 1'd1) begin
      clk_cnt         <= 10'd0;
      o_dri_clk_valid <= 1'b1;
    end else begin
      clk_cnt         <= clk_cnt + 1'b1;
      o_dri_clk_valid <= 1'b0;
    end
  end
  //--
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) cnt <= 'd0;
    else if (state_cur != state_next) cnt <= 'd0;
    else if (o_dri_clk_valid) cnt <= cnt + 1'd1;
    else cnt <= cnt;
  end
  //----------------------------------------------------------------------------
  always @(posedge clk, negedge rst_n) begin
    //复位初始化
    if (!rst_n) begin
      scl_o   <= 1'b1;
      sda_o   <= 1'b1;
      sda_t   <= 1'b1;
      st_done <= 1'b0;
      o_done  <= 1'b0;
      o_ack   <= 1'b0;
    end else begin
      st_done <= 1'b0;
      case (state_cur)
        ST_IDLE: begin  //空闲状态
          scl_o  <= 1'b1;
          sda_o  <= 1'b1;
          sda_t  <= 1'b1;
          o_done <= 1'b0;
        end
        ST_START: begin  //写地址(器件地址和字地址)
          case (cnt)
            7'd1:    sda_o <= 1'b0;  //开始I2C
            7'd3:    scl_o <= 1'b0;
            7'd4: begin
              st_done <= 1'b1;
              scl_o <= 1'b0;
            end
            default: ;
          endcase
        end
        ST_WDATA: begin  //写数据(8 bit)
          case (cnt)
            7'd0: begin
              sda_o <= i_wdata[7];
              sda_t <= 1'b1;
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
              sda_t   <= 1'b0;
              sda_o   <= 1'b1;
            end
            7'd33:   scl_o <= 1'b1;
            7'd34: begin  //从机应答
              if (sda_i == 1'b1)  //高电平表示未应答
              o_ack <= 1'b1;  //拉高应答标志位
            end
            7'd35: begin
              scl_o <= 1'b0;

             st_done <= 1'b1;
            end
            default: ;
          endcase
        end
        ST_RDATA: begin  //读取数据(8 bit)
          case (cnt)
            7'd0:    sda_t <= 1'b0;
            7'd1: begin
              rd_data[7] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd3:    scl_o <= 1'b0;
            7'd5: begin
              rd_data[6] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd7:    scl_o <= 1'b0;
            7'd9: begin
              rd_data[5] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd11:   scl_o <= 1'b0;
            7'd13: begin
              rd_data[4] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd15:   scl_o <= 1'b0;
            7'd17: begin
              rd_data[3] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd19:   scl_o <= 1'b0;
            7'd21: begin
              rd_data[2] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd23:   scl_o <= 1'b0;
            7'd25: begin
              rd_data[1] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd27:   scl_o <= 1'b0;
            7'd29: begin
              rd_data[0] <= sda_i;
              scl_o      <= 1'b1;
            end
            7'd31:   scl_o <= 1'b0;
            7'd32: begin
              sda_t <= 1'b1;
              sda_o <= 1'b1;
            end
            7'd33:   scl_o <= 1'b1;
            7'd34: begin
            end
            7'd35: begin
              scl_o   <= 1'b0;
              st_done <= 1'b1;
            end
            default: ;
          endcase
        end
        ST_STOP: begin  //结束I2C操作
          case (cnt)
            7'd0: begin
              sda_t <= 1'b1;  //结束I2C
              sda_o <= 1'b0;
            end
            7'd1:    scl_o <= 1'b1;
            7'd3:    sda_o <= 1'b1;
            7'd15: begin
            end
            7'd16: begin
              st_done <= 1'b1;
              o_done <= 1'b1;  //向上层模块传递I2C结束信号
            end
            default: ;
          endcase
        end
      endcase
    end
  end
endmodule
