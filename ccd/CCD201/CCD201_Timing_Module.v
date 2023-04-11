`timescale 1ns / 1ps

module CCD201_Timing_Module(
    input CLK_SYS,      //ϵͳʱ��
    input CLK_20M,
    input RST_N,        //ϵͳ��λ�ź�
    output Iphi1,       //��������ֱת��ʱ�ӵ�1��
    output Iphi2,       //��������ֱת��ʱ�ӵ�2��
    output Iphi3,       //��������ֱת��ʱ�ӵ�3��
    output Iphi4,       //��������ֱת��ʱ�ӵ�4��
    output Sphi1,       //�洢����ֱת��ʱ�ӵ�1��
    output Sphi2,       //�洢����ֱת��ʱ�ӵ�2��
    output Sphi3,       //�洢����ֱת��ʱ�ӵ�3��
    output Sphi4,       //�洢����ֱת��ʱ�ӵ�4��
    output Rphi1,       //ˮƽת��ʱ�ӵ�3��
    output Rphi2,       //ˮƽת��ʱ�ӵ�3��
    output Rphi3,       //ˮƽת��ʱ�ӵ�3��
    output phiR,        //��λʱ��
    output Rphi2HV,     //��ѹ����ʱ��
    output DG1,         //Dump Gateʱ��1
    output DG2,          //Dump Gateʱ��2
    output Rphi2HV_EN,    //��ѹ����ʱ��ʹ���ź�
    output reg pixel_clk, ////1111111100000000����ʱ��ռ�ձ�50%
    output CL_LVAL,
    output CL_FVAL,
    output CL_DVAL,
    input ADC_OUTCLK,
    input [15:0 ]ADC_DATA,
    output hs,
    output cl_dclk,
    output [15:0] cl_data,
    output reg OS_select,
    input [255:0]UART_IN,
    input uart_ready,
    output os_rst
    );
    

//����ˮƽת��ʱ�ӼĴ���������������
reg [4:0] clk_cnt;      //����16��Ƶ������

reg [15:0] Rphi1_R0;            //1000000011111111ռ�ձ�9/16
reg [15:0] Rphi2_R0;            //1111100000000000ռ�ձ�5/16
reg [15:0]  Rphi3_R0;            //0000111110000000ռ�ձ�5/16
reg [15:0] phiR_R0;             //0010000000000000ռ�ձ�1/16
reg [15:0] Rphi2HV_R0;          //1111100000000011
reg [15:0] pixel_clk_r0;

reg [15:0] Rphi1_Rs;            //1000000011111111ռ�ձ�9/16
reg [15:0] Rphi2_Rs;            //1111100000000000ռ�ձ�5/16
reg [15:0]  Rphi3_Rs;            //0000111110000000ռ�ձ�5/16
reg [15:0] phiR_Rs;             //0010000000000000ռ�ձ�1/16
reg [15:0] Rphi2HV_Rs;          //1111100000000011
reg [15:0] pixel_clk_rs;

reg Rphi1_R;
reg Rphi2_R;
reg Rphi3_R;
reg phiR_R;
reg Rphi2HV_R;

//ˮƽʱ�ӵ���
always @(posedge CLK_SYS or negedge RST_N )
begin
        if(!RST_N) begin
            Rphi1_R0    <= 16'b1000000011111111;            //1000000011111111ռ�ձ�9/16
            Rphi2_R0    <= 16'b1111100000000000;            //1111100000000000ռ�ձ�5/16
            Rphi3_R0    <= 16'b0000111110000000;            //0000111110000000ռ�ձ�5/16
            phiR_R0     <= 16'b0010000000000000;            //0010000000000000ռ�ձ�1/16
            Rphi2HV_R0  <= 16'b1111000000000011;            //1111100000000011
            pixel_clk_r0<= 16'hf0;
        end
        else if(uart_ready && (UART_IN[31:16] == 16'hB1A1)&&(UART_IN[255:32]==224'd0))
            Rphi1_R0 <= UART_IN[15:0];
        else if(uart_ready && (UART_IN[31:16] == 16'hB1A2)&&(UART_IN[255:32]==224'd0))
            Rphi2_R0 <= UART_IN[15:0];
        else if(uart_ready && (UART_IN[31:16] == 16'hB1A3)&&(UART_IN[255:32]==224'd0))
            Rphi3_R0 <= UART_IN[15:0];
        else if(uart_ready && (UART_IN[31:16] == 16'hB1A4)&&(UART_IN[255:32]==224'd0))
            phiR_R0 <= UART_IN[15:0];
        else if(uart_ready && (UART_IN[31:16] == 16'hB1A5)&&(UART_IN[255:32]==224'd0))
            Rphi2HV_R0 <= UART_IN[15:0];
        else if(uart_ready && (UART_IN[31:16] == 16'hB1A6)&&(UART_IN[255:32]==224'd0))
            pixel_clk_r0 <= UART_IN[15:0];
end

always @ (posedge CLK_SYS or negedge RST_N) begin
	if (!RST_N) begin
		clk_cnt     <= 5'd0;
		pixel_clk   <= 1'b0;
		Rphi1_R     <= 1'b1;
		Rphi2_R     <= 1'b0;
		Rphi3_R     <= 1'b0;
		phiR_R      <= 1'b0;
		Rphi2HV_R   <= 1'b0;

        Rphi1_Rs    <= Rphi1_R0;
        Rphi2_Rs    <= Rphi2_R0;
        Rphi3_Rs    <= Rphi3_R0;
        phiR_Rs     <= phiR_R0;
        Rphi2HV_Rs  <= Rphi2HV_R0;
        pixel_clk_rs<= pixel_clk_r0;
	end
	else begin
		clk_cnt <= clk_cnt + 1'b1;
		pixel_clk <= pixel_clk_rs[15-clk_cnt];
		Rphi1_R <= Rphi1_Rs[15-clk_cnt];
		Rphi2_R <= Rphi2_Rs[15-clk_cnt];
		Rphi3_R <= Rphi3_Rs[15-clk_cnt];
		phiR_R  <= phiR_Rs[15-clk_cnt];
		Rphi2HV_R <= Rphi2HV_Rs[15-clk_cnt];
        if(clk_cnt>=4'd15)
        clk_cnt<=4'd0;
	end
end

//ˮƽת�������־�ź��Լ���������
reg [11:0] pixel_cnt;           //����1121�Σ�47�洢����ֱת��һ��+16��ɨ��+16������+1024��Ч����+16�����أ�
reg [11:0] line_cnt;            //����1060�Σ�21��ֱת��+2�мĴ������+6+1024��Ч��+7��

reg hreg_clr;                   //�мĴ������״̬������2��line_cnt
reg vtrans_en;					//��ֱת����Ч״̬������21��line_cnt
reg htrans_en;					//ˮƽת����Ч״̬������1037��line_cnt(6(1+5)+1024+7(2+5))
reg all_line_flag;              //����1030��line_cnt(6(1+5)+1024)
reg active_line_flag;           //��������Ч״̬������1024��line_cnt


reg Rf_all_en;                  //piexl_cnt��ˮƽת��ʱ����Ч״̬������1072��pixel_cnt

reg Sphi1_R;                      //ˮƽת������洢����ֱת��ʱ��1
reg Sphi2_R;                      //ˮƽת������洢����ֱת��ʱ��2

reg [15:0] Integration_T;


always @ (posedge pixel_clk or negedge RST_N)begin
	if(!RST_N) begin
		pixel_cnt <= 12'd0;
		line_cnt <= 12'd0;
		hreg_clr <= 1'b0;
		vtrans_en <= 1'b0;
		htrans_en <= 1'b0;
		all_line_flag <= 1'b0;
        active_line_flag <= 1'b0;
		Rf_all_en <= 1'b0;
		Sphi1_R <= 1'b0;
		Sphi2_R <= 1'b0;			
	end
	else begin
		pixel_cnt <= pixel_cnt + 1'b1;
		case (pixel_cnt)
			0 : begin
				Rf_all_en <= 1'b0;
				line_cnt <= line_cnt + 1'b1;	
				case(line_cnt)
					0 : begin
						vtrans_en <= 1'b1;
						htrans_en <= 1'b0;
						all_line_flag <= 1'b0;
					end
					21 : begin
						vtrans_en <= 1'b0;
						hreg_clr <= 1'b1;
					end
					23 : begin
					 	hreg_clr <= 1'b0;	
					 	htrans_en <= 1'b1;
					 	all_line_flag <= 1'b1;
					 end
					29 : begin
					  active_line_flag <= 1'b1;	
					end
//					1047 : begin
//					  active_line_flag <= 1'b0;
//					  all_line_flag    <= 1'b0;//??????1030or1037
					743 : begin
					  active_line_flag <= 1'b0;
					  all_line_flag    <= 1'b0;//??????1030or1037					  
					end
					Integration_T : begin
						line_cnt <= 12'd0;
					end
				endcase		
			end
			1 : begin Sphi1_R <= 1'b1; end
			10 : Sphi2_R <= 1'b1;
			16 : begin Sphi1_R <= 1'b0; end
//			16 : begin Sphi1_R <= 1'b0; Rf_all_en <= 1'b1;end
//			25 : begin Sphi2_R <= 1'b0; Rf_all_en <= 1'b1;end
			25 : begin Sphi2_R <= 1'b0; end			
			
			120 : Rf_all_en <= 1'b1;
//			1107 : Rf_all_en <= 1'b0;
			1474 : Rf_all_en <= 1'b0;			
//			1120 : pixel_cnt <= 12'd0;
			1820 : pixel_cnt <= 12'd0;
		endcase
	end
end
//ˮƽת��ʱ������
assign Rphi1 = (~(vtrans_en ? 1'b1 : (hreg_clr ? Rphi1_R : (htrans_en ? (Rf_all_en ? Rphi1_R : 1'b1) : 1'b1))));//OSH
assign Rphi3 = (~(vtrans_en ? 1'b1 : (hreg_clr ? Rphi2_R : (htrans_en ? (Rf_all_en ? Rphi2_R : 1'b1) : 1'b1))));//OSH
assign Rphi2 = ~(vtrans_en ? 1'b0 : (hreg_clr ? Rphi3_R : (htrans_en ? (Rf_all_en ? Rphi3_R : 1'b0) : 1'b0)));
assign phiR = ~(vtrans_en ? 1'b1 : (hreg_clr ? phiR_R : (htrans_en ? (Rf_all_en ? phiR_R : 1'b1) : 1'b1)));
assign Rphi2HV = ~Rphi2HV_R;

assign Rphi2HV_EN = 1'b0;

//������ֱת����ʱ�ӼĴ���
`define  IDLE			2'd0
`define  FIRSTPULSE	    2'd1
`define  TRANS			2'd2
`define  LASTPULSE		2'd3

reg [9:0] pixel_clk_cnt;        //
reg [10:0] cycle_cnt;           //
reg [3:0] state;                //

//(*mark_debug = "true"*) reg [3:0] state;


reg Iphi1_R;                      //��ֱת��1��
reg Iphi2_R;                      //��ֱת��2��

always @ (posedge pixel_clk or negedge RST_N) begin
	if (!RST_N) begin
		pixel_clk_cnt <= 1'b0;
		cycle_cnt <= 1'b0;
		state <= `IDLE;
		
		Iphi1_R <= 1'b0;
		Iphi2_R <= 1'b0;	
	end
	else begin
		case (state)
			`IDLE : begin
				if (pixel_cnt == 0 && line_cnt == 0) begin
					Iphi1_R <= 1'b1;
					Iphi2_R <= 1'b0;
					pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
					state <= `FIRSTPULSE;
				end
				else begin
					Iphi1_R <= 1'b0;
					Iphi2_R <= 1'b0;
					state <= `IDLE;
				end
			end
		
			`FIRSTPULSE : begin
				if (pixel_clk_cnt == 599) begin
					Iphi2_R <= 1'b1;
					pixel_clk_cnt <= 1'b0;
					state <= `TRANS;
				end
				else begin
					Iphi1_R <= 1'b1;
					Iphi2_R <= 1'b0;
					pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
				end
			end
		
			`TRANS : begin
				pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
				case (pixel_clk_cnt)					
					1 : Iphi1_R <= 1'b0;						//3
                    10 : Iphi1_R <= 1'b1;						//10
					12 : Iphi2_R <= 1'b0;
					21 : begin
						Iphi2_R <= 1'b1;
						pixel_clk_cnt <= 1'b0;
						cycle_cnt <= cycle_cnt + 1'b1;
						if (cycle_cnt == 1035) begin
							cycle_cnt <= 1'b0;
							state <= `LASTPULSE;	
						end
					end
				endcase	
			end
		
			`LASTPULSE : begin
				pixel_clk_cnt <= pixel_clk_cnt + 1'b1;
				case (pixel_clk_cnt)
					1 : Iphi1_R <= 1'b0;
					10 : begin
						Iphi2_R <= 1'b0;
						pixel_clk_cnt <= 1'b0;
						state <= `IDLE;
					end
				endcase
			end			
		endcase
	end
end

//���ɴ�ֱת���ź�
assign Iphi1 = ~(Iphi1_R);
assign Iphi2 = ~(Iphi1_R);
assign Iphi3 = ~(Iphi2_R);
assign Iphi4 = ~(Iphi2_R);
assign Sphi1 = ~(vtrans_en ? Iphi1_R : (hreg_clr ? 1'b0 : (htrans_en ? Sphi1_R : 1'b0)));
assign Sphi2 = ~(vtrans_en ? Iphi1_R : (hreg_clr ? 1'b0 : (htrans_en ? Sphi1_R : 1'b0)));
assign Sphi3 = ~(vtrans_en ? Iphi2_R : (hreg_clr ? 1'b0 : (htrans_en ? Sphi2_R : 1'b0)));
assign Sphi4 = ~(vtrans_en ? Iphi2_R : (hreg_clr ? 1'b0 : (htrans_en ? Sphi2_R : 1'b0)));

//����DG�ź�
assign DG1 = 1'b1;
assign DG2 = 1'b1;

reg all_pixel_addata;
reg active_pixel_addata;

//(*mark_debug = "true"*) reg active_pixel_addata;

always @ (posedge pixel_clk or negedge RST_N) begin
	if (!RST_N) begin
    all_pixel_addata <= 1'b0;
    active_pixel_addata <= 1'b0;	
  end
	else if (all_line_flag) begin
		case (pixel_cnt)
			46 : all_pixel_addata <= 1'b1;
			172 : active_pixel_addata <= 1'b1;
			1452 : active_pixel_addata <= 1'b0;
			1460 : all_pixel_addata <= 1'b0;
		endcase
	end
end


wire fifo_wrclk;
wire fifo_wrreq;
assign fifo_wrclk = ADC_OUTCLK;
assign fifo_wrreq = active_pixel_addata;
assign hs = active_pixel_addata;



wire fifo_rdclk;
assign fifo_rdclk = CLK_20M;

reg fifo_rdreq;
wire [9:0] fifo_rdusedw;
wire [9:0] fifo_wrusedw;

wire fifo_empty;
wire fifo_full;

//(*mark_debug = "true"*) wire [9:0] fifo_rdusedw;
//(*mark_debug = "true"*) wire [9:0] fifo_wrusedw;
//(*mark_debug = "true"*) reg fifo_rdreq;
//(*mark_debug = "true"*) wire fifo_wrreq;
//(*mark_debug = "true"*) wire fifo_empty;
//(*mark_debug = "true"*) wire fifo_full;




always @ (posedge CLK_20M or negedge RST_N) begin
	if (!RST_N) fifo_rdreq <= 1'b0;
	else if (fifo_wrusedw == 790) fifo_rdreq <= 1'b1;	
	else if (fifo_rdusedw == 1) fifo_rdreq <= 1'b0;
	else fifo_rdreq <= fifo_rdreq;	
end

reg fifo_rdreq1;
always @ (posedge fifo_rdclk or negedge RST_N) begin
	if (!RST_N) fifo_rdreq1 <= 1'b0;
	else fifo_rdreq1 <= fifo_rdreq;
end

wire [15:0] fifo_dout;

assign CL_LVAL = fifo_rdreq;
assign cl_dclk = fifo_rdclk;
assign CL_FVAL = all_line_flag;
assign cl_data = fifo_dout;
assign CL_DVAL = CL_LVAL&&all_line_flag; 

FIFO_ctrl FIFO_ctrl0 (
      .wr_clk(fifo_wrclk),                  // input wire wr_clk
      .rd_clk(fifo_rdclk),                  // input wire rd_clk
      .din(ADC_DATA),                       // input wire [15 : 0] din
      .wr_en(fifo_wrreq),                   // input wire wr_en
      .rd_en(fifo_rdreq),                   // input wire rd_en
      .dout(fifo_dout),                     // output wire [15 : 0] dout
      .full(fifo_full),                     // output wire full
      .empty(fifo_empty),                   // output wire empty
      .rd_data_count(fifo_rdusedw),         // output wire [9 : 0] rd_data_count
      .wr_data_count(fifo_wrusedw)          // output wire [9 : 0] wr_data_count
    );

//	
//	
////--------------------------------------------
////
////--------------------------------------------
//OSͨ��ѡ��OSL:A0A00000 OSH:A0A00001
always @(posedge CLK_SYS or negedge RST_N )
    begin
        if(!RST_N)
            OS_select  <= 1'd0;                  
        else if(uart_ready && (UART_IN[31:16] == 16'hA0A0)&&(UART_IN[255:32]==224'd0))
			OS_select <= UART_IN[0];
        else
            OS_select  <= OS_select;                        
    end
reg OS_select_n;
always @(posedge CLK_SYS or negedge RST_N )
begin
        if(!RST_N)
            OS_select_n  <= 1'd0;                  
        else
            OS_select_n  <= OS_select;                        
end

assign os_rst = OS_select^OS_select_n;

//����ʱ�����
always @(posedge CLK_SYS or negedge RST_N )
    begin
        if(!RST_N)
            Integration_T  <= 16'd1059;                        
        else if(uart_ready && (UART_IN[31:16] == 16'hA1A1)&&(UART_IN[255:32]==224'd0))
        begin
			Integration_T <= UART_IN[15:0];
        end
        else
            Integration_T  <= Integration_T;                        
    end

endmodule