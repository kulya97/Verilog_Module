module myFIFOTop_tb();

timeunit 1ns;
timeprecision 10ps;

localparam DATA_WIDTH = 8;
localparam ADDR_WIDTH = 4;
localparam [0:0] FWFT_EN = 1;
logic [DATA_WIDTH-1:0] din;
logic                  wr_en;
logic                  full;
logic                  almost_full;
logic                  wr_clk;
logic                  wr_rst;
logic [DATA_WIDTH-1:0] dout;
logic                  rd_en;
logic                  empty;
logic                  almost_empty;
logic                  rd_clk;
logic                  rd_rst;
logic [DATA_WIDTH-1:0] vivado_fifo_dout;
logic                  vivado_fifo_full;
logic                  vivado_fifo_empty;
logic                  vivado_fifo_almost_full;
logic                  vivado_fifo_almost_empty;

myFIFOTop #(
  .DATA_WIDTH (DATA_WIDTH),
  .ADDR_WIDTH (ADDR_WIDTH),
  .FWFT_EN    (FWFT_EN   )
) myFIFOTop_inst (.*);


// 生成时钟
localparam WCLKT = 2;
initial begin
  wr_clk = 0;
  forever #(WCLKT / 2) wr_clk = ~wr_clk;
end

localparam RCLKT = 6;
initial begin
  rd_clk = 0;
  forever #(RCLKT / 2) rd_clk = ~rd_clk;
end


// 复位块
initial begin
  wr_rst = 1;
  #(WCLKT * 2)
  wr_rst = 0;
end


// 读写使能控制
// initial begin
//   wr_en = 0;
//   rd_en = 0;
//   #(WCLKT * 2)
//   wait(~full && ~vivado_fifo_full); // 两个FIFO都从复位态恢复时开始写

//   // 写入一个数据
//   wr_en = 1;
//   #(WCLKT * 1)
//   wr_en = 0;

//   // 读出一个数据
//   wait(~empty && ~vivado_fifo_empty);// 两个FIFO都非空时开始读，比较读数据和empty信号是否有差异
//   rd_en = 1;
//   #(RCLKT * 1)
//   rd_en = 0;

//   // 写满
//   wr_en = 1;
//   wait(full && vivado_fifo_full); // 两个FIFO都满时停止写，如果两者不同时满，则先满的一方会有写满的情况发生，但对功能无影响
//   // vivado FIFO IP在FWFT模式时, 设定深度16时实际深度为17, 但仿真显示full会在写入15个数据后置高, 过几个时钟后后拉低,
//   // 再写入一个数据, full又置高; 然后过几个时钟又拉低, 再写入一个数据置高, 如此才能写入17个数据
//   // 所以这里多等待12个wclk周期, 就是为了能真正写满vivado FWFT FIFO
//   #(WCLKT * 12)
//   wr_en = 0;

//   // 读空
//   wait(~empty && ~vivado_fifo_empty);
//   rd_en = 1;
//   wait(empty && vivado_fifo_empty); // 两个FIFO都空时停止读，如果两者不同时空，则先空的一方会有读空的情况发生，但对功能无影响
//   rd_en = 0;

//   #(RCLKT * 10)
//   $stop;
// end


// 使用以下代码时，先注释掉上面的读写使能控制initial
// 同时读写
initial begin
  #(RCLKT * 30)
  $stop;
end

assign wr_en = ~full || ~vivado_fifo_full; // 未满就一直写
assign rd_en = ~empty || ~vivado_fifo_empty; // 未空就一直读

always @(posedge wr_clk) begin
  if (wr_rst)
    din <= 0;
  else if (wr_en && ~full && ~vivado_fifo_full)
    din <= din + 1;
end

assign rd_rst = wr_rst;

endmodule