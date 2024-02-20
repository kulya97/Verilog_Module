`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/19 16:21:55
// Design Name: 
// Module Name: grab_edge_module
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
// grab_edge_module  u_grab_edge_module (
//     .clk                     ( clk            ),
//     .sign                    ( sign           ),

//     .sign_pipe               ( sign_pipe      ),
//     .rising_edge             ( rising_edge    ),
//     .falling_edge            ( falling_edge   )
// );

module grab_edge_module (
    input  clk,
    input  sign,
    output sign_pipe,
    output rising_edge,
    output falling_edge
);
  reg [3:0] r_sign = 4'd0;
  always @(posedge clk) begin
    r_sign <= {r_sign[2:0], sign};
  end
  assign sign_pipe    = r_sign[3];
  assign rising_edge  = !r_sign[3] & r_sign[2];
  assign falling_edge = r_sign[3] & !r_sign[2];
endmodule
