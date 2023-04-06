`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/05 16:02:47
// Design Name: 
// Module Name: ICX424_Timing
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


module ICX424_Timing (
    input             sys_clk,
    input             rst_n,
    input             sys_en,
    output            V1,
    output            V2,
    output            V3,
    output            V_TR,
    output            FSUB,
    output            HF1,
    output            HF2,
    output            FRG,
    output reg        pixel_clk,
    output reg        frame_valid,
    output reg        line_valid,
    output reg        data_valid,
    output reg [11:0] line_cnt,
    output reg [11:0] pixel_cnt
);
  /*******************************************/
  parameter LINE_N = 560;
  parameter PIXEL_N = 560;
  /*******************************************/
  reg [15:0] HF1_Rs, HF2_Rs, FRG_Rs, pixel_clk_Rs;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      HF1_Rs       <= 16'b1111_1111_0000_0000;
      HF2_Rs       <= 16'b1111_1111_0000_0000;
      FRG_Rs       <= 16'b1111_1111_0000_0000;
      pixel_clk_Rs <= 16'b1111_1111_0000_0000;
    end else begin
    end
  end

  reg [3:0] pixel_clk_cnt;
  reg HF1_R, HF2_R, FRG_R;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      pixel_clk_cnt <= 4'd0;
      HF1_R         <= 1'd0;
      HF2_R         <= 1'd0;
      FRG_R         <= 1'd0;
      pixel_clk     <= 1'd0;
    end else begin
      pixel_clk_cnt <= pixel_clk_cnt + 1'd1;
      HF1_R         <= HF1_Rs[15-pixel_clk_cnt];
      HF2_R         <= HF2_Rs[15-pixel_clk_cnt];
      FRG_R         <= pixel_clk_Rs[15-pixel_clk_cnt];
      pixel_clk     <= pixel_clk_Rs[15-pixel_clk_cnt];
      if (pixel_clk_cnt == 4'd15) pixel_clk_cnt <= 4'd0;
    end
  end
  /*******************************************/
  reg [4:0] S_STATE_CURRENT;
  reg [4:0] S_STATE_NEXT;
  localparam S_IDLE = 0;
  localparam S_INTERGTAL = 1;
  localparam S_VS = 2;
  localparam S_HS = 3;
  localparam S_READ = 4;
  localparam S_WAIT0 = 5;
  localparam S_WAIT1 = 6;

  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) S_STATE_CURRENT <= S_IDLE;
    else S_STATE_CURRENT <= S_STATE_NEXT;
  end
  reg [15:0] state_clk_cnt;
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 16'd0;
    else if (S_STATE_NEXT != S_STATE_CURRENT) state_clk_cnt <= 16'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  always @(*) begin
    case (S_STATE_CURRENT)
      S_IDLE: begin
        if (sys_en) S_STATE_NEXT = S_VS;
        else S_STATE_NEXT = S_IDLE;
      end
      S_VS: begin
        if (state_clk_cnt == 632) S_STATE_NEXT = S_READ;
        else S_STATE_NEXT = S_VS;
      end
      S_HS: begin
        if (state_clk_cnt == 71) S_STATE_NEXT = S_READ;
        else S_STATE_NEXT = S_HS;
      end
      S_READ: begin
        if (state_clk_cnt == 707) S_STATE_NEXT = S_WAIT0;
        else S_STATE_NEXT = S_READ;
      end
      S_WAIT0: begin
        if (line_cnt == 525) S_STATE_NEXT = S_IDLE;
        else S_STATE_NEXT = S_HS;
      end
      default: S_STATE_NEXT = S_IDLE;
    endcase
  end
  /******************************************************/
  reg V2_R, V3_R, V1_R, SUB_R, V_TR_R;
  reg [71:0] V1_Rs, V2_Rs, V3_Rs, SUB_Rs;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      V1_Rs  <= 72'b111111111111_111111111111_111111111111_000000000000_000000000000_000000000000;
      V2_Rs  <= 72'b111111111111_000000000000_000000000000_000000000000_111111111111_111111111111;
      V3_Rs  <= 72'b000000000000_000000000000_111111111111_111111111111_111111111111_000000000000;
      SUB_Rs <= 72'b000000000000_000000000000_000000000000_011111111111_111111111111_000000000000;
    end
  end
  /**************************转移状态****************************/
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) begin
      V1_R      <= 1'd0;
      V2_R      <= 1'd0;
      V3_R      <= 1'd0;
      SUB_R     <= 1'd0;
      V_TR_R    <= 1'd0;
      line_cnt  <= 1'd0;
      pixel_cnt <= 1'd0;
    end else
      case (S_STATE_CURRENT)
        S_IDLE: begin
          V1_R      <= 1'd0;
          V2_R      <= 1'd1;
          V3_R      <= 1'd1;
          SUB_R     <= 1'd0;
          V_TR_R    <= 1'd0;
          line_cnt  <= 1'd0;
          pixel_cnt <= 1'd0;
        end
        S_VS: begin
          case (state_clk_cnt)
            0: begin
              V1_R   <= 1'd0;
              V2_R   <= 1'd1;
              V3_R   <= 1'd1;
              SUB_R  <= 1'd0;
              V_TR_R <= 1'd0;
            end
            520: begin
              V_TR_R <= 1'd1;
            end
            582: begin
              V_TR_R <= 1'd0;
            end
            632: begin
              V3_R <= 1'd0;
            end
            default begin
              V1_R   <= V1_R;
              V2_R   <= V2_R;
              V3_R   <= V3_R;
              SUB_R  <= SUB_R;
              V_TR_R <= V_TR_R;
            end
          endcase
        end
        S_HS: begin
          V1_R   <= V1_Rs[71-state_clk_cnt];
          V2_R   <= V2_Rs[71-state_clk_cnt];
          V3_R   <= V3_Rs[71-state_clk_cnt];
          SUB_R  <= SUB_Rs[71-state_clk_cnt];
          V_TR_R <= 1'd0;
        end
        S_READ: begin
          V1_R      <= 1'd0;
          V2_R      <= 1'd1;
          V3_R      <= 1'd0;
          SUB_R     <= 1'd0;
          V_TR_R    <= 1'd0;
          pixel_cnt <= pixel_cnt + 1'd1;
        end
        S_WAIT0: begin
          line_cnt <= line_cnt + 1'd1;
        end
        default: begin
          V1_R   <= 1'd0;
          V2_R   <= 1'd0;
          V3_R   <= 1'd0;
          SUB_R  <= 1'd0;
          V_TR_R <= 1'd0;
        end
      endcase
  end
  /******************************************************/
  assign V1   = V1_R;
  assign V2   = V2_R;
  assign V3   = V3_R;
  assign V_TR = V_TR_R;
  assign FSUB = SUB_R;
  assign HF1  = HF1_R;
  assign HF2  = HF2_R;
  assign FRG  = FRG_R;
  /******************************************************/
  /**************************有效位****************************/
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) frame_valid <= 1'b0;
    else if (S_STATE_CURRENT == S_IDLE && S_STATE_CURRENT == S_INTERGTAL) frame_valid <= 1'b0;
    else frame_valid <= 1'b1;
  end
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) line_valid <= 1'b0;
    else if (S_STATE_CURRENT == S_READ) line_valid <= 1'b1;
    else line_valid <= 1'b0;
  end
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) data_valid <= 1'b0;
    else if (S_STATE_CURRENT == S_READ) data_valid <= 1'b1;
    else data_valid <= 1'b0;
  end
  /******************************************************/
endmodule
