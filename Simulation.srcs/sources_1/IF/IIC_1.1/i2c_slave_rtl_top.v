

module i2c_slave_rtl_top (
    input i_clk,
    input i_rstn,

    input         i_wvalid,
    output        o_wready,
    input  [15:0] i_wdata,
    output        o_init_done,
    inout         i2c_scl,
    input         i2c_sda
);

  parameter SLAVE_ADDR = 7'b1010000;  //EEPROM从机地址
  parameter CLK_FREQ = 26'd50_000_000;  //模块输入的时钟频率
  parameter I2C_FREQ = 18'd250_000;  //IIC_SCL的时钟频率

  wire        w_i2c_req;

  wire        w_i2c_done;
  wire        w_i2c_ack;
  wire        w_dri_clk;
  wire        w_cmd_bit_ctrl;
  wire [15:0] w_i2c_data;
  wire [ 7:0] i_i2c_addr;
  wire [ 7:0] i_i2c_wdata;

  assign i_i2c_addr  = w_i2c_data[15:8];
  assign i_i2c_wdata = w_i2c_data[7:0];


  wire        w_i2c_init_done;
  wire        w_i2c_init_req;
  wire [15:0] w_i2c_init_data;

  assign w_i2c_data      = o_init_done ? i_wdata : w_i2c_init_data;
  assign w_i2c_req       = o_init_done ? i_wvalid : w_i2c_init_req;
  assign o_wready        = o_init_done ? w_i2c_done : 1'b0;
  assign w_i2c_init_done = o_init_done ? 1'b0 : w_i2c_done;
  iic_slave_module #(
      .SLAVE_ADDR(SLAVE_ADDR),
      .CLK_FREQ(CLK_FREQ),
      .I2C_FREQ(I2C_FREQ),
      .WR_BITS(1),
      .RD_BITS(1)
  ) iic_slave_module_inst (
      .i_clk         (i_clk),
      .i_rstn        (i_rstn),
      .i_i2c_req     (w_i2c_req),
      .o_i2c_done    (w_i2c_done),
      .o_i2c_ack     (w_i2c_ack),
      .i_cmd_bit_ctrl(0),
      .i_cmd_rh_wl   (1),
      .i_i2c_addr    (i_i2c_addr),
      .i_i2c_wdata   (i_i2c_wdata),
      .o_i2c_rdata   (o_i2c_rdata),
      .i2c_scl       (i2c_scl),
      .i2c_sda       (i2c_sda),
      .o_dri_clk     (w_dri_clk)
  );
  i2c_reg_map_module #(
      .REG_NUM  (70),
      .REG_WIDTH(16)
  ) i2c_reg_map_module_inst (
      .i_clk      (w_dri_clk),
      .i_rstn     (i_rstn),
      .i_i2c_done (w_i2c_init_done),
      .o_i2c_req  (w_i2c_init_req),
      .o_i2c_data (w_i2c_init_data),
      .o_init_done(o_init_done)
  );
endmodule
