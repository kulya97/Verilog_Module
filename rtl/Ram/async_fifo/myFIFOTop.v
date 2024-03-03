/*
 * @Author       : Xu Xiaokang
 * @Email        : xuxiaokang_up@qq.com
 * @Date         : 2023-10-09 09:43:46
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2023-10-11 21:59:14
 * @Filename     :
 * @Description  :
*/

/*
! 模块功能: 异步FIFO
* 思路:
  1.在判断写满与读空信号时，需要转换时钟域，为止先将读写指针转换为格雷码，减小亚稳态发生的概率
  2.开辟一个寄存器组作为RAM实现数据存储
*/

`default_nettype none

module myFIFOTop
#(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4,
  parameter [0:0] FWFT_EN = 1 // First word fall-through without latency
)(

  input  wire [DATA_WIDTH-1:0] din,
  input  wire                  wr_en,
  output wire                  full,
  output wire                  almost_full,
  input  wire                  wr_clk,
  input  wire                  wr_rst,


  output wire [DATA_WIDTH-1:0] dout,
  input  wire                  rd_en,
  output wire                  empty,
  output wire                  almost_empty,
  input  wire                  rd_clk,
  input  wire                  rd_rst,

  output wire [DATA_WIDTH-1:0] vivado_fifo_dout,
  output wire                  vivado_fifo_full,
  output wire                  vivado_fifo_empty,
  output wire                  vivado_fifo_almost_full,
  output wire                  vivado_fifo_almost_empty
);


vivado_async_fifo vivado_async_fifo_u0 (
  .wr_clk       (wr_clk                 ), // input wire wr_clk
  .wr_rst       (wr_rst                 ), // input wire wr_rst
  .rd_clk       (rd_clk                 ), // input wire rd_clk
  .rd_rst       (rd_rst                 ), // input wire rd_rst
  .din          (din                    ), // input wire [7 : 0] din
  .wr_en        (wr_en                  ), // input wire wr_en
  .rd_en        (rd_en                  ), // input wire rd_en
  .dout         (vivado_fifo_dout       ), // output wire [7: 0] dout
  .full         (vivado_fifo_full       ), // output wire full
  .almost_full  (vivado_fifo_almost_full), // output wire almost_full
  .empty        (vivado_fifo_empty      ), // output wire empty
  .almost_empty (vivado_fifo_almost_empty)  // output wire almost_empty
);


asyncFIFO #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .FWFT_EN(FWFT_EN)
) asyncFIFO_inst (
  .din          (din         ),
  .wr_en        (wr_en       ),
  .full         (full        ),
  .almost_full  (almost_full ),
  .wr_clk       (wr_clk      ),
  .wr_rst       (wr_rst      ),
  .dout         (dout        ),
  .rd_en        (rd_en       ),
  .empty        (empty       ),
  .almost_empty (almost_empty),
  .rd_clk       (rd_clk      ),
  .rd_rst       (rd_rst      )
);


endmodule

`resetall