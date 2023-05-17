//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/23 10:08:17
// Design Name: 
// Module Name: spi_slave_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ����ģʽCPOL��CPHA
//(����)mode 0:00:sclk���ͣ���һ�����ز������ڶ������ط��ͣ��½��ط��ͣ������ز���
//(����)mode 1:01:sclk���ͣ���һ�����ط��ͣ��ڶ������ز������½��ز����������ط���
//(����)mode 2:10:sclk���ߣ���һ�����ز������ڶ������ط��ͣ��½��ز����������ط���
//(����)mode 3:11:sclk���ߣ���һ�����ط��ͣ��ڶ������ز������½��ط��ͣ������ز���
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module spi_slave_core (
    input clk,
    input rst_n,
    input en,

    input  CPOL,  // ʱ�Ӽ���
    input  CPHA,  //ʱ����λ 
    input  CS,    //chip select (SPI mode)
    input  DCLK,  //spi clock
    input  MOSI,  //spi data input
    output MISO,  //spi output 

    input  [7:0] data_in,    //data in
    output [7:0] data_out,   //data out
    output       data_ready  //��Ӧ
);

  /***************************/
  parameter BITNUM = 8'd8;
  localparam BITCNT = BITNUM * 2;
  /***************************/
  reg [7:0] MOSI_shift;
  reg [7:0] MISO_shift;
  reg [7:0] r_data_out;
  reg       r_data_ready;

  reg [7:0] r_rising_cnt;
  reg [7:0] r_falling_cnt;
  reg [7:0] r_edge_cnt;
  reg r_dclk_d0, r_dclk_d1;
  wire r_sampling_r;
  wire r_sampling_f;
  wire r_sampling;
  /***************************/
  assign MISO       = MISO_shift[7];
  assign data_ready = r_data_ready;
  assign data_out   = r_data_out;
  /***************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      r_dclk_d0 <= 1'b0;
      r_dclk_d1 <= 1'b0;
    end else begin
      r_dclk_d0 <= DCLK;
      r_dclk_d1 <= r_dclk_d0;
    end
  end
  assign r_sampling_r = r_dclk_d0 & !r_dclk_d1;  //������
  assign r_sampling_f = !r_dclk_d0 & r_dclk_d1;  //�½���
  assign r_sampling   = (r_dclk_d0 != r_dclk_d1);  //������
  /**************************ͬ��״̬****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //����
  localparam S_INIT = 5'd1;  //����
  localparam S_DCLK_IDLE = 5'd2;  //����
  localparam S_ACK = 5'd3;  //����

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
        if (!CS) STATE_NEXT = S_INIT;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        if (CS) STATE_NEXT = S_IDLE;
        else STATE_NEXT = S_DCLK_IDLE;
      end
      S_DCLK_IDLE: begin
        if (CS) STATE_NEXT = S_IDLE;
        else if (r_edge_cnt == BITCNT) STATE_NEXT = S_ACK;
        else STATE_NEXT = S_DCLK_IDLE;
      end
      S_ACK: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************���ؼ���****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_rising_cnt <= 'd0;
    else if (STATE_CURRENT == S_INIT) r_rising_cnt <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && r_sampling_r) r_rising_cnt <= r_rising_cnt + 1'd1;
    else r_rising_cnt <= r_rising_cnt;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_falling_cnt <= 'd0;
    else if (STATE_CURRENT == S_INIT) r_falling_cnt <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && r_sampling_f) r_falling_cnt <= r_falling_cnt + 1'd1;
    else r_falling_cnt <= r_falling_cnt;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_edge_cnt <= 'd0;
    else if (STATE_CURRENT == S_INIT) r_edge_cnt <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && r_sampling) r_edge_cnt <= r_edge_cnt + 1'd1;
    else r_edge_cnt <= r_edge_cnt;
  end
  /**************************����****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) MOSI_shift <= 'd0;
    else if (STATE_CURRENT == S_INIT) MOSI_shift <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA == CPOL && r_sampling_r) MOSI_shift <= {MOSI_shift[6:0], MOSI};  //�����ز���
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA != CPOL && r_sampling_f) MOSI_shift <= {MOSI_shift[6:0], MOSI};  //�½��ز���
    else MOSI_shift <= MOSI_shift;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_data_out <= 'd0;
    else if (STATE_CURRENT == S_ACK) r_data_out <= MOSI_shift;
    else r_data_out <= r_data_out;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_data_ready <= 1'd0;
    else if (STATE_CURRENT == S_ACK) r_data_ready <= 1'b1;
    else r_data_ready <= 1'd0;
  end
  /*************************���****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) MISO_shift <= 'd0;
    else if (STATE_CURRENT == S_INIT) MISO_shift <= data_in;
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA && CPOL && r_sampling_r && r_edge_cnt != 'd0) MISO_shift <= {MISO_shift[6:0], 1'b0};  //�����ش���
    else if (STATE_CURRENT == S_DCLK_IDLE && !CPHA && !CPOL && r_sampling_r) MISO_shift <= {MISO_shift[6:0], 1'b0};  //�����ش���
    else if (STATE_CURRENT == S_DCLK_IDLE && !CPHA && CPOL && r_sampling_f) MISO_shift <= {MISO_shift[6:0], 1'b0};  //�½��ش���
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA && !CPOL && r_sampling_f && r_edge_cnt != 'd0) MISO_shift <= {MISO_shift[6:0], 1'b0};  //�½��ش���
    else MISO_shift <= MISO_shift;
  end
endmodule
