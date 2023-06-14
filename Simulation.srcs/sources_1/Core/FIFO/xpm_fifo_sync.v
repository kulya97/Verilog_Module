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
      .rst          (rst),
      .wr_clk       (wr_clk),
      .wr_en        (wr_en),
      .din          (din),
      .rd_en        (rd_en),
      .dout         (dout),
      .data_valid   (data_valid),
      .wr_ack       (wr_ack),
      .rd_data_count(rd_data_count),
      .wr_data_count(wr_data_count),
      .empty        (empty),
      .full         (full),
      .almost_empty (almost_empty),
      .almost_full  (almost_full),
      .overflow     (overflow),
      .prog_empty   (prog_empty),
      .prog_full    (prog_full),
      .rd_rst_busy  (rd_rst_busy),
      .wr_rst_busy  (wr_rst_busy),
      .underflow    (underflow),
      .dbiterr      (dbiterr),
      .sbiterr      (sbiterr),
      .injectdbiterr(injectdbiterr),
      .injectsbiterr(injectsbiterr),
      .sleep        (sleep)
  );

endmodule
