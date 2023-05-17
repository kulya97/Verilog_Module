`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/19 20:41:12
// Design Name: 
// Module Name: state_tb
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


module state_tb;

  // udp_rx Inputs
  reg clk = 0;
  reg rst_n = 0;
  parameter PERIOD = 10;
  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end
  initial begin
    #(PERIOD * 2) rst_n = 1;
  end

  localparam st_idle = 7'd0;  //初始状态，等待接收前导码
  localparam st_preamble = 7'd1;  //接收前导码状态 
  localparam st_eth_head = 7'd2;  //接收以太网帧头
  localparam st_ip_head = 7'd3;  //接收IP首部
  localparam st_udp_head = 7'd4;  //接收UDP首部
  localparam st_rx_data = 7'd5;  //接收有效数据
  localparam st_rx_end = 7'd6;  //接收结束
  localparam st_rx_error = 7'd7;  //接收结束

  //reg define
  reg [6:0] cur_state;
  reg [6:0] next_state;
  //*****************************************************
  //**                    main code
  //*****************************************************

  //(三段式状态机)同步时序描述状态转移
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cur_state <= st_idle;
    else cur_state <= next_state;
  end
  reg [11:0] state_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state_cnt <= 12'd0;
    else if (next_state != cur_state) state_cnt <= 12'd0;
    else state_cnt <= state_cnt + 1'd1;
  end

  //组合逻辑判断状态转移条件
  always @(*) begin
    next_state = st_idle;
    case (cur_state)
      st_idle: begin  //等待接收前导码
        next_state = st_preamble;
      end
      st_preamble: begin
        if (state_cnt == 12'd8 - 1) next_state = st_eth_head;
        else next_state = st_preamble;
      end
      st_eth_head: begin  //接收以太网帧头
        if (state_cnt == 12'd14 - 1) next_state = st_ip_head;
        else next_state = st_eth_head;
      end
      st_ip_head: begin  //接收IP首部
        if (state_cnt == 12'd20 - 1) next_state = st_udp_head;
        else next_state = st_ip_head;
      end
      st_udp_head: begin  //接收UDP首部
        if (state_cnt == 12'd8 - 1) next_state = st_rx_data;
        else next_state = st_udp_head;
      end
      st_rx_data: begin  //接收有效数据
        if (state_cnt == 10 - 1) next_state = st_rx_end;
        else next_state = st_rx_data;
      end
      st_rx_end: begin  //接收结束
        if (state_cnt == 10 - 1) next_state = st_idle;
        else next_state = st_rx_end;
      end
      st_rx_error: begin  //接收异常
        next_state = st_rx_error;
      end
      default: next_state = st_idle;
    endcase
  end
  reg [31:0] rec_data;
  reg [ 7:0] gmii_rxd;
  reg [ 3:0] rec_cnt;
  reg [ 7:0] rxd_data;  //打拍数据
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) gmii_rxd <= 7'd0;
    else if (cur_state == st_idle) gmii_rxd <= 4'd0;
    else gmii_rxd <= gmii_rxd + 1'd1;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rxd_data <= 8'd0;
    else rxd_data <= gmii_rxd;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_data <= 32'd0;
    else if (next_state == st_idle) rec_data <= 32'd0;
    else if (next_state != st_rx_data) rec_data <= 32'd0;
    else if (rec_cnt == 4'd0) rec_data[31:24] <= rxd_data[7:0];
    else if (rec_cnt == 4'd1) rec_data[23:16] <= rxd_data[7:0];
    else if (rec_cnt == 4'd2) rec_data[15:8] <= rxd_data[7:0];
    else if (rec_cnt == 4'd3) rec_data[7:0] <= rxd_data[7:0];
    else rec_data[7:0] <= rec_data[7:0];
  end
  /****************解析数据*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_cnt <= 4'd0;
    else if (rec_cnt == 4'd3) rec_cnt <= 4'd0;
    else if (next_state == st_rx_data) rec_cnt <= rec_cnt + 1'd1;  //这里最好还是改一下
    else rec_cnt <= 4'd0;
  end
  reg [4:0] test_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) test_cnt <= 4'd0;
    else if (next_state == st_rx_data) test_cnt <= test_cnt + 1'd1;  //这个最好还是改一下
    else test_cnt <= 4'd0;
  end
  reg rec_en;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_en <= 1'd0;
    else if (cur_state == st_rx_data && rec_cnt == 4'd3 || (cur_state == st_rx_data && next_state == st_rx_end)) rec_en <= 1'b1;
    else rec_en <= 1'd0;
  end
  /***************************************************************/

endmodule
