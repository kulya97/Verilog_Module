`timescale 1ns / 1ps
module Sync_Pulse_Slow2Fast(
    input  clk          ,
    input  rst_n        ,
    input  sign_i      ,
    output reg pulse_r_o  ,
    output reg pulse_f_o  ,
    output sign_o       
    );
reg sign_r1;
reg sign_r2;
always@(posedge clk) begin
    sign_r1 <= sign_i   ;
    sign_r2 <= sign_r1;
end
always@(posedge clk,negedge rst_n) begin
     if(!rst_n)begin
        pulse_r_o <= 1'd0;
        pulse_f_o<=1'd0;
     end
     else if({sign_r2,sign_r1} == 2'b01)begin
        pulse_r_o <= 1'b1;
     end
     else if({sign_r2,sign_r1} == 2'b10)begin
        pulse_f_o <= 1'b1;
     end
     else begin
        pulse_r_o <= 1'b0;
        pulse_f_o<=1'd0;
     end
end
assign sign_o=sign_r2;
endmodule
