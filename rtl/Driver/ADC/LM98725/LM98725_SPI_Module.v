
`timescale 1ns / 1ps

module LM98725_SPI_Module #(
    parameter ADDRESS = 16'HADAA
) (
    input             CLK,
    input             RST_N,
    input      [31:0] UART_IN,
    input             uart_ready,
    output reg        SCLK,
    output reg        SEN,
    output            SDI,
    input             SDO
);

  reg  [ 3:0] STATE_CS;  //状态机的当前状态
  reg  [ 3:0] STATE_NS;  //状态机的下一个状态
  reg  [ 4:0] sdi_bit_cnt;  //用来记录数据发送个数的计数器
  reg  [ 4:0] sdi_bit_cnt_n;
  reg  [ 4:0] sdo_bit_cnt;  //用来记录数据接收个数的计数器
  reg  [ 4:0] sdo_bit_cnt_n;
  reg  [15:0] sdi_shift;  //移位寄存器,将最高位数据移给SDI 
  reg  [15:0] sdi_shift_n;  //SDI_shift的下一个状态

  reg         uart_req;
  wire        initial_req;
  wire        UpdateReq;
  //    reg              stop;
  //    reg stop_n;
  wire        stop;
  reg         stop_n1;
  reg         stop_n2;
  reg  [ 7:0] start_cnt;
  reg  [ 7:0] start_cnt_n;
  reg  [ 9:0] period_cnt;
  reg  [ 9:0] period_cnt_n;

  reg  [ 4:0] time_cnt;  //用于记录时钟个数的计数器
  reg  [ 4:0] time_cnt_n;
  reg  [ 4:0] delay_cnt;  //用于记录延时个数的计数器
  reg  [ 4:0] delay_cnt_n;
  reg         SCLK_N;  //SCLK的下一个状态
  reg         SEN_N;  //SEN的下一个状态
  reg  [ 7:0] DATA_OUT_N;  //DATA_OUT的下一个状态
  reg  [15:0] DATA_IN;

  parameter STATE_IDLE = 4'h0;  //状态机的空闲状态
  parameter STATE_READY = 4'h1;  //状态机的准备状态,将SEN拉低
  parameter STATE_RECEIVE = 4'h2;  //状态机的接收状态,接收8个数据
  parameter STATE_TRANSFORM = 4'h3;  //状态机的转换状态,高阻状态
  parameter STATE_SEND = 4'h4;  //状态机的发送状态,发送16个数据
  parameter STATE_FINISH = 4'h5;  //状态的完成状态,将SEN拉高

  reg  [29:0] begin_cnt;
  reg  [29:0] begin_cnt_n;

  reg  [ 7:0] DATA_OUT;
  wire        UpdateDone;
  wire        locked;
  wire        CLK_300M;
  //   wire RST_N;

  /* 设置定时器的时间为1000ms,计算方法为  (10*10^3)us / (1/50)us */
  parameter SET_TIME_10MS = 30'd5_000_000;
  /* 时序电路,用来给delay_cnt寄存器赋值 */
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N) begin_cnt <= 30'd0;
    else begin_cnt <= begin_cnt_n;
  end

  /* 组合电路,用来实现10ms的延迟,等待器件稳定 */
  always @(*) begin
    if (begin_cnt == SET_TIME_10MS) begin_cnt_n = begin_cnt;
    else begin_cnt_n <= begin_cnt + 1'b1;
  end

  //时序电路,用来给time_cnt寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      start_cnt <= 8'd0;  //初始化time_cnt值
    else start_cnt <= start_cnt_n;  //用来给time_cnt赋值
  end

  //组合电路,用于记录时钟个数的计数器
  always @(*) begin
    if (start_cnt == 8'd180)  //判断状态机的当前状态
      start_cnt_n = 8'd0;  //状态发生改变（除了转换和发送状态）,计数器就清零
    else if (stop) start_cnt_n = 8'd0;
    else start_cnt_n = start_cnt + 8'd1;  //否则计数器就加1
  end

  assign initial_req = (start_cnt == 8'd2);  //标识发送完成

  //时序电路,用来给time_cnt寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      period_cnt <= 10'd0;  //初始化time_cnt值
    else period_cnt <= period_cnt_n;  //用来给time_cnt赋值
  end

  //组合电路,用于记录时钟个数的计数器
  always @(*) begin
    if (start_cnt == 8'd180 && begin_cnt == SET_TIME_10MS)  //判断状态机的当前状态
      period_cnt_n = period_cnt + 10'd1;  //状态发生改变（除了转换和发送状态）,计数器就清零
    else period_cnt_n = period_cnt;  //否则计数器就加1
  end

  assign stop = (period_cnt == 10'd27);

  //时序电路,用来给time_cnt寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      time_cnt <= 5'h0;  //初始化time_cnt值
    else time_cnt <= time_cnt_n;  //用来给time_cnt赋值
  end

  //组合电路,用于记录时钟个数的计数器
  always @(*) begin
    if ((STATE_CS != STATE_NS) && (STATE_NS != STATE_TRANSFORM) && (STATE_NS != STATE_SEND))  //判断状态机的当前状态
      time_cnt_n = 5'h0;  //状态发生改变（除了转换和发送状态）,计数器就清零
    else if (SCLK != SCLK_N)  //判断时钟的当前状态
      time_cnt_n = 5'h0;  //时钟发生变化,计数器清零
    else time_cnt_n = time_cnt + 5'h1;  //否则计数器就加1
  end

  //时序电路,用来给delay_cnt寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      delay_cnt <= 4'h0;  //初始化delay_cnt值
    else delay_cnt <= delay_cnt_n;  //用来给delay_cnt赋值
  end

  //组合电路,用来记录延时个数的计数器
  always @(*) begin
    if (STATE_CS != STATE_TRANSFORM)  //判断状态机的当前状态
      delay_cnt_n = 4'h0;  //如果当前的状态不在转换状态,delay_cnt_n就置0
    else if (SCLK && (!SCLK_N))  //判断时钟的当前状态
      delay_cnt_n = delay_cnt + 4'h1;  //如果SCLK处于运行状态,delay_cnt_n就加1
    else delay_cnt_n = delay_cnt;  //否则保持不变
  end


  //时序电路,用来给sdi_bit_cnt寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      sdi_bit_cnt <= 5'h0;  //初始化bit_cnt值
    else sdi_bit_cnt <= sdi_bit_cnt_n;  //用来给bit_cnt赋值
  end

  //组合电路,用来记录数据发送个数的计数器
  always @(*) begin
    if (STATE_CS != STATE_SEND)  //判断状态机的当前状态
      sdi_bit_cnt_n = 5'h0;  //如果当前的状态不在发送状态,bit_cnt_n就置0
    else if (SCLK && (!SCLK_N))  //判断时钟的当前状态
      sdi_bit_cnt_n = sdi_bit_cnt + 5'h1;  //如果SCLK处于运行状态,bit_cnt_n就加1
    else sdi_bit_cnt_n = sdi_bit_cnt;  //否则保持不变
  end

  //时序电路,用来给sdo_bit_cnt寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      sdo_bit_cnt <= 5'h0;  //初始化sdo_bit_cnt值
    else sdo_bit_cnt <= sdo_bit_cnt_n;  //用来给sdo_bit_cnt赋值
  end

  //组合电路,用来记录数据接收个数的计数器
  always @(*) begin
    if (STATE_CS != STATE_RECEIVE)  //判断状态机的当前状态
      sdo_bit_cnt_n = 5'h0;  //如果当前的状态不在接收状态,bit_cnt_n就置0
    else if (SCLK && (!SCLK_N))  //判断时钟的当前状态
      sdo_bit_cnt_n = sdo_bit_cnt + 5'h1;  //如果SCLK处于运行状态,bit_cnt_n就加1
    else sdo_bit_cnt_n = sdo_bit_cnt;  //否则保持不变
  end

  //时序电路,用来给sdi_shift寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      sdi_shift <= 16'h0;  //初始化shift_reg值
    else sdi_shift <= sdi_shift_n;  //用来给shift_reg赋值
  end

  //组合电路,移位寄存器,将DATA_IN的数据依次移给sdi_shift
  always @(*) begin
    if (UpdateReq)  //判断开始标识
      sdi_shift_n = DATA_IN;  //如果标志为1,则将DATA_IN的数据赋值给移位寄存器
    else if (SCLK && (time_cnt == 5'h0) && (STATE_CS == STATE_SEND))  //判断SCLK的状态,且处于发送状态
      sdi_shift_n = {sdi_shift[14:0], 1'h0};  //如果SCLK为高,移位寄存器开始移位
    else sdi_shift_n = sdi_shift;  //否则保持不变
  end

  //时序电路,用来给DATA_OUT寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      DATA_OUT <= 8'b0;  //初始化DATA_OUT值
    else DATA_OUT <= DATA_OUT_N;  //用来给DATA_OUT赋值
  end

  //组合电路,移位寄存器,将SDO的数据依次移给DATA_OUT
  always @(*) begin
    if (UpdateReq)  //判断开始标识
      DATA_OUT_N = 8'b0;  //初始化DATA_OUT值
    else if (SCLK && (time_cnt == 5'h0) && (STATE_CS == STATE_RECEIVE))  //判断SCLK的状态，且处于接收状态
      DATA_OUT_N = {DATA_OUT[6:0], SDO};  //如果SCLK为高,移位寄存器开始移位
    else DATA_OUT_N = DATA_OUT;  //否则保持不变
  end

  assign SDI = sdi_shift[15];
  //---------------------------------------------------------------------------
  //--    状态机
  //---------------------------------------------------------------------------

  //时序电路,用来给STATE_CS寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      STATE_CS <= STATE_IDLE;  //初始化STATE_CS值
    else STATE_CS <= STATE_NS;  //用来给STATE_CS赋值
  end

  //组合电路,用来实现状态机
  always @(*) begin
    case (STATE_CS)  //判断状态机的当前状态
      STATE_IDLE:
      if (UpdateReq)  //判断开始标识
        STATE_NS = STATE_READY;  //如果标识符为1,则进入准备状态
      else if (begin_cnt != SET_TIME_10MS) STATE_NS = STATE_CS;  //否则保持原状态不变
      else STATE_NS = STATE_CS;  //否则保持原状态不变

      STATE_READY:
      if (time_cnt == 5'h1)  //等待两个时钟
        STATE_NS = STATE_RECEIVE;  //两个时钟到了便进入接收状态
      else STATE_NS = STATE_CS;  //否则保持原状态不变

      STATE_RECEIVE:
      if ((sdo_bit_cnt == 5'h8) && (!SCLK))  //接收数据8个
        STATE_NS = STATE_TRANSFORM;  //接收完成进入转换状态
      else STATE_NS = STATE_CS;  //否则保持原状态不变

      STATE_TRANSFORM:
      if (delay_cnt == 5'h2)  //等待两个SCLK时钟
        STATE_NS = STATE_SEND;  //两个时钟到了便进入发送状态
      else STATE_NS = STATE_CS;  //否则保持原状态不变

      STATE_SEND:
      if ((sdi_bit_cnt == 5'h10) && (!SCLK))  //发送数据16个
        STATE_NS = STATE_FINISH;  //发送完成进入完成状态
      else STATE_NS = STATE_CS;  //否则保持原状态不变

      STATE_FINISH:
      if (time_cnt == 4'h2)  //等待三个时钟
        STATE_NS = STATE_IDLE;  //完成一次数据转换,进入下一次转换
      else STATE_NS = STATE_CS;  //否则保持原状态不变

      default: STATE_NS = STATE_IDLE;
    endcase
  end

  //时序电路,用来给SEN寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      SEN <= 1'h1;  //初始化SEN值
    else SEN <= SEN_N;  //用来给SEN赋值
  end

  //组合电路,用来生成SEN的片选波形
  always @(*) begin
    if (STATE_CS == STATE_READY)  //判断状态机的当前状态
      SEN_N = 1'h0;  //如果当前的状态等于准备状态,SEN_N就置0
    else if ((STATE_CS == STATE_FINISH) && (time_cnt == 5'h1))  //判断状态机的当前状态
      SEN_N = 1'h1;  //如果当前的状态等于完成状态并且时钟计数器等于1,SEN_N就置1
    else SEN_N = SEN;  //否则保持不变
  end

  //时序电路,用来给SCLK寄存器赋值
  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N)  //判断复位
      SCLK <= 1'h0;  //初始化SCLK值
    else SCLK <= SCLK_N;  //用来给SCLK赋值
  end

  //组合电路,用来生成SCLK的时钟波形
  always @(*) begin
    if (((STATE_CS == STATE_SEND) || (STATE_CS == STATE_RECEIVE) || (STATE_CS == STATE_TRANSFORM)) && (!SCLK) && (time_cnt == 5'h1))  //判断状态机的当前状态
      SCLK_N = 1'h1;  //如果符合上述条件,每两个时钟就会生成一个高电平的DA_CLK
    else if (((STATE_CS == STATE_SEND) || (STATE_CS == STATE_RECEIVE) || (STATE_CS == STATE_TRANSFORM)) && (SCLK) && (time_cnt == 5'h1))  //判断状态机的当前状态
      SCLK_N = 1'h0;  //如果符合上述条件,每两个时钟就会生成一个低电平的DA_CLK
    else SCLK_N = SCLK;  //否则保持不变
  end

  assign UpdateDone = (STATE_CS == STATE_FINISH);  //标识发送完成

  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N) uart_req <= 1'd0;
    else if (uart_ready && (UART_IN[31:16] == ADDRESS)) uart_req <= 1'd1;
    else uart_req <= 1'd0;
  end

  assign UpdateReq = (uart_req || initial_req);

  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N) DATA_IN = 16'h0;
    else if (stop) DATA_IN = UART_IN[15:0];
    else begin
      case (period_cnt)  //cnt0、cnt末位无效
        //PAGE 0
        0: DATA_IN = {8'h00, 8'b1010_0010};  //无效
        1: DATA_IN = {8'h00, 8'b1010_0010};
        2: DATA_IN = {8'h02, 8'b0100_0010};  //OSR
        3: DATA_IN = {8'h03, 8'h86};  //
        4: DATA_IN = {8'h04, 8'b0000_0000};  //Main Configuration 4 :CLPIN Enable
        5: DATA_IN = {8'h05, 8'b0100_0000};  //Main Configuration 5 :Output Enable
        6: DATA_IN = {8'h06, 8'b0000_0001};  //TEST PATTERN


        7:  DATA_IN = {8'h08, 8'h0F};  //OSR CLAMP Start Edge
        7:  DATA_IN = {8'h08, 8'h0F};  //OSR CLAMP Start Edge
        8:  DATA_IN = {8'h09, 8'h13};  //OSR CLAMP Stop Edge      
        9:  DATA_IN = {8'h0A, 8'h00};  //OSG CLAMP Start Edge
        10: DATA_IN = {8'h0B, 8'h04};  //OSG CLAMP Stop Edge
        11: DATA_IN = {8'h0E, 8'h00};  //OSR Sample Start Edge              
        12: DATA_IN = {8'h0F, 8'h04};  //OSR Sample Stop Edge              
        13: DATA_IN = {8'h10, 8'h10};  //OSG Sample Start Edge               
        14: DATA_IN = {8'h11, 8'h14};  //OSG Sample Stop Edge              
        15: DATA_IN = {8'h1F, 8'b0000_0001};  //to PAGE 1

        16: DATA_IN = {8'h00, 8'h00};  //CDS Gain Mode              
        //17:DATA_IN = {8'h01,8'hBD};//Red PGA    
        17: DATA_IN = {8'h01, 8'h61};  //Red PGA    
        18: DATA_IN = {8'h02, 8'hB2};  //Green PGA;              
        //19:DATA_IN = {8'h04,8'h75};//Red even DAC MSB   
        19: DATA_IN = {8'h04, 8'h70};  //Red even DAC MSB               
        20: DATA_IN = {8'h05, 8'b0000_0000};
        21: DATA_IN = {8'h06, 8'h72};  //Green even DAC MSB              
        22: DATA_IN = {8'h07, 8'h00};
        23: DATA_IN = {8'h10, 8'h40};  //Red Even digital offset
        24: DATA_IN = {8'h11, 8'h40};  //Green Even digital offset
        25: DATA_IN = {8'h1F, 8'b0000_0000};  //to PAGE 1

        26: DATA_IN = {8'h00, 8'b1010_0011};  //locked
        27: DATA_IN = {8'h00, 8'b1010_0011};  //last cnt无效       
        //PAGE 1
        default: DATA_IN = {8'h00, 8'b1010_0010};

      endcase
    end
  end

  //组合电路,用来生成SEN的片选波形
  always @(*) begin
    if (STATE_CS == STATE_READY)  //判断状态机的当前状态
      SEN_N = 1'h0;  //如果当前的状态等于准备状态,SEN_N就置0
    else if ((STATE_CS == STATE_FINISH) && (time_cnt == 5'h1))  //判断状态机的当前状态
      SEN_N = 1'h1;  //如果当前的状态等于完成状态并且时钟计数器等于1,SEN_N就置1
    else SEN_N = SEN;  //否则保持不变
  end

endmodule




