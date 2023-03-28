`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/28 11:00:32
// Design Name: 
// Module Name: ad5302_switch_module
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


module ad5302_switch_module (
    input         clk,
    input         rst_n,
    input  [31:0] uart_reg,
    input         uart_ready,
    output        ad5302_en
);

  parameter ADDRESS = 16'hdacX;

  reg r_dldac;
  assign ad5302_en = r_dldac;
  /**************************Í¬²½×´Ì¬****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //¿ÕÏÐ
  localparam S_INIT = 5'd1;  //
  localparam S_ENREG = 5'd4;  //
  localparam S_DONE = 5'd5;  //
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 32'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  /**************************×ªÒÆ×´Ì¬****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (uart_ready && uart_reg[31:16] == ADDRESS) STATE_NEXT = S_ENREG;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        STATE_NEXT = S_ENREG;
      end
      S_ENREG: begin
        if (state_clk_cnt == 'd10) STATE_NEXT = S_DONE;
        else STATE_NEXT = S_ENREG;
      end
      S_DONE: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************×´Ì¬Êä³ö****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_dldac <= 1'b1;
    else if (STATE_CURRENT == S_ENREG) r_dldac <= 1'b0;
    else r_dldac <= 1'b1;
  end
endmodule
