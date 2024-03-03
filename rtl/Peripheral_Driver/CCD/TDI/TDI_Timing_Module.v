`timescale 1ns / 1ps

module TDI_Timing_Module#
(
    parameter FREQ_MHz          =10             ,
    parameter LINE_N          =1,
    parameter PIXEL_N         =1060
)
(
input CLK_SYS           ,//系统时钟
input RST_N             ,
output G1               ,
output ICG1              ,
output ICG2              ,
output V1               ,
output V2T               ,
output V2B               ,
output V3               ,
output V4T               ,
output V4B               ,
output H1               ,
output H2L               ,
output H2R               ,
output H3               ,
output H4L               ,
output H4R               ,
output SG               ,
output FR               ,
output reg pixel_clk    ,

output CL_LVAL          ,
output CL_FVAL          ,
output CL_DVAL          ,

input [31:0]UART_IN     ,
input uart_ready
);
/**************************************************************************************/
localparam TIME_N             =FREQ_MHz;//1us
/**************************************************************************************/
reg  H1_R;
reg  H2_R;
reg  H3_R;
reg  H4_R;

reg  SG_R;
reg  FR_R;
//产生水平转移时钟寄存器（持续产生）
reg [4:0] clk_cnt;
reg [15:0] pixel_clk_r0;

reg [15:0] H1_R0;//6
reg [15:0] H2_R0;
reg [15:0] H3_R0;
reg [15:0] H4_R0;

reg [15:0] SG_R0;//4
reg [15:0] FR_R0;
/****************************************************/
/****************************************************/
// reg [15:0]LINE_N          ;
// reg [15:0]PIXEL_N         ;  

// always @(posedge CLK_SYS or negedge RST_N ) begin
//     if(!RST_N) begin
//         LINE_N <= 16'd10;
//         PIXEL_N <= 16'd1060;
//     end
//     else if(uart_ready && (UART_IN[31:16] == 16'hff00))
//         LINE_N <= UART_IN[15:0];
//     else if(uart_ready && (UART_IN[31:16] == 16'hff01))
//         PIXEL_N <= UART_IN[15:0];
// end
//水平时钟相位调节
always @(posedge CLK_SYS or negedge RST_N ) begin
    if(!RST_N) begin
        H1_R0 <= 16'hF00F;
        H2_R0 <= 16'hFF00;
        H3_R0 <= 16'h0FF0;
        H4_R0 <= 16'h00FF;
        SG_R0 <= 16'h00FF;
        FR_R0 <= 16'h00f0;
        pixel_clk_r0 <= 16'hFf00;
    end
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A1))
        H1_R0 <= UART_IN[15:0];
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A2))
        H2_R0 <= UART_IN[15:0];
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A3))
        H3_R0 <= UART_IN[15:0];
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A4))
        H4_R0 <= UART_IN[15:0];
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A5))
        SG_R0 <= UART_IN[15:0];
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A6))
        FR_R0 <= UART_IN[15:0];
    else if(uart_ready && (UART_IN[31:16] == 16'hB1A7))
        pixel_clk_r0 <= UART_IN[15:0];
end
/****************************************************/
always @ (posedge CLK_SYS or negedge RST_N) begin
	if (!RST_N) begin
		clk_cnt     <= 5'd0;
		pixel_clk   <= 1'b0;
        H1_R        <= 1'b0;
        H2_R        <= 1'b0;
        H3_R        <= 1'b0;
        H4_R        <= 1'b0;
        SG_R        <= 1'b0;
        FR_R        <= 1'b0;
	end
	else begin
		clk_cnt     <= clk_cnt + 1'b1;
		pixel_clk   <= pixel_clk_r0[15-clk_cnt];
		H1_R        <= H1_R0[15-clk_cnt];
		H2_R        <= H2_R0[15-clk_cnt];
		H3_R        <= H3_R0[15-clk_cnt];
		H4_R        <= H4_R0[15-clk_cnt];
        SG_R        <= SG_R0[15-clk_cnt];
		FR_R        <= FR_R0[15-clk_cnt];
        if(clk_cnt>=4'd15)
        clk_cnt<=4'd0;
	end
end
/**************************************************************************************/
reg [24:0] Integration_T;
//积分时间调节
always @(posedge CLK_SYS or negedge RST_N ) begin
    if(!RST_N)
        Integration_T  <= 32'd5;
    else if(uart_ready && (UART_IN[31:24] == 16'hB3))
    begin
		Integration_T <= UART_IN[23:0];
    end
    else begin
        Integration_T  <= Integration_T;
    end

end
/**************************************************************************************/
reg [3:0] state;
reg [3:0] state_next;

localparam  IDLE= 0;
localparam  INTEGRATION= 1;
localparam  TRANSFER= 2;
localparam  READ= 3;
localparam  WAIT= 4;
/****************************************************/
reg line_valid  ; //行有效
reg frame_valid ; //帧有效
reg data_valid  ; //数据有效

reg G1_Reg;
reg ICG1_Reg;
reg ICG2_Reg;
reg V1_Reg;
reg V2B_Reg;
reg V2T_Reg;
reg V3_Reg;
reg V4B_Reg;
reg V4T_Reg;

reg [31:0] pixel_clk_cnt;
reg [31:0] pixel_cnt;
reg [31:0] line_cnt;

reg [31:0] ICG1_Regs;//4
reg [31:0] ICG2_Regs;//4
reg [31:0] G1_Regs;
reg [31:0] V1_Regs;//6
reg [31:0] V2T_Regs;
reg [31:0] V2B_Regs;
reg [31:0] V3_Regs;
reg [31:0] V4T_Regs;
reg [31:0] V4B_Regs;

/**************************************************************************************/
//水平时钟相位调节
always @(posedge CLK_SYS or negedge RST_N ) begin
    if(!RST_N) begin
        ICG1_Regs   <= 32'h0FFF_F800;
        ICG2_Regs   <= 32'h0FFF_F800;
        G1_Regs     <= 32'h0000_0000;
        V1_Regs     <= 32'h0FFF_F000;
        V2T_Regs    <= 32'h000F_FFFF;
        V2B_Regs    <= 32'h000F_FFFF;
        V3_Regs     <= 32'hFF00_00FF;
        V4T_Regs    <= 32'hFFFF_000F;
        V4B_Regs    <= 32'hFFFF_000F;
    end
    else if(uart_ready && (UART_IN[31:16] == 16'hB2A1))
        ICG1_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2A2))
        G1_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2A3))
        V1_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2A4))
        V2T_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2A5))
        V3_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2A6))
        V4T_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
/*************************************************************************************************************************************************************************/
    else if(uart_ready && (UART_IN[31:16] == 16'hB2B1))
        ICG2_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2B2))
        G1_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2B3))
        V1_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2B4))
        V2B_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2B5))
        V3_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};
    else if(uart_ready && (UART_IN[31:16] == 16'hB2B6))
        V4B_Regs <= {UART_IN[15],UART_IN[15],UART_IN[14],UART_IN[14],UART_IN[13],UART_IN[13],UART_IN[12],UART_IN[12],UART_IN[11],UART_IN[11],UART_IN[10],UART_IN[10],
        UART_IN[9],UART_IN[9],UART_IN[8],UART_IN[8],UART_IN[7],UART_IN[7],UART_IN[6],UART_IN[6],
        UART_IN[5],UART_IN[5],UART_IN[4],UART_IN[4],UART_IN[3],UART_IN[3],UART_IN[2],UART_IN[2],UART_IN[1],UART_IN[1],UART_IN[0],UART_IN[0]};

end

/****************************************************/
always @(posedge pixel_clk or negedge RST_N) begin
    if(!RST_N) begin
        state   <=  IDLE;
        pixel_clk_cnt   <= 32'd0;
        ICG1_Reg <= 1'b0;
        ICG2_Reg <= 1'b0;
        G1_Reg  <= 1'b0;
        V1_Reg  <= 1'b0;
        V2T_Reg  <= 1'b0;
        V2B_Reg  <= 1'b0;
        V3_Reg  <= 1'b0;
        V4T_Reg  <= 1'b0;
        V4B_Reg  <= 1'b0;
        
        pixel_cnt     <= 12'd0;
        line_cnt     <= 12'd0;
        
        line_valid <= 1'b0;
        data_valid     <= 1'd0;
        frame_valid <= 1'b0;

    end
    else begin
        case (state)
        IDLE        :begin
            pixel_clk_cnt   <= 32'd0;
            pixel_cnt   <= 32'd0;
            line_cnt    <= 32'd0;
            line_valid  <= 1'b0;	
            data_valid  <= 1'd0;
            frame_valid <= 1'b0;
            state<=INTEGRATION;
        end
        INTEGRATION :begin
            pixel_clk_cnt   <= pixel_clk_cnt + 1'b1;
            line_valid      <= 1'b0;
            data_valid      <= 1'd0;
            frame_valid     <= 1'b1;
            pixel_cnt       <= 12'd0;
            line_cnt        <= 12'd0;
            if(pixel_clk_cnt<=31) begin
                ICG1_Reg <= 1'b1;
                ICG2_Reg <= 1'b1;
                G1_Reg <= 1'b1;
                V1_Reg <= 1'b0;
                V2T_Reg <= 1'b0;
                V2B_Reg <= 1'b0;
                V3_Reg <= 1'b1;
                V4T_Reg <= 1'b1;
                V4B_Reg <= 1'b1;
                state<=INTEGRATION;
            end
            else if(pixel_clk_cnt>31&&(pixel_clk_cnt<=Integration_T)) begin
                ICG1_Reg <= 1'b0;
                ICG2_Reg <= 1'b0;
                G1_Reg <= 1'b0;
                V1_Reg <= 1'b0;
                V2T_Reg <= 1'b0;
                V2B_Reg <= 1'b0;
                V3_Reg <= 1'b1;
                V4T_Reg <= 1'b1;
                V4B_Reg <= 1'b1;
                state<=INTEGRATION;
            end
            else if(pixel_clk_cnt>=Integration_T) begin
                ICG1_Reg <= 1'b0;
                ICG2_Reg <= 1'b0;
                G1_Reg <= 1'b0;
                V1_Reg <= 1'b0;
                V2T_Reg <= 1'b0;
                V2B_Reg <= 1'b0;
                V3_Reg <= 1'b1;
                V4T_Reg <= 1'b1;
                V4B_Reg <= 1'b1;
                pixel_clk_cnt<=32'd0;
                state<=TRANSFER;
            end
        end
        
        TRANSFER    :begin
            pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
            line_valid      <= 1'b0     ;
        	data_valid      <= 1'd0     ;
        	frame_valid     <= 1'b1     ;
        	pixel_cnt       <= 12'd0    ;
            ICG1_Reg           <= ICG1_Regs   [31-pixel_clk_cnt];
            ICG2_Reg           <= ICG2_Regs   [31-pixel_clk_cnt];
            G1_Reg           <= G1_Regs    [31-pixel_clk_cnt];
            V1_Reg           <= V1_Regs    [31-pixel_clk_cnt];
            V2T_Reg           <= V2T_Regs    [31-pixel_clk_cnt];
            V2B_Reg           <= V2B_Regs    [31-pixel_clk_cnt];
            V3_Reg           <= V3_Regs    [31-pixel_clk_cnt];
            V4T_Reg           <= V4T_Regs    [31-pixel_clk_cnt];
            V4B_Reg           <= V4B_Regs    [31-pixel_clk_cnt];
            if(pixel_clk_cnt>=32'd31)begin
                pixel_clk_cnt<=32'd0;
                state<=READ;
            end
            else begin
                state<=TRANSFER;
            end
        end

        READ        :begin
            ICG1_Reg           <= 1'b0;
            ICG2_Reg           <= 1'b0;
            G1_Reg           <= 1'b0;
            V1_Reg           <= 1'b0;
            V2T_Reg           <= 1'b0;
            V2B_Reg           <= 1'b0;
            V3_Reg           <= 1'B1;
            V4T_Reg           <= 1'b1;
            V4B_Reg           <= 1'b1;
            
            frame_valid     <= 1'b1;	
            line_valid      <= 1'b1;
            data_valid      <= 1'd1;	
			pixel_clk_cnt   <=32'd0;
            pixel_cnt       <= pixel_cnt + 1'b1;
		    if(pixel_cnt>=PIXEL_N-1)begin
		        state     <= WAIT;
                pixel_cnt <= 12'd0    ;
		        line_cnt  <= line_cnt + 1'b1;
		    end
		    else
		        state<=READ;
        end
        WAIT        :begin
            ICG1_Reg <= 1'b0;
            ICG2_Reg <= 1'b0;
            G1_Reg <= 1'b0;
            V1_Reg <= 1'b0;
            V2T_Reg <= 1'b0;
            V2B_Reg <= 1'b0;
            V3_Reg <= 1'b1;
            V4T_Reg <= 1'b1;
            V4B_Reg <= 1'b1;
            line_valid <= 1'b0;	
        	data_valid<= 1'd0;
        	frame_valid <= 1'b1;
            pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
            if(pixel_clk_cnt>=Integration_T)begin
           	    pixel_clk_cnt<=32'd0;
                state<=TRANSFER;
              end
            else
                state<=WAIT;
        end
        default     :begin
            ICG1_Reg <= 1'b0;
            ICG2_Reg <= 1'b0;
            G1_Reg <= 1'b0;
            V1_Reg <= 1'b0;
            V2T_Reg <= 1'b0;
            V2B_Reg <= 1'b0;
            V3_Reg <= 1'b0;
            V4T_Reg <= 1'b0;
            V4B_Reg <= 1'b0;
            frame_valid     <= 1'b0;
            line_valid      <= 1'b0;	
            data_valid      <= 1'd0;
            state = IDLE;
        end
        endcase
    end
end

assign G1       =   G1_Reg                          ;
assign ICG1     =   ICG1_Reg                          ;
assign ICG2     =   ICG2_Reg                          ;
assign V1       =   V1_Reg                          ;
assign V2T      =   V2T_Reg                          ;
assign V2B      =   V2B_Reg                          ;
assign V3       =   V3_Reg                          ;
assign V4T      =   V4T_Reg                          ;
assign V4B      =   V4B_Reg                          ;

assign H1       =   ((state==READ)?H1_R:((state==TRANSFER||state==WAIT)?1:0));
assign H3       =   ((state==READ)?H3_R:0)          ;

assign H2L      =   ((state==READ)?H2_R:0)          ;
assign H4L      =   ((state==READ)?H4_R:0)          ;
assign H2R      =   ((state==READ)?H2_R:0)          ;
assign H4R      =   ((state==READ)?H4_R:0)          ;

assign SG   =SG_R          ;
assign FR  =FR_R           ;
/****************************************************/
assign CL_FVAL = frame_valid;//帧有效
assign CL_LVAL = line_valid;//行有效
assign CL_DVAL = data_valid;//数据有效
endmodule