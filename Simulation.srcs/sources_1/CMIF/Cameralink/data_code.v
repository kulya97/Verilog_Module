`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 14:53:00
// Design Name: 
// Module Name: data_code
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
module data_code(
	clk,  
	rst_n,
	data,
	frame_flag,
	data_flag,
	
	txclkin,
	txdata
);

input clk,rst_n;
input [15:0] data;
input frame_flag;
input data_flag;

output [34:0] txdata;
output txclkin;

`define LINE 576
//`define LINE 18

wire daclk;
assign daclk = ~clk;

reg dval;
reg lval;
reg fval;
always @(posedge clk) begin
	lval <= data_flag;
	dval <= data_flag;
	fval <= frame_flag;
end


reg [6:0] datain3;
reg [6:0] datain2;
reg [6:0] datain1;
reg [6:0] datain0;
reg [6:0] clkin;
reg data_en;
always @(posedge daclk or negedge rst_n) begin
	if(!rst_n) begin
		data_en <= 1'b0;
	end
	else begin
		datain3 <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, data[7], data[6]};
		datain2 <= {dval, fval, lval, 1'b0, 1'b0, 1'b0, 1'b0};
		datain1 <= {1'b0, 1'b0, 1'b0, 1'b0, data[11:9]};
		datain0 <= {data[8], data[5:0]};
		clkin  <= {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1};
		
		data_en <= 1'b1;
	end
end

assign txdata = {datain3, datain2, datain1, datain0, clkin};
assign txclkin = data_en & clk;

endmodule
