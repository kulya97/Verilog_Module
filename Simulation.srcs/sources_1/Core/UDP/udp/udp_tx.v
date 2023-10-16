module udp_tx (
    input        clk,      //时钟信号
    input        rst_n,    //复位信号，低电平有效
    input [47:0] des_mac,  //发送的目标MAC地址
    input [31:0] des_ip,   //发送的目标IP地址

    input             tx_start_en,  //以太网开始发送信号
    input      [ 7:0] tx_data,      //以太网待发送数据
    input      [15:0] tx_byte_num,  //以太网发送的有效字节数
    output reg        tx_done,      //以太网发送完成信号
    output reg        tx_req,       //读数据请求信号

    input      [31:0] crc_data,  //CRC校验数据
    input      [31:0] crc_next,  //CRC下次校验完成数据
    output reg        crc_en,    //CRC开始校验使能
    output reg        crc_clr,   //CRC数据复位信号

    output reg       gmii_tx_en,  //GMII输出数据有效信号
    output reg [7:0] gmii_txd     //GMII输出数据
);

  //parameter define
  //开发板MAC地址
  parameter BOARD_MAC = 48'h00_11_22_33_44_55;
  //开发板IP地址
  parameter BOARD_IP = {8'd192, 8'd168, 8'd1, 8'd123};
  //目的MAC地址
  parameter DES_MAC = 48'hff_ff_ff_ff_ff_ff;
  //目的IP地址
  parameter DES_IP = {8'd192, 8'd168, 8'd1, 8'd102};
  //以太网协议类型 IP协议
  localparam ETH_TYPE = 16'h0800;

  //以太网数据最小46个字节，IP首部20个字节+UDP首部8个字节
  //所以数据至少46-20-8=18个字节
  localparam MIN_DATA_NUM = 16'd18;
  //reg define
  reg [6:0] cur_state;
  reg [6:0] next_state;
  localparam st_idle = 7'd0;  //初始状态，等待开始发送信号
  localparam st_init = 7'd1;  //初始状态，等待开始发送信号
  localparam st_check_sum = 7'd2;  //IP首部校验和
  localparam st_preamble = 7'd3;  //发送前导码+帧起始界定符
  localparam st_eth_head = 7'd4;  //发送以太网帧头
  localparam st_ip_head = 7'd5;  //发送IP首部
  localparam st_udp_head = 7'd6;  //发送UDP首部
  localparam st_tx_data = 7'd7;  //发送数据
  localparam st_crc = 7'd8;  //发送CRC校验值
  localparam st_done = 7'd9;
  /********************************************************/

  reg  [ 63:0] preamble_header;  //前导码
  reg  [111:0] eth_header;  //以太网部首
  reg  [159:0] ip_header;  //ip部首
  reg  [ 63:0] udp_header;  //udp部首
  reg  [ 31:0] check_buffer;  //首部校验和
  reg  [ 31:0] fcs_buffer;

  reg  [ 15:0] tx_data_num;  //发送的有效数据字节个数
  reg  [ 15:0] total_num;  //总字节数
  reg  [ 15:0] udp_num;  //UDP字节数
  wire [ 15:0] real_tx_data_num;  //实际发送的字节数(以太网最少字节要求)


  reg          start_en_d0;
  reg          start_en_d1;
  wire         pos_start_en;  //开始发送数据上升沿

  //*****************************************************
  //**                    main code
  //*****************************************************

  assign pos_start_en     = (~start_en_d1) & start_en_d0;
  assign real_tx_data_num = (tx_data_num >= MIN_DATA_NUM) ? tx_data_num : MIN_DATA_NUM;

  //采tx_start_en的上升沿
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_en_d0 <= 1'b0;
      start_en_d1 <= 1'b0;
    end else begin
      start_en_d0 <= tx_start_en;
      start_en_d1 <= start_en_d0;
    end
  end

  //寄存数据有效字节
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_data_num <= 16'd0;
      total_num   <= 16'd0;
      udp_num     <= 16'd0;
    end else begin
      if (pos_start_en && cur_state == st_idle) begin
        //数据长度
        tx_data_num <= tx_byte_num;
        //IP长度：有效数据+IP首部长度            
        total_num   <= tx_byte_num + 16'd28;
        //UDP长度：有效数据+UDP首部长度            
        udp_num     <= tx_byte_num + 16'd8;
      end
    end
  end

  /*****************************************************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) cur_state <= st_idle;
    else cur_state <= next_state;
  end

  reg [11:0] state_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_cnt <= 12'd0;
    else if (next_state != cur_state) state_cnt <= 12'd0;
    else state_cnt <= state_cnt + 1'd1;
  end

  always @(*) begin
    //next_state = st_idle;
    case (cur_state)
      st_idle: begin  //等待发送数据
        if (pos_start_en) next_state = st_init;
        else next_state = st_idle;
      end
      st_init: begin  //
        next_state = st_check_sum;
      end
      st_check_sum: begin  //IP首部校验
        if (state_cnt == 12'd5 - 1) next_state = st_preamble;
        else next_state = st_check_sum;
      end
      st_preamble: begin  //发送前导码+帧起始界定符
        if (state_cnt == 12'd8 - 1) next_state = st_eth_head;
        else next_state = st_preamble;
      end
      st_eth_head: begin  //发送以太网首部
        if (state_cnt == 12'd14 - 1) next_state = st_ip_head;
        else next_state = st_eth_head;
      end
      st_ip_head: begin  //发送IP首部
        if (state_cnt == 12'd20 - 1) next_state = st_udp_head;
        else next_state = st_ip_head;
      end
      st_udp_head: begin  //UDP首部
        if (state_cnt == 12'd8 - 1) next_state = st_tx_data;
        else next_state = st_udp_head;
      end
      st_tx_data: begin  //发送数据
        if (state_cnt == real_tx_data_num - 1) next_state = st_crc;
        else next_state = st_tx_data;
      end
      st_crc: begin  //发送CRC校验值
        if (state_cnt == 12'd4 - 1) next_state = st_done;
        else next_state = st_crc;
      end
      st_done: begin
        next_state = st_idle;
      end
      default: next_state = st_idle;
    endcase
  end

  always @(posedge clk) begin
    if (cur_state == st_init) preamble_header[63:0] <= {8'h55, 8'h55, 8'h55, 8'h55, 8'h55, 8'h55, 8'h55, 8'hd5};
    else if (cur_state == st_preamble) preamble_header[63:0] <= {preamble_header[55:0], 8'h00};
    else preamble_header[63:0] <= preamble_header[63:0];
  end

  /**************************eth header***********************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) eth_header[111:0] <= {DES_MAC[47:0], BOARD_MAC[47:0], ETH_TYPE[15:0]};
    else if (cur_state == st_init) eth_header[111:0] <= {des_mac[47:0], BOARD_MAC[47:0], ETH_TYPE[15:0]};
    else if (cur_state == st_eth_head) eth_header[111:0] <= {eth_header[103:0], 8'h00};
  end
  /**************************IP header***********************************/
  reg [15:0] r_fcnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_fcnt[15:0] <= 'd0;
    else if (cur_state == st_done) r_fcnt[15:0] <= r_fcnt[15:0] + 'd1;
    else r_fcnt[15:0] <= r_fcnt[15:0];
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      check_buffer     <= 32'd0;
      ip_header[159:0] <= 160'd0;
    end else if (cur_state == st_init) begin
      check_buffer       <= 32'd0;
      //版本号：4 首部长度：5(单位:32bit,20byte/4=5)
      ip_header[159:128] <= {8'h45, 8'h00, total_num[15:0]};
      //16位标识，每次发送累加1     
      ip_header[127:112] <= r_fcnt[15:0];
      // ip_header[127:112] <= 16'd1;
      //bit[15:13]: 010表示不分片
      ip_header[111:96]  <= 16'h4000;
      //协议：17(udp)                  
      ip_header[95:64]   <= {8'h40, 8'h11, 8'h00, 8'h00};
      //源IP地址
      ip_header[63:32]   <= BOARD_IP[31:0];
      //目的IP地址    
      if (des_ip != 32'd0) ip_header[31:0] <= des_ip[31:0];
      else ip_header[31:0] <= DES_IP[31:0];
    end else if (cur_state == st_check_sum) begin
      if (state_cnt == 5'd0) begin
        check_buffer[31:0] <= ip_header[159:144] + ip_header[143:128] + ip_header[127:112] + ip_header[111:96] + ip_header[95:80] + ip_header[79:64] + ip_header[63:48] + ip_header[47:32] + ip_header[31:16] + ip_header[15:0];
      end else if (state_cnt == 5'd1)  //可能出现进位,累加一次
        check_buffer[31:0] <= check_buffer[31:16] + check_buffer[15:0];
      else if (state_cnt == 5'd2) begin  //可能再次出现进位,累加一次
        check_buffer[31:0] <= check_buffer[31:16] + check_buffer[15:0];
      end else if (state_cnt == 5'd3) begin  //按位取反
        ip_header[79:64] <= ~check_buffer[15:0];
      end
    end else if (cur_state == st_ip_head) ip_header[159:0] <= {ip_header[151:0], 8'h00};
  end
  /**************************udp header***********************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) udp_header[63:0] <= 64'd0;
    else if (cur_state == st_init) begin
      //16位源端口号：1234
      udp_header[63:48] <= {16'd1234};
      //16位目的端口号：1234
      udp_header[47:32] <= {16'd1234};
      //16位udp长度
      udp_header[31:16] <= udp_num[15:0];
      //16位udp校验和
      udp_header[15:0]  <= 16'h0000;
    end else if (cur_state == st_udp_head) udp_header[63:0] <= {udp_header[55:0], 8'h00};
  end
  /**************************fcs***********************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) fcs_buffer[31:0] <= 64'd0;
    else if (cur_state == st_crc && state_cnt == 'd0) begin
      fcs_buffer[31:0] <= crc_next[31:0];
    end else if (next_state == st_crc) fcs_buffer[31:0] <= {fcs_buffer[24:0], 8'h00};
  end

  /**************************gmii txd************************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) gmii_txd[7:0] <= 8'h00;
    else
      case (cur_state)
        st_idle: begin  //等待发送数据
          gmii_txd[7:0] <= 8'h00;
        end
        st_init: begin  //
          gmii_txd[7:0] <= 8'h00;
        end
        st_check_sum: begin  //IP首部校验
          gmii_txd[7:0] <= 8'h00;
        end
        st_preamble: begin  //发送前导码+帧起始界定符
          gmii_txd[7:0] <= preamble_header[63:56];
        end
        st_eth_head: begin  //发送以太网首部
          gmii_txd[7:0] <= eth_header[111:104];
        end
        st_ip_head: begin  //发送IP首部
          gmii_txd[7:0] <= ip_header[159:152];
        end
        st_udp_head: begin  //UDP首部
          gmii_txd[7:0] <= udp_header[63:56];
        end
        st_tx_data: begin  //发送数据
          gmii_txd[7:0] <= tx_data[7:0];
        end
        st_crc: begin  //发送CRC校验值
          if (state_cnt == 3'd0) gmii_txd <= {~crc_next[24], ~crc_next[25], ~crc_next[26], ~crc_next[27], ~crc_next[28], ~crc_next[29], ~crc_next[30], ~crc_next[31]};
          else if (state_cnt == 3'd1) gmii_txd <= {~crc_data[16], ~crc_data[17], ~crc_data[18], ~crc_data[19], ~crc_data[20], ~crc_data[21], ~crc_data[22], ~crc_data[23]};
          else if (state_cnt == 3'd2) begin
            gmii_txd <= {~crc_data[8], ~crc_data[9], ~crc_data[10], ~crc_data[11], ~crc_data[12], ~crc_data[13], ~crc_data[14], ~crc_data[15]};
          end else if (state_cnt == 3'd3) begin
            gmii_txd <= {~crc_data[0], ~crc_data[1], ~crc_data[2], ~crc_data[3], ~crc_data[4], ~crc_data[5], ~crc_data[6], ~crc_data[7]};
          end
        end
        st_done: begin
          gmii_txd[7:0] <= 8'h00;
        end
        default: gmii_txd[7:0] <= 8'h00;
      endcase
  end

  always @(posedge clk) begin
    if (next_state == st_tx_data) tx_req <= 1'b1;  //这里要提前两个时钟读取数据，用nextstate，fifo用fist word 模式
    else tx_req <= 1'b0;
  end

  reg r_crc_en;  //这里crcen要滞后一个时钟
  always @(posedge clk) begin
    if (cur_state == st_eth_head) crc_en <= 1'b1;
    else if (cur_state == st_ip_head) crc_en <= 1'b1;
    else if (cur_state == st_udp_head) crc_en <= 1'b1;
    else if (cur_state == st_tx_data) crc_en <= 1'b1;
    else crc_en <= 1'b0;
  end

  always @(posedge clk) begin
    if (cur_state == st_preamble) gmii_tx_en <= 1'b1;
    else if (cur_state == st_eth_head) gmii_tx_en <= 1'b1;
    else if (cur_state == st_ip_head) gmii_tx_en <= 1'b1;
    else if (cur_state == st_udp_head) gmii_tx_en <= 1'b1;
    else if (cur_state == st_tx_data) gmii_tx_en <= 1'b1;
    else if (cur_state == st_crc) gmii_tx_en <= 1'b1;
    else gmii_tx_en <= 1'b0;
  end
  //发送完成信号及crc值复位信号
  always @(posedge clk) begin
    if (cur_state == st_done) begin
      tx_done <= 1'b1;
      crc_clr <= 1'b1;
    end else begin
      tx_done <= 1'b0;
      crc_clr <= 1'b0;
    end
  end

endmodule

