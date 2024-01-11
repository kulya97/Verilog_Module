`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 14:54:35
// Design Name: 
// Module Name: cameralink_lvds_tx
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
module cameralink_lvds_tx(
	//input interface
	input							I_clk_pix,				//时钟输入
	input							I_clk_lvds,				//cameralink传输时钟	7 x I_clk_pix
	input							I_rst_n,				//复位信号
	input			[34:0]			I_data,					//cameralink信号
	//output interface
	output 			[4:0]			O_lvds_P,				//cameralink差分输出
	output 			[4:0]			O_lvds_N				//cameralink差分输出
);

//========================================================================================\
//**************    parameter	申明	**********************************
//========================================================================================/
parameter							DB_W 	= 5;			// data bus width
//========================================================================================\
//**************    wire	申明	**********************************
//========================================================================================/
wire			[DB_W-1  :0]		s_OSERDES_DAT;			// tx io data
//wire								CLK;					//高速时钟259.875mhz
//wire								CLK_DIV;				//像素时钟37.125mhz
//wire			[DB_W*7-1:0]		TX_DATA;				//
//========================================================================================\
//**************    REG		申明	**********************************
//========================================================================================/

//========================================================================================\
//**************    aasign	申明	**********************************
//========================================================================================/
//assign 				I_clk_pix		=		CLK_DIV;		//
//assign 				I_clk_lvds		=		CLK;			//
//assign 				I_data			=		TX_DATA;		//
//========================================================================================\
//**************    模块调用	**********************************
//========================================================================================/

camlink_tx camlink_tx_inst(
	.I_clk(I_clk_lvds),
	.I_rst_n(I_rst_n),
	
	.tx_in(I_data),
	.tx_out(s_OSERDES_DAT)
);

genvar i;
generate
	for (i=0; i<DB_W; i=i+1) begin: data_txout
	   // OSERDESE3 #(
		  // .DATA_WIDTH(7),                								 // Parallel Data Width (4-8)
		  // .INIT(1'b0),                   								 // Initialization value of the OSERDES flip-flops
		  // .IS_CLKDIV_INVERTED(1'b0),     								 // Optional inversion for CLKDIV
		  // .IS_CLK_INVERTED(1'b0),        								 // Optional inversion for CLK
		  // .IS_RST_INVERTED(1'b0),        								 // Optional inversion for RST
		  // .SIM_DEVICE("ULTRASCALE_PLUS") 								 // Set the device version for simulation functionality (ULTRASCALE,
			//															 ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
	   // )
	   // OSERDESE3_inst (
		  // .OQ				(s_OSERDES_DAT[i] 				),      	// 1-bit output: Serial Output Data
		  // .T_OUT			(								),   		// 1-bit output: 3-state control output to IOB
		  // .CLK				(CLK							),       	// 1-bit input: High-speed clock
		  // .CLKDIV			(CLK_DIV						), 		// 1-bit input: Divided Clock
		  // .D				(TX_DATA[i*7+6:i*7+0]			),           	// 8-bit input: Parallel Data Input
		  // .RST				(~I_rst_n						),       	// 1-bit input: Asynchronous Reset
		  // .T				(								)            	// 1-bit input: Tristate input from fabric
	   // );
		OBUFDS #(
			.SLEW			( "FAST"						)   // Specify the output slew rate
		)
		U_OBUFDS_TLA0 (
			.O				( O_lvds_P[i]			),	// Diff_p output (connect directly to top-level port)
			.OB				( O_lvds_N[i]			),	// Diff_n output (connect directly to top-level port)
			.I				( s_OSERDES_DAT[i]		) 	// Buffer input
		);

	end
endgenerate
//========================================================================================\
//**************    逻辑设计	**********************************
//========================================================================================/

endmodule

