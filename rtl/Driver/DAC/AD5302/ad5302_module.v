`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 14:29:24
// Design Name: 
// Module Name: ad5302_module
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


module ad5302_module (
    input             clk,
    input             rst_n,
    output            DSYNC0_N,  //
    output            DSYNC1_N,  //
    output            DCLK,      //
    output            DIN,
    output            DLDAC_N,   //
    input      [31:0] app_din,
    input             app_req,
    output reg        app_ack
);

  parameter ADDRESS_DAC0 = 16'hdac0;
  parameter ADDRESS_DAC1 = 16'hdac1;
  parameter ADDRESS_DAC_EN = 16'hdacf;

  // spi_master_core data
  reg         wr_req = 0;
  reg  [15:0] data_in = 0;
  wire        wr_ack;
  wire [15:0] data_out;

  reg  [ 7:0] r_channel;
  // spi_master_core io
  reg         r_dldac;
  wire [ 7:0] CS;

  //
  assign DSYNC0_N = CS[0];
  assign DSYNC1_N = CS[1];
  assign DLDAC_N  = r_dldac;
  /**************************ͬ��״̬****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //����
  localparam S_INIT = 5'd1;  //
  localparam S_WRITE = 5'd2;  //
  localparam S_WAIT = 5'd3;  //
  localparam S_ENREG = 5'd4;  //
  localparam S_DONE = 5'd5;  //
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 32'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  /**************************ת��״̬****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (app_req && app_din[31:16] == ADDRESS_DAC0) STATE_NEXT = S_WRITE;
        else if (app_req && app_din[31:16] == ADDRESS_DAC1) STATE_NEXT = S_WRITE;
        else if (app_req && app_din[31:16] == ADDRESS_DAC_EN) STATE_NEXT = S_ENREG;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        STATE_NEXT = S_WRITE;
      end
      S_WRITE: begin
        STATE_NEXT = S_WAIT;
      end
      S_WAIT: begin
        if (wr_ack) STATE_NEXT = S_DONE;
        else STATE_NEXT = S_WAIT;
      end
      S_ENREG: begin
        if (state_clk_cnt == 'd2) STATE_NEXT = S_DONE;
        else STATE_NEXT = S_ENREG;
      end
      S_DONE: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************״̬���****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) data_in <= 0;
    else if (app_req && app_din[31:16] == ADDRESS_DAC0) data_in <= app_din[15:0];
    else if (app_req && app_din[31:16] == ADDRESS_DAC1) data_in <= app_din[15:0];
    else data_in <= data_in;
  end
  //req
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) wr_req <= 1'b0;
    else if (STATE_CURRENT == S_WRITE) wr_req <= 1'b1;
    else wr_req <= 1'b0;
  end
  //r_channel
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_channel <= 8'b0;
    else if (app_req && app_din[31:16] == ADDRESS_DAC0) r_channel <= 8'b0000_0001;
    else if (app_req && app_din[31:16] == ADDRESS_DAC1) r_channel <= 8'b0000_0010;
    else r_channel <= r_channel;
  end
  //
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_dldac <= 1'b1;
    else if (STATE_CURRENT == S_ENREG) r_dldac <= 1'b0;
    else r_dldac <= 1'b1;
  end
  //ack
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) app_ack <= 1'b0;
    else if (STATE_CURRENT == S_DONE) app_ack <= 1'b1;
    else app_ack <= 1'b0;
  end
  /*****************************************************************/
  spi_master_core #(
      .BITNUM(16'd16)
  ) u_spi_master_core (
      .clk     (clk),
      .rst_n   (rst_n),
      .clk_div (16'd10),
      .channel (r_channel),
      .CPOL    (1'b0),
      .CPHA    (1'b1),
      .MISO    (1'B1),
      .wr_req  (wr_req),
      .data_in (data_in[15:0]),
      .CS      (CS),
      .DCLK    (DCLK),
      .MOSI    (DIN),
      .wr_ack  (wr_ack),
      .data_out(data_out[15:0])
  );
endmodule
