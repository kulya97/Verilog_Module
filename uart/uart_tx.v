//*******************************************************************************/
module uart_tx
#(
    parameter CLK_FRE = 50,      //clock frequency(Mhz)
    parameter BAUD_RATE = 115200 //serial baud rate
)
(
    input                        clk            ,           //clock input
    input                        rst_n          ,           //asynchronous reset input, low active 
    input [7:0]                  tx_data        ,           //data to send
    input                        tx_data_valid  ,           //data to be sent is valid
    output reg                   tx_data_ready  ,           //send ready
    output                       tx_interrupt   ,
    output                       tx_pin                     //serial data output
);
localparam                       CYCLE = CLK_FRE * 1000000 / BAUD_RATE;
/***********************************************************************/
//状态机
reg[2:0]                         state          ;
reg[2:0]                         next_state     ;
localparam          S_IDLE       = 1            ;//空闲
localparam          S_START      = 2            ;//起始位
localparam          S_SEND_BYTE  = 3            ;//数据位
localparam          S_STOP       = 4            ;//停止位
/***********************************************************************/
reg[15:0]                        cycle_cnt      ; //波特率计数
reg[2:0]                         bit_cnt        ;//数据计数
reg[7:0]                         tx_data_latch  ; //数据
reg                              tx_reg         ;
/***********************************************************************/
assign tx_pin = tx_reg;
/***********************************************************************/
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		state <= S_IDLE;
	else
		state <= next_state;
end
always@(*)
begin
	case(state)
		S_IDLE:
			if(tx_data_valid == 1'b1)
				next_state <= S_START;
			else
				next_state <= S_IDLE;
		S_START:
			if(cycle_cnt == CYCLE - 1)
				next_state <= S_SEND_BYTE;
			else
				next_state <= S_START;
		S_SEND_BYTE:
			if(cycle_cnt == CYCLE - 1  && bit_cnt == 3'd7)
				next_state <= S_STOP;
			else
				next_state <= S_SEND_BYTE;
		S_STOP:
			if(cycle_cnt == CYCLE - 1)
				next_state <= S_IDLE;
			else
				next_state <= S_STOP;
		default:
			next_state <= S_IDLE;
	endcase
end
/***********************************************************************/
//波特率产生
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		cycle_cnt <= 16'd0;
	else if((state == S_SEND_BYTE && cycle_cnt == CYCLE - 1) || next_state != state)
		cycle_cnt <= 16'd0;
	else
		cycle_cnt <= cycle_cnt + 16'd1;
end
/***********************************************************************/
//检测到起始信号，锁存数据
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		begin
			tx_data_latch <= 8'd0;
		end
	else if(state == S_IDLE && tx_data_valid == 1'b1)
			tx_data_latch <= tx_data;
		
end
/***********************************************************************/
//数据计数
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		begin
			bit_cnt <= 3'd0;
		end
	else if(state == S_SEND_BYTE)
		if(cycle_cnt == CYCLE - 1)
			bit_cnt <= bit_cnt + 3'd1;
		else
			bit_cnt <= bit_cnt;
	else
		bit_cnt <= 3'd0;
end
/***********************************************************************/
//发送
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		tx_reg <= 1'b1;
	else
		case(state)
			S_IDLE,S_STOP:
				tx_reg <= 1'b1; 
			S_START:
				tx_reg <= 1'b0; 
			S_SEND_BYTE:
				tx_reg <= tx_data_latch[bit_cnt];
			default:
				tx_reg <= 1'b1; 
		endcase
end
/***********************************************************************/
//刷新状态
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		begin
			tx_data_ready <= 1'b0;
		end
	else if(state == S_IDLE&&tx_data_valid == 1'b0)
			tx_data_ready <= 1'b1;
		else
			tx_data_ready <= 1'b0;
end
/***********************************************************************/
reg tx_interrupt_r;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      tx_interrupt_r<=1'b0;
    end
    else if(state == S_STOP && cycle_cnt == CYCLE - 1) begin
        tx_interrupt_r<=1'b1;
    end
    else begin
      tx_interrupt_r<=1'b0;
    end
end
assign tx_interrupt=tx_interrupt_r;
endmodule 