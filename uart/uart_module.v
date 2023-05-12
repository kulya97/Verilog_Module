module uart_module #(
    parameter CLK_FRE    = 50,      //Mhz
    parameter BPS        = 115200,  //uart bps
    parameter IDLE_CYCLE = 20,      //idle time
    parameter REG_SIZE   = 32
) (
    input                 sys_clk,        //system clock 50Mhz on board
    input                 rst_n,          //reset ,low active
    input                 uart_rx,
    output                uart_tx,
    output [REG_SIZE-1:0] uart_rx_reg,    //uart reg 
    output                uart_rx_ready,  //if update ready=1
    input  [        31:0] uart_tx_reg,
    input                 uart_tx_en
);
  /*******************************************************************/
  wire        tx_data_valid;
  wire        tx_data_ready;
  wire        tx_ack;
  wire [ 7:0] tx_data;

  wire        rx_data_valid;
  wire        rx_data_ready;
  wire        rx_ack;
  wire        rx_frame_ack;
  wire [ 7:0] rx_data;
  /*******************************************************************/
  wire [31:0] din;  // input wire [31 : 0] din
  wire        wr_en;  // input wire wr_en
  wire        rd_en;  // input wire rd_en
  wire [ 7:0] dout;  // output wire [7 : 0] dout
  wire        full;  // output wire full
  wire        empty;  // output wire empty
  wire        valid;
  /***********************************************************************/
  //开启接收数据
  assign rx_data_ready = 1'b1;
  /***********************************************************************/
  //写tx fifo数据
  assign wr_en         = uart_tx_en;
  assign din           = uart_tx_reg;
  /***********************************************************************/
  //读tx fifo数据
  assign rd_en         = valid && tx_data_ready;
  assign tx_data       = dout;
  /***********************************************************************/
  //发送数据
  assign tx_data_valid = valid && tx_data_ready;
  /***********************************************************************/
  uart_rx_module #(
      .CLK_FRE(CLK_FRE),
      .BAUD_RATE(BPS),
      .IDLE_CYCLE(IDLE_CYCLE)
  ) uart_rx_inst (
      .clk          (sys_clk),
      .rst_n        (rst_n),
      .rx_data      (rx_data),
      .rx_data_valid(rx_data_valid),
      .rx_data_ready(rx_data_ready),
      .rx_frame_ack (rx_frame_ack),
      .rx_ack       (rx_ack),
      .rx_pin       (uart_rx)
  );

  uart_tx_module #(
      .CLK_FRE  (CLK_FRE),
      .BAUD_RATE(BPS)
  ) uart_tx_inst (
      .clk          (sys_clk),
      .rst_n        (rst_n),
      .tx_data      (tx_data),
      .tx_data_valid(tx_data_valid),
      .tx_data_ready(tx_data_ready),
      .tx_ack       (tx_ack),
      .tx_pin       (uart_tx)
  );

  fifo_tx fifo_tx_inst (
      .clk  (sys_clk),  // input wire clk
      .din  (din),      // input wire [31 : 0] din
      .wr_en(wr_en),    // input wire wr_en
      .rd_en(rd_en),    // input wire rd_en
      .dout (dout),     // output wire [7 : 0] dout
      .full (full),     // output wire full
      .empty(empty),    // output wire empty
      .valid(valid)     // output wire valid
  );
  uart_reg #(
      .REG_SIZE(REG_SIZE)
  ) uart_reg0 (
      .clk          (sys_clk),
      .rst_n        (rst_n),
      .rx_data      (rx_data),
      .rx_data_valid(rx_data_valid),
      .rx_frame_ack (rx_frame_ack),
      .rx_ack       (rx_ack),
      .reg_data     (uart_rx_reg),
      .reg_ready    (uart_rx_ready)
  );

endmodule
