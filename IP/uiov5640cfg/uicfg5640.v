`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Company : Liyang Milian Electronic Technology Co., Ltd.
Brand: Ã×Áª¿Í(msxbo)
Technical forum:uisrc.com
taobao: osrc.taobao.com
Create Date: 2019/12/17
Module Name: uicfg5640
Description: 
Configure the uicfg5640 register.
Copyright: Copyright (c) msxbo
Revision: 1.0
Signal description£º
1) _i input
2) _o output
3) _n activ low
4) _dg debug signal 
5) _r delay or register
6) _s state mechine
*/
////////////////////////////////////////////////////////////////////////////////
module uicfg5640#(
parameter	 CLK_DIV  = 16'd499
)
(
input  clk_i,
input  rst_n,
output cmos_scl,
inout  cmos_sda,
input wire [15 :0] CAM_HSIZE,
input wire [15 :0] CAM_VSIZE,
output reg cfg_done
);
parameter   DEVID   =  8'h78; //8'h78 	
//reset counter for delay time
reg  [8 :0] rst_cnt = 9'd0;
always@(posedge clk_i) begin
    if(!rst_n)
        rst_cnt <= 9'd0;
    else if(!rst_cnt[8]) 
        rst_cnt <= rst_cnt + 1'b1;
end

reg  iic_en;
wire ic_busy;   
reg  [31:0] wr_data;
reg  [1 :0] TS_S = 2'd0;
reg  [8 :0] byte_cnt = 9'd0;
wire [23:0] REG_DATA;
wire [8 :0] REG_SIZE;
reg  [8 :0] REG_INDEX; 
//state machine write one byte and then read one byte
always@(posedge clk_i) begin
    if(!rst_cnt[8])begin
        REG_INDEX<= 9'd0;
        iic_en  <= 1'b0;
        wr_data <= 32'd0;
        cfg_done<= 1'b0;
        TS_S    <= 2'd0;    
    end
    else begin
        case(TS_S)
        0:if(cfg_done == 1'b0)
            TS_S <= 2'd1;
        1:if(!iic_busy)begin//write data
            iic_en  <= 1'b1;
			wr_data[7  :0] <= DEVID;// ov5640 id   
			wr_data[15 :8] <= REG_DATA[23:16];   
			wr_data[23:16] <= REG_DATA[15: 8];   
			wr_data[31:24] <= REG_DATA[7 : 0];
        end
        else 
            TS_S    <= 2'd2;
        2:begin
            iic_en  <= 1'b0; 
            if(!iic_busy)begin 
			REG_INDEX<= REG_INDEX + 1'b1;
			TS_S    <= 2'd3;
            end
        end
        3:begin//read rtc register
            if(REG_INDEX == REG_SIZE)begin
				cfg_done <= 1'b1;
			end
			TS_S 	<= 2'd0;
        end 
    endcase
   end
end

uii2c#
(
.WMEN_LEN(5),
.RMEN_LEN(1),
.CLK_DIV(CLK_DIV)//499 for 50M 999 for 100M
)
uii2c_inst
(
.clk_i(clk_i),
.iic_scl(cmos_scl),
.iic_sda(cmos_sda),
.wr_data(wr_data),
.wr_cnt(8'd4),//write data max len = 4BYTES
.rd_data(),   //read not used
.rd_cnt(8'd0),//read not used
.iic_mode(1'b0),
.iic_en(iic_en),
.iic_busy(iic_busy)
);
// 5640reg
ui5640reg ui5640reg_inst
(
.CAM_VSIZE(CAM_VSIZE),
.CAM_HSIZE(CAM_HSIZE),
.REG_SIZE(REG_SIZE),
.REG_INDEX(REG_INDEX),
.REG_DATA(REG_DATA)
);   

endmodule
