/*
 * @Author       : Xu Xiaokang
 * @Email        : xuxiaokang_up@qq.com
 * @Date         : 2023-10-09 09:43:46
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2023-10-12 21:20:50
 * @Filename     :
 * @Description  :
*/

/*
! 模块功能: 同步FIFO
* 思路:
  1.开辟一个寄存器组作为RAM实现数据存储
*/

`default_nettype none

module syncFIFO
#(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4,
  parameter [0:0] FWFT_EN = 1 // First word fall-through without latency
)(
  input  wire [DATA_WIDTH-1:0] din,
  input  wire                  wr_en,
  output reg                   full,
  output reg                   almost_full,

  output wire [DATA_WIDTH-1:0] dout,
  input  wire                  rd_en,
  output reg                   empty,
  output reg                   almost_empty,

  input  wire                  clk,
  input  wire                  rst
);


//++ 生成读写指针 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg  [ADDR_WIDTH:0] rptr;
always @(posedge clk or posedge rst) begin
  if (rst)
    rptr <= 0;
  else if (rd_en & ~empty)
    rptr <= rptr + 1'b1;
end


reg  [ADDR_WIDTH:0] wptr;
always @(posedge clk or posedge rst) begin
  if (rst)
    wptr <= 0;
  else if (wr_en & ~full)
    wptr <= wptr + 1'b1;
end


wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];


wire [ADDR_WIDTH:0] rptr_p1 = rptr + 1'b1;
wire [ADDR_WIDTH:0] wptr_p1 = wptr + 1'b1;
//-- 生成读写指针 ------------------------------------------------------------


//++ 生成empty与almost_empty信号 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  if (rst)
    empty <= 1'b1;
  else if (rptr == wptr)
    empty <= 1'b1;
  else
    empty <= 1'b0;
end


always @(*) begin
  if (rst)
    almost_empty <= 1'b1;
  else if (rptr_p1 == wptr || empty)
    almost_empty <= 1'b1;
  else
    almost_empty <= 1'b0;
end
//-- 生成empty与almost_empty信号 ------------------------------------------------------------


//++ 生成full与almost_full信号 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  if (rst)
    full  <= 1'b1;
  else if ((wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH])
          && (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0])
          )
    full  <= 1'b1;
  else
    full  <= 1'b0;
end


always @(*) begin
  if (rst)
    almost_full <= 1'b1;
  else if (((wptr_p1[ADDR_WIDTH] != rptr[ADDR_WIDTH])
            && (wptr_p1[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0])
            )
          || full
          )
    almost_full <= 1'b1;
  else
    almost_full <= 1'b0;
end
//-- 生成full与almost_full信号 ------------------------------------------------------------


//++ 寄存器组定义与读写 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
localparam DEPTH = 1 << ADDR_WIDTH; // 等价于 2**ADDR_WIDTH
(* ram_style ="distributed" *)
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1]; // 在Vivado中可选两种实现方式(* ram_style ="block" *)


always @(posedge clk) begin
  if (wr_en && ~full)
    mem[waddr] <= din;
end


generate
  if (FWFT_EN == 1) begin
    // 这种写法会使得在empty为高时, dout为下一个地址的值, 此行为与Vivado FIFO不一致
    // assign dout = mem[raddr];

    // Vivado FIFO在FIFO为空时, dout保持最后一个有效值, 为实现这一特性, 采用了下方的写法
    // 注意这两种写法的功能都是正确的
    reg [DATA_WIDTH-1:0] dout_old;
    always @(posedge clk) begin
      if (rd_en && ~empty)
        dout_old <= mem[raddr]; // 存储上一个值
    end

    reg [DATA_WIDTH-1:0] dout_r;
    always @(*) begin
      if (~empty)
        dout_r <= mem[raddr];
      else
        dout_r <= dout_old;
    end

    assign dout = dout_r;
  end
  else begin
    reg [DATA_WIDTH-1:0] dout_r;

    always @(posedge clk) begin
      if (rd_en && ~empty)
        dout_r <= mem[raddr];
    end

    assign dout = dout_r;
  end
endgenerate
//-- 寄存器组定义与读写 ------------------------------------------------------------


endmodule

`resetall