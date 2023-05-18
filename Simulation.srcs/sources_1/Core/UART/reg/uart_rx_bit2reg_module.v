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
// Description: 这是一个接受的发送长度不同的同步fifo模块，会以空闲中断的方式不足一帧的数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx_bit2reg_module #(
    parameter WIDTH = 32,
    parameter DEPTH = 1024,
    localparam ADDR_WIDTH = clogb2(DEPTH)
) (
    input clk,
    input rst_n,

    input                       wr_en,
    input                       wr_rst,
    input      [           7:0] din,
    input                       rd_en,
    output reg [     WIDTH-1:0] dout,
    output reg                  full,
    output reg                  empty,
    output reg [ADDR_WIDTH-1:0] fifo_cnt
);
  function integer clogb2;
    input [31:0] value;
    begin
      value = value - 1;
      for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
    end
  endfunction
  /**************************************************************/
  //接收数据
  reg [WIDTH-1:0] r_din;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_din <= 'd0;
    end else if (wr_en) begin
      r_din <= {r_din, din};
    end else begin
      r_din <= r_din;
    end
  end
  /**************************************************************/
  //计数
  reg [15:0] data_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_cnt <= 'd0;
    end else if (wr_en) begin
      data_cnt <= data_cnt + 'd8;
    end else if (wr_rst || data_cnt == WIDTH) begin
      data_cnt <= 'd0;
    end
  end
  /**************************************************************/
  //生成信号
  reg [WIDTH-1:0] fifo_din;
  reg             fifo_wren;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fifo_din  <= 'd0;
      fifo_wren <= 'd0;
    end else if (data_cnt == WIDTH) begin
      fifo_din  <= r_din;
      fifo_wren <= 'd1;
    end else begin
      fifo_wren <= 'd0;
    end
  end
  /**************************************************************/
  reg [     WIDTH-1:0] ram     [DEPTH-1:0];
  reg [ADDR_WIDTH-1:0] wr_addr;
  reg [ADDR_WIDTH-1:0] rd_addr;
  /**************************************************************/
  //read
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) rd_addr <= {ADDR_WIDTH{1'b0}};
    else if (rd_en && !empty) begin
      rd_addr <= rd_addr + 1'd1;
      dout    <= ram[rd_addr];
    end else begin
      rd_addr <= rd_addr;
      dout    <= dout;
    end
  end
  //write
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) wr_addr <= {ADDR_WIDTH{1'b0}};
    else if (fifo_wren && !full) begin
      wr_addr      <= wr_addr + 1'd1;
      ram[wr_addr] <= fifo_din;
    end else wr_addr <= wr_addr;
  end
  //fifo_cnt
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) fifo_cnt <= {ADDR_WIDTH{1'b0}};
    else if (fifo_wren && !full && !rd_en) fifo_cnt <= fifo_cnt + 1'd1;
    else if (rd_en && !empty && !fifo_wren) fifo_cnt <= fifo_cnt - 1'd1;
    else fifo_cnt <= fifo_cnt;
  end
  //empty 
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) empty <= 1'b1;  //reset:1
    else empty <= (!fifo_wren && (fifo_cnt[ADDR_WIDTH-1:1] == 'b0)) && ((fifo_cnt[0] == 1'b0) || rd_en);
  end
  //full
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) full <= 1'b1;  //reset:1
    else full <= (!rd_en && (fifo_cnt[ADDR_WIDTH-1:1] == {(ADDR_WIDTH - 1) {1'b1}})) && ((fifo_cnt[0] == 1'b1) || fifo_wren);
  end
endmodule
