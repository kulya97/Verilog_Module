

module top (
    input sys_clk_p,  //系统时钟
    input sys_clk_n,  //系统时钟
    //input sys_rst_n,  //系统复位，低电平有效
    //摄像头接口lvds
    input cam_lvds_clk_p,
    input cam_lvds_clk_n,
    input [3:0] cam_lvds_data_p,
    input [3:0] cam_lvds_data_n,
    //
    output cam_extclk,  //cmos 主时钟输入
    output cam_efsync,  //cmos 外同步
    output cam_xshutdn,  //cmos 复位信号，低电平有效
    output cam_pwdn,  //电源休眠模式选择 0：正常模式 1：电源休眠模式

    output P1V2_EN,
    output P1V8_EN,
    output P2V8_EN,
    inout cam_scl,  //cmos SCCB_SCL线
    inout cam_sda,  //cmos SCCB_SDA线
    //cameralink 
    output [4:0] CAM_BUS_p,
    output [4:0] CAM_BUS_n
);


  //wire define
  wire locked0, locked1;  //时钟锁定信号
  wire        rst_n;  //全局复位


  wire        cmos_fvalid;  //
  wire        cmos_lvalid;  //
  wire        cmos_dvalid;  //
  wire [11:0] cmos_data;
  wire        cmos_clk;
  wire        cmos_clk_x7;



  //待时钟锁定后产生复位结束信号


  wire        clk_tmp;
  wire        clk_sys_37m125;
  wire clk_cm_clk_74m25, cam_extclk_37m125, clk_cm_clk_519m75;
  wire init_calib_complete;

  assign rst_n = locked0;

  assign cam_extclk = cam_extclk_37m125;

  // ****************** Clock ****************** 
  IBUFDS #(
      .DIFF_TERM ("TRUE"),
      .IOSTANDARD("LVDS")
  ) ibufds_clk_ref (
      .I (sys_clk_p),
      .IB(sys_clk_n),
      .O (clk_tmp)
  );
  BUFG bufg_clk_ref (
      .I(clk_tmp),
      .O(clk_sys_37m125)
  );
  /**************************************************************************/

  clk_wiz_0 u_clk_wiz_0 (
      // Clock out ports
      .clk_out1(cam_extclk_37m125),
      .clk_out2(clk_cm_clk_74m25),
      .clk_out3(clk_cm_clk_111m375),
      .clk_out4(clk_cm_clk_519m75),
      // Status and control signals
      .locked  (locked0),
      // Clock in ports
      .clk_in1 (clk_sys_37m125)
  );


  Serdes Serdes_inst (
      .I_rstn(rst_n),
      .I_lvds_clk(clk_cm_clk_111m375),
      .I_cmos_clk(clk_cm_clk_74m25),

      .I_lvds_clk_p (cam_lvds_clk_p),
      .I_lvds_clk_n (cam_lvds_clk_n),
      .I_lvds_data_p(cam_lvds_data_p),
      .I_lvds_data_n(cam_lvds_data_n),

      .O_cmos_data_valid(cmos_dvalid),
      .O_cmos_line_valid(cmos_lvalid),
      .O_cmos_frame_valid(cmos_fvalid),
      .O_cmos_data(cmos_data)
  );

  cameralink cameralink_inst (
      .clk37_125(clk_cm_clk_74m25),
      .clk_259_875(clk_cm_clk_519m75),
      .rst_n(rst_n),
      .i_vsync(cmos_fvalid),
      .i_hsync(cmos_dvalid),
      .i_data_16({8'd0, cmos_data[11:4]}),
      .CAM_BUS_p(CAM_BUS_p),
      .CAM_BUS_n(CAM_BUS_n)
  );


  SC2110_driver SC2110_driver_inst (
      .clk(clk_sys_37m125),
      .rst_n(rst_n),
      .cam_xshutdn(cam_xshutdn),
      .cam_pwdn(cam_pwdn),
      .cam_DOVDD18(P1V8_EN),
      .cam_DVDD12(P1V2_EN),
      .cam_AVDD28(P2V8_EN),
      .IIC_SCL(cam_scl),
      .IIC_SDA(cam_sda),
      .cam_init_done()
  );
  //   SC2110_driver u_SC2110_driver (
  //       .clk      (clk_sys_37m125),
  //       .rst_n    (rst_n),
  //       .cam_DVDD12 (P1V2_EN),
  //       .cam_DOVDD18(P1V8_EN),
  //       .cam_AVDD28 (P2V8_EN),
  //       .cam_pwdn   (cam_pwdn),
  //       .cam_xshutdn(cam_xshutdn)
  //   );


endmodule
