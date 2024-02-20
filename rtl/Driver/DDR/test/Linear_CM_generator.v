`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/15 09:38:56
// Design Name: 
// Module Name: CM_generator
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
module Linear_CM_generator(
input               sys_rst_n        ,
input   [15:0]      ui_img_h        ,
input   [15:0]      ui_img_w        ,
/******************************************/
input               CL_CLK          ,
input               CL_LVAL         ,
input               CL_FVAL         ,
input               CL_DVAL         ,
/******************************************/
input               CM_CLK          ,
output  reg         CM_LVAL         ,
output  reg         CM_FVAL         ,
output  reg         CM_DVAL         
    );
reg [15:0] IMG_H;
reg [15:0] IMG_W;

always@(posedge CM_CLK,negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        IMG_H<=16'd0;
        IMG_W<=16'd0;
    end
    else begin
        IMG_H<=ui_img_h;
        IMG_W<=ui_img_w;
    end
end

reg CL_dval_d;
always@(posedge CM_CLK,negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        CM_FVAL<=1'b0;
        CM_LVAL<=1'b0;
        CL_dval_d<=1'b0;
    end
    else begin
        CM_FVAL<=CL_FVAL;
        CM_LVAL<=CL_LVAL;
        CL_dval_d<=CL_DVAL;
    end
end

reg [15:0]  pixel_cnt;
always@(posedge CM_CLK,negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        pixel_cnt<=12'd0;
    end
    else if(!CM_FVAL)
        pixel_cnt<=12'd0;
    else if(CL_dval_d)
        pixel_cnt=pixel_cnt+1'd1;
    else
        pixel_cnt<=12'd0;
end

always@(posedge CM_CLK,negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        CM_DVAL=1'b0;
    end
    if(CL_dval_d&&pixel_cnt<=IMG_W-1)
        CM_DVAL<=1'b1;
    else
        CM_DVAL=1'b0;
end
endmodule
