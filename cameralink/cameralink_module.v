`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/19 15:59:01
// Design Name: 
// Module Name: cameralink_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cameralink_module (
    input        rst_n,
    input [15:0] app_image_h,
    input [15:0] app_image_w,
    input        data_clk,
    input        frame_valid,
    input        line_valid,
    input        data_valid,
    input [15:0] din,

    input         cm_data_clk,
    output        cm_frame_valid,
    output        cm_line_valid,
    output        cm_data_valid,
    output [15:0] cm_dout
);

  reg         r_data_valid;
  reg         r_line_valid;
  reg         r_frame_valid;
  reg  [15:0] r_din;

  reg         r_fifo_rden;
  reg         r_cm_frame_valid;
  reg  [15:0] r_cm_dout;

  wire        w_frame_valid_rising;
  wire        w_line_valid_rising;
  wire        w_line_valid_falling;
  /************************锁存数据********************************/
  always @(posedge data_clk, negedge rst_n) begin
    if (!rst_n) r_data_valid <= 1'b0;
    else r_data_valid <= data_valid;
  end

  always @(posedge data_clk, negedge rst_n) begin
    if (!rst_n) r_line_valid <= 1'b0;
    else r_line_valid <= line_valid;
  end

  always @(posedge data_clk, negedge rst_n) begin
    if (!rst_n) r_frame_valid <= 1'b0;
    else r_frame_valid <= frame_valid;
  end

  always @(posedge data_clk, negedge rst_n) begin
    if (!rst_n) r_din <= 'b0;
    else r_din <= din;
  end
  /************************捕捉边沿********************************/
  grab_edge_module grab_edge_module1 (
      .clk         (cm_data_clk),
      .sign        (r_frame_valid),
      .sign_pipe   (),
      .rising_edge (w_frame_valid_rising),
      .falling_edge()
  );

  grab_edge_module grab_edge_module2 (
      .clk         (cm_data_clk),
      .sign        (r_line_valid),
      .sign_pipe   (),
      .rising_edge (),
      .falling_edge(w_line_valid_falling)
  );

  /**************************同步状态****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //空闲
  localparam S_READ = 5'd1;
  localparam S_FRAME_DONE = 5'd2;

  always @(posedge cm_data_clk, negedge rst_n) begin
    if (!rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge cm_data_clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 32'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  /**************************转移状态****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (w_line_valid_falling) STATE_NEXT = S_READ;
        else STATE_NEXT = S_IDLE;
      end
      S_READ: begin
        if (state_clk_cnt == app_image_w - 1) STATE_NEXT = S_IDLE;
        else STATE_NEXT = S_READ;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  always @(posedge cm_data_clk, negedge rst_n) begin
    if (!rst_n) r_fifo_rden <= 1'b0;
    else if (STATE_CURRENT == S_READ) r_fifo_rden <= 1'b1;
    else r_fifo_rden <= 1'b0;
  end

  always @(posedge cm_data_clk, negedge rst_n) begin
    if (!rst_n) r_cm_frame_valid <= 1'b0;
    else if (w_frame_valid_rising) r_cm_frame_valid <= 1'b0;
    else if (w_line_valid_falling) r_cm_frame_valid <= 1'b1;
    else r_cm_frame_valid <= r_cm_frame_valid;
  end
  /**************************状态输出****************************/
  assign cm_frame_valid = r_cm_frame_valid;
  assign cm_line_valid  = r_fifo_rden;
  assign cm_data_valid  = r_fifo_rden;

  fifo_cameralink your_instance_name (
      .wr_clk(data_clk),      // input wire wr_clk
      .rd_clk(cm_data_clk),   // input wire rd_clk
      .din   (r_din),         // input wire [15 : 0] din
      .wr_en (r_data_valid),  // input wire wr_en
      .rd_en (r_fifo_rden),   // input wire rd_en
      .dout  (cm_dout),       // output wire [15 : 0] dout
      .full  (),              // output wire full
      .empty (),              // output wire empty
      .valid ()               // output wire valid
  );



endmodule
