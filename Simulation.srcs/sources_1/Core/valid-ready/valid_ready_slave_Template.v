`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 16:53:13
// Design Name: 
// Module Name: valid_ready_slave_Template
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


module valid_ready_slave_Template (
    input            clk,
    input            rst_n,
    input            I_valid,
    output reg       O_ready,
    input      [7:0] O_din
);

  /**********************************************/
  //接收完一次就停止接收进行处理，等待下一个state状态到来再次接收
  wire state1;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) O_ready <= 1'b0;
    else if (!O_ready && state1) O_ready <= 1'b1;
    else O_ready <= 1'b0;
  end
  /**********************************************/

  /**********************************************/
  //突发接收
  wire state2;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) O_ready <= 1'b0;
    else if (!O_ready && state2) O_ready <= 1'b1;
    else O_ready <= 1'b0;
  end
  /**********************************************/

endmodule
