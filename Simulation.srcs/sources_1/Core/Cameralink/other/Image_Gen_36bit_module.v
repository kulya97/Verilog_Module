`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 09:07:09
// Design Name: 
// Module Name: Image_Gen_36bit_module
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
//  u_Image_Gen_36bit_module (
//     .I_Data_Clk                     ( I_Data_Clk                      ),
//     .rst_n                   ( rst_n                    ),
//     .I_CMD              ( I_CMD        [31:0] ),
//     .I_CMD_Valid        ( I_CMD_Valid         ),

//     .O_Data_R                ( O_Data_R          [11:0] ),
//     .O_Data_G                ( O_Data_G          [11:0] ),
//     .O_Data_B                ( O_Data_B          [11:0] )
// );

module Image_Gen_36bit_module (
    input             I_Data_Clk,
    input             rst_n,
    /**********************/
    output reg [15:0] O_Data_R,
    output reg [15:0] O_Data_G,
    output reg [15:0] O_Data_B,
    /**********************/
    input      [31:0] I_CMD,
    input             I_CMD_Valid
);
  parameter Module_Addr = 8'HF1;
  parameter R_Addr = 8'h00;
  parameter G_Addr = 8'h01;
  parameter B_Addr = 8'h02;
  /************/

  wire W_cmd_valid;
  assign W_cmd_valid = I_CMD_Valid && I_CMD[31:24] == Module_Addr;

  always @(posedge I_Data_Clk, negedge rst_n) begin
    if (!rst_n) begin
      O_Data_R <= 16'd0;
      O_Data_G <= 16'd0;
      O_Data_B <= 16'd0;
    end else if (W_cmd_valid && I_CMD[23:16] == R_Addr) O_Data_R <= I_CMD[15:0];
    else if (W_cmd_valid && I_CMD[23:16] == G_Addr) O_Data_G <= I_CMD[15:0];
    else if (W_cmd_valid && I_CMD[23:16] == B_Addr) O_Data_B <= I_CMD[15:0];
    else begin
      O_Data_R <= O_Data_R;
      O_Data_G <= O_Data_G;
      O_Data_B <= O_Data_B;
    end
  end
endmodule
