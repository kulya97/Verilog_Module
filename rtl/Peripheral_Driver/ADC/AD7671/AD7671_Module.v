module AD7671_Module (
    input CLK_50M,
    input RST_N,

    output adc_reset_o,
    output adc_pd_o,
    output adc_invsync_o,
    output adc_rdc_o,
    output adc_exit_o,

    output        adc_cs_n_o,
    output        adc_rd_n_o,
    output        adc_cnvst_n_o,
    input         adc_busy_i,
    input         adc_sync_i,
    output        adc_sclk_o,
    input         adc_sdout_i,
    /*******************************/
    output        ui_valid_o,
    output [15:0] ui_data_o,
    input  [31:0] UART_IN,
    input         uart_ready
);



  reg         invsync;
  reg         rdc;
  reg         exit;
  wire [15:0] data;
  reg  [15:0] ui_data;
  reg         uart_valid_r;

  always @(posedge CLK_50M, negedge RST_N) begin
    if (!RST_N) begin
      uart_valid_r <= 1'b0;
      ui_data      <= 16'b0;
      invsync      <= 1'b1;
      rdc          <= 1'b0;
      exit         <= 1'b1;
    end else if (uart_ready && (UART_IN[31:16] == 16'hcccc)) begin
      uart_valid_r <= 1'b1;
      ui_data      <= data;
    end else if (uart_ready && (UART_IN[31:16] == 16'hcc51)) invsync <= 1'b1;
    else if (uart_ready && (UART_IN[31:16] == 16'hcc50)) invsync <= 1'b0;
    else if (uart_ready && (UART_IN[31:16] == 16'hcc41)) exit <= 1'b1;
    else if (uart_ready && (UART_IN[31:16] == 16'hcc40)) exit <= 1'b0;
    else if (uart_ready && (UART_IN[31:16] == 16'hcc71)) rdc <= 1'b1;
    else if (uart_ready && (UART_IN[31:16] == 16'hcc70)) rdc <= 1'b0;
    else begin
      uart_valid_r <= 1'b0;
      ui_data      <= ui_data;
    end
  end
  assign adc_invsync_o = invsync;
  assign adc_rdc_o     = rdc;
  assign adc_exit_o    = exit;

  assign ui_valid_o    = uart_valid_r;
  assign ui_data_o     = ui_data;
  wire ui_ready_i = 1'b1;
  //   wire                    adc_sclk;
  //   assign adc_sclk_o = adc_sclk;
  //   SPI_Master_Core SPI_Master_Core0 (
  //       .sys_clk      (CLK_50M),
  //       .rst_n        (RST_N),
  //       .adc_cs_n_o   (adc_cs_n_o),
  //       .adc_rd_n_o   (adc_rd_n_o),
  //       .adc_cnvst_n_o(adc_cnvst_n_o),
  //       .adc_busy_i   (adc_busy_i),
  //       .adc_reset_o  (adc_reset_o),
  //       .adc_pd_o     (adc_pd_o),
  //       .adc_data_i   (),
  //       .adc_din      (adc_sdout_i),
  //       .adc_sclk     (adc_sclk),
  //       .adc_sync_i   (adc_sync_i),
  //       .ui_ready_i   (ui_ready_i),
  //       .ui_valid_o   (),
  //       .ui_data_o    (data)
  //   );
  reg                     clk_1hz;
  reg                     clk_1khz;
  reg                     clk_1mhz;
  spi_read_x16 u_spi_read_x16 (
      .clk_in       (clk_1mhz),
      .rstn         (RST_N),
      .adc_cs_n_o   (adc_cs_n_o),
      .adc_rd_n_o   (adc_rd_n_o),
      .adc_pd_o     (adc_pd_o),
      .adc_cnvst_n_o(adc_cnvst_n_o),
      .adc_reset_o  (adc_reset_o),
      .adc_busy_i   (adc_busy_i),

      .spi_sdin(adc_sdout_i),
      .spi_sclk(adc_sclk_o),

      .rdata(data)
  );
  reg [4:0] clk_cnt1;
  always @(posedge CLK_50M or negedge RST_N) begin
    if (RST_N == 1'b0) begin
      clk_cnt1 <= 5'd0;
      clk_1mhz <= 1'b0;
    end else begin
      clk_cnt1 <= clk_cnt1 + 1;
      if (clk_cnt1 == 5'd12) begin
        clk_cnt1 <= 5'd0;
        clk_1mhz <= ~clk_1mhz;
      end
    end
  end

endmodule
