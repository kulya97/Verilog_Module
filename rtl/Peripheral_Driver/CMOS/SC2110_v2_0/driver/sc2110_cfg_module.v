module sc2110_cfg_module (
    input clk,   //时钟信号
    input rst_n, //复位信号，低电平有效

    input             i2c_done,  //I2C寄存器配置完成信号
    output reg        i2c_exec,  //I2C触发执行信号   
    output reg [23:0] i2c_data,  //I2C要配置的地址与数据(高8位地址,低8位数据)
    output reg        init_done  //初始化完成信号
);

  //parameter define
  parameter REG_NUM = 8'd112;  //总共需要配置的寄存器个数

  //reg define
  reg [31:0] start_init_cnt;  //等待延时计数器
  reg [ 7:0] init_reg_cnt;  //寄存器配置个数计数器

  //*****************************************************
  //**                    main code
  //*****************************************************

  //cam_scl配置成250khz,输入的clk为1Mhz,周期为1us,1023*1us = 1.023ms
  //寄存器延时配置
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) start_init_cnt <= 'b0;
    //else if ((init_reg_cnt == 8'd1) && i2c_done) start_init_cnt <= 'b0;
    else if (start_init_cnt < 32'd1023) begin
      start_init_cnt <= start_init_cnt + 1'b1;
    end
  end

  //寄存器配置个数计数    
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) init_reg_cnt <= 8'd0;
    else if (i2c_exec) init_reg_cnt <= init_reg_cnt + 8'b1;
  end

  //i2c触发执行信号   
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2c_exec <= 1'b0;
    else if (start_init_cnt == 32'd1022) i2c_exec <= 1'b1;
    //只有刚上电和配置第一个寄存器增加延时
    else if (i2c_done && (init_reg_cnt < REG_NUM)) i2c_exec <= 1'b1;
    else i2c_exec <= 1'b0;
  end

  //初始化完成信号
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) init_done <= 1'b0;
    else if ((init_reg_cnt == REG_NUM) && i2c_done) init_done <= 1'b1;
  end

  //配置寄存器地址与数据
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2c_data <= 16'b0;
    else begin
      case (init_reg_cnt)
        8'd000: i2c_data <= {16'h0103, 8'h01};
        8'd001: i2c_data <= {16'h0100, 8'h00};
        8'd002: i2c_data <= {16'h36e9, 8'h80};
        8'd003: i2c_data <= {16'h36f9, 8'h80};
        8'd004: i2c_data <= {16'h3001, 8'h00};
        8'd005: i2c_data <= {16'h3002, 8'h00};
        8'd006: i2c_data <= {16'h3018, 8'h72};
        8'd007: i2c_data <= {16'h301c, 8'h1c};
        8'd008: i2c_data <= {16'h301e, 8'hf0};
        8'd009: i2c_data <= {16'h301f, 8'ha6};
        8'd010: i2c_data <= {16'h3031, 8'h0c};
        8'd011: i2c_data <= {16'h3037, 8'h40};
        8'd012: i2c_data <= {16'h3038, 8'h22};
        8'd013: i2c_data <= {16'h3106, 8'h81};
        8'd014: i2c_data <= {16'h3202, 8'h00};
        8'd015: i2c_data <= {16'h3203, 8'h3c};
        8'd016: i2c_data <= {16'h3206, 8'h04};
        8'd017: i2c_data <= {16'h3207, 8'h83};
        8'd018: i2c_data <= {16'h320a, 8'h04};
        8'd019: i2c_data <= {16'h320b, 8'h38};
        8'd020: i2c_data <= {16'h320c, 8'h04};
        8'd021: i2c_data <= {16'h320d, 8'he2};
        8'd022: i2c_data <= {16'h320e, 8'h04};
        8'd023: i2c_data <= {16'h320f, 8'ha4};
        8'd024: i2c_data <= {16'h3212, 8'h00};
        8'd025: i2c_data <= {16'h3213, 8'h08};
        8'd026: i2c_data <= {16'h3220, 8'h23};
        8'd027: i2c_data <= {16'h3301, 8'h20};
        8'd028: i2c_data <= {16'h3305, 8'h00};
        8'd029: i2c_data <= {16'h3306, 8'hf8};
        8'd030: i2c_data <= {16'h330a, 8'h04};
        8'd031: i2c_data <= {16'h330b, 8'h00};
        8'd032: i2c_data <= {16'h3326, 8'h00};
        8'd033: i2c_data <= {16'h3366, 8'h92};
        8'd034: i2c_data <= {16'h336e, 8'h30};
        8'd035: i2c_data <= {16'h338a, 8'h01};
        8'd036: i2c_data <= {16'h338b, 8'h00};
        8'd037: i2c_data <= {16'h338c, 8'h04};
        8'd038: i2c_data <= {16'h338d, 8'h00};
        8'd039: i2c_data <= {16'h33b4, 8'hb0};
        8'd040: i2c_data <= {16'h3620, 8'h88};
        8'd041: i2c_data <= {16'h3622, 8'hf0};
        8'd042: i2c_data <= {16'h362c, 8'hf2};
        8'd043: i2c_data <= {16'h362f, 8'hff};
        8'd044: i2c_data <= {16'h3630, 8'h20};
        8'd045: i2c_data <= {16'h3631, 8'h81};
        8'd046: i2c_data <= {16'h3632, 8'h88};
        8'd047: i2c_data <= {16'h3633, 8'h44};
        8'd048: i2c_data <= {16'h3000, 8'h00};
        8'd049: i2c_data <= {16'h3635, 8'h40};
        8'd050: i2c_data <= {16'h363b, 8'h20};
        8'd051: i2c_data <= {16'h363e, 8'h02};
        8'd052: i2c_data <= {16'h363f, 8'h20};
        8'd053: i2c_data <= {16'h3648, 8'h01};
        8'd054: i2c_data <= {16'h3650, 8'h71};
        8'd055: i2c_data <= {16'h3651, 8'had};
        8'd056: i2c_data <= {16'h36ea, 8'h3a};
        8'd057: i2c_data <= {16'h36eb, 8'h16};
        8'd058: i2c_data <= {16'h36ec, 8'h07};
        8'd059: i2c_data <= {16'h36ed, 8'h14};
        8'd060: i2c_data <= {16'h36fa, 8'h38};
        8'd061: i2c_data <= {16'h36fb, 8'h13};
        8'd062: i2c_data <= {16'h36fc, 8'h11};
        8'd063: i2c_data <= {16'h36fd, 8'h04};
        8'd064: i2c_data <= {16'h3907, 8'h01};
        8'd065: i2c_data <= {16'h3908, 8'h11};
        8'd066: i2c_data <= {16'h3e01, 8'h24};
        8'd067: i2c_data <= {16'h3e02, 8'hc0};
        8'd068: i2c_data <= {16'h3e09, 8'h40};
        8'd069: i2c_data <= {16'h3e1b, 8'h3a};
        8'd070: i2c_data <= {16'h3e26, 8'h40};
         8'd071:  i2c_data <= {16'h4501, 8'hc4};
        // 8'd071: i2c_data <= {16'h4501, 8'hbc};
        8'd072: i2c_data <= {16'h4509, 8'h40};
        8'd073: i2c_data <= {16'h4837, 8'h69};
        8'd074: i2c_data <= {16'h4b00, 8'hf2};
        8'd075: i2c_data <= {16'h4b01, 8'h09};
        8'd076: i2c_data <= {16'h36e9, 8'h54};
        8'd077: i2c_data <= {16'h36f9, 8'h04};
        8'd078: i2c_data <= {16'h0100, 8'h01};
        8'd079: i2c_data <= {16'h363e, 8'h02};
        8'd080: i2c_data <= {16'h3301, 8'h20};
        8'd081: i2c_data <= {16'h3633, 8'h44};
        8'd082: i2c_data <= {16'h3622, 8'hf0};
        8'd083: i2c_data <= {16'h362c, 8'hf2};
        8'd084: i2c_data <= {16'h3630, 8'h20};
        8'd085: i2c_data <= {16'h3631, 8'h81};
        8'd086: i2c_data <= {16'h363f, 8'h20};
        8'd087: i2c_data <= {16'h3648, 8'h01};
        8'd088: i2c_data <= {16'h363e, 8'h02};
        8'd089: i2c_data <= {16'h3301, 8'h20};
        8'd090: i2c_data <= {16'h3633, 8'h43};
        8'd091: i2c_data <= {16'h3622, 8'hf0};
        8'd092: i2c_data <= {16'h362c, 8'hf2};
        8'd093: i2c_data <= {16'h3630, 8'h20};
        8'd094: i2c_data <= {16'h3631, 8'h81};
        8'd095: i2c_data <= {16'h363f, 8'h20};
        8'd096: i2c_data <= {16'h3648, 8'h01};
        8'd097: i2c_data <= {16'h363e, 8'h10};
        8'd098: i2c_data <= {16'h3301, 8'h20};
        8'd099: i2c_data <= {16'h3633, 8'h44};
        8'd100: i2c_data <= {16'h3622, 8'h00};
        8'd101: i2c_data <= {16'h362c, 8'h02};
        8'd102: i2c_data <= {16'h3631, 8'h80};
        8'd103: i2c_data <= {16'h3630, 8'h90};
        8'd104: i2c_data <= {16'h3648, 8'h00};
        8'd105: i2c_data <= {16'h363f, 8'h90};
        8'd106: i2c_data <= {16'h3222, 8'h02};
        8'd107: i2c_data <= {16'h3225, 8'h14};
        8'd108: i2c_data <= {16'h3230, 8'h00};
        8'd109: i2c_data <= {16'h3231, 8'h04};
        8'd110: i2c_data <= {16'h322e, 8'h04};
        8'd111: i2c_data <= {16'h322f, 8'ha0};
        default: i2c_data <= {16'h0000, 8'h00};
      endcase
    end
  end

endmodule
