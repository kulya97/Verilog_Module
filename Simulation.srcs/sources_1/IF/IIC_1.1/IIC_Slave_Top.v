

module IIC_Slave_Top (
    input I_clk,
    input I_rstn,

    input        I_awvalid,
    output       O_awready,
    input  [7:0] I_awdata,

    input        I_wvalid,
    output       O_wready,
    input  [7:0] I_wdata,

    output       O_rvalid,
    input        I_rready,
    output [7:0] O_rdata,
    output       O_init_done,
    inout        IIC_SDA,
    input        IIC_SCL
);

  parameter SLAVE_ADDR = 7'b1010000;  //EEPROM从机地址
  parameter CLK_FREQ = 26'd50_000_000;  //模块输入的时钟频率
  parameter I2C_FREQ = 18'd250_000;  //IIC_SCL的时钟频率


  IIC_Slave_Core #(
      .SLAVE_ADDR(SLAVE_ADDR),
      .CLK_FREQ  (CLK_FREQ),
      .I2C_FREQ  (I2C_FREQ)
  ) IIC_Slave_Core_inst (
      .clk       (clk),
      .rst_n     (rst_n),
      .i2c_exec  (i2c_exec),
      .i2c_done  (i2c_done),
      .i2c_ack   (i2c_ack),
      .bit_ctrl  (bit_ctrl),
      .i2c_rh_wl (i2c_rh_wl),
      .i2c_addr  (i2c_addr),
      .i2c_data_w(i2c_data_w),
      .i2c_data_r(i2c_data_r),
      .scl       (scl),
      .sda       (sda),
      .dri_clk   (dri_clk)
  );


endmodule
