`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 14:56:57
// Design Name: 
// Module Name: CAM_Cfg
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


module Config_drv #(
    parameter MAP_LEN   = 32,
    parameter MAP_WITDH = 96
) (
    input                  I_clk,
    input                  I_rstn,
    //map port
    output [          7:0] O_map_index,
    input  [MAP_WITDH-1:0] I_map_data,
    //out port
    input                  I_ready,
    output                 O_valid,
    output [MAP_WITDH-1:0] O_data,
    //
    output                 O_init_done
);

  /******************************************************/
  reg [7:0] R_index;

  /******************************************************/
  assign O_valid          = ((R_index < MAP_LEN) && I_rstn) ? 1'b1 : 1'b0;
  assign O_init_done      = !O_valid;
  assign O_map_index[7:0] = R_index[7:0];
  assign O_data           = I_map_data;
  /******************************************************/
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) R_index <= 'd0;
    else if (I_ready && O_valid) R_index <= R_index + 1'd1;
    else R_index <= R_index;
  end
endmodule
