module mySyncFIFOTop_tb();

timeunit 1ns;
timeprecision 10ps;

parameter DIN_WIDTH = 4; // 输入位宽与输出位宽比值必须为2的指数，如1, 2, 4, 8, 16等
parameter DOUT_WIDTH = 8;
parameter WADDR_WIDTH = 5;
parameter [0:0] FWFT_EN = 1; // First word fall-through without latency
parameter [0:0] MSB_FIFO = 1; // 1表示高位先进先出, 0表示低位先进先出
logic [DIN_WIDTH-1:0] din;
logic                 wr_en;
logic                 full;
logic                 almost_full;

logic [DOUT_WIDTH-1:0] dout;
logic                  rd_en;
logic                  empty;
logic                  almost_empty;

logic                  clk;
logic                  rst;

logic [DOUT_WIDTH-1:0] vivado_fifo_dout;
logic                  vivado_fifo_full;
logic                  vivado_fifo_empty;
logic                  vivado_fifo_almost_full;
logic                  vivado_fifo_almost_empty;

mySyncFIFOTop # (
  .DIN_WIDTH   (DIN_WIDTH  ),
  .DOUT_WIDTH  (DOUT_WIDTH ),
  .WADDR_WIDTH (WADDR_WIDTH),
  .FWFT_EN     (FWFT_EN    ),
  .MSB_FIFO    (MSB_FIFO   )
) mySyncFIFOTop_inst (.*);


// 生成时钟
localparam CLKT = 2;
initial begin
  clk = 0;
  forever #(CLKT / 2) clk = ~clk;
end


// 读写使能控制
initial begin
  rst = 1;
  #(CLKT * 2)
  rst = 0;
  wr_en = 0;
  rd_en = 0;
  #(CLKT * 2)
  wait(~full && ~vivado_fifo_full); // 两个FIFO都从复位态恢复时开始写

  // 写入一个数据
  wr_en = 1;
  wait(~empty || ~vivado_fifo_empty);
  wr_en = 0;

  // 读出一个数据
  wait(~empty && ~vivado_fifo_empty);// 两个FIFO都非空时开始读，比较读数据和empty信号是否有差异
  rd_en = 1;
  #(CLKT * 1)
  rd_en = 0;

  // 写满
  wr_en = 1;
  wait(full && vivado_fifo_full); // 两个FIFO都满时停止写，如果两者不同时满，则先满的一方会有写满的情况发生，但对功能无影响
  // vivado FIFO IP在FWFT模式时, 设定深度16时实际深度为17, 但仿真显示full会在写入15个数据后置高, 过几个时钟后后拉低,
  // 再写入一个数据, full又置高; 然后过几个时钟又拉低, 再写入一个数据置高, 如此才能写入17个数据
  // 所以这里多等待12个wclk周期, 就是为了能真正写满vivado FWFT FIFO
  #(CLKT * 12)
  wr_en = 0;

  // 读空
  wait(~empty && ~vivado_fifo_empty);
  rd_en = 1;
  wait(empty && vivado_fifo_empty); // 两个FIFO都空时停止读，如果两者不同时空，则先空的一方会有读空的情况发生，但对功能无影响
  rd_en = 0;

  #(CLKT * 10)
  $stop;
end


// 使用以下代码时，先注释掉上面的读写使能控制initial
// 同时读写
// initial begin
//   #(CLKT * 30)
//   $stop;
// end

// assign wr_en = ~full || ~vivado_fifo_full; // 未满就一直写
// assign rd_en = ~empty || ~vivado_fifo_empty; // 未空就一直读

always @(posedge clk) begin
  if (rst)
    din <= 0;
  else if (wr_en && ~full && ~vivado_fifo_full)
    din <= din + 1;
end


endmodule