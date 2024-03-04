`timescale 1ns / 1ps
module moniyuan
#(
    parameter                WIDTH       = 12   ,
    parameter                TRUELINE    = 1080 ,
    parameter                TRUEPIXEL   = 1920 ,
    parameter                NUM_OF_PIX  = 2020 ,    //1380
    parameter                NUM_OF_LINE = 1100      //1124
)
(
  input              		        iclk		       		 ,   
  input                             rst_n                    ,
  output		                    sync_mny                 ,  
  output			                line_valid_mny           ,   
  output  [WIDTH-1:0]               data_mny                     
  );

  reg     [11:0]       line_cnt = 0;   //行计数
  reg     [11:0]       pix_cnt  = 0;   //列计数
  wire                  sync_1;
  wire                  line_valid;
  reg                  CLK;
//generate 2 clk  data joint  CLK_T = 2iclk_T 10MHZ
always@(posedge iclk or negedge rst_n)
 begin
      	if(~rst_n)
			 CLK <= 0;
		else
			 CLK<= ~CLK;  
 end
//counter
  always@(posedge iclk or negedge rst_n)
  begin
		if(~rst_n)
			 pix_cnt <= 0;
		else if(pix_cnt < (NUM_OF_PIX-1))
			 pix_cnt <= pix_cnt + 1'b1;
		else
			 pix_cnt <= 0;
  end
  
  always@(posedge iclk or negedge rst_n)
  begin
		if(~rst_n)
			line_cnt <= 12'd0; 
		else if((pix_cnt == (NUM_OF_PIX-1)) && (line_cnt < (NUM_OF_LINE-1)))
			 line_cnt <= line_cnt+1'b1;
		else if((pix_cnt == (NUM_OF_PIX-1)) && (line_cnt == (NUM_OF_LINE-1)))
			 line_cnt <= 12'd0;
		else    
			 line_cnt <= line_cnt;
  end
  
  wire    vsync;
  
  assign sync_1 = (line_cnt<=(NUM_OF_LINE-TRUELINE-1))?1'b0:1'b1;
  assign line_valid = (sync_1 & (pix_cnt<=(TRUEPIXEL-1)))?1'b1:1'b0;
  assign vsync= ((line_cnt<=12'd13)&&(line_cnt>=12'd8))?1'b1:1'b0;
  
 // read data
  reg    [19:0]          cnt_addra;
  wire   [23:0]          rom_data_out;
  reg    [11:0]          data_d;
  always@(negedge CLK or negedge rst_n)
  begin
		if(~rst_n)
			cnt_addra <= 0;    
		else if(cnt_addra == 20'd1036800 - 1'd1)     //can be changed
			cnt_addra <= 0;
        else if ((line_valid==0)&&(line_cnt>=(NUM_OF_LINE-TRUELINE-1))&&(pix_cnt==(NUM_OF_PIX-2))&&(line_cnt<(NUM_OF_LINE-1)))
            begin
                 cnt_addra <= cnt_addra + 1'd1;  
            end
		else if(line_valid&&(pix_cnt<12'd1918))   
			cnt_addra <= cnt_addra + 1'd1;
		else
			cnt_addra <= cnt_addra;
  end
  
//image_input u0_image_input (
//  .clka(CLK),    // input wire clka
//  .addra(cnt_addra),  // input wire [19 : 0] addra
//  .douta(rom_data_out)  // output wire [23 : 0] douta
//);

blk_mem_gen_1920x1080 u0_image_input (
  .clka(CLK),    // input wire clka
  .addra(cnt_addra),  // input wire [19 : 0] addra
  .douta(rom_data_out)  // output wire [23 : 0] douta
);

always@(posedge iclk )
begin
        if((pix_cnt == (NUM_OF_PIX-1))&&(line_cnt>=(NUM_OF_LINE-TRUELINE-1)))
            begin
                 data_d         <= rom_data_out[23:12];
            end
        else if(pix_cnt[0]==1&&line_valid==1)
            begin
                 data_d         <= rom_data_out[23:12];
            end
        else if(pix_cnt[0]==0&&line_valid==1)
            begin
                 data_d         <= rom_data_out[11:0];
            end
        else
            begin
                data_d          <=0;
            end
end
assign  sync_mny = vsync;
assign  line_valid_mny = line_valid;//line_valid_d;
assign  data_mny =line_valid? data_d:12'h00;      

endmodule
