`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/30 23:18:11
// Design Name: 
// Module Name: cmlink2dcp
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


module cmlink2dcp (
    input             i_clk,
    input             i_rstn,
    input      [27:0] i_cm_data,
    output reg        o_fvld,
    output reg        o_lvld,
    output reg        o_dvld,
    output reg [ 7:0] o_porta,
    output reg [ 7:0] o_portb,
    output reg [ 7:0] o_portc

);

  reg [27:0] r_cm_data_d;
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
    if (!i_rstn) r_cm_data_d <= 28'd0;
    else r_cm_data_d <= i_cm_data;
  end
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      o_fvld  <= 1'b0;
      o_lvld  <= 1'b0;
      o_dvld  <= 1'b0;
      o_porta <= 8'b0;
      o_portb <= 8'b0;
      o_portc <= 8'b0;
    end else begin
      o_fvld  <= i_cm_data[21];
      o_lvld  <= i_cm_data[17];
      o_dvld  <= i_cm_data[25];
      o_porta <= {i_cm_data[4], i_cm_data[0], i_cm_data[23], i_cm_data[19], i_cm_data[15], i_cm_data[11], i_cm_data[7], i_cm_data[3]};
      o_portb <= {i_cm_data[12], i_cm_data[8], i_cm_data[18], i_cm_data[14], i_cm_data[10], i_cm_data[6], i_cm_data[2], i_cm_data[27]};
      o_portc <= {i_cm_data[20], i_cm_data[16], i_cm_data[13], i_cm_data[9], i_cm_data[5], i_cm_data[1], i_cm_data[26], i_cm_data[22]};
    end
  end

  // always @(posedge i_clk, negedge i_rstn) begin
  //   if (!i_rstn) begin
  //     o_fvld  <= 1'b0;
  //     o_lvld  <= 1'b0;
  //     o_dvld  <= 1'b0;
  //     o_porta <= 8'b0;
  //     o_portb <= 8'b0;
  //     o_portc <= 8'b0;
  //   end else begin
  //     o_fvld  <= i_cm_data[21];
  //     o_lvld  <= r_cm_data_d[17];
  //     o_dvld  <= i_cm_data[25];
  //     o_porta <= {r_cm_data_d[4], r_cm_data_d[0], i_cm_data[23], r_cm_data_d[19], r_cm_data_d[15], r_cm_data_d[11], r_cm_data_d[7], r_cm_data_d[3]};
  //     o_portb <= {r_cm_data_d[12], r_cm_data_d[8], r_cm_data_d[18], r_cm_data_d[14], r_cm_data_d[10], r_cm_data_d[6], r_cm_data_d[2], i_cm_data[27]};
  //     o_portc <= {i_cm_data[20], r_cm_data_d[16], r_cm_data_d[13], r_cm_data_d[9], r_cm_data_d[5], r_cm_data_d[1], i_cm_data[26], i_cm_data[22]};
  //   end
  // end
  //-- portA7   4| portA6  0| portA5  23| portA4  19| portA3  15| portA2  11| portA1  7| portA0 3
  //-- portB7  12| portB6  8| portB5  18| portB4  14| portB3  10| portB2   6| portB1  2| portB0 27
  //-- portC7  20| portC6 16| portC5  13| portC4   9| portC3   5| portC2   1| portC1 26| portC0  22
  //-- dval   25| lval    17| fval    21|

endmodule
