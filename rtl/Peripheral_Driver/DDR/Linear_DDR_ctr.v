`timescale 1ns / 1ps
//面阵器件
////////////////////////////////////////////////////////////////////////////////
module Linear_DDR_ctr#
(
    parameter  integer  ADDR_WIDTH = 28,
    parameter  integer  APP_DATA_WIDTH = 128,
    parameter  integer  ADDR_OFFSET = 0,
    parameter  integer  BUF_SIZE = 3
)
(
	output      [ADDR_WIDTH - 1:0]          app_addr,
	output      [2:0]                       app_cmd,
	output                	                app_en,
	output      [APP_DATA_WIDTH - 1:0]      app_wdf_data,
	output             	                    app_wdf_end,
	output                 	                app_wdf_wren,
	input       [APP_DATA_WIDTH - 1:0]      app_rd_data,
	input            	                    app_rd_data_valid,
	input            	                    app_rdy,
	input            	                    app_wdf_rdy,
	input            	                    ui_clk,
	input            	                    ui_rstn_i,
    input       [15:0]                      ui_img_h,
    input       [15:0]                      ui_img_w,
	//Sensor video 640x480p -W0_FIFO
	input                                   W0_wclk_i,      //CAMERALINK输入时钟
    input                                   W0_Fval_i,      //CAMERALINK帧有效
    input                                   W0_Dval_i,      //CAMERALINK数据有效
	input       [31:0]                      W0_data_i,      //CAMERALINK数据
	//vga/hdmi output -R0_FIFO
	input                                   R0_rclk_i,      //CAMERALINK输入时钟
    input                                   R0_Fval_i,      //CAMERALINK帧有效
    input                                   R0_rden_i,
	output      [31:0]                      R0_data_o       //CAMERALINK数据
    );

wire [21:0] WR_BURST_LEN;
wire [21:0] RD_BURST_LEN;
wire [31:0] IMAGE_SIZE  ;
wire [15:0]W_BURST_TIMES;
wire [15:0]R_BURST_TIMES;
assign  WR_BURST_LEN = ui_img_w/4;//一次burst 25x128/32=100 个像素画 也就是一行数据
assign  RD_BURST_LEN = ui_img_w/4;//一次burst 25x128/32=100 个像素画 也就是一行数据
assign IMAGE_SIZE       = ui_img_h*ui_img_w;
assign W_BURST_TIMES    = ui_img_h;
assign R_BURST_TIMES    = ui_img_h;
 //-------------------------- 控制信息FIFO信号 ------------------------------//
reg       msg_wren=1'b0;
reg       msg_rden=1'b0;
reg  [7:0]msg_wdata=10'b0;
wire      msg_clk;
wire [7:0]msg_rdata;
wire      msg_full;
wire [4:0]msg_dcnt;
 //------------------------- W0写通道FIFO信号 ------------------------//
wire[127:0]W0_dout;
wire[9:0]  W0_rcnt;
wire       W0_rclk;
wire W0_rden;
reg  W0_FIFO_Rst=1'b1;
//------------------------- R0读通道 FIFO信号  --------------------------//    
wire[127:0]R0_din;
wire[11:0] R0_rcnt;
wire       R0_wclk;
wire R0_wren;
reg  R0_FIFO_Rst=1'b1;
//-------------------------- FIFO读写时钟处理 ----------------------------//
assign W0_rclk    =     ui_clk;
assign R0_wclk    =     ui_clk;
assign msg_clk      =     ui_clk;



//-------------------------写控制信号进入MSG_FIFO--------------------------//
wire  w_fval_cap;
wire  r_fval_cap;
Sync_Pulse_Slow2Fast sync0(
    .clk        (ui_clk     )   ,
    .rst_n      (ui_rstn_i  )   ,
    .sign_i     (W0_Fval_i  )   ,
    .pulse_r_o    (w_fval_cap  )  ,
    .pulse_f_o    (),
    .sign_o     ()    
    );
Sync_Pulse_Slow2Fast sync1(
    .clk        (ui_clk     )   ,
    .rst_n      (ui_rstn_i  )   ,
    .sign_i     (R0_Fval_i  )   ,
    .pulse_r_o    (r_fval_cap  )  ,
    .pulse_f_o    (),
    .sign_o     ()
    );
//-------------------------写控制信号进入MSG_FIFO--------------------------//
always@(posedge ui_clk)begin
    if(!ui_rstn_i)begin//--ddr校准完成--//
         msg_wren    <=1'd0;
         msg_wdata    <=8'd0;
    end
    else begin
        msg_wren    <= w_fval_cap||r_fval_cap;
        msg_wdata   <={w_fval_cap,1'b0,1'b0,1'b0,r_fval_cap,1'b0,1'b0,1'b0};
    end
end
/***********************************************************************************/
reg W0_REQ = 1'b0;
reg R0_REQ = 1'b0;
always@(posedge ui_clk)begin
     W0_REQ    <= (W0_rcnt    >= WR_BURST_LEN-2);//接收fifo里凑够一行数据，写数据计数
     R0_REQ    <= (R0_rcnt    <= RD_BURST_LEN-2);//读出fifo里少于一行数据，读数据计数
end
/***********************************************************************************/
reg  [7:0]rst_FIFO_cnt= 6'b0;  
reg  [15:0]count_rden  = 16'd0;
reg  [15:0]count_wren  = 16'd0;
//------------------------地址空间--------------------------//   
reg [15:0]wburst_cnt = 16'd0;
reg [15:0]rburst_cnt = 16'd0; 
reg [2 :0]R0_Fbuf   = 3'd0;//缓存切换高地址
reg [2 :0]W0_Fbuf   = 3'd0;//缓存切换高地址
reg [24:0]W0_addr   = 25'd0;
reg [24:0]R0_addr   = 25'd0;
//-------------------------------状态机-----------------------------------//
reg  [2:0]M_S = 3'd0;
localparam [2:0]S_MFIFO0    =3'd0;
localparam [2:0]S_MFIFO1    =3'd1;
localparam [2:0]S_DATA0     =3'd3;
localparam [2:0]S_DATA1     =3'd4;
localparam [2:0]S_DATA2     =3'd5;
localparam [2:0]S_WDATA     =3'd6;
localparam [2:0]S_RDATA     =3'd7;

always@(posedge ui_clk)begin
     if(!ui_rstn_i)begin
         M_S           <= S_MFIFO0;
         msg_rden      <= 1'd0;
         W0_FIFO_Rst   <= 1'd0;
         R0_FIFO_Rst   <= 1'd0;
         rst_FIFO_cnt  <= 8'd0;
         count_rden    <= 16'd0;
         count_wren    <= 16'd0;    
         W0_addr       <= 25'd0;
         R0_addr       <= 25'd0;   
         W0_Fbuf       <= 3'd0;
         R0_Fbuf       <= 3'd0; 
         wburst_cnt    <= 16'd0; 
         rburst_cnt    <= 16'd0;
      end
      else case(M_S)
        //------------------------读取FIFO的控制信号-------------------------//
         S_MFIFO0:begin//--FIFO有数据就读取--//
            M_S             <=({msg_full,msg_dcnt}!=5'd0) ? S_MFIFO1 : S_DATA2;
            msg_rden        <=({msg_full,msg_dcnt}!=5'd0);
            W0_FIFO_Rst     <=1'd0;
            R0_FIFO_Rst     <=1'd0;
            rst_FIFO_cnt    <=8'd0;
            count_rden      <=16'd0;
            count_wren      <=16'd0;
        end   
        S_MFIFO1:begin  //--停止msgfifo读取，只有一个clk的读取--//
            msg_rden        <= 1'b0;
            M_S             <= S_DATA0;
        end
        //------------------------读取FIFO的控制信号-------------------------//      
         S_DATA0:begin//--相对地址处理 多缓存切换--//
            M_S             <= S_DATA1;
              if(msg_rdata[7])begin             //wirte
                 wburst_cnt    <= 16'd0;
                 W0_addr <= 25'd0;
                 if(W0_Fbuf == (BUF_SIZE-1)) 
                     W0_Fbuf <= 0;
                 else 
                     W0_Fbuf <= W0_Fbuf + 1'b1;
              end
              if(msg_rdata[3])begin             //read
                 rburst_cnt    <= 16'd0;
                 R0_addr <= 25'd0;
                 if(W0_Fbuf == 0)
                     R0_Fbuf <= (BUF_SIZE-1);
                 else
                     R0_Fbuf <= W0_Fbuf - 1'b1;
              end  
        end 
         S_DATA1:begin//--复位--//
            M_S             <= (rst_FIFO_cnt>=8'd200) ? S_DATA2 : M_S;
            R0_FIFO_Rst     <= (rst_FIFO_cnt<=8'd100)&&msg_rdata[3];
            W0_FIFO_Rst     <= (rst_FIFO_cnt<=8'd100)&&msg_rdata[7];
            rst_FIFO_cnt    <= rst_FIFO_cnt + 8'd1;
         end           
        //-------------------------状态机空闲状态--------------------------//
         S_DATA2:begin    
            count_rden        <=16'd0;
            count_wren        <=16'd0;
            casex({W0_REQ&1'b1,1'b0,1'b0,1'b0,R0_REQ&1'b1,1'b0,1'b0,1'b0})
                8'b1???_????:begin
                    if( wburst_cnt < W_BURST_TIMES) M_S  <= S_WDATA; //-ddr写数据-//
                    else  M_S  <= S_MFIFO0;
                end
                8'b0000_1000:begin
                    if( rburst_cnt < R_BURST_TIMES)M_S  <= S_RDATA; //-ddr读数据-//
                    else  M_S  <= S_MFIFO0;
                end 
                default:       M_S  <= S_MFIFO0;
            endcase
         end
        //-------------------------sdram读状态--------------------------//
         S_RDATA:begin //--读取数据--//
            R0_addr         <= app_rdy ? (R0_addr+4'd8) : R0_addr ;//每次写入的数据地址
            count_rden      <= app_rdy ? count_rden+1'd1:count_rden;//count_rden用来标记一次burst的数据量
            if(app_rdy&&(count_rden==RD_BURST_LEN-1'b1))begin
               M_S <= S_MFIFO0;
               rburst_cnt <=  rburst_cnt + 1'b1;
            end
            else
                M_S <= S_RDATA;
         end
        //-------------------------sdram写状态--------------------------//
         S_WDATA:begin//--写入数据--//            
            W0_addr         <= app_rdy&&app_wdf_rdy ? (W0_addr+4'd8) : W0_addr ;//每次写入的数据地址
            count_wren      <= app_rdy&&app_wdf_rdy ? count_wren+1'd1:count_wren;//count_wren用来标记一次burst的数据量
            if(app_rdy&&(count_wren==WR_BURST_LEN-1'b1))begin
               M_S <= S_MFIFO0;
               wburst_cnt <=  wburst_cnt + 1'b1;
            end
            else 
                M_S <= S_WDATA; 
         end        
        default:begin
            M_S             <=S_MFIFO0;
            count_rden      <=16'd0;
            count_wren      <=16'd0;
        end    
        endcase                        
end

//-------------------------------DDR接口-----------------------------------//
parameter [2:0]CMD_WRITE   =3'd0;//write cmd
parameter [2:0]CMD_READ    =3'd1;//read cmd

assign    app_wdf_end   = app_wdf_wren;//两个相等即可
assign    app_en        = (M_S==S_WDATA) ? (app_rdy&app_wdf_rdy) : ((M_S==S_RDATA)&app_rdy);//控制命令使能
assign    app_cmd       = (M_S==S_WDATA) ? CMD_WRITE : CMD_READ;//控制命令
assign    app_addr      = (M_S==S_WDATA) ? ({W0_Fbuf,W0_addr}+ ADDR_OFFSET) : ({R0_Fbuf,R0_addr}+ ADDR_OFFSET);//读写地址切换
assign    app_wdf_data  = W0_dout;//写入的数据是计数器
assign    app_wdf_wren  = (M_S==S_WDATA)&app_rdy&app_wdf_rdy;//写使能

assign    W0_rden     = app_wdf_wren; //W0-FIFO 读使能
assign    R0_din     = app_rd_data; // R0-FIFO 写入的数据
assign    R0_wren     = app_rd_data_valid;//R0-FIFO 写使能

//----------------Sensor fifo接口--------------------//
wr_fifo wr_fifo_inst (
    .rst            (W0_FIFO_Rst    ),  // input wire rst
    .wr_clk         (W0_wclk_i      ),  // input wire wr_clk
    .rd_clk         (W0_rclk        ),  // input wire rd_clk
    .din            (W0_data_i      ),  // input wire [31 : 0] din
    .wr_en          (W0_Dval_i      ),  // input wire wr_en
    .rd_en          (W0_rden        ),  // input wire rd_en
    .dout           (W0_dout        ),  // output wire [255 : 0] dout
    .valid          (               ),                  // output wire valid
    .rd_data_count  (W0_rcnt        )   // output wire [7 : 0] rd_data_count
    );

//----------------R0 fifo接口--------------------//
wire R0_valid_i;
rd_fifo rd_fifo_inst (
    .rst            (R0_FIFO_Rst    ),  // input wire rst
    .wr_clk         (R0_wclk        ),  // input wire wr_clk
    .rd_clk         (R0_rclk_i      ),  // input wire rd_clk
    .din            (R0_din         ),  // input wire [255 : 0] din
    .wr_en          (R0_wren        ),  // input wire wr_en
    .rd_en          (R0_rden_i      ),  // input wire rd_en
    .dout           (R0_data_o      ),  // output wire [31 : 0] dout
    .full           (               ),  // output wire full
    .empty          (               ),  // output wire empty
    .valid          (R0_valid_i     ),  // output wire valid
    .wr_data_count  (R0_rcnt        )   // output wire [7 : 0] wr_data_count
    );

//----------------控制消息fifo接口--------------------//
ms_fifo ms_fifo_inst (
    .clk            (msg_clk        ),  // input wire clk
    .din            (msg_wdata      ),  // input wire [9 : 0] din
    .wr_en          (msg_wren       ),  // input wire wr_en
    .rd_en          (msg_rden       ),  // input wire rd_en
    .dout           (msg_rdata      ),  // output wire [9 : 0] dout
    .full           (msg_full       ),  // output wire full
    .empty          (empty          ),  // output wire empty
    .data_count     (msg_dcnt       )   // output wire [4 : 0] data_count
);
endmodule
