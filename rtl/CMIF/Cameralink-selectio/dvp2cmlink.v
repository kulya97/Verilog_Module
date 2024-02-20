`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
// 
// Create Date: 2024/01/30 17:07:32
// Design Name: 
// Module Name: dvp2cmlink
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


module dvp2cmlink (
    input             i_clk,
    input             i_rstn,
    input             i_fvld,
    input             i_lvld,
    input             i_dvld,
    input      [ 7:0] i_porta,
    input      [ 7:0] i_portb,
    input      [ 7:0] i_portc,
    output reg [27:0] o_cm_data
);
  //-------------------------------------------------------
  //--  clk     —————————————_____________________————————————
  //--  txout0 | tx7  | tx6  | tx4  | tx3  | tx2  | tx1  | tx0
  //--  txout1 | tx18 | tx15 | tx14 | tx13 | tx12 | tx9  | tx8
  //--  txout2 | tx26 | tx25 | tx24 | tx22 | tx21 | tx20 | tx19
  //--  txout3 | tx23 | tx17 | tx16 | tx11 | tx10 | tx5  | tx27
  //-------------------------------------------------------
  //--  clk    ————————————————————______________________________—————————————————
  //--  txout0 | portB0 | portA5  | portA4  | portA3  | portA2  | portA1  | portA0
  //--  txout1 | portC1 | portC0  | portB5  | portB4  | portB3  | portB2  | portB1
  //--  txout2 | dval   | fval    | lval    | portC5  | portC4  | portC3  | portC2
  //--  txout3 | spare  | portC7  | portC6  | portB7  | portB6  | portA7  | portA6
  //-------------------------------------------------------
  //-- tx0  = portA0  ||  tx7  = portB0  || tx15  =  portC0
  //-- tx1  = portA1  ||  tx8  = portB1  || tx18  =  portC1
  //-- tx2  = portA2  ||  tx9  = portB2  || tx19  =  portC2
  //-- tx3  = portA3  ||  tx12 = portB3  || tx20  =  portC3
  //-- tx4  = portA4  ||  tx13 = portB4  || tx21  =  portC4
  //-- tx6  = portA5  ||  tx14 = portB5  || tx22  =  portC5
  //-- tx27 = portA6  ||  tx10 = portB6  || tx16  =  portC6
  //-- tx5  = portA7  ||  tx11 = portB7  || tx17  =  portC7
  //-- tx24 = lval    ||  tx25 = fval    || tx26  =  dval    
  //-- tx23= spare   
  //-------------------------------------------------------

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) o_cm_data[27:0] <= 28'd0;
    else
      o_cm_data[27:0] <= {
        i_portb[0],
        i_portc[1],
        i_dvld,
        1'b0,
        i_porta[5],
        i_portc[0],
        i_fvld,
        i_portc[7],
        i_porta[4],
        i_portb[5],
        i_lvld,
        i_portc[6],
        i_porta[3],
        i_portb[4],
        i_portc[5],
        i_portb[7],
        i_porta[2],
        i_portb[3],
        i_portc[4],
        i_portb[6],
        i_porta[1],
        i_portb[2],
        i_portc[3],
        i_porta[7],
        i_porta[0],
        i_portb[1],
        i_portc[2],
        i_porta[6]
      };
  end

endmodule
