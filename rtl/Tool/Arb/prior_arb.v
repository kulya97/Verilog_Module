`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/19 09:08:01
// Design Name: 数据仲裁器
// Module Name: prior_arb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 一个数和它的补码相与，得到的结果是一个独热码，独热码为1的那一位是这个数最低的1。
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module prior_arb #(

    parameter REQ_WIDTH = 16

) (
    input  [REQ_WIDTH-1:0] req,
    output [REQ_WIDTH-1:0] gnt

);

  assign gnt = req & (~(req - 1));

endmodule
