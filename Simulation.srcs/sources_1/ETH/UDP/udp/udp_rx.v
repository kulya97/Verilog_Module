//****************************************************************************************//

module udp_rx (
    input clk,   //时钟信号
    input rst_n, //复位信号，低电平有效

    input             gmii_rx_dv,    //GMII输入数据有效信号
    input      [ 7:0] gmii_rxd,      //GMII输入数据
    output reg        rec_pkt_done,  //以太网单包数据接收完成信号
    output reg        rec_en,        //以太网接收的数据使能信号
    output reg [31:0] rec_data,      //以太网接收的数据
    output reg [15:0] rec_byte_num   //以太网接收的有效字数 单位:byte     
);
  //parameter define
  //开发板MAC地址 00-11-22-33-44-55
  parameter BOARD_MAC = 48'h00_11_22_33_44_55;
  //开发板IP地址 192.168.1.10 
  parameter BOARD_IP = {8'd192, 8'd168, 8'd1, 8'd10};
  localparam ETH_TYPE = 16'h0800;  //以太网协议类型 IP协议

  reg  [ 63:0] preamble_header;  //前导码
  reg  [111:0] eth_header;  //以太网部首
  reg  [159:0] ip_header;  //ip部首
  reg  [ 63:0] udp_header;  //udp部首
  //   reg [ 47:0] des_mac;  //目的MAC地址
  //   reg [ 15:0] eth_type;  //以太网类型
  //   reg [ 31:0] des_ip;  //目的IP地址

  wire [ 47:0] des_mac;  //目的MAC地址
  wire [ 15:0] eth_type;  //以太网类型
  wire [ 31:0] des_ip;  //目的IP地址
  wire [ 15:0] udp_byte_num;
  assign des_mac      = eth_header[111:64];
  assign eth_type     = eth_header[15:0];
  assign des_ip       = ip_header[31:0];
  assign udp_byte_num = udp_header[31:16];
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
  /******************************************************/
  reg [7:0] rxd_data;  //打拍数据
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rxd_data <= 8'd0;
    else rxd_data <= gmii_rxd;
  end
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
      st_idle: begin  //等待
        if (gmii_rx_dv) next_state = st_preamble;
        else next_state = st_idle;
      end
      st_preamble: begin  //接收前导码
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (state_cnt == 12'd8 - 1) next_state = st_eth_head;
        else next_state = st_preamble;
      end
      st_eth_head: begin  //接收以太网帧头
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (preamble_header[63:0] != 64'h5555_5555_5555_55d5) next_state = st_rx_error;  //前导码错误
        else if (state_cnt == 12'd14 - 1) next_state = st_ip_head;
        else next_state = st_eth_head;
      end
      st_ip_head: begin  //接收IP首部
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (des_mac[47:0] != BOARD_MAC && (des_mac[47:0] != 48'hff_ff_ff_ff_ff_ff)) next_state = st_rx_error;  //本机mac错误
        else if (eth_header[15:0] != ETH_TYPE) next_state = st_rx_error;  //iptype错误
        else if (state_cnt == 12'd20 - 1) next_state = st_udp_head;
        else next_state = st_ip_head;
      end
      st_udp_head: begin  //接收UDP首部
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (ip_header[31:0] != BOARD_IP) next_state = st_rx_error;  //本机ip错误
        else if ((state_cnt == 12'd8 - 1)) next_state = st_rx_data;
        else next_state = st_udp_head;
      end
      st_rx_data: begin  //接收有效数据
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (state_cnt == udp_byte_num[15:0] - 16'd9) next_state = st_rx_end;
        else next_state = st_rx_data;
      end
      st_rx_end: begin  //接收结束
        if (!gmii_rx_dv) next_state = st_idle;
        else next_state = st_rx_end;
      end
      st_rx_error: begin  //接收异常
        if (!gmii_rx_dv) next_state = st_idle;
        else next_state = st_rx_error;
      end
      default: next_state = st_idle;
    endcase
  end

  /****************解析前导码和sfd*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) preamble_header <= 64'd0;
    else if (cur_state == st_idle) preamble_header <= 64'd0;
    else if (cur_state == st_preamble) preamble_header <= {preamble_header[55:0], rxd_data[7:0]};
    else preamble_header <= preamble_header;
  end
  /****************解析以太网帧头*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) eth_header <= 112'd0;
    else if (cur_state == st_idle) eth_header <= 112'd0;
    else if (cur_state == st_eth_head) eth_header <= {eth_header[103:0], rxd_data[7:0]};
    else eth_header <= eth_header;
  end

  /****************解析ip部首*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) ip_header <= 160'd0;
    else if (cur_state == st_idle) ip_header <= 160'd0;
    else if (cur_state == st_ip_head) ip_header <= {ip_header[151:0], rxd_data[7:0]};
    else ip_header <= ip_header;
  end
  /****************解析udp部首*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) udp_header <= 64'd0;
    else if (cur_state == st_idle) udp_header <= 64'd0;
    else if (cur_state == st_udp_head) udp_header <= {udp_header[55:0], rxd_data[7:0]};
    else udp_header <= udp_header;
  end
  /****************解析数据*************************/
  reg [3:0] rec_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_cnt <= 4'd0;
    else if (rec_cnt == 4'd3) rec_cnt <= 4'd0;
    else if (cur_state != next_state) rec_cnt <= 4'd0;  //这里最好还是改一下
    else rec_cnt <= rec_cnt + 1'd1;
  end

  reg [7:0] rxd_data_d;  //打拍数据
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rxd_data_d <= 8'd0;
    else rxd_data_d <= rxd_data;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_data <= 32'd0;
    else if (cur_state == st_idle) rec_data <= 32'd0;
    else if (cur_state != st_rx_data) rec_data <= 32'd0;
    else if (rec_cnt == 4'd0) rec_data[31:24] <= rxd_data[7:0];
    else if (rec_cnt == 4'd1) rec_data[23:16] <= rxd_data[7:0];
    else if (rec_cnt == 4'd2) rec_data[15:8] <= rxd_data[7:0];
    else if (rec_cnt == 4'd3) rec_data[7:0] <= rxd_data[7:0];
    else rec_data[7:0] <= rec_data[7:0];
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_en <= 1'd0;
    else if (cur_state == st_rx_data && rec_cnt == 4'd3 || (cur_state == st_rx_data && next_state == st_rx_end)) rec_en <= 1'b1;
    else rec_en <= 1'd0;
  end
  /***************************************************************/
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rec_pkt_done <= 1'd0;
      rec_byte_num <= 16'd0;
    end else if (cur_state == st_rx_data && next_state == st_rx_end) begin
      rec_pkt_done <= 1'b1;
      rec_byte_num <= udp_header[31:16] - 16'd8;
    end else begin
      rec_pkt_done <= 1'd0;
      rec_byte_num <= rec_byte_num;
    end
  end
endmodule
