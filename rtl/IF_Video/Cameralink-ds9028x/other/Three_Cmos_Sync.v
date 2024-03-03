`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 16:56:06
// Design Name: 
// Module Name: Three_Cmos_Sync
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

module Three_Cmos_Sync (
    input         I_Clk_50m,
    input         ila_clk,
    input         I_rstn,
    //
    output        O_C1_EX_SYNC,
    input         I_C1_PCLK,
    input         I_C1_F_DE,
    input         I_C1_HSYNC,
    input         I_C1_VSTNC,
    input  [11:0] I_C1_DATA,
    //
    output        O_C2_EX_SYNC,
    input         I_C2_PCLK,     //不使用
    input         I_C2_F_DE,
    input         I_C2_HSYNC,
    input         I_C2_VSTNC,
    input  [11:0] I_C2_DATA,
    //
    output        O_C3_EX_SYNC,
    input         I_C3_PCLK,     //不使用
    input         I_C3_F_DE,
    input         I_C3_HSYNC,
    input         I_C3_VSTNC,
    input  [11:0] I_C3_DATA,
    //
    input         I_CM_Clk,
    output        O_CM_Fval,
    output        O_CM_Lval,
    output        O_CM_Dval,
    output [11:0] O_CM_C1_Data,
    output [11:0] O_CM_C2_Data,
    output [11:0] O_CM_C3_Data
);

  parameter LINE_N = 505;
  parameter PIXEL_N = 708;

  /**********************************************/
  reg         R_C1_frame_valid;
  reg         R_C1_line_valid;
  reg         R_C1_data_valid;
  reg  [11:0] R_C1_din;
  //
  reg         R_C2_frame_valid;
  reg         R_C2_line_valid;
  reg         R_C2_data_valid;
  reg  [11:0] R_C2_din;
  //
  reg         R_C3_frame_valid;
  reg         R_C3_line_valid;
  reg         R_C3_data_valid;
  reg  [11:0] R_C3_din;
  /**********************************************/
  reg         R_fifo_rden;
  wire        W_fifo_rst;
  reg         R_cm_frame_valid;

  wire        W_frame_valid_rising;
  wire        W_frame_valid_falling;
  wire        W_line_valid_rising;
  wire        W_line_valid_falling;
  wire        W_data_valid_rising;
  wire        W_data_valid_falling;
  /************************锁存C1数据********************************/
  always @(posedge I_C1_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C1_frame_valid <= 1'b0;
    else R_C1_frame_valid <= !I_C1_VSTNC;
  end

  always @(posedge I_C1_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C1_line_valid <= 1'b0;
    else R_C1_line_valid <= !I_C1_HSYNC;
  end

  always @(posedge I_C1_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C1_data_valid <= 1'b0;
    else R_C1_data_valid <= I_C1_F_DE;
  end

  always @(posedge I_C1_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C1_din <= 'b0;
    else R_C1_din <= I_C1_DATA;
  end
  /************************锁存C2数据********************************/
  always @(posedge I_C2_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C2_frame_valid <= 1'b0;
    else R_C2_frame_valid <= !I_C2_VSTNC;
  end

  always @(posedge I_C2_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C2_line_valid <= 1'b0;
    else R_C2_line_valid <= !I_C2_HSYNC;
  end

  always @(posedge I_C2_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C2_data_valid <= 1'b0;
    else R_C2_data_valid <= I_C2_F_DE;
  end

  always @(posedge I_C2_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C2_din <= 'b0;
    else R_C2_din <= I_C2_DATA;
  end
  /************************锁存C3数据********************************/
  always @(posedge I_C3_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C3_frame_valid <= 1'b0;
    else R_C3_frame_valid <= !I_C3_VSTNC;
  end

  always @(posedge I_C3_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C3_line_valid <= 1'b0;
    else R_C3_line_valid <= !I_C3_HSYNC;
  end

  always @(posedge I_C3_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C3_data_valid <= 1'b0;
    else R_C3_data_valid <= I_C3_F_DE;
  end

  always @(posedge I_C3_PCLK, negedge I_rstn) begin
    if (!I_rstn) R_C3_din <= 'b0;
    else R_C3_din <= I_C3_DATA;
  end

  /************************捕捉边沿********************************/
  grab_edge_module grab_edge_module1 (
      .clk         (I_CM_Clk),
      .sign        (R_C1_frame_valid),
      .sign_pipe   (),
      .rising_edge (W_frame_valid_rising),
      .falling_edge(W_frame_valid_falling)
  );

  grab_edge_module grab_edge_module2 (
      .clk         (I_CM_Clk),
      .sign        (R_C1_line_valid),
      .sign_pipe   (),
      .rising_edge (W_line_valid_rising),
      .falling_edge(W_line_valid_falling)
  );
  grab_edge_module grab_edge_module3 (
      .clk         (I_CM_Clk),
      .sign        (R_C1_data_valid),
      .sign_pipe   (),
      .rising_edge (W_data_valid_rising),
      .falling_edge(W_data_valid_falling)
  );
  /**************************同步状态****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //空闲
  localparam S_READ = 5'd1;
  localparam S_FRAME_DONE = 5'd2;

  always @(posedge I_CM_Clk, negedge I_rstn) begin
    if (!I_rstn) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge I_CM_Clk, negedge I_rstn) begin
    if (!I_rstn) state_clk_cnt <= 32'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  /**************************转移状态****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (W_data_valid_falling) STATE_NEXT = S_READ;
        else STATE_NEXT = S_IDLE;
      end
      S_READ: begin
        if (state_clk_cnt == PIXEL_N - 1) STATE_NEXT = S_IDLE;
        else STATE_NEXT = S_READ;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end


  always @(posedge I_CM_Clk, negedge I_rstn) begin
    if (!I_rstn) R_fifo_rden <= 1'b0;
    else if (STATE_CURRENT == S_READ) R_fifo_rden <= 1'b1;
    else R_fifo_rden <= 1'b0;
  end

  always @(posedge I_CM_Clk, negedge I_rstn) begin
    if (!I_rstn) R_cm_frame_valid <= 1'b0;
    else if (W_frame_valid_rising) R_cm_frame_valid <= 1'b0;
    else if (W_data_valid_rising) R_cm_frame_valid <= 1'b1;
    else R_cm_frame_valid <= R_cm_frame_valid;
  end
  /**************************状态输出****************************/
  assign O_CM_Fval  = R_cm_frame_valid;
  assign O_CM_Lval  = R_fifo_rden;
  assign O_CM_Dval  = R_fifo_rden;
  assign W_fifo_rst = !R_cm_frame_valid;
  wire full, empty, valid;
  fifo_cameralink C1_Din (
      .rst   (W_fifo_rst),
      .wr_clk(I_C1_PCLK),        // input wire wr_clk
      .rd_clk(I_CM_Clk),         // input wire rd_clk
      .din   (R_C1_din),         // input wire [15 : 0] din
      .wr_en (R_C1_data_valid),  // input wire wr_en
      .rd_en (R_fifo_rden),      // input wire rd_en
      .dout  (O_CM_C1_Data),     // output wire [15 : 0] dout
      .full  (),             // output wire full
      .empty (),            // output wire empty
      .valid ()             // output wire valid
  );
  fifo_cameralink C2_Din (
      .rst   (W_fifo_rst),
      .wr_clk(I_C2_PCLK),        // input wire wr_clk
      .rd_clk(I_CM_Clk),         // input wire rd_clk
      .din   (R_C2_din),         // input wire [15 : 0] din
      .wr_en (R_C2_data_valid),  // input wire wr_en
      .rd_en (R_fifo_rden),      // input wire rd_en
      .dout  (O_CM_C2_Data),     // output wire [15 : 0] dout
      .full  (full),             // output wire full
      .empty (empty),            // output wire empty
      .valid (valid)             // output wire valid
  );
  fifo_cameralink C3_Din (
      .rst   (W_fifo_rst),
      .wr_clk(I_C3_PCLK),        // input wire wr_clk
      .rd_clk(I_CM_Clk),         // input wire rd_clk
      .din   (R_C3_din),         // input wire [15 : 0] din
      .wr_en (R_C3_data_valid),  // input wire wr_en
      .rd_en (R_fifo_rden),      // input wire rd_en
      .dout  (O_CM_C3_Data),     // output wire [15 : 0] dout
      .full  (),                 // output wire full
      .empty (),                 // output wire empty
      .valid ()                  // output wire valid
  );

  //生成外同步信号
  Ex_Sync_Gen u_Ex_Sync_Gen (
      .I_Clk_50m(I_Clk_50m),
      .I_rstn   (I_rstn),
      .I_en     (1'b1),

      .O_C1_EX(O_C1_EX_SYNC),
      .O_C2_EX(O_C2_EX_SYNC),
      .O_C3_EX(O_C3_EX_SYNC)
  );

  ila_0 your_instance_name2 (
      .clk(ila_clk),  // input wire clk

      .probe0 (I_C2_PCLK),          // input wire [0:0]  probe0  
      .probe1 (I_CM_Clk),         // input wire [0:0]  probe1 
      .probe2 (O_CM_Fval),        // input wire [0:0]  probe2 
      .probe3 (O_CM_Lval),        // input wire [0:0]  probe3 
      .probe4 (R_C1_din),         // input wire [11:0]  probe4 
      .probe5 (O_CM_Dval),        // input wire [0:0]  probe5 
      .probe6 (full),             // input wire [0:0]  probe6 
      .probe7 (empty),            // input wire [0:0]  probe7 
      .probe8 (valid),            // input wire [0:0]  probe8 
      .probe9 (R_C2_din),          // input wire [11:0]  probe9 
      .probe10(R_C2_data_valid),  // input wire [0:0]  probe10 
      .probe11(R_fifo_rden),      // input wire [0:0]  probe11 
      .probe12(O_C2_EX_SYNC),     // input wire [0:0]  probe12 
      .probe13(O_C2_EX_SYNC),     // input wire [0:0]  probe13 
      .probe14(O_CM_C2_Data)      // input wire [11:0]  probe14
  );
endmodule
