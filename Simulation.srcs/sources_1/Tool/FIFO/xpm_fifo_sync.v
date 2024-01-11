module xpm_fifo_sync;
  xpm_fifo_sync #(
      .READ_MODE          ("std"),     // fifo 类型 "std", "fwft"
      .FIFO_WRITE_DEPTH   (2048),      // fifo 深度
      .WRITE_DATA_WIDTH   (32),        // 写端口数据宽度
      .READ_DATA_WIDTH    (32),        // 读端口数据宽度
      .PROG_EMPTY_THRESH  (10),        // 快空水线
      .PROG_FULL_THRESH   (10),        // 快满水线
      .RD_DATA_COUNT_WIDTH(1),         // 读侧数据统计值的位宽
      .WR_DATA_COUNT_WIDTH(1),         // 写侧数据统计值的位宽
      .USE_ADV_FEATURES   ("0707"),    //各标志位的启用控制
      .FULL_RESET_VALUE   (0),         // fifo 复位值
      .DOUT_RESET_VALUE   ("0"),       // fifo 复位值
      .CASCADE_HEIGHT     (0),         // DECIMAL
      .ECC_MODE           ("no_ecc"),  // “no_ecc”,"en_ecc"
      .FIFO_MEMORY_TYPE   ("auto"),    // 指定资源类型，auto，block，distributed
      .FIFO_READ_LATENCY  (1),         // 读取数据路径中的输出寄存器级数，如果READ_MODE=“fwft”，则唯一适用的值为0。
      .SIM_ASSERT_CHK     (0),         // 0=禁用仿真消息，1=启用仿真消息
      .WAKEUP_TIME        (0)          // 禁用sleep
  ) xpm_fifo_sync_inst (
      .rst          (rst),            // 1-bit input: fifo复位
      .wr_clk       (wr_clk),         // 1-bit input:写时钟
      .wr_en        (wr_en),          // 1-bit input:写使能
      .din          (din),            // data  input:写数据
      .rd_en        (rd_en),          // 1-bit input:读使能
      .dout         (dout),           // data  output读复位
      .data_valid   (data_valid),     // 1-bit output:数据有效
      .wr_ack       (wr_ack),         // 1-bit output:写响应
      .empty        (empty),          // 1-bit output:fifo空标志位
      .full         (full),           // 1-bit output:fifo满标志位
      .almost_empty (almost_empty),   // 1-bit output:快满标志位
      .almost_full  (almost_full),    // 1-bit output:快空标志位
      .prog_empty   (prog_empty),     // 1-bit output:快满标志位
      .prog_full    (prog_full),      // 1-bit output:快空标志位
      .rd_data_count(rd_data_count),  // 1-bit output:fifo读端口计数
      .wr_data_count(wr_data_count),  // 1-bit output:fifo写端口计数
      .rd_rst_busy  (rd_rst_busy),    // 1-bit output: 写入复位忙：活动高指示FIFO当前处于复位状态
      .wr_rst_busy  (wr_rst_busy),    // 1-bit output: 读取复位忙：活动高指示FIFO当前处于复位状态
      .overflow     (overflow),       // 1-bit output:写溢出标志位
      .underflow    (underflow),      // 1-bit output:欠流： 表示上一个时钟周期内的读取请求（rd_en）因FIFO为空而被拒绝。欠流FIFO对FIFO没有破坏性
      .dbiterr      (dbiterr),        // 1-bit output: 双位错误：表示ECC解码器检测到双比特错误，并且FIFO核心中的数据被破坏。
      .sbiterr      (sbiterr),        // 1-bit output: 单个位错误：表示ECC解码器检测到并修复了单个位错误。
      .injectdbiterr(injectdbiterr),  // 1-bit input: 双位错误注入：如果ECC功能用于块RAM或UltraRAM宏，则注入双位错误。
      .injectsbiterr(injectsbiterr),  // 1-bit input: 单位错误注入：如果ECC功能用于块RAM或UltraRAM宏，则注入单位错误。
      .sleep        (sleep)           // 1-bit input: 动态省电：如果睡眠为高，则内存/ffo块处于省电模式。
  );

endmodule
