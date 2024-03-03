`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 16:57:44
// Design Name: 
// Module Name: BitSlip_module
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


module BitSlip_module (
    input             I_clk,
    input             I_rstn,
    input             I_en,
    input             I_data_valid,
    input      [47:0] I_data,
    output reg [ 3:0] O_bitslip,
    output reg        O_bitslip_done
);

  reg [47:0] r_data_d0;
  reg [47:0] r_data_d1;
  reg [ 7:0] r_checked_cnt;

  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) begin
      r_data_d0[47:0] <= 'd0;
      r_data_d1[47:0] <= 'd0;
    end else if (I_data_valid) begin
      r_data_d0[47:0] <= I_data[47:0];
      r_data_d1[47:0] <= r_data_d0[47:0];
    end else begin
      r_data_d0[47:0] <= r_data_d0[47:0];
      r_data_d1[47:0] <= r_data_d1[47:0];
    end
  end
  /**************************同步状态****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //空闲
  localparam S_BITSLIP = 5'd1;  //
  localparam S_CEHCK = 5'd2;  //
  localparam S_DONE = 5'd3;  //
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) state_clk_cnt <= 32'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  /**************************转移状态****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        STATE_NEXT = S_CEHCK;
      end
      S_BITSLIP: begin
        STATE_NEXT = S_CEHCK;  //稳定后校验
      end
      S_CEHCK: begin
        if (r_checked_cnt == 8'd100) STATE_NEXT = S_DONE;  //校验通过
        else if (state_clk_cnt == 32'd200) STATE_NEXT = S_BITSLIP;  //超时重新校验
        else STATE_NEXT = S_CEHCK;
      end
      S_DONE: begin  //报错之后重新开始
        // if (I_en) STATE_NEXT = S_IDLE;
        // else STATE_NEXT = S_DONE;
          STATE_NEXT = S_DONE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end


  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_checked_cnt <= 'd0;
    else if (STATE_CURRENT == S_CEHCK) begin
      if (r_data_d0[47:0] == 48'h0000_0f00_0000 && r_data_d1[47:0] == 48'h0000_00f0_0000)
        r_checked_cnt <= r_checked_cnt + 1'b1;
      else if (r_data_d1[47:0] == 48'h0000_0f00_0000 && r_data_d0[47:0] == 48'h0000_00f0_0000)
        r_checked_cnt <= r_checked_cnt + 1'b1;
      else r_checked_cnt <= 'd0;
    end else r_checked_cnt <= 'd0;
  end


  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) begin
      O_bitslip <= 4'b0;
    end else if (STATE_CURRENT == S_BITSLIP) begin
      O_bitslip <= 4'hf;
    end else begin
      O_bitslip <= 4'b0;
    end
  end


endmodule
