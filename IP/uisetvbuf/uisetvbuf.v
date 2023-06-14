`timescale 1ns / 1ps
/*
Company : Liyang Milian Electronic Technology Co., Ltd.
Brand: milianke
Technical forum:www.uisrc.com
taobao1: https://milianke.taobao.com
taobao2: https://osrc.taobao.com
jd:https://milianke.jd.com
Create Date: 2019/12/17
Module Name: uisetvbuf
Description: 
Copyright: Copyright (c) milianke
Revision: 1.0
Signal description:
1) _i input
2) _o output
3) _n activ low
4) _dg debug signal 
5) _r delay or register
6) _s state mechine
*/
//////////////////////////////////////////////////////////////////////////////////

module uisetvbuf#(
parameter  integer                  BUF_DELAY     = 1,
parameter  integer                  BUF_LENTH     = 3
)
(

input      [7   :0]                 bufn_i,
output     [7   :0]                 bufn_o
);    

assign bufn_o = (bufn_i+(BUF_LENTH-1'b1-BUF_DELAY))%BUF_LENTH;


endmodule

