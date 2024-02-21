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
    output reg       i2c_scl,
    inout            i2c_sda

);
  localparam integer CLK_DIV = (CLK_FREQ / I2C_FREQ) >> 2'd2;
  localparam integer CLK_DIV_00 = CLK_DIV * 00;
  localparam integer CLK_DIV_01 = CLK_DIV * 01;
  localparam integer CLK_DIV_02 = CLK_DIV * 02;
  localparam integer CLK_DIV_03 = CLK_DIV * 03;
  localparam integer CLK_DIV_04 = CLK_DIV * 04;
  localparam integer CLK_DIV_05 = CLK_DIV * 05;
  localparam integer CLK_DIV_06 = CLK_DIV * 06;
  localparam integer CLK_DIV_07 = CLK_DIV * 07;
  localparam integer CLK_DIV_08 = CLK_DIV * 08;
  localparam integer CLK_DIV_09 = CLK_DIV * 09;
  localparam integer CLK_DIV_10 = CLK_DIV * 10;
  localparam integer CLK_DIV_11 = CLK_DIV * 11;
  localparam integer CLK_DIV_12 = CLK_DIV * 12;
  localparam integer CLK_DIV_13 = CLK_DIV * 13;
  localparam integer CLK_DIV_14 = CLK_DIV * 14;
  localparam integer CLK_DIV_15 = CLK_DIV * 15;
  localparam integer CLK_DIV_16 = CLK_DIV * 16;
  localparam integer CLK_DIV_17 = CLK_DIV * 17;
  localparam integer CLK_DIV_18 = CLK_DIV * 18;
  localparam integer CLK_DIV_19 = CLK_DIV * 19;
  localparam integer CLK_DIV_20 = CLK_DIV * 20;
  localparam integer CLK_DIV_21 = CLK_DIV * 21;
  localparam integer CLK_DIV_22 = CLK_DIV * 22;
  localparam integer CLK_DIV_23 = CLK_DIV * 23;
  localparam integer CLK_DIV_24 = CLK_DIV * 24;
  localparam integer CLK_DIV_25 = CLK_DIV * 25;
  localparam integer CLK_DIV_26 = CLK_DIV * 26;
  localparam integer CLK_DIV_27 = CLK_DIV * 27;
  localparam integer CLK_DIV_28 = CLK_DIV * 28;
  localparam integer CLK_DIV_29 = CLK_DIV * 29;
  localparam integer CLK_DIV_30 = CLK_DIV * 30;
  localparam integer CLK_DIV_31 = CLK_DIV * 31;
  localparam integer CLK_DIV_32 = CLK_DIV * 32;
  localparam integer CLK_DIV_33 = CLK_DIV * 33;
  localparam integer CLK_DIV_34 = CLK_DIV * 34;
  localparam integer CLK_DIV_35 = CLK_DIV * 35;
  localparam integer CLK_DIV_36 = CLK_DIV * 36;
  localparam integer CLK_DIV_37 = CLK_DIV * 37;
  localparam integer CLK_DIV_38 = CLK_DIV * 38;
  localparam integer CLK_DIV_39 = CLK_DIV * 39;

  //----------------------------------------------------------------------------
  localparam [7:0] ST_IDLE = 8'd0;
  localparam [7:0] ST_START = 8'd1;
  localparam [7:0] ST_WDATA = 8'd2;
  localparam [7:0] ST_RDATA = 8'd3;
  localparam [7:0] ST_STOP = 8'd4;
  //----------------------------------------------------------------------------
  reg  [ 7:0] state_cur;  //状态机当前状态
  reg  [ 7:0] state_next;  //状态机下一状态
  reg         st_done;
  //--
  reg  [31:0] cnt;

  reg  [ 7:0] rd_data;
  //-- reg define
  reg         sda_dir;  //I2C数据(SDA)方向控制
  reg         sda_out;  //SDA输出信号
  wire        sda_in;  //SDA输入信号

  reg         cmd_start;
  reg         cmd_wdata;
  reg         cmd_rdata;
  reg         cmd_stop;
  reg  [ 7:0] wdata;
  //----------------------------------------------------------------------------
  assign i2c_sda = sda_dir ? sda_out : 1'bz;  //SDA数据输出或高阻
  assign sda_in  = i2c_sda;  //SDA数据输入
  //----------------------------------------------------------------------------
  //--
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) o_wready <= 1'b0;
    else if (!o_wready && i_wvalid && (state_cur == ST_IDLE)) o_wready <= 1'b1;
    else o_wready <= 1'b0;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      cmd_start <= 1'b0;
      cmd_wdata <= 1'b0;
      cmd_rdata <= 1'b0;
      cmd_stop  <= 1'b0;
      wdata     <= 8'b0;
    end else if (!o_wready && i_wvalid) begin
      cmd_start <= i_cmd_start;
      cmd_wdata <= i_cmd_wdata;
      cmd_rdata <= i_cmd_rdata;
      cmd_stop  <= i_cmd_stop;
      wdata     <= i_wdata;
    end else begin
      cmd_start <= cmd_start;
      cmd_wdata <= cmd_wdata;
      cmd_rdata <= cmd_rdata;
      cmd_stop  <= cmd_stop;
      wdata     <= wdata;
    end
  end


  //----------------------------------------------------------------------------
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_cur <= ST_IDLE;
    else state_cur <= state_next;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) cnt <= 1'b0;
    else if (state_cur != state_next) cnt <= 1'b0;
    else cnt <= cnt + 1'b1;
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
        if ((cnt == CLK_DIV_04) && cmd_wdata) state_next = ST_WDATA;
        else if ((cnt == CLK_DIV_04) && cmd_rdata) state_next = ST_RDATA;
        else if ((cnt == CLK_DIV_04)) state_next = ST_IDLE;
        else state_next = ST_START;
      end
      ST_WDATA: begin  //写数据(8 bit)
        if ((cnt == CLK_DIV_36 - 1) && cmd_stop) state_next = ST_STOP;
        else if ((cnt == CLK_DIV_36 - 1) && !cmd_stop) state_next = ST_IDLE;
        else state_next = ST_WDATA;
      end
      ST_RDATA: begin  //读取数据(8 bit)
        if ((cnt == CLK_DIV_36 - 1) && cmd_stop) state_next = ST_STOP;
        else if ((cnt == CLK_DIV_36 - 1) && cmd_stop) state_next = ST_IDLE;
        else state_next = ST_RDATA;
      end
      ST_STOP: begin  //结束I2C操作
        if ((cnt == CLK_DIV_16)) state_next = ST_IDLE;
        else state_next = ST_STOP;
      end
      default: state_next = ST_IDLE;
    endcase
  end
  //----------------------------------------------------------------------------
  always @(posedge clk, negedge rst_n) begin
    //复位初始化
    if (!rst_n) begin
      i2c_scl <= 1'b1;
      sda_out <= 1'b1;
      sda_dir <= 1'b1;
      st_done <= 1'b0;
      o_done  <= 1'b0;
      o_ack   <= 1'b0;
    end else begin
      st_done <= 1'b0;

      case (state_cur)
        ST_IDLE: begin  //空闲状态
          i2c_scl <= 1'b1;
          sda_out <= 1'b1;
          sda_dir <= 1'b1;
          o_done  <= 1'b0;
          cnt     <= 1'b0;
        end
        ST_START: begin  //写地址(器件地址和字地址)
          case (cnt)
            CLK_DIV_01: sda_out <= 1'b0;  //开始I2C
            CLK_DIV_03: i2c_scl <= 1'b0;
            CLK_DIV_04: begin
              st_done <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default:    ;
          endcase
        end
        ST_WDATA: begin  //写数据(8 bit)
          case (cnt)
            CLK_DIV_00: begin
              i2c_scl <= 1'b0;
              sda_dir <= 1'b1;
              sda_out <= wdata[7];
            end
            CLK_DIV_01: i2c_scl <= 1'b1;
            CLK_DIV_02: i2c_scl <= 1'b1;
            CLK_DIV_03: i2c_scl <= 1'b0;
            CLK_DIV_04: sda_out <= wdata[6];
            CLK_DIV_05: i2c_scl <= 1'b1;
            CLK_DIV_06: i2c_scl <= 1'b1;
            CLK_DIV_07: i2c_scl <= 1'b0;
            CLK_DIV_08: sda_out <= wdata[5];
            CLK_DIV_09: i2c_scl <= 1'b1;
            CLK_DIV_10: i2c_scl <= 1'b1;
            CLK_DIV_11: i2c_scl <= 1'b0;
            CLK_DIV_12: sda_out <= wdata[4];
            CLK_DIV_13: i2c_scl <= 1'b1;
            CLK_DIV_14: i2c_scl <= 1'b1;
            CLK_DIV_15: i2c_scl <= 1'b0;
            CLK_DIV_16: sda_out <= wdata[3];
            CLK_DIV_17: i2c_scl <= 1'b1;
            CLK_DIV_18: i2c_scl <= 1'b1;
            CLK_DIV_19: i2c_scl <= 1'b0;
            CLK_DIV_20: sda_out <= wdata[2];
            CLK_DIV_21: i2c_scl <= 1'b1;
            CLK_DIV_22: i2c_scl <= 1'b1;
            CLK_DIV_23: i2c_scl <= 1'b0;
            CLK_DIV_24: sda_out <= wdata[1];
            CLK_DIV_25: i2c_scl <= 1'b1;
            CLK_DIV_26: i2c_scl <= 1'b1;
            CLK_DIV_27: i2c_scl <= 1'b0;
            CLK_DIV_28: sda_out <= wdata[0];
            CLK_DIV_29: i2c_scl <= 1'b1;
            CLK_DIV_30: i2c_scl <= 1'b1;
            CLK_DIV_31: i2c_scl <= 1'b0;
            CLK_DIV_32: begin
              sda_dir <= 1'b0;
              sda_out <= 1'b1;
            end
            CLK_DIV_33: i2c_scl <= 1'b1;
            CLK_DIV_34: begin  //从机应答
              if (sda_in == 1'b1)  //高电平表示未应答
                o_ack <= 1'b1;  //拉高应答标志位
            end
            CLK_DIV_35: begin
              i2c_scl <= 1'b0;
            end
            CLK_DIV_36-1: begin
              sda_dir <= 1'b1;
              st_done <= 1'b1;
              o_done <= 1'b1;
            end
            default:    ;
          endcase
        end
        ST_RDATA: begin  //读取数据(8 bit)
          case (cnt)
            CLK_DIV_00: sda_dir <= 1'b0;
            CLK_DIV_01: begin
              rd_data[7] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_03: i2c_scl <= 1'b0;
            CLK_DIV_05: begin
              rd_data[6] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_07: i2c_scl <= 1'b0;
            CLK_DIV_09: begin
              rd_data[5] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_11: i2c_scl <= 1'b0;
            CLK_DIV_13: begin
              rd_data[4] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_15: i2c_scl <= 1'b0;
            CLK_DIV_17: begin
              rd_data[3] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_19: i2c_scl <= 1'b0;
            CLK_DIV_21: begin
              rd_data[2] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_23: i2c_scl <= 1'b0;
            CLK_DIV_25: begin
              rd_data[1] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_27: i2c_scl <= 1'b0;
            CLK_DIV_29: begin
              rd_data[0] <= sda_in;
              i2c_scl    <= 1'b1;
            end
            CLK_DIV_31: i2c_scl <= 1'b0;
            CLK_DIV_32: begin
              sda_dir <= 1'b1;
              sda_out <= 1'b1;
            end
            CLK_DIV_33: i2c_scl <= 1'b1;
            CLK_DIV_34: begin
            end
            CLK_DIV_35: begin
              i2c_scl <= 1'b0;
              st_done <= 1'b1;
            end
            default:    ;
          endcase
        end
        ST_STOP: begin  //结束I2C操作
          case (cnt)
            CLK_DIV_00: begin
              sda_dir <= 1'b1;  //结束I2C
              sda_out <= 1'b0;
            end
            CLK_DIV_01: i2c_scl <= 1'b1;
            CLK_DIV_03: sda_out <= 1'b1;
            CLK_DIV_15: begin
            end
            CLK_DIV_16: begin
              st_done <= 1'b1;
              o_done  <= 1'b1;  //向上层模块传递I2C结束信号
            end
            default:    ;
          endcase
        end
      endcase
    end
  end
endmodule
