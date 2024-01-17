`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/17 15:00:00
// Design Name: 
// Module Name: APB_Master_Core
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

module APB_Master_Core #(
    parameter APB_DBIT = 32,
    parameter APB_ABIT = 32,
    parameter RD_FLAG  = 2'b00,
    parameter WR_FLAG  = 2'b11
) (
    //-- user port
    input                       i_cmd_rvld,
    output                      o_cmd_rready,
    input      [           1:0] i_cmd_rw,
    input      [  APB_ABIT-1:0] i_cmd_addr,
    input      [  APB_DBIT-1:0] i_cmd_wdata,
    output reg [  APB_DBIT-1:0] o_cmd_rdata,
    //-- apb if
`ifdef APB4
    output     [           2:0] o_apb_prot,     //APB4 sign unused  000
    output     [APB_DBIT/8-1:0] o_apb_strb,     //APB4 sign 
`endif
    //-- apb3 if
    input                       i_apb_clk,
    input                       i_apb_rstn,
    output reg [  APB_ABIT-1:0] o_apb_addr,
    output reg                  o_apb_write,
    output reg                  o_apb_selx,
    output reg                  o_apb_enable,
    output reg [  APB_DBIT-1:0] o_apb_wdata,
    input      [  APB_DBIT-1:0] i_apb_rata,
    input                       i_apb_ready,
    input                       i_apb_slverr
);

  localparam CMD_WIDTH = APB_DBIT + APB_ABIT + 2;
  //-- FSM state
  localparam S_IDLE = 3'b001;
  localparam S_SETUP = 3'b010;
  localparam S_ACCESS = 3'b100;
  //-- current state and next state
  reg [          2:0] cur_state;
  reg [          2:0] nxt_state;

  //-- data buf
  reg                 start_flag;
  reg [CMD_WIDTH-1:0] cmd_in_buf;
  reg [ APB_DBIT-1:0] cmd_rd_data_buf;
  /*****************************************************************/
`ifdef APB4
  assign o_apb_prot = 3'b000;  //APB4 sign unused  000
  assign o_apb_strb = o_apb_write ? 4'b0000 : 4'b1111;
`endif

  assign o_cmd_rready = i_apb_ready;
  /*****************************************************************/
  /*-----------------------------------------------
 --             update cmd_in_buf              --
-----------------------------------------------*/
  always @(posedge i_apb_clk or negedge i_apb_rstn) begin
    if (!i_apb_rstn) begin
      cmd_in_buf <= {(CMD_WIDTH) {1'b0}};
    end else if (i_cmd_rvld && o_cmd_rready) begin
      cmd_in_buf <= {i_cmd_rw, i_cmd_addr, i_cmd_wdata};
    end
  end

  /*-----------------------------------------------
 --             start flag of transfer         --
-----------------------------------------------*/
  always @(posedge i_apb_clk or negedge i_apb_rstn) begin
    if (!i_apb_rstn) begin
      start_flag <= 1'b0;
    end else if (i_cmd_rvld && o_cmd_rready) begin
      start_flag <= 1'b1;
    end else begin
      start_flag <= 1'b0;
    end
  end

  /*-----------------------------------------------
 --           update current state             --
-----------------------------------------------*/
  always @(posedge i_apb_clk or negedge i_apb_rstn) begin
    if (!i_apb_rstn) begin
      cur_state <= S_IDLE;
    end else begin
      cur_state <= nxt_state;
    end
  end

  /*-----------------------------------------------
 --               update next state            --
-----------------------------------------------*/
  always @(*) begin
    case (cur_state)
      S_IDLE:
      if (start_flag) begin
        nxt_state = S_SETUP;
      end else begin
        nxt_state = S_IDLE;
      end
      S_SETUP: nxt_state = S_ACCESS;
      S_ACCESS:
      if (!o_cmd_rready) begin
        nxt_state = S_ACCESS;
      end else if (start_flag) begin
        nxt_state = S_SETUP;
      end else if (!i_cmd_rvld && o_cmd_rready) begin
        nxt_state = S_IDLE;
      end
    endcase
  end

  /*-----------------------------------------------
 --         update signal of output            --
-----------------------------------------------*/
  always @(posedge i_apb_clk or negedge i_apb_rstn) begin
    if (!i_apb_rstn) begin
      o_apb_write  <= 1'b0;
      o_apb_selx   <= 1'b0;
      o_apb_enable <= 1'b0;
      o_apb_addr   <= {(APB_ABIT) {1'b0}};
      o_apb_wdata  <= {(APB_DBIT) {1'b0}};
    end else if (nxt_state == S_IDLE) begin
      o_apb_selx   <= 1'b0;
      o_apb_enable <= 1'b0;
    end else if (nxt_state == S_SETUP) begin
      o_apb_selx   <= 1'b1;
      o_apb_enable <= 1'b0;
      o_apb_addr   <= cmd_in_buf[CMD_WIDTH-2-1:APB_DBIT];
      //-- read
      if (cmd_in_buf[CMD_WIDTH-1:CMD_WIDTH-2] == RD_FLAG) begin
        o_apb_write <= 1'b0;
      end  //-- write
      else begin
        o_apb_write <= 1'b1;
        o_apb_wdata <= cmd_in_buf[APB_DBIT-1:0];
      end
    end else if (nxt_state == S_ACCESS) begin
      o_apb_enable <= 1'b1;
    end
  end

  /*-----------------------------------------------
 --            update cmd_rd_data_buf          --
-----------------------------------------------*/
  always @(posedge i_apb_clk or negedge i_apb_rstn) begin
    if (!i_apb_rstn) begin
      cmd_rd_data_buf <= {(APB_DBIT) {1'b0}};
    end else if (i_apb_ready && o_apb_selx && o_apb_enable) begin
      cmd_rd_data_buf <= i_apb_rata;
    end
  end

  /*-----------------------------------------------
 --            update o_cmd_rdata            --
-----------------------------------------------*/
  always @(posedge i_apb_clk or negedge i_apb_rstn) begin
    if (!i_apb_rstn) begin
      o_cmd_rdata <= {(APB_DBIT) {1'b0}};
    end else begin
      o_cmd_rdata <= cmd_rd_data_buf;
    end
  end

endmodule
