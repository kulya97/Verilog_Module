module Serdes (
    //
    input       I_rstn,
    input       I_lvds_clk_p,
    input       I_lvds_clk_n,
    input [3:0] I_lvds_data_p,
    input [3:0] I_lvds_data_n,

    input I_lvds_clk,
    input I_cmos_clk,

    output        O_cmos_data_valid,
    output        O_cmos_line_valid,
    output        O_cmos_frame_valid,
    output [11:0] O_cmos_data
);

  wire [47:0] W_data;
  wire        W_ref_clk;
  wire        W_data_clk;
  wire        W_data_valid;

  wire [ 3:0] W_bitslip;
  wire        W_bitslip_done;
  ui_selectio ui_selectio_inst (

      .I_rstn       (I_rstn),
      .I_lvds_clk_p (I_lvds_clk_p),
      .I_lvds_clk_n (I_lvds_clk_n),
      .I_lvds_data_p(I_lvds_data_p),
      .I_lvds_data_n(I_lvds_data_n),

      .I_ref_clk   (I_lvds_clk),
      .O_data_clk  (w_data_clk),
      .I_bitslip   (W_bitslip),
      .O_data_valid(W_data_valid),
      .O_data      (W_data[47:0])
  );

  BitSlip_module BitSlip_module0 (
      .I_clk         (w_data_clk),      //数据时钟
      .I_rstn        (I_rstn),
      .I_en          (0),               //初始化或报错时
      .I_data        (W_data[47:0]),
      .I_data_valid  (W_data_valid),
      .O_bitslip     (W_bitslip[3:0]),
      .O_bitslip_done(W_bitslip_done)   //bitslip正确
  );

  wire [11:0] W_12bit_data;
  wire        W_12bit_data_valid;


  /***********************/
  decode_48to12 decode_48to12_inst (
      .I_clk       (w_data_clk),
      .I_rstn      (I_rstn),
      .I_slip_done (I_slip_done),
      .I_data_valid(W_data_valid),
      .I_data      (W_data),
      .O_data      (W_12bit_data),
      .O_data_valid(W_12bit_data_valid)
  );
  wire [11:0] fifo_dout;
  wire        fifo_empty;


  ila_1 your_instance_name (
      .clk   (I_cmos_clk),             // input wire clk
      .probe0(O_cmos_data),        // input wire [11:0]  probe0  
      .probe1(O_cmos_data_valid),  // input wire [0:0]  probe1
      .probe2(O_cmos_line_valid),  // input wire [0:0]  probe1
      .probe3(O_cmos_frame_valid)  // input wire [0:0]  probe1
  );

  fifo_generator_0 your_instance_name1 (
      .wr_clk(w_data_clk),          // input wire wr_clk
      .rd_clk(I_cmos_clk),          // input wire rd_clk
      .din   (W_12bit_data),        // input wire [11 : 0] din
      .wr_en (W_12bit_data_valid),  // input wire wr_en
      .rd_en (1),                   // input wire rd_en
      .dout  (fifo_dout),           // output wire [11 : 0] dout
      .full  (),                    // output wire full
      .empty (fifo_empty),          // output wire empty
      .valid ()                     // output wire valid
  );

  Sync_Gen_module Sync_Gen_module0 (
      .I_bitslip_done(W_bitslip_done),
      .I_clk         (I_cmos_clk),
      .I_rstn        (I_rstn),

      .O_bitslip_error(),  //报错时

      .I_data      (fifo_dout[11:0]),
      .I_data_valid(1'b1),

      .O_cmos_clk        (),
      .O_cmos_frame_valid(O_cmos_frame_valid),
      .O_cmos_line_valid (O_cmos_line_valid),
      .O_cmos_data_valid (O_cmos_data_valid),
      .O_cmos_data       (O_cmos_data)
  );


endmodule
