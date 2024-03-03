`timescale 1ns / 1ps
//��������
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
	input                                   W0_wclk_i,      //CAMERALINK����ʱ��
    input                                   W0_Fval_i,      //CAMERALINK֡��Ч
    input                                   W0_Dval_i,      //CAMERALINK������Ч
	input       [31:0]                      W0_data_i,      //CAMERALINK����
	//vga/hdmi output -R0_FIFO
	input                                   R0_rclk_i,      //CAMERALINK����ʱ��
    input                                   R0_Fval_i,      //CAMERALINK֡��Ч
    input                                   R0_rden_i,
	output      [31:0]                      R0_data_o       //CAMERALINK����
    );

wire [21:0] WR_BURST_LEN;
wire [21:0] RD_BURST_LEN;
wire [31:0] IMAGE_SIZE  ;
wire [15:0]W_BURST_TIMES;
wire [15:0]R_BURST_TIMES;
assign  WR_BURST_LEN = ui_img_w/4;//һ��burst 25x128/32=100 �����ػ� Ҳ����һ������
assign  RD_BURST_LEN = ui_img_w/4;//һ��burst 25x128/32=100 �����ػ� Ҳ����һ������
assign IMAGE_SIZE       = ui_img_h*ui_img_w;
assign W_BURST_TIMES    = ui_img_h;
assign R_BURST_TIMES    = ui_img_h;
 //-------------------------- ������ϢFIFO�ź� ------------------------------//
reg       msg_wren=1'b0;
reg       msg_rden=1'b0;
reg  [7:0]msg_wdata=10'b0;
wire      msg_clk;
wire [7:0]msg_rdata;
wire      msg_full;
wire [4:0]msg_dcnt;
 //------------------------- W0дͨ��FIFO�ź� ------------------------//
wire[127:0]W0_dout;
wire[9:0]  W0_rcnt;
wire       W0_rclk;
wire W0_rden;
reg  W0_FIFO_Rst=1'b1;
//------------------------- R0��ͨ�� FIFO�ź�  --------------------------//    
wire[127:0]R0_din;
wire[11:0] R0_rcnt;
wire       R0_wclk;
wire R0_wren;
reg  R0_FIFO_Rst=1'b1;
//-------------------------- FIFO��дʱ�Ӵ��� ----------------------------//
assign W0_rclk    =     ui_clk;
assign R0_wclk    =     ui_clk;
assign msg_clk      =     ui_clk;



//-------------------------д�����źŽ���MSG_FIFO--------------------------//
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
//-------------------------д�����źŽ���MSG_FIFO--------------------------//
always@(posedge ui_clk)begin
    if(!ui_rstn_i)begin//--ddrУ׼���--//
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
     W0_REQ    <= (W0_rcnt    >= WR_BURST_LEN-2);//����fifo��չ�һ�����ݣ�д���ݼ���
     R0_REQ    <= (R0_rcnt    <= RD_BURST_LEN-2);//����fifo������һ�����ݣ������ݼ���
end
/***********************************************************************************/
reg  [7:0]rst_FIFO_cnt= 6'b0;  
reg  [15:0]count_rden  = 16'd0;
reg  [15:0]count_wren  = 16'd0;
//------------------------��ַ�ռ�--------------------------//   
reg [15:0]wburst_cnt = 16'd0;
reg [15:0]rburst_cnt = 16'd0; 
reg [2 :0]R0_Fbuf   = 3'd0;//�����л��ߵ�ַ
reg [2 :0]W0_Fbuf   = 3'd0;//�����л��ߵ�ַ
reg [24:0]W0_addr   = 25'd0;
reg [24:0]R0_addr   = 25'd0;
//-------------------------------״̬��-----------------------------------//
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
        //------------------------��ȡFIFO�Ŀ����ź�-------------------------//
         S_MFIFO0:begin//--FIFO�����ݾͶ�ȡ--//
            M_S             <=({msg_full,msg_dcnt}!=5'd0) ? S_MFIFO1 : S_DATA2;
            msg_rden        <=({msg_full,msg_dcnt}!=5'd0);
            W0_FIFO_Rst     <=1'd0;
            R0_FIFO_Rst     <=1'd0;
            rst_FIFO_cnt    <=8'd0;
            count_rden      <=16'd0;
            count_wren      <=16'd0;
        end   
        S_MFIFO1:begin  //--ֹͣmsgfifo��ȡ��ֻ��һ��clk�Ķ�ȡ--//
            msg_rden        <= 1'b0;
            M_S             <= S_DATA0;
        end
        //------------------------��ȡFIFO�Ŀ����ź�-------------------------//      
         S_DATA0:begin//--��Ե�ַ���� �໺���л�--//
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
         S_DATA1:begin//--��λ--//
            M_S             <= (rst_FIFO_cnt>=8'd200) ? S_DATA2 : M_S;
            R0_FIFO_Rst     <= (rst_FIFO_cnt<=8'd100)&&msg_rdata[3];
            W0_FIFO_Rst     <= (rst_FIFO_cnt<=8'd100)&&msg_rdata[7];
            rst_FIFO_cnt    <= rst_FIFO_cnt + 8'd1;
         end           
        //-------------------------״̬������״̬--------------------------//
         S_DATA2:begin    
            count_rden        <=16'd0;
            count_wren        <=16'd0;
            casex({W0_REQ&1'b1,1'b0,1'b0,1'b0,R0_REQ&1'b1,1'b0,1'b0,1'b0})
                8'b1???_????:begin
                    if( wburst_cnt < W_BURST_TIMES) M_S  <= S_WDATA; //-ddrд����-//
                    else  M_S  <= S_MFIFO0;
                end
                8'b0000_1000:begin
                    if( rburst_cnt < R_BURST_TIMES)M_S  <= S_RDATA; //-ddr������-//
                    else  M_S  <= S_MFIFO0;
                end 
                default:       M_S  <= S_MFIFO0;
            endcase
         end
        //-------------------------sdram��״̬--------------------------//
         S_RDATA:begin //--��ȡ����--//
            R0_addr         <= app_rdy ? (R0_addr+4'd8) : R0_addr ;//ÿ��д������ݵ�ַ
            count_rden      <= app_rdy ? count_rden+1'd1:count_rden;//count_rden�������һ��burst��������
            if(app_rdy&&(count_rden==RD_BURST_LEN-1'b1))begin
               M_S <= S_MFIFO0;
               rburst_cnt <=  rburst_cnt + 1'b1;
            end
            else
                M_S <= S_RDATA;
         end
        //-------------------------sdramд״̬--------------------------//
         S_WDATA:begin//--д������--//            
            W0_addr         <= app_rdy&&app_wdf_rdy ? (W0_addr+4'd8) : W0_addr ;//ÿ��д������ݵ�ַ
            count_wren      <= app_rdy&&app_wdf_rdy ? count_wren+1'd1:count_wren;//count_wren�������һ��burst��������
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

//-------------------------------DDR�ӿ�-----------------------------------//
parameter [2:0]CMD_WRITE   =3'd0;//write cmd
parameter [2:0]CMD_READ    =3'd1;//read cmd

assign    app_wdf_end   = app_wdf_wren;//������ȼ���
assign    app_en        = (M_S==S_WDATA) ? (app_rdy&app_wdf_rdy) : ((M_S==S_RDATA)&app_rdy);//��������ʹ��
assign    app_cmd       = (M_S==S_WDATA) ? CMD_WRITE : CMD_READ;//��������
assign    app_addr      = (M_S==S_WDATA) ? ({W0_Fbuf,W0_addr}+ ADDR_OFFSET) : ({R0_Fbuf,R0_addr}+ ADDR_OFFSET);//��д��ַ�л�
assign    app_wdf_data  = W0_dout;//д��������Ǽ�����
assign    app_wdf_wren  = (M_S==S_WDATA)&app_rdy&app_wdf_rdy;//дʹ��

assign    W0_rden     = app_wdf_wren; //W0-FIFO ��ʹ��
assign    R0_din     = app_rd_data; // R0-FIFO д�������
assign    R0_wren     = app_rd_data_valid;//R0-FIFO дʹ��

//----------------Sensor fifo�ӿ�--------------------//
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

//----------------R0 fifo�ӿ�--------------------//
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

//----------------������Ϣfifo�ӿ�--------------------//
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
