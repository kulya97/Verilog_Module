`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 14:24:38
// Design Name: 
// Module Name: ui_selectio
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ui_selectio (
    input       I_rstn,
    input       I_lvds_clk_p,
    input       I_lvds_clk_n,
    input [3:0] I_lvds_data_p,
    input [3:0] I_lvds_data_n,

    input I_ref_clk,
    output O_data_clk,

    input [3:0] I_bitslip,
    output O_data_valid,
    output [47:0] O_data
);



  //单端时钟
  wire w_lvds_clk;
  wire w_lvds_clk_tmp;
  //单端数据
  wire w_ch0_1bit_tmp;
  wire w_ch1_1bit_tmp;
  wire w_ch2_1bit_tmp;
  wire w_ch3_1bit_tmp;
  //ddr
  wire [1:0] w_ch0_2bit_tmp;
  wire [1:0] w_ch1_2bit_tmp;
  wire [1:0] w_ch2_2bit_tmp;
  wire [1:0] w_ch3_2bit_tmp;

  //打拍同步
  reg [1:0] r_ch0_2bit;
  reg [1:0] r_ch1_2bit;
  reg [1:0] r_ch2_2bit;
  reg [1:0] r_ch3_2bit;

  wire [7:0] w_lvds_data_8bit;
  wire [7:0] w_lvds_data_8bit_tmp;
  reg [47:0] r_lvds_data_48bit;
  reg [47:0] r_lvds_data_48bit_tmp;
  reg [95:0] r_lvds_data_96bit_tmp;


  reg [3:0] r_data_clk_cnt;
  reg r_data_valid;
  reg [47:0] r_data_out;

  reg [3:0] r_slip_cnt;
  /*****************************************************/
  assign O_data_clk   = I_ref_clk;
  assign O_data_valid = r_data_valid;
  assign O_data[47:0] = r_data_out[47:0];
  /*****************************************************/
  ila_2 ila_2_inst (
      .clk(O_data_clk),  // input wire clk
      .probe0(w_lvds_data_8bit),
      .probe1(I_bitslip),
      .probe2(O_data_valid)
  );


  /*****************************************************/
  IBUFDS #(
    .CCIO_EN_M("TRUE"),
    .CCIO_EN_S("TRUE") 
  ) ibufds_clk_ref (
      .I (I_lvds_clk_p),
      .IB(I_lvds_clk_n),
      .O (w_lvds_clk_tmp)
  );

//   assign w_lvds_clk=!w_lvds_clk_tmp;
  BUFG bufg_clk_ref (
      .I(w_lvds_clk_tmp),
      .O(w_lvds_clk)
  );
  /*******************/
  IBUFDS #(
    .CCIO_EN_M("TRUE"),
    .CCIO_EN_S("TRUE") 
  ) ibufds_clk_ref0 (
      .I (I_lvds_data_p[0]),
      .IB(I_lvds_data_n[0]),
      .O (w_ch0_1bit_tmp)
  );
  IDDRE1 #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      .IS_CB_INVERTED(1'b0),  // Optional inversion for CB
      .IS_C_INVERTED(1'b0)  // Optional inversion for C
  ) IDDRE1_inst0 (
      .Q1(w_ch0_2bit_tmp[1]),  // 1-bit output: Registered parallel output 1
      .Q2(w_ch0_2bit_tmp[0]),  // 1-bit output: Registered parallel output 2
      .C(w_lvds_clk),  // 1-bit input: High-speed clock
      .CB(!w_lvds_clk),  // 1-bit input: Inversion of High-speed clock C
      .D(w_ch0_1bit_tmp),  // 1-bit input: Serial Data Input
      .R(!I_rstn)  // 1-bit input: Active-High Async Reset
  );
  /*******************/
  IBUFDS #(
    .CCIO_EN_M("TRUE"),
    .CCIO_EN_S("TRUE") 
  ) ibufds_clk_ref1 (
      .I (I_lvds_data_p[1]),
      .IB(I_lvds_data_n[1]),
      .O (w_ch1_1bit_tmp)
  );
  IDDRE1 #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      .IS_CB_INVERTED(1'b0),  // Optional inversion for CB
      .IS_C_INVERTED(1'b0)  // Optional inversion for C
  ) IDDRE1_inst1 (
      .Q1(w_ch1_2bit_tmp[1]),  // 1-bit output: Registered parallel output 1
      .Q2(w_ch1_2bit_tmp[0]),  // 1-bit output: Registered parallel output 2
      .C(w_lvds_clk),  // 1-bit input: High-speed clock
      .CB(!w_lvds_clk),  // 1-bit input: Inversion of High-speed clock C
      .D(w_ch1_1bit_tmp),  // 1-bit input: Serial Data Input
      .R(!I_rstn)  // 1-bit input: Active-High Async Reset
  );

  /*******************/
  IBUFDS #(
    .CCIO_EN_M("TRUE"),
    .CCIO_EN_S("TRUE") 
  ) ibufds_clk_ref2 (
      .I (I_lvds_data_p[2]),
      .IB(I_lvds_data_n[2]),
      .O (w_ch2_1bit_tmp)
  );
  IDDRE1 #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      .IS_CB_INVERTED(1'b0),  // Optional inversion for CB
      .IS_C_INVERTED(1'b0)  // Optional inversion for C
  ) IDDRE1_inst2 (
      .Q1(w_ch2_2bit_tmp[1]),  // 1-bit output: Registered parallel output 1
      .Q2(w_ch2_2bit_tmp[0]),  // 1-bit output: Registered parallel output 2
      .C(w_lvds_clk),  // 1-bit input: High-speed clock
      .CB(!w_lvds_clk),  // 1-bit input: Inversion of High-speed clock C
      .D(w_ch2_1bit_tmp),  // 1-bit input: Serial Data Input
      .R(!I_rstn)  // 1-bit input: Active-High Async Reset
  );

  /****************/
  IBUFDS #(
    .CCIO_EN_M("TRUE"),
    .CCIO_EN_S("TRUE") 
  ) ibufds_clk_ref3 (
      .I (I_lvds_data_p[3]),
      .IB(I_lvds_data_n[3]),
      .O (w_ch3_1bit_tmp)
  );
  IDDRE1 #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      .IS_CB_INVERTED(1'b0),  // Optional inversion for CB
      .IS_C_INVERTED(1'b0)  // Optional inversion for C
  ) IDDRE1_inst3 (
      .Q1(w_ch3_2bit_tmp[1]),  // 1-bit output: Registered parallel output 1
      .Q2(w_ch3_2bit_tmp[0]),  // 1-bit output: Registered parallel output 2
      .C(w_lvds_clk),  // 1-bit input: High-speed clock
      .CB(!w_lvds_clk),  // 1-bit input: Inversion of High-speed clock C
      .D(w_ch3_1bit_tmp),  // 1-bit input: Serial Data Input
      .R(!I_rstn)  // 1-bit input: Active-High Async Reset
  );

  assign w_lvds_data_8bit_tmp = {
    r_ch3_2bit[0],
    r_ch2_2bit[0],
    r_ch1_2bit[0],
    r_ch0_2bit[0],
    r_ch3_2bit[1],
    r_ch2_2bit[1],
    r_ch1_2bit[1],
    r_ch0_2bit[1]
  };

  
  always @(posedge w_lvds_clk, negedge I_rstn) begin
    if (!I_rstn) begin
      r_ch0_2bit <= 'd0;
      r_ch1_2bit <= 'd0;
      r_ch2_2bit <= 'd0;
      r_ch3_2bit <= 'd0;
    end else begin
      r_ch0_2bit <= w_ch0_2bit_tmp;
      r_ch1_2bit <= w_ch1_2bit_tmp;
      r_ch2_2bit <= w_ch2_2bit_tmp;
      r_ch3_2bit <= w_ch3_2bit_tmp;
    end
  end

  fifo_generator_1 fifo_generator_11 (
  .wr_clk(w_lvds_clk),  // input wire wr_clk
  .rd_clk(O_data_clk),  // input wire rd_clk
  .din(w_lvds_data_8bit_tmp),        // input wire [11 : 0] din
  .wr_en(1),    // input wire wr_en
  .rd_en(1),    // input wire rd_en
  .dout(w_lvds_data_8bit)     // output wire [11 : 0] dout
);

  // wire w_fifo_wren;
  // wire w_fifo_rden;
  // wire w_fifo_empty;
  // wire w_fifo_full;
  // wire w_wr_rst_busy;
  // wire w_rd_rst_busy;

  // assign w_fifo_wren=!w_wr_rst_busy;
  // assign w_fifo_rden=!w_rd_rst_busy;
  // xpm_fifo_async #(
  //     .READ_MODE          ("fwft"),     // fifo 类型 "std", "fwft"
  //     .FIFO_WRITE_DEPTH   (32),      // fifo 深度
  //     .WRITE_DATA_WIDTH   (12),        // 写端口数据宽度
  //     .READ_DATA_WIDTH    (12),        // 读端口数据宽度
  //     .PROG_EMPTY_THRESH  (5),        // 快空水线
  //     .PROG_FULL_THRESH   (7),        // 快满水线
  //     .RD_DATA_COUNT_WIDTH(1),         // 读侧数据统计值的位宽
  //     .WR_DATA_COUNT_WIDTH(1),         // 写侧数据统计值的位宽
  //     .USE_ADV_FEATURES   ("0707"),    //各标志位的启用控制
  //     .FULL_RESET_VALUE   (0),         // fifo 复位值
  //     .DOUT_RESET_VALUE   ("0"),       // fifo 复位值
  //     .CASCADE_HEIGHT     (0),         // DECIMAL
  //     .CDC_SYNC_STAGES    (2),         // 指定CDC路径上的同步阶段数如果FIFO_WRITE_PDEPTH=16，则必须小于5
  //     .ECC_MODE           ("no_ecc"),  // “no_ecc”,"en_ecc"
  //     .FIFO_MEMORY_TYPE   ("auto"),    // 指定资源类型，auto，block，distributed
  //     .FIFO_READ_LATENCY  (1),         // 读取数据路径中的输出寄存器级数，如果READ_MODE=“fwft”，则唯一适用的值为0。
  //     .RELATED_CLOCKS     (0),         // 指定wr_clk和rd_clk是否具有相同的源但不同的时钟比率
  //     .SIM_ASSERT_CHK     (0),         // 0=禁用仿真消息，1=启用仿真消息
  //     .WAKEUP_TIME        (0)          // 禁用sleep
  // ) xpm_fifo_async_inst (
  //     .rst          (!I_rstn),            // 1-bit input: fifo复位
  //     .wr_clk       (w_lvds_clk),         // 1-bit input:写时钟
  //     .wr_en        (w_fifo_wren),          // 1-bit input:写使能
  //     .din          (w_lvds_data_8bit_tmp),            // data  input:写数据
  //     .rd_clk       (O_data_clk),         // 1-bit input:读时钟
  //     .rd_en        (w_fifo_rden),          // 1-bit input:读使能
  //     .dout         (w_lvds_data_8bit),           // data  output读复位
  //     .empty        (w_fifo_empty),          // 1-bit output:fifo空标志位
  //     .full         (w_fifo_full),           // 1-bit output:fifo满标志位
  //     .wr_rst_busy  (w_wr_rst_busy),    // 1-bit output: 写入复位忙：活动高指示FIFO当前处于复位状态
  //     .rd_rst_busy  (w_rd_rst_busy)   // 1-bit output: 读取复位忙：活动高指示FIFO当前处于复位状态
  // );

  /*****************************************************/

  /****************************************************/
  always @(posedge O_data_clk, negedge I_rstn) begin
    if (!I_rstn) r_lvds_data_96bit_tmp <= 48'd0;
    else r_lvds_data_96bit_tmp[95:0] <= {r_lvds_data_96bit_tmp[87:0], w_lvds_data_8bit[7:0]};
  end

  /****************************************************/

  always @(posedge O_data_clk, negedge I_rstn) begin
    if (!I_rstn) r_slip_cnt <= 1'd0;
    else if (I_bitslip == 4'hf && r_slip_cnt < 4'd5) r_slip_cnt <= r_slip_cnt + 1'd1;
    else if (I_bitslip == 4'hf && r_slip_cnt == 4'd5) r_slip_cnt <= 1'd0;
    else r_slip_cnt <= r_slip_cnt;
  end

  always @(posedge O_data_clk, negedge I_rstn) begin
    if (!I_rstn) begin
      r_lvds_data_48bit <= 'd0;
    end else
      case (r_slip_cnt)
        4'd0: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[47:0]};
        4'd1: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[55:8]};
        4'd2: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[63:16]};
        4'd3: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[71:24]};
        4'd4: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[79:32]};
        4'd5: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[87:40]};
        default: r_lvds_data_48bit <= r_lvds_data_96bit_tmp[47:0];
      endcase
  end
  /****************************************************/

  //计数，每6个数据输出一组

  always @(posedge O_data_clk, negedge I_rstn) begin
    if (!I_rstn) r_data_clk_cnt <= 1'd0;
    else if (r_data_clk_cnt == 4'd5) r_data_clk_cnt <= 1'd0;
    else r_data_clk_cnt <= r_data_clk_cnt + 1'd1;
  end

  //输出锁存
  always @(posedge O_data_clk, negedge I_rstn) begin
    if (!I_rstn) r_data_out[47:0] <= 48'd0;
    else if (r_data_clk_cnt == 4'd1) r_data_out[47:0] <= r_lvds_data_48bit[47:0];
    else r_data_out[47:0] <= r_data_out[47:0];
  end
  //数据有效
  always @(posedge O_data_clk, negedge I_rstn) begin
    if (!I_rstn) r_data_valid <= 1'b0;
    else if (r_data_clk_cnt == 4'd1) r_data_valid <= 1'b1;
    else r_data_valid <= 1'b0;
  end
  /****************************************************/
endmodule
