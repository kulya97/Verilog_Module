
module SC2110_driver (
    input      clk,           //时钟
    input      rst_n,         //复位信号,低电平有效
    //摄像头接口 
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



  SC2110_cfg_top SC2110_cfg_top_inst (
      .I_clk(clk),
      .I_rstn(rst_n),
      .I_cfg_en(cfg_en),
      .O_cfg_done(cam_init_done),
      .I_IIC_SCL(IIC_SCL),
      .IO_IIC_SDA(IIC_SDA)
  );

endmodule
