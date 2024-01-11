`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 14:56:40
// Design Name: 
// Module Name: camlink_tx
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
// camlink_tx(
	// I_clk,
	// I_clk_data,
	// I_rst_n,
	
	// tx_in,
	// tx_out
// );

// input I_clk;
// input I_clk_data;
// input I_rst_n;

// input [34:0] tx_in;
// output [4:0] tx_out;


// assign tx_out[4] = tx_p4 ^ tx_n4;
// assign tx_out[3] = tx_p3 ^ tx_n3;
// assign tx_out[2] = tx_p2 ^ tx_n2;
// assign tx_out[1] = tx_p1 ^ tx_n1;
// assign tx_out[0] = tx_p0 ^ tx_n0;

// reg [3:0] cnt_p;
// reg [3:0] cnt_n;

// reg tx_p0;
// reg tx_p1;
// reg tx_p2;
// reg tx_p3;
// reg tx_p4;
// reg tx_n0;
// reg tx_n1;
// reg tx_n2;
// reg tx_n3;
// reg tx_n4;

// reg [34:0] reg_txin;
// reg [34:0] reg_txin_p;
// reg [34:0] reg_txin_n;

// always@(posedge I_clk or negedge I_rst_n)begin
	// if(!I_rst_n) begin
		// cnt_p <= 4'd0;
	// end
	// else begin
		// if(cnt_p == 4'd6) cnt_p <= 4'd0;
		// else cnt_p <= cnt_p + 1;
	// end
// end

// always@(negedge I_clk or negedge I_rst_n)begin
	// if(!I_rst_n) begin
		// cnt_n <= 4'd0;
	// end
	// else begin
		// if(cnt_n == 4'd6) cnt_n <= 4'd0;
		// else cnt_n <= cnt_n + 1;
	// end
// end

// always@(posedge I_clk_data or negedge I_rst_n)begin
	// if(!I_rst_n) begin
		// reg_txin <= 35'd0;
	// end
	// else begin
		// reg_txin <= tx_in;
	// end
// end

// always@(posedge I_clk or negedge I_rst_n)begin
	// if(!I_rst_n) begin
		// tx_p4 <= 1'b0;
		// tx_p3 <= 1'b0;
		// tx_p2 <= 1'b0;
		// tx_p1 <= 1'b0;
		// tx_p0 <= 1'b0;
		// reg_txin_n <= 35'd0;
	// end
	// else begin
		// case(cnt_p)
			// 0:begin
				// tx_p4<= reg_txin_p[34] ^ tx_n4;
				// tx_p3 <= reg_txin_p[27] ^ tx_n3;
				// tx_p2 <= reg_txin_p[20] ^ tx_n2;
				// tx_p1 <= reg_txin_p[13] ^ tx_n1;
				// tx_p0 <= reg_txin_p[6] ^ tx_n0;
			// end
			// 1:begin
				// tx_p4<= reg_txin_p[32] ^ tx_n4;
				// tx_p3 <= reg_txin_p[25] ^ tx_n3;
				// tx_p2 <= reg_txin_p[18] ^ tx_n2;
				// tx_p1 <= reg_txin_p[11] ^ tx_n1;
				// tx_p0 <= reg_txin_p[4] ^ tx_n0;
				// reg_txin_n <= reg_txin;
			// end
			// 2:begin
				// tx_p4<= reg_txin_p[30] ^ tx_n4;
				// tx_p3 <= reg_txin_p[23] ^ tx_n3;
				// tx_p2 <= reg_txin_p[16] ^ tx_n2;
				// tx_p1 <= reg_txin_p[9] ^ tx_n1;
				// tx_p0 <= reg_txin_p[2] ^ tx_n0;
			// end
			// 3:begin
				// tx_p4<= reg_txin_p[28] ^ tx_n4;
				// tx_p3 <= reg_txin_p[21] ^ tx_n3;
				// tx_p2 <= reg_txin_p[14] ^ tx_n2;
				// tx_p1 <= reg_txin_p[7] ^ tx_n1;
				// tx_p0 <= reg_txin_p[0] ^ tx_n0;
				
			// end
			// 4:begin
				// tx_p4<= reg_txin_n[33] ^ tx_n4;
				// tx_p3 <= reg_txin_n[26] ^ tx_n3;
				// tx_p2 <= reg_txin_n[19] ^ tx_n2;
				// tx_p1 <= reg_txin_n[12] ^ tx_n1;
				// tx_p0 <= reg_txin_n[5] ^ tx_n0;
			// end
			// 5:begin
				// tx_p4<= reg_txin_n[31] ^ tx_n4;
				// tx_p3 <= reg_txin_n[24] ^ tx_n3;
				// tx_p2 <= reg_txin_n[17] ^ tx_n2;
				// tx_p1 <= reg_txin_n[10] ^ tx_n1;
				// tx_p0 <= reg_txin_n[3] ^ tx_n0;
			// end
			// 6:begin
				// tx_p4<= reg_txin_n[29] ^ tx_n4;
				// tx_p3 <= reg_txin_n[22] ^ tx_n3;
				// tx_p2 <= reg_txin_n[15] ^ tx_n2;
				// tx_p1 <= reg_txin_n[8] ^ tx_n1;
				// tx_p0 <= reg_txin_n[1] ^ tx_n0;
			// end
			// default:;
		// endcase
	// end
// end

// always@(negedge I_clk or negedge I_rst_n)begin
	// if(!I_rst_n) begin
		// tx_n4 <= 1'b0;
		// tx_n3 <= 1'b0;
		// tx_n2 <= 1'b0;
		// tx_n1 <= 1'b0;
		// tx_n0 <= 1'b0;
		// reg_txin_p <= 35'd0;
	// end
	// else begin
		// case(cnt_n)
			// 0:begin
				// tx_n4<= reg_txin_p[33] ^ tx_p4;
				// tx_n3 <= reg_txin_p[26] ^ tx_p3;
				// tx_n2 <= reg_txin_p[19] ^ tx_p2;
				// tx_n1 <= reg_txin_p[12] ^ tx_p1;
				// tx_n0 <= reg_txin_p[5] ^ tx_p0;
			// end
			// 1:begin
				// tx_n4<= reg_txin_p[31] ^ tx_p4;
				// tx_n3 <= reg_txin_p[24] ^ tx_p3;
				// tx_n2 <= reg_txin_p[17] ^ tx_p2;
				// tx_n1 <= reg_txin_p[10] ^ tx_p1;
				// tx_n0 <= reg_txin_p[3] ^ tx_p0;
			// end
			// 2:begin
				// tx_n4<= reg_txin_p[29] ^ tx_p4;
				// tx_n3 <= reg_txin_p[22] ^ tx_p3;
				// tx_n2 <= reg_txin_p[15] ^ tx_p2;
				// tx_n1 <= reg_txin_p[8] ^ tx_p1;
				// tx_n0 <= reg_txin_p[1] ^ tx_p0;
			// end
			// 3:begin
				// tx_n4<= reg_txin_n[34] ^ tx_p4;
				// tx_n3 <= reg_txin_n[27] ^ tx_p3;
				// tx_n2 <= reg_txin_n[20] ^ tx_p2;
				// tx_n1 <= reg_txin_n[13] ^ tx_p1;
				// tx_n0 <= reg_txin_n[6] ^ tx_p0;
			// end
			// 4:begin
				// tx_n4<= reg_txin_n[32] ^ tx_p4;
				// tx_n3 <= reg_txin_n[25] ^ tx_p3;
				// tx_n2 <= reg_txin_n[18] ^ tx_p2;
				// tx_n1 <= reg_txin_n[11] ^ tx_p1;
				// tx_n0 <= reg_txin_n[4] ^ tx_p0;
				// reg_txin_p <= reg_txin;
			// end
			// 5:begin
				// tx_n4<= reg_txin_n[30] ^ tx_p4;
				// tx_n3 <= reg_txin_n[23] ^ tx_p3;
				// tx_n2 <= reg_txin_n[16] ^ tx_p2;
				// tx_n1 <= reg_txin_n[9] ^ tx_p1;
				// tx_n0 <= reg_txin_n[2] ^ tx_p0;
			// end
			// 6:begin
				// tx_n4<= reg_txin_n[28] ^ tx_p4;
				// tx_n3 <= reg_txin_n[21] ^ tx_p3;
				// tx_n2 <= reg_txin_n[14] ^ tx_p2;
				// tx_n1 <= reg_txin_n[7] ^ tx_p1;
				// tx_n0 <= reg_txin_n[0] ^ tx_p0;
			// end
			// default:;
		// endcase
	// end
// end

// endmodule






//------------------------------备用---------------------------------------
//------------------------------备用---------------------------------------
//------------------------------备用---------------------------------------

module camlink_tx(
	I_clk,
	I_rst_n,
	
	tx_in,
	tx_out
);

input I_clk;
input I_rst_n;

input [34:0] tx_in;
output [4:0] tx_out;

reg [3:0] cnt;
reg [6:0] reg_data0;
reg [6:0] reg_data1;
reg [6:0] reg_data2;
reg [6:0] reg_data3;
reg [6:0] reg_clk;

always@(posedge I_clk or negedge I_rst_n)begin
	if(!I_rst_n) begin
		cnt <= 4'd0;
	end
	else begin
		if(cnt == 4'd6) cnt <= 4'd0;
		else cnt <= cnt + 1;
	end
end

always@(posedge I_clk or negedge I_rst_n)begin
	if(!I_rst_n) begin
		reg_data3 <= 7'd0;
		reg_data2 <= 7'd0;
		reg_data1 <= 7'd0;
		reg_data0 <= 7'd0;
		reg_clk <= 7'd0;
	end
	else begin
		case(cnt)
			0:begin
				reg_data3 <= tx_in[34:28];
				reg_data2 <= tx_in[27:21];
				reg_data1 <= tx_in[20:14];
				reg_data0 <= tx_in[13:7];
				reg_clk <= tx_in[6:0];
			end
			default:begin
				reg_data3 <= {reg_data3[5:0],1'b0};
				reg_data2 <= {reg_data2[5:0],1'b0};
				reg_data1 <= {reg_data1[5:0],1'b0};
				reg_data0 <= {reg_data0[5:0],1'b0};
				reg_clk <= {reg_clk[5:0],1'b0};
			end
		endcase
	end
end

assign tx_out[4] = reg_data3[6];
assign tx_out[3] = reg_data2[6];
assign tx_out[2] = reg_data1[6];
assign tx_out[1] = reg_data0[6];
assign tx_out[0] = reg_clk[6];

endmodule
