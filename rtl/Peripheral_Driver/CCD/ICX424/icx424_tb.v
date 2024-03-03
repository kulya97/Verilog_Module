`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/17 15:30:30
// Design Name: 
// Module Name: icx424_tb
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

module icx424_tb;

  reg         sys_clk;
  reg         rst_n;
  reg         sys_en;
  wire        V1;
  wire        V2;
  wire        V3;
  wire        V_TR;
  wire        FSUB;
  wire        HF1;
  wire        HF2;
  wire        FRG;
  wire        pixel_clk;
  wire        frame_valid;
  wire        line_valid;
  wire        data_valid;
  wire [11:0] line_cnt;
  wire [11:0] pixel_cnt;
  always #1 sys_clk = !sys_clk;
  initial begin
    sys_clk = 0;
    rst_n   = 0;
    sys_en  = 1;
    #20 rst_n = 1;
  end
  ICX424_Timing ICX424_Timing0 (
      .sys_clk    (sys_clk    ),
      .rst_n      (rst_n      ),
      .sys_en     (sys_en     ),
      .V1         (V1         ),
      .V2         (V2         ),
      .V3         (V3         ),
      .V_TR       (V_TR       ),
      .FSUB       (FSUB       ),
      .HF1        (HF1        ),
      .HF2        (HF2        ),
      .FRG        (FRG        ),
      .pixel_clk  (pixel_clk  ),
      .frame_valid(frame_valid),
      .line_valid (line_valid ),
      .data_valid (data_valid ),
      .line_cnt   (line_cnt   ),
      .pixel_cnt  (pixel_cnt  )
  );
endmodule