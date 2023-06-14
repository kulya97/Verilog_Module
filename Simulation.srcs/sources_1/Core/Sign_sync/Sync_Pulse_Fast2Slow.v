`timescale 1ns / 1ps
//Synchronous��ʱ������ʱ����
module Sync_Pulse_Fast2Slow(
    input           clk_fast,
    input           clk_slow,
    input           rst_n,
    input           pulse_i,
    output          pulse_o,
    output          signal_o
);

//-------------------------------------------------------
reg             signal_a;
reg             signal_b;
reg     [1:0]   signal_b_r;
reg     [1:0]   signal_a_r;

//-------------------------------------------------------
//��clk_fast�£�����չ���ź�signal_a
always @(posedge clk_fast or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        signal_a <= 1'b0;
    end
    else if(pulse_i == 1'b1)begin
        signal_a <= 1'b1;
    end
    else if(signal_a_r[1] == 1'b1)
        signal_a <= 1'b0;
    else
        signal_a <= signal_a;
end

//-------------------------------------------------------
//��clkb��ͬ��signal_a
always @(posedge clkb or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        signal_b <= 1'b0;
    end
    else begin
        signal_b <= signal_a;
    end
end

//-------------------------------------------------------
//��clkb�����������źź�����ź�
always @(posedge clkb or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        signal_b_r <= 2'b00;
    end
    else begin
        signal_b_r <= {signal_b_r[0], signal_b};
    end
end

assign    pulse_o = ~signal_b_r[1] & signal_b_r[0];
assign    signal_o = signal_b_r[1];

//-------------------------------------------------------
//��clk_fast�²ɼ�signal_b[1]������signal_a_r[1]���ڷ�������signal_a
always @(posedge clk_fast or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        signal_a_r <= 2'b00;
    end
    else begin
        signal_a_r <= {signal_a_r[0], signal_b_r[1]};
    end
end

endmodule