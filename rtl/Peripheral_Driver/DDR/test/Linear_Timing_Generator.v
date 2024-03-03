`timescale 1ns / 1ps
module Linear_Timing_Generator(
input CLK_SYS           ,//系统时钟
input RST_N             ,
input   [15:0]      ui_img_h        ,
input   [15:0]      ui_img_w        ,
output CL_LVAL          ,
output CL_FVAL          ,
output CL_DVAL          ,
output reg [15:0] CL_DATA
);
reg [15:0] LINE_N;
reg [15:0] PIXEL_N;
/**********************************积分时间****************************************************/
always@(posedge CLK_SYS,negedge RST_N)begin
    if(!RST_N)begin
        LINE_N<=16'd0;
        PIXEL_N<=16'd0;
    end
    else begin
        LINE_N<=ui_img_h;
        PIXEL_N<=ui_img_w;
    end
end
/**************************************************************************************/
reg [3:0] state;
reg [3:0] state_next;
localparam  IDLE= 0;//空闲
localparam  LINE_TRANSFER = 3;//转移
localparam  WAIT1= 4;//读出前
localparam  READ= 5;//读出
localparam  WAIT2= 6;//读出后
/****************************************************/
reg line_valid  ; //行有效
reg frame_valid ; //帧有效
reg data_valid  ; //数据有效
reg [11:0] pixel_cnt;
reg [11:0] line_cnt;
reg [11:0] vertical_cnt;
reg [16:0] pixel_clk_cnt;
/**************************************************************************************/
always @(posedge CLK_SYS or negedge RST_N) begin
    if(!RST_N) begin
        state   <=  IDLE;
        pixel_clk_cnt   <= 32'd0;
        
        pixel_cnt       <= 12'd0;
        line_cnt        <= 12'd0;
        vertical_cnt    <= 12'd0;

        line_valid      <= 1'b0;
        data_valid      <= 1'd0;
        frame_valid     <= 1'b0;

    end
    else begin
        case (state)
        IDLE        :begin
            pixel_clk_cnt   <= 32'd0;
            pixel_cnt   <= 12'd0;
            line_cnt    <= 12'd0;
            vertical_cnt<= 12'd0;

            line_valid  <= 1'b0;
            data_valid  <= 1'd0;
            frame_valid <= 1'b0;
            state<=WAIT1;
        end
        WAIT1       :begin
            line_valid <= 1'b0;	
        	data_valid<= 1'd0;
        	frame_valid <= 1'b1;
            pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
            
            if(pixel_clk_cnt>=32'd100)begin
           	    pixel_clk_cnt<=32'd0;
                state<=READ;
              end
            else begin
                state<=WAIT1;
            end
        end
        LINE_TRANSFER :begin
            pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
            line_valid      <= 1'b0                         ;
        	data_valid      <= 1'd0                         ;
        	frame_valid     <= 1'b1                         ;
        	pixel_cnt       <= 12'd0                        ;
            if(pixel_clk_cnt>=32'd15)begin
                pixel_clk_cnt<=32'd0;
                state<=WAIT1;
            end
            else begin
                state<=LINE_TRANSFER;
            end
        end
        WAIT2        :begin

            line_valid <= 1'b0;
        	data_valid<= 1'd0;
        	frame_valid <= 1'b1;
            pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
            if(pixel_clk_cnt>=32'd3&&line_cnt<LINE_N)begin
           	    pixel_clk_cnt<=32'd0;
                state<=LINE_TRANSFER;
              end
		    else if(pixel_clk_cnt>=32'd3&&(line_cnt>=LINE_N)) begin
		        state <= IDLE;
		    end
            else
                state<=WAIT2;
        end
        READ        :begin
            frame_valid     <= 1'b1                         ;	
            line_valid      <= 1'b1                         ;	
       	    data_valid      <= 1'd1                         ;
			pixel_clk_cnt   <=32'd0;
            pixel_cnt       <= pixel_cnt + 1'b1;
		    if(pixel_cnt==PIXEL_N-1)begin
		        state     <= WAIT2;
                pixel_cnt <= 12'd0    ;
		        line_cnt  <= line_cnt + 1'b1;
		    end
		    else
		        state<=READ;
        end
        default     :begin
            frame_valid     <= 1'b0                         ;
            line_valid      <= 1'b0                         ;	
            data_valid      <= 1'd0                         ;
            state           <= IDLE                         ;
        end
        endcase
    end
end

/****************************************************/
assign CL_FVAL = frame_valid;//帧有效
assign CL_LVAL = line_valid;//行有效
assign CL_DVAL = data_valid;//数据有效

always@(posedge CLK_SYS)begin
    if(!CL_FVAL)
        CL_DATA<=32'd0;
    else if(CL_DVAL)
        CL_DATA=CL_DATA+1'd1;
    else
        CL_DATA<=CL_DATA;
end
/********************************************************************************************/
endmodule