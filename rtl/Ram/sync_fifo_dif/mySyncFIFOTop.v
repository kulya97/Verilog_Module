/*
 * @Author       : Xu Xiaokang
 * @Email        : xuxiaokang_up@qq.com
 * @Date         : 2023-10-09 09:43:46
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2023-10-24 15:36:43
 * @Filename     :
 * @Description  :
*/

/*
! 模块功能: 读写位宽不同的同步FIFO顶层模块
* 思路:
*/

`default_nettype none

module mySyncFIFOTop
#(
  parameter DIN_WIDTH = 8, // 输入位宽与输出位宽比值必须为2的指数，如1, 2, 4, 8, 16等
  parameter DOUT_WIDTH = 4,
  parameter WADDR_WIDTH = 4,
  parameter [0:0] FWFT_EN = 1, // First word fall-through without latency
  parameter [0:0] MSB_FIFO = 1 // 1表示高位先进先出, 0表示低位先进先出
)(
  input  wire [DIN_WIDTH-1:0] din,
  input  wire                  wr_en,
  output wire                  full,
  output wire                  almost_full,

  output wire [DOUT_WIDTH-1:0] dout,
  input  wire                  rd_en,
  output wire                  empty,
  output wire                  almost_empty,

  input  wire                  clk,
  input  wire                  rst,

  output wire [DOUT_WIDTH-1:0] vivado_fifo_dout,
  output wire                  vivado_fifo_full,
  output wire                  vivado_fifo_empty,
  output wire                  vivado_fifo_almost_full,
  output wire                  vivado_fifo_almost_empty
);


vivado_sync_fifo vivado_sync_fifo_u0 (
  .clk          (clk                     ), // input wire clk
  .rst          (rst                     ), // input wire rst
  .din          (din                     ), // input wire [7 : 0] din
  .wr_en        (wr_en                   ), // input wire wr_en
  .rd_en        (rd_en                   ), // input wire rd_en
  .dout         (vivado_fifo_dout        ), // output wire [7: 0] dout
  .full         (vivado_fifo_full        ), // output wire full
  .almost_full  (vivado_fifo_almost_full ), // output wire almost_full
  .empty        (vivado_fifo_empty       ), // output wire empty
  .almost_empty (vivado_fifo_almost_empty)// output wire almost_empty
);


syncFIFO_diffWidth # (
  .DIN_WIDTH   (DIN_WIDTH  ),
  .DOUT_WIDTH  (DOUT_WIDTH ),
  .WADDR_WIDTH (WADDR_WIDTH),
  .FWFT_EN     (FWFT_EN    ),
  .MSB_FIFO    (MSB_FIFO   )
) syncFIFO_diffWidth_inst (
  .din          (din         ),
  .wr_en        (wr_en       ),
  .full         (full        ),
  .almost_full  (almost_full ),
  .dout         (dout        ),
  .rd_en        (rd_en       ),
  .empty        (empty       ),
  .almost_empty (almost_empty),
  .clk          (clk         ),
  .rst          (rst         )
);


endmodule

`resetall