
module sc2110_driver_top (
    input      clk,           //时钟
    input      rst_n,         //复位信号,低电平有效
    output reg cam_xshutdn,   //cmos 复位信号，低电平有效
    output reg cam_pwdn,      //cmos 电源休眠模式选择信号
    output reg cam_DOVDD18,
    output reg cam_DVDD12,
    output reg cam_AVDD28,
    output     IIC_SCL,
    inout      IIC_SDA,
    output     cam_init_done
);


  reg  [15:0] cnt_wait;
  reg  [ 2:0] cnt_queue;
  reg         cnt_flag;
  wire        cfg_en;

  parameter SLAVE_ADDR = 7'h30;  //EEPROM从机地址
  parameter CLK_FREQ = 26'd37_125_000;  //模块输入的时钟频率
  parameter I2C_FREQ = 18'd100_000;  //IIC_SCL的时钟频率


  wire        i2c_exec;
  wire        i2c_done;
  wire        i2c_ack;
  wire [15:0] i2c_addr;
  wire [ 7:0] i2c_data_w;
  wire [ 7:0] i2c_data_r;
  wire        dri_clk;


  wire [23:0] w_i2c_data;

  assign cfg_en = cnt_flag;
  //*****************************************************
  //**                    main code                      
  //*****************************************************
  always @(posedge clk or negedge rst_n)
    if (!rst_n) cnt_wait <= 16'd0;
    else if (cnt_wait == 16'd10_000) cnt_wait <= 16'd0;
    else if (cnt_flag == 1'b1) cnt_wait <= 16'd0;
    else cnt_wait <= cnt_wait + 1'd1;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cnt_queue <= 3'd0;
    else if (cnt_queue == 3'd5) cnt_queue <= 3'd0;
    else if (cnt_wait == 16'd10_00) cnt_queue <= cnt_queue + 1'd1;
    else cnt_queue <= cnt_queue;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cnt_flag <= 1'b0;
    else if (cnt_queue == 3'd5) cnt_flag <= 1'b1;
    else cnt_flag <= cnt_flag;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cam_DOVDD18 <= 1'b0;
    else if (cnt_queue == 3'd0) cam_DOVDD18 <= 1'b1;
    else cam_DOVDD18 <= cam_DOVDD18;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cam_DVDD12 <= 1'b0;
    else if (cnt_queue == 3'd1) cam_DVDD12 <= 1'b1;
    else cam_DVDD12 <= cam_DVDD12;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cam_AVDD28 <= 1'b0;
    else if (cnt_queue == 3'd2) cam_AVDD28 <= 1'b1;
    else cam_AVDD28 <= cam_AVDD28;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cam_xshutdn <= 1'b0;
    else if (cnt_queue == 3'd3) cam_xshutdn <= 1'b1;
    else cam_xshutdn <= cam_xshutdn;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) cam_pwdn <= 1'b0;
    else if (cnt_queue == 3'd4) cam_pwdn <= 1'b1;
    else cam_pwdn <= cam_pwdn;



  sc2110_i2c_dri_module #(
      .SLAVE_ADDR(SLAVE_ADDR),
      .CLK_FREQ  (CLK_FREQ),
      .I2C_FREQ  (I2C_FREQ)
  ) i2c_dri_inst (
      .clk       (clk),
      .rst_n     (rst_n && cfg_en),
      .i2c_exec  (i2c_exec),
      .i2c_done  (i2c_done),
      .i2c_ack   (i2c_ack),
      .bit_ctrl  (1'b1),
      .i2c_rh_wl (1'b0),
      .i2c_addr  (w_i2c_data[23:8]),
      .i2c_data_w(w_i2c_data[7:0]),
      .i2c_data_r(i2c_data_r),
      .scl       (IIC_SCL),
      .sda       (IIC_SDA),
      .dri_clk   (dri_clk)
  );

  sc2110_cfg_module i2c_sc2110_cfg_inst (
      .clk      (dri_clk),
      .rst_n    (rst_n && cfg_en),
      .i2c_done (i2c_done),
      .i2c_exec (i2c_exec),
      .i2c_data (w_i2c_data),
      .init_done(cam_init_done)
  );

endmodule
