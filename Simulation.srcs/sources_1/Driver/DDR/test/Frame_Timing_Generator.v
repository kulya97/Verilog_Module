`timescale 1ns / 1ps
module Frame_Timing_Generator (
    input             sys_clk,      //系统时钟
    input             rst_n,
    input      [15:0] ui_img_h,
    input      [15:0] ui_img_w,
    output reg        line_valid,
    output reg        frame_valid,
    output reg        data_valid,
    output reg [15:0] CL_DATA
);
  reg [15:0] LINE_N;
  reg [15:0] PIXEL_N;
  /**********************************积分时间****************************************************/
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      LINE_N  <= 16'd0;
      PIXEL_N <= 16'd0;
    end else begin
      LINE_N  <= ui_img_h;
      PIXEL_N <= ui_img_w;
    end
  end
  /**************************************************************************************/
  reg [3:0] state;
  reg [3:0] state_next;
  localparam S_IDLE = 0;  //空闲
  localparam S_LINE_TRANSFER = 3;  //转移
  localparam S_WAIT1 = 4;  //读出前
  localparam S_READ = 5;  //读出
  localparam S_WAIT2 = 6;  //读出后
  /****************************************************/
  reg [11:0] pixel_cnt;
  reg [11:0] line_cnt;
  reg [11:0] vertical_cnt;
  reg [16:0] pixel_clk_cnt;
  /**************************************************************************************/
  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) state <= S_IDLE;
    else state <= state_next;
  end
  always @(*) begin
    case (state)
      S_IDLE: begin
        state = S_WAIT1;
      end
      S_WAIT1: begin
        if (pixel_clk_cnt >= 32'd100) begin
          state = S_READ;
        end else begin
          state = S_WAIT1;
        end
      end
      S_LINE_TRANSFER: begin
        if (pixel_clk_cnt >= 32'd15) begin
          state = S_WAIT1;
        end else begin
          state = S_LINE_TRANSFER;
        end
      end
      S_WAIT2: begin
        if (pixel_clk_cnt >= 32'd3 && line_cnt < LINE_N) begin
          state = S_LINE_TRANSFER;
        end else if (pixel_clk_cnt >= 32'd3 && (line_cnt >= LINE_N)) begin
          state = S_IDLE;
        end else state = S_WAIT2;
      end
      S_READ: begin
        if (pixel_cnt == PIXEL_N - 1) begin
          state = S_WAIT2;
        end else state = S_READ;
      end
      default: begin
        state = S_IDLE;
      end
    endcase
  end

  always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
      line_valid  <= 1'b0;
      data_valid  <= 1'd0;
      frame_valid <= 1'b0;
    end else begin
      case (state)
        S_IDLE: begin
          line_valid  <= 1'b0;
          data_valid  <= 1'd0;
          frame_valid <= 1'b0;
        end
        S_WAIT1: begin
          line_valid  <= 1'b0;
          data_valid  <= 1'd0;
          frame_valid <= 1'b1;
        end
        S_LINE_TRANSFER: begin
          line_valid  <= 1'b0;
          data_valid  <= 1'd0;
          frame_valid <= 1'b1;

        end
        S_WAIT2: begin
          line_valid  <= 1'b0;
          data_valid  <= 1'd0;
          frame_valid <= 1'b1;
        end
        S_READ: begin
          frame_valid <= 1'b1;
          line_valid  <= 1'b1;
          data_valid  <= 1'd1;
        end
        default: begin
          frame_valid <= 1'b0;
          line_valid  <= 1'b0;
          data_valid  <= 1'd0;
        end
      endcase
    end
  end

  /****************************************************/
  assign CL_FVAL = frame_valid;  //帧有效
  assign CL_LVAL = line_valid;  //行有效
  assign CL_DVAL = data_valid;  //数据有效

  always @(posedge sys_clk) begin
    if (!CL_FVAL) CL_DATA <= 32'd0;
    else if (CL_DVAL) CL_DATA = CL_DATA + 1'd1;
    else CL_DATA <= CL_DATA;
  end
  /********************************************************************************************/
endmodule
