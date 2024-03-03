module i2c_master_module #(
    parameter integer CLK_FREQ = 26'd50_000_000,  //模块输入的时钟频率
    parameter integer I2C_FREQ = 18'd250_000     //IIC_SCL的时钟频率
) (
    input             i_clk,
    input             i_rst_n,
    //--
    input             i_cmd_bit_ctrl,  //字地址位控制(16b/8b)
    input             i_cmd_rh_wl,     //I2C读写控制信号
    input      [ 6:0] i_cmd_sladdr,
    input      [15:0] i_cmd_regaddr,   //I2C器件内地址
    input             i_cmd_wvalid,
    output reg        i_cmd_wready,
    //--
    //  input             i_i2c_wvalid,
    //  output            i_i2c_wready,
    input      [ 7:0] i_i2c_wdata,     //I2C要写的数据
    //  input             i_i2c_wlast,
    //--
    output reg [ 7:0] o_i2c_rdata,     //I2C读出的数据
    //  input             i_i2c_rready,
    output reg        o_i2c_rvalid,
    //  output reg        o_i2c_rlast,
    //-- i2c interface
    output reg        i2c_scl,         //I2C的SCL时钟信号
    inout             i2c_sda,         //I2C的SDA信号
    //-- user interface
    output            o_i2c_done,      //I2C一次操作完成
    output            o_i2c_ack,       //I2C应答标志 0:应答 1:未应答
    output            o_i2c_busy
);
  localparam CLK_DIV = (CLK_FREQ / I2C_FREQ) >> 2'd2;
  localparam CLK_DIV_00 = CLK_DIV * 00;
  localparam CLK_DIV_01 = CLK_DIV * 01;
  localparam CLK_DIV_02 = CLK_DIV * 02;
  localparam CLK_DIV_03 = CLK_DIV * 03;
  localparam CLK_DIV_04 = CLK_DIV * 04;
  localparam CLK_DIV_05 = CLK_DIV * 05;
  localparam CLK_DIV_06 = CLK_DIV * 06;
  localparam CLK_DIV_07 = CLK_DIV * 07;
  localparam CLK_DIV_08 = CLK_DIV * 08;
  localparam CLK_DIV_09 = CLK_DIV * 09;
  localparam CLK_DIV_10 = CLK_DIV * 10;
  localparam CLK_DIV_11 = CLK_DIV * 11;
  localparam CLK_DIV_12 = CLK_DIV * 12;
  localparam CLK_DIV_13 = CLK_DIV * 13;
  localparam CLK_DIV_14 = CLK_DIV * 14;
  localparam CLK_DIV_15 = CLK_DIV * 15;
  localparam CLK_DIV_16 = CLK_DIV * 16;
  localparam CLK_DIV_17 = CLK_DIV * 17;
  localparam CLK_DIV_18 = CLK_DIV * 18;
  localparam CLK_DIV_19 = CLK_DIV * 19;
  localparam CLK_DIV_20 = CLK_DIV * 20;
  localparam CLK_DIV_21 = CLK_DIV * 21;
  localparam CLK_DIV_22 = CLK_DIV * 22;
  localparam CLK_DIV_23 = CLK_DIV * 23;
  localparam CLK_DIV_24 = CLK_DIV * 24;
  localparam CLK_DIV_25 = CLK_DIV * 25;
  localparam CLK_DIV_26 = CLK_DIV * 26;
  localparam CLK_DIV_27 = CLK_DIV * 27;
  localparam CLK_DIV_28 = CLK_DIV * 28;
  localparam CLK_DIV_29 = CLK_DIV * 29;
  localparam CLK_DIV_30 = CLK_DIV * 30;
  localparam CLK_DIV_31 = CLK_DIV * 31;
  localparam CLK_DIV_32 = CLK_DIV * 32;
  localparam CLK_DIV_33 = CLK_DIV * 33;
  localparam CLK_DIV_34 = CLK_DIV * 34;
  localparam CLK_DIV_35 = CLK_DIV * 35;
  localparam CLK_DIV_36 = CLK_DIV * 36;
  localparam CLK_DIV_37 = CLK_DIV * 37;
  localparam CLK_DIV_38 = CLK_DIV * 38;
  localparam CLK_DIV_39 = CLK_DIV * 39;
  localparam CLK_DIV_40 = CLK_DIV * 40;

  //----------------------------------------------------------------------------
  localparam ST_IDLE = 8'd00;  //空闲状态
  localparam ST_SLADDR = 8'd01;  //发送器件地址(slave address)
  localparam ST_ADDR16 = 8'd02;  //发送16位字地址
  localparam ST_ADDR8 = 8'd03;  //发送8位字地址
  localparam ST_WDATA = 8'd04;  //写数据(8 bit)
  localparam ST_SLADDR_RD = 8'd05;  //发送器件地址读
  localparam ST_RDATA = 8'd06;  //读数据(8 bit)
  localparam ST_STOP = 8'd07;  //结束I2C操作
  //----------------------------------------------------------------------------
  //reg define
  reg         sda_dir;  //I2C数据(SDA)方向控制
  reg         sda_out;  //SDA输出信号
  wire        sda_in;  //SDA输入信号
  //--
  reg         st_done;  //状态结束
  reg  [ 7:0] cur_state;  //状态机当前状态
  reg  [ 7:0] next_state;  //状态机下一状态
  //--
  reg  [31:0] cnt;
  reg         cnt_clr;
  //--
  reg         wr_flag_t;
  reg         bit_ctrl_t;
  reg  [15:0] addr_t;
  reg  [ 7:0] data_rd_t;
  reg  [ 7:0] data_wr_t;
  reg  [ 6:0] sladdr_t;
  //-- 
  reg         i2c_done_t;
  reg         i2c_ack_t;
  reg         i2c_busy_t;

  //----------------------------------------------------------------------------
  assign o_i2c_done = i2c_done_t;
  assign o_i2c_ack  = i2c_ack_t;
  assign o_i2c_busy = i2c_busy_t;
  //SDA控制
  assign i2c_sda    = sda_dir ? sda_out : 1'bz;  //SDA数据输出或高阻
  assign sda_in     = i2c_sda;  //SDA数据输入
  //----------------------------------------------------------------------------
  //--
  always @(posedge i_clk, negedge i_rst_n) begin
    if (!i_rst_n) begin
      i_cmd_wready <= 1'b0;
    end else if (i_cmd_wvalid && !i_cmd_wready && cur_state == ST_IDLE) i_cmd_wready <= 1'b1;
    else i_cmd_wready <= 1'b0;
  end
  //----------------------------------------------------------------------------
  always @(posedge i_clk, negedge i_rst_n) begin
    if (!i_rst_n) cur_state <= ST_IDLE;
    else cur_state <= next_state;
  end

  always @(posedge i_clk, negedge i_rst_n) begin
    if (!i_rst_n) cnt <= 1'b0;
    else if (cur_state != next_state || cnt_clr) cnt <= 1'b0;
    else cnt <= cnt + 1'b1;
  end

  always @(*) begin
    next_state = ST_IDLE;
    case (cur_state)
      ST_IDLE: begin  //空闲状态
        if (i_cmd_wready && i_cmd_wvalid) next_state = ST_SLADDR;
        else next_state = ST_IDLE;
      end
      ST_SLADDR: begin  //判断是16位还是8位字地址
        if (st_done && bit_ctrl_t) next_state = ST_ADDR16;
        else if (st_done && !bit_ctrl_t) next_state = ST_ADDR8;
        else next_state = ST_SLADDR;
      end
      ST_ADDR16: begin  //写16位字地址
        if (st_done) next_state = ST_ADDR8;
        else next_state = ST_ADDR16;
      end
      ST_ADDR8: begin  //8位字地址
        if (st_done && !wr_flag_t) next_state = ST_WDATA;
        else if (st_done && wr_flag_t) next_state = ST_SLADDR_RD;
        else next_state = ST_ADDR8;
      end
      ST_WDATA: begin  //写数据(8 bit)
        if (st_done) next_state = ST_STOP;
        else next_state = ST_WDATA;
      end
      ST_SLADDR_RD: begin  //写地址以进行读数据
        if (st_done) next_state = ST_RDATA;
        else next_state = ST_SLADDR_RD;
      end
      ST_RDATA: begin  //读取数据(8 bit)
        if (st_done) next_state = ST_STOP;
        else next_state = ST_RDATA;
      end
      ST_STOP: begin  //结束I2C操作
        if (st_done) next_state = ST_IDLE;
        else next_state = ST_STOP;
      end
      default: next_state = ST_IDLE;
    endcase
  end

  //----------------------------------------------------------------------------
  //时序电路描述状态输出
  always @(posedge i_clk, negedge i_rst_n) begin
    //复位初始化
    if (!i_rst_n) begin
      cnt_clr      <= 1'b0;
      o_i2c_rdata  <= 1'b0;
      st_done      <= 1'b0;
      i2c_scl      <= 1'b1;
      sda_out      <= 1'b1;
      sda_dir      <= 1'b1;
      i2c_done_t   <= 1'b0;
      i2c_ack_t    <= 1'b0;
      wr_flag_t    <= 1'b0;
      bit_ctrl_t   <= 1'b0;
      o_i2c_rvalid <= 1'b0;
      i2c_busy_t   <= 1'b1;
      addr_t       <= 1'b0;
      sladdr_t     <= 7'd0;
      data_rd_t    <= 1'b0;
      data_wr_t    <= 1'b0;
    end else begin
      st_done      <= 1'b0;
      cnt_clr      <= 1'b0;
      o_i2c_rvalid <= 1'b0;
      i2c_busy_t   <= 1'b1;
      case (cur_state)
        ST_IDLE: begin  //空闲状态
          i2c_scl    <= 1'b1;
          sda_out    <= 1'b1;
          sda_dir    <= 1'b1;
          i2c_done_t <= 1'b0;
          i2c_ack_t  <= 1'b0;
          i2c_busy_t <= 1'b0;
          if (i_cmd_wready && i_cmd_wvalid) begin
            wr_flag_t  <= i_cmd_rh_wl;
            bit_ctrl_t <= i_cmd_bit_ctrl;
            addr_t     <= i_cmd_regaddr;
            sladdr_t   <= i_cmd_sladdr;
            wrbits_t   <= i_i2c_wrbits;
            rdbits_t   <= i_i2c_rdbits;
            data_wr_t  <= i_i2c_wdata;
          end
        end
        ST_SLADDR: begin  //写地址(器件地址和字地址)
          case (cnt)
            CLK_DIV_01:    sda_out <= 1'b0;  //开始I2C
            CLK_DIV_03:    i2c_scl <= 1'b0;
            CLK_DIV_04:    sda_out <= sladdr_t[6];  //传送器件地址
            CLK_DIV_05:    i2c_scl <= 1'b1;
            CLK_DIV_07:    i2c_scl <= 1'b0;
            CLK_DIV_08:    sda_out <= sladdr_t[5];
            CLK_DIV_09:    i2c_scl <= 1'b1;
            CLK_DIV_11:   i2c_scl <= 1'b0;
            CLK_DIV_12:   sda_out <= sladdr_t[4];
            CLK_DIV_13:   i2c_scl <= 1'b1;
            CLK_DIV_15:   i2c_scl <= 1'b0;
            CLK_DIV_16:   sda_out <= sladdr_t[3];
            CLK_DIV_17:   i2c_scl <= 1'b1;
            CLK_DIV_19:   i2c_scl <= 1'b0;
            CLK_DIV_20:   sda_out <= sladdr_t[2];
            CLK_DIV_21:   i2c_scl <= 1'b1;
            CLK_DIV_23:   i2c_scl <= 1'b0;
            CLK_DIV_24:   sda_out <= sladdr_t[1];
            CLK_DIV_25:   i2c_scl <= 1'b1;
            CLK_DIV_27:   i2c_scl <= 1'b0;
            CLK_DIV_28:   sda_out <= sladdr_t[0];
            CLK_DIV_29:   i2c_scl <= 1'b1;
            CLK_DIV_31:   i2c_scl <= 1'b0;
            CLK_DIV_32:   sda_out <= 1'b0;  //0:写
            CLK_DIV_33:   i2c_scl <= 1'b1;
            CLK_DIV_35:   i2c_scl <= 1'b0;
            CLK_DIV_36: begin
              sda_dir <= 1'b0;
              sda_out <= 1'b1;
            end
            CLK_DIV_37:   i2c_scl <= 1'b1;
            CLK_DIV_38: begin  //从机应答 

              if (sda_in == 1'b1)  //高电平表示未应答
                i2c_ack_t <= 1'b1;  //拉高应答标志位
            end
            CLK_DIV_39: begin

              i2c_scl <= 1'b0;
            end
            CLK_DIV_40 - 1: begin
              st_done <= 1'b1;
              cnt_clr <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default: ;
          endcase
        end
        ST_ADDR16: begin
          case (cnt)
            CLK_DIV_00: begin
              sda_dir <= 1'b1;
              sda_out <= addr_t[15];  //传送字地址
            end
            CLK_DIV_01:    i2c_scl <= 1'b1;
            CLK_DIV_03:    i2c_scl <= 1'b0;
            CLK_DIV_04:    sda_out <= addr_t[14];
            CLK_DIV_05:    i2c_scl <= 1'b1;
            CLK_DIV_07:    i2c_scl <= 1'b0;
            CLK_DIV_08:    sda_out <= addr_t[13];
            CLK_DIV_09:    i2c_scl <= 1'b1;
            CLK_DIV_11:   i2c_scl <= 1'b0;
            CLK_DIV_12:   sda_out <= addr_t[12];
            CLK_DIV_13:   i2c_scl <= 1'b1;
            CLK_DIV_15:   i2c_scl <= 1'b0;
            CLK_DIV_16:   sda_out <= addr_t[11];
            CLK_DIV_17:   i2c_scl <= 1'b1;
            CLK_DIV_19:   i2c_scl <= 1'b0;
            CLK_DIV_20:   sda_out <= addr_t[10];
            CLK_DIV_21:   i2c_scl <= 1'b1;
            CLK_DIV_23:   i2c_scl <= 1'b0;
            CLK_DIV_24:   sda_out <= addr_t[9];
            CLK_DIV_25:   i2c_scl <= 1'b1;
            CLK_DIV_27:   i2c_scl <= 1'b0;
            CLK_DIV_28:   sda_out <= addr_t[8];
            CLK_DIV_29:   i2c_scl <= 1'b1;
            CLK_DIV_31:   i2c_scl <= 1'b0;
            CLK_DIV_32: begin
              sda_dir <= 1'b0;
              sda_out <= 1'b1;
            end
            CLK_DIV_33:   i2c_scl <= 1'b1;
            CLK_DIV_34: begin  //从机应答
              if (sda_in == 1'b1)  //高电平表示未应答
                i2c_ack_t <= 1'b1;  //拉高应答标志位
            end
            CLK_DIV_35: begin
              i2c_scl <= 1'b0;
            end
            CLK_DIV_36 - 1: begin
              st_done <= 1'b1;
              cnt_clr <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default: ;
          endcase
        end
        ST_ADDR8: begin
          case (cnt)
            CLK_DIV_00: begin
              sda_dir <= 1'b1;
              sda_out <= addr_t[7];  //字地址
            end
            CLK_DIV_01:    i2c_scl <= 1'b1;
            CLK_DIV_03:    i2c_scl <= 1'b0;
            CLK_DIV_04:    sda_out <= addr_t[6];
            CLK_DIV_05:    i2c_scl <= 1'b1;
            CLK_DIV_07:    i2c_scl <= 1'b0;
            CLK_DIV_08:    sda_out <= addr_t[5];
            CLK_DIV_09:    i2c_scl <= 1'b1;
            CLK_DIV_11:   i2c_scl <= 1'b0;
            CLK_DIV_12:   sda_out <= addr_t[4];
            CLK_DIV_13:   i2c_scl <= 1'b1;
            CLK_DIV_15:   i2c_scl <= 1'b0;
            CLK_DIV_16:   sda_out <= addr_t[3];
            CLK_DIV_17:   i2c_scl <= 1'b1;
            CLK_DIV_19:   i2c_scl <= 1'b0;
            CLK_DIV_20:   sda_out <= addr_t[2];
            CLK_DIV_21:   i2c_scl <= 1'b1;
            CLK_DIV_23:   i2c_scl <= 1'b0;
            CLK_DIV_24:   sda_out <= addr_t[1];
            CLK_DIV_25:   i2c_scl <= 1'b1;
            CLK_DIV_27:   i2c_scl <= 1'b0;
            CLK_DIV_28:   sda_out <= addr_t[0];
            CLK_DIV_29:   i2c_scl <= 1'b1;
            CLK_DIV_31:   i2c_scl <= 1'b0;
            CLK_DIV_32: begin
              sda_dir <= 1'b0;
              sda_out <= 1'b1;
            end
            CLK_DIV_33:   i2c_scl <= 1'b1;
            CLK_DIV_34: begin  //从机应答
              if (sda_in == 1'b1)  //高电平表示未应答
                i2c_ack_t <= 1'b1;  //拉高应答标志位
            end
            CLK_DIV_35: begin
              i2c_scl <= 1'b0;
            end
            CLK_DIV_36 - 1: begin
              st_done <= 1'b1;
              cnt_clr <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default: ;
          endcase
        end
        ST_WDATA: begin  //写数据(8 bit)
          case (cnt)
            CLK_DIV_00: begin
              sda_out <= data_wr_t[7];  //I2C写8位数据
              sda_dir <= 1'b1;
            end
            CLK_DIV_01:    i2c_scl <= 1'b1;
            CLK_DIV_03:    i2c_scl <= 1'b0;
            CLK_DIV_04:    sda_out <= data_wr_t[6];
            CLK_DIV_05:    i2c_scl <= 1'b1;
            CLK_DIV_07:    i2c_scl <= 1'b0;
            CLK_DIV_08:    sda_out <= data_wr_t[5];
            CLK_DIV_09:    i2c_scl <= 1'b1;
            CLK_DIV_11:   i2c_scl <= 1'b0;
            CLK_DIV_12:   sda_out <= data_wr_t[4];
            CLK_DIV_13:   i2c_scl <= 1'b1;
            CLK_DIV_15:   i2c_scl <= 1'b0;
            CLK_DIV_16:   sda_out <= data_wr_t[3];
            CLK_DIV_17:   i2c_scl <= 1'b1;
            CLK_DIV_19:   i2c_scl <= 1'b0;
            CLK_DIV_20:   sda_out <= data_wr_t[2];
            CLK_DIV_21:   i2c_scl <= 1'b1;
            CLK_DIV_23:   i2c_scl <= 1'b0;
            CLK_DIV_24:   sda_out <= data_wr_t[1];
            CLK_DIV_25:   i2c_scl <= 1'b1;
            CLK_DIV_27:   i2c_scl <= 1'b0;
            CLK_DIV_28:   sda_out <= data_wr_t[0];
            CLK_DIV_29:   i2c_scl <= 1'b1;
            CLK_DIV_31:   i2c_scl <= 1'b0;
            CLK_DIV_32: begin
              sda_dir   <= 1'b0;
              sda_out   <= 1'b1;
            end
            CLK_DIV_33:   i2c_scl <= 1'b1;
            CLK_DIV_34: begin  //从机应答
              if (sda_in == 1'b1)  //高电平表示未应答
                i2c_ack_t <= 1'b1;  //拉高应答标志位
            end
            CLK_DIV_35: begin
              i2c_scl <= 1'b0;
            end
            CLK_DIV_36 - 1: begin
              cnt_clr <= 1'b1;
              st_done <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default: ;
          endcase
        end
        ST_SLADDR_RD: begin  //写地址以进行读数据
          case (cnt)
            CLK_DIV_00: begin
              sda_dir <= 1'b1;
              sda_out <= 1'b1;
            end
            CLK_DIV_01:    i2c_scl <= 1'b1;
            CLK_DIV_02:    sda_out <= 1'b0;  //重新开始
            CLK_DIV_03:    i2c_scl <= 1'b0;
            CLK_DIV_04:    sda_out <= sladdr_t[6];  //传送器件地址
            CLK_DIV_05:    i2c_scl <= 1'b1;
            CLK_DIV_07:    i2c_scl <= 1'b0;
            CLK_DIV_08:    sda_out <= sladdr_t[5];
            CLK_DIV_09:    i2c_scl <= 1'b1;
            CLK_DIV_11:   i2c_scl <= 1'b0;
            CLK_DIV_12:   sda_out <= sladdr_t[4];
            CLK_DIV_13:   i2c_scl <= 1'b1;
            CLK_DIV_15:   i2c_scl <= 1'b0;
            CLK_DIV_16:   sda_out <= sladdr_t[3];
            CLK_DIV_17:   i2c_scl <= 1'b1;
            CLK_DIV_19:   i2c_scl <= 1'b0;
            CLK_DIV_20:   sda_out <= sladdr_t[2];
            CLK_DIV_21:   i2c_scl <= 1'b1;
            CLK_DIV_23:   i2c_scl <= 1'b0;
            CLK_DIV_24:   sda_out <= sladdr_t[1];
            CLK_DIV_25:   i2c_scl <= 1'b1;
            CLK_DIV_27:   i2c_scl <= 1'b0;
            CLK_DIV_28:   sda_out <= sladdr_t[0];
            CLK_DIV_29:   i2c_scl <= 1'b1;
            CLK_DIV_31:   i2c_scl <= 1'b0;
            CLK_DIV_32:   sda_out <= 1'b1;  //1:读
            CLK_DIV_33:   i2c_scl <= 1'b1;
            CLK_DIV_35:   i2c_scl <= 1'b0;
            CLK_DIV_36: begin
              sda_dir <= 1'b0;
              sda_out <= 1'b1;
            end
            CLK_DIV_37:   i2c_scl <= 1'b1;
            CLK_DIV_38: begin  //从机应答
              if (sda_in == 1'b1)  //高电平表示未应答
                i2c_ack_t <= 1'b1;  //拉高应答标志位
            end
            CLK_DIV_39: begin
              i2c_scl <= 1'b0;
            end
            CLK_DIV_40 - 1: begin
              cnt_clr <= 1'b1;
              st_done <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default: ;
          endcase
        end
        ST_RDATA: begin  //读取数据(8 bit)
          case (cnt)
            CLK_DIV_00: sda_dir <= 1'b0;
            CLK_DIV_01: begin
              data_rd_t[7] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_03: i2c_scl <= 1'b0;
            CLK_DIV_05: begin
              data_rd_t[6] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_07: i2c_scl <= 1'b0;
            CLK_DIV_09: begin
              data_rd_t[5] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_11: i2c_scl <= 1'b0;
            CLK_DIV_13: begin
              data_rd_t[4] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_15: i2c_scl <= 1'b0;
            CLK_DIV_17: begin
              data_rd_t[3] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_19: i2c_scl <= 1'b0;
            CLK_DIV_21: begin
              data_rd_t[2] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_23: i2c_scl <= 1'b0;
            CLK_DIV_25: begin
              data_rd_t[1] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_27: i2c_scl <= 1'b0;
            CLK_DIV_29: begin
              data_rd_t[0] <= sda_in;
              i2c_scl      <= 1'b1;
            end
            CLK_DIV_31: i2c_scl <= 1'b0;
            CLK_DIV_32: begin
              sda_dir <= 1'b1;
              sda_out <= 1'b1;
            end
            CLK_DIV_33: i2c_scl <= 1'b1;
            CLK_DIV_35: begin
              i2c_scl <= 1'b0;
            end
            CLK_DIV_36 - 1: begin
              cnt_clr <= 1'b1;
              st_done <= 1'b1;
              i2c_scl <= 1'b0;
            end
            default:    ;
          endcase
        end
        ST_STOP: begin  //结束I2C操作
          case (cnt)
            CLK_DIV_00: begin
              sda_dir <= 1'b1;  //结束I2C
              sda_out <= 1'b0;
            end
            CLK_DIV_01: i2c_scl <= 1'b1;
            CLK_DIV_03: sda_out <= 1'b1;
            CLK_DIV_17: begin
              cnt_clr <= 1'b1;
              st_done    <= 1'b1;
              o_i2c_rvalid <= 1'b1;
              o_i2c_rdata <= data_rd_t;
              i2c_done_t <= 1'b1;  //向上层模块传递I2C结束信号
            end
            default:    ;
          endcase
        end
      endcase
    end
  end
  //----------------------------------------------------------------------------
endmodule
