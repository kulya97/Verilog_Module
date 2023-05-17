`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/31 11:08:14
// Design Name: 
// Module Name: Mode_Selector
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


module Mode_Selector(
input sys_clk   ,
input rst_n     ,
input [31:0] uart_reg ,
input uart_ready,

input  V1_i,
input  V2_i,
input  V3_i,
input  V4_i,
input  ICG1_i,
input  ICG2_i,
output reg V1_o,
output reg V2T_o,
output reg V4T_o,
output reg V3_o,
output reg V2B_o,
output reg V4B_o,
output reg ICG1_o,
output reg ICG2_o,

input  H1_i,
input  H2_i,
input  H3_i,
input  H4_i,
input  SG_i,
input  FR_i,

output reg H1T_o , 
output reg H2LT_o, 
output reg H4LT_o, 
output reg H3T_o , 
output reg H2RT_o, 
output reg H4RT_o, 

output reg H1B_o , 
output reg H2LB_o, 
output reg H4LB_o, 
output reg H3B_o , 
output reg H2RB_o, 
output reg H4RB_o, 

output reg SG1_o ,
output reg SG2_o ,
output reg FRR_o ,
output reg FRL_o ,

input [15:0] ADC1_is,
input [15:0] ADC2_is,
input [15:0] ADC3_is,
input [15:0] ADC4_is,
output reg [15:0] ADC_os
);
parameter S_REST  =8'd0;
parameter S_1A1B_TL    =8'd1;
parameter S_1A1B_TR    =8'd2;
parameter S_1A1B_BL    =8'd3;
parameter S_1A1B_BR    =8'd4;
parameter S_1A1B_TLR   =8'd5;
parameter S_1A1B_BLR   =8'd6;
parameter S_1A1B_TBLR  =8'd7;

parameter S_2A2B_TL  =8'd8;
parameter S_2A2B_TR  =8'd9;
parameter S_2A2B_BL  =8'd10;
parameter S_2A2B_BR  =8'd11;
parameter S_2A2B_TLR  =8'd12;
parameter S_2A2B_BLR  =8'd13;
reg [7:0] mode;
always @(posedge sys_clk or negedge rst_n ) begin
    if(!rst_n) begin
        mode <=S_REST;
    end
    else if(uart_ready && (uart_reg[31:16] == 16'hEE00))
        mode <=S_REST;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE01))
        mode <=S_1A1B_TL;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE02))
        mode <=S_1A1B_TR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE03))
        mode <=S_1A1B_BL;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE04))
        mode <=S_1A1B_BR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE05))
        mode <=S_1A1B_TLR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE06))
        mode <=S_1A1B_BLR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE07))
        mode <=S_1A1B_TBLR;

    else if(uart_ready && (uart_reg[31:16] == 16'hEE08))
        mode <=S_2A2B_TL;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE09))
        mode <=S_2A2B_TR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE0A))
        mode <=S_2A2B_BL;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE0B))
        mode <=S_2A2B_BR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE0C))
        mode <=S_2A2B_TLR;
    else if(uart_ready && (uart_reg[31:16] == 16'hEE0D))
        mode <=S_2A2B_BLR;
end
always @(*) begin
    case(mode)
        S_REST:begin
                V2T_o =0;
                V4T_o =0;
                V2B_o =0;
                V4B_o =0;
                H2LT_o=0;
                H4LT_o=0;
                H2RT_o=0;
                H4RT_o=0;
                H2LB_o=0;
                H4LB_o=0;
                H2RB_o=0;
                H4RB_o=0;
            end
        S_1A1B_TL  :begin
                V2T_o =V2_i;
                V4T_o =V4_i;
                V2B_o =V4_i;
                V4B_o =V2_i;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H4_i;
                H4RT_o=H2_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H4_i;
                H4RB_o=H2_i;
            end
        S_1A1B_TR  :begin
                V2T_o =V2_i;
                V4T_o =V4_i;
                V2B_o =V4_i;
                V4B_o =V2_i;

                H2LT_o=H4_i;
                H4LT_o=H2_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;

                H2LB_o=H4_i;
                H4LB_o=H2_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
        S_1A1B_BL  :begin
                V2T_o =V4_i;
                V4T_o =V2_i;
                V2B_o =V2_i;
                V4B_o =V4_i;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H4_i;
                H4RT_o=H2_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H4_i;
                H4RB_o=H2_i;
            end
        S_1A1B_BR  :begin
                V2T_o =V4_i;
                V4T_o =V2_i;
                V2B_o =V2_i;
                V4B_o =V4_i;

                H2LT_o=H4_i;
                H4LT_o=H2_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H4_i;
                H4LB_o=H2_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
        S_1A1B_TLR :begin
                V2T_o =V2_i;
                V4T_o =V4_i;
                V2B_o =V4_i;
                V4B_o =V2_i;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
        S_1A1B_BLR :begin
                V2T_o =V4_i;
                V4T_o =V2_i;
                V2B_o =V2_i;
                V4B_o =V4_i;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
        S_1A1B_TBLR:begin
                V2T_o =V2_i;
                V4T_o =V4_i;
                V2B_o =V2_i;
                V4B_o =V4_i;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end

            S_2A2B_TL:begin
                V2T_o =0;
                V4T_o =V4_i;
                V2B_o =V2_i;
                V4B_o =0;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H4_i;
                H4RT_o=H2_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H4_i;
                H4RB_o=H2_i;
            end
            S_2A2B_TR:begin
                V2T_o =0;
                V4T_o =V4_i;
                V2B_o =V2_i;
                V4B_o =0;

                H2LT_o=H4_i;
                H4LT_o=H2_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H4_i;
                H4LB_o=H2_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
            S_2A2B_BL:begin
                V2T_o =0;
                V4T_o =V2_i;
                V2B_o =V4_i;
                V4B_o =0;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H4_i;
                H4RT_o=H2_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H4_i;
                H4RB_o=H2_i;
            end
            S_2A2B_BR:begin
                V2T_o =0;
                V4T_o =V2_i;
                V2B_o =V4_i;
                V4B_o =0;

                H2LT_o=H4_i;
                H4LT_o=H2_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H4_i;
                H4LB_o=H2_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
            S_2A2B_TLR:begin
                V2T_o =0;
                V4T_o =V4_i;
                V2B_o =V2_i;
                V4B_o =0;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
            S_2A2B_BLR:begin
                V2T_o =0;
                V4T_o =V2_i;
                V2B_o =V4_i;
                V4B_o =0;

                H2LT_o=H2_i;
                H4LT_o=H4_i;
                H2RT_o=H2_i;
                H4RT_o=H4_i;
                H2LB_o=H2_i;
                H4LB_o=H4_i;
                H2RB_o=H2_i;
                H4RB_o=H4_i;
            end
            default:begin
                V2T_o =0;
                V4T_o =0;
                V2B_o =0;
                V4B_o =0;

                H2LT_o=0;
                H4LT_o=0;
                H2RT_o=0;
                H4RT_o=0;
                H2LB_o=0;
                H4LB_o=0;
                H2RB_o=0;
                H4RB_o=0;
            end
    endcase
end
always @(*) begin
    case(mode)
        S_REST:begin
            V1_o  =0;
            V3_o  =0;
            ICG1_o=0;
            ICG2_o=0;
            H1T_o =0;
            H3T_o =0;
            H1B_o =0;
            H3B_o =0;
            SG1_o =0;
            SG2_o =0;
            FRR_o =0;
            FRL_o =0;
            end
        default:begin
            V1_o  =V1_i;
            V3_o  =V3_i;
            ICG1_o=ICG1_i;
            ICG2_o=ICG2_i;
            H1T_o =H1_i;
            H3T_o =H3_i;
            H1B_o =H1_i;
            H3B_o =H3_i;
            SG1_o =SG_i;
            SG2_o =SG_i;
            FRR_o =FR_i;
            FRL_o =FR_i;
            end
    endcase
end
reg [7:0] adcmode ;
parameter S_A  =8'd0;
parameter S_B    =8'd1;
parameter S_C    =8'd2;
parameter S_D    =8'd3;
parameter S_T    =8'd4;
always @(posedge sys_clk or negedge rst_n ) begin
    if(!rst_n) begin
        adcmode <=S_REST;
    end
    else if(uart_ready && (uart_reg[31:16] == 16'hEF00))
        adcmode <=S_A;
    else if(uart_ready && (uart_reg[31:16] == 16'hEF01))
        adcmode <=S_B;
    else if(uart_ready && (uart_reg[31:16] == 16'hEF02))
        adcmode <=S_C;
    else if(uart_ready && (uart_reg[31:16] == 16'hEF03))
        adcmode <=S_D;
    else if(uart_ready && (uart_reg[31:16] == 16'hEFff))
        adcmode <=S_T;
end
always @(*) begin
    case(adcmode)
        S_A:begin
            ADC_os=ADC1_is;
        end
        S_B:begin
            ADC_os=ADC2_is;
        end
        S_C:begin
            ADC_os=ADC3_is;
        end
        S_D:begin
            ADC_os=ADC4_is;
        end
        S_T:begin
            ADC_os=uart_reg[15:0];
            end
        default:begin
            ADC_os=ADC1_is;
        end
    endcase
end

endmodule
