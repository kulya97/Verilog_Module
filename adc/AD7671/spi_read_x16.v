

module spi_read_x16 
(
	input clk_in,
	input rstn,
	
	output reg adc_cs_n_o,
	output reg adc_rd_n_o,
	output adc_pd_o,
	output reg adc_cnvst_n_o,
	output reg adc_reset_o,
	input adc_busy_i,

    output [15:0] rdata,

	input  spi_sdin,
	output spi_sclk

);
	wire clk;
	wire rst;


assign clk = clk_in;
assign rst = ~rstn;

assign adc_pd_o = 1'b0;


wire spi_clk;
reg spi_ncs_u;
reg adc_reset_n;


always @(posedge clk ) begin
	if (rst)
		adc_cs_n_o <= 1'b1;		
	else
		adc_cs_n_o <= spi_ncs_u;
end


always @(posedge clk ) begin
	if (rst)
		adc_rd_n_o <= 1'b1;		
	else
		adc_rd_n_o <= spi_ncs_u;
end

always @(posedge clk ) begin
	if (rst)
		adc_reset_o <= 1'b1;		
	else
		adc_reset_o <= adc_reset_n;
end



reg clk_active;
reg clk_active_r;

//always @(posedge clk) begin
//	clk_active_r <= clk_active;
//end



assign spi_sclk = !clk & clk_active;



reg [15:0] rdata_be;
reg [3:0] state;



reg [7:0] bitno; 
reg [15:0] data_shifted;

reg [15:0] delay_cnt; 




parameter STATE_IDLE = 0;
parameter STATE_RESET = 1;
parameter STATE_RD = 2;
parameter STATE_SEN = 3;
parameter STATE_WAIT = 4;
parameter STATE_DATA = 5;
parameter STATE_DELAY = 6;
parameter STATE_TRANSEND = 7;



assign rdata = rdata_be;


always @(posedge clk) begin
	if (rst) begin
		state <= STATE_RESET;
		bitno <= 7;
		delay_cnt <= 10;
		spi_ncs_u <= 1;
		adc_reset_n <= 1;
        adc_cnvst_n_o <= 1;
        clk_active <= 0;
        data_shifted <=16'h0000;
	end else begin
	
        if (state == STATE_RESET) begin
            spi_ncs_u <= 1;
            clk_active <= 0;
            bitno <= 7;
            adc_reset_n <= 1;
            adc_cnvst_n_o <= 1;
            data_shifted <=16'h0000;
            if (delay_cnt==0) begin
                delay_cnt <= 10;
                state <= STATE_IDLE;
            end else begin
                delay_cnt<=delay_cnt-1;
            end            
        end

		
		else if (state == STATE_IDLE) begin
			spi_ncs_u <= 1;
			clk_active <= 0;
			bitno <= 7;
            adc_reset_n <= 0;
            adc_cnvst_n_o <= 1;
            data_shifted <=16'h0000;
            if (delay_cnt==0) begin
                delay_cnt <= 10;
                state <= STATE_RD;
            end else begin
                delay_cnt<=delay_cnt-1;
            end             
		end
		
		else if (state == STATE_RD) begin
            spi_ncs_u <= 0;
            clk_active <= 0;
            bitno <= 7;
            adc_reset_n <= 0;
            adc_cnvst_n_o <= 1;
            data_shifted <=16'h0000;
            if (delay_cnt==0) begin
                delay_cnt <= 10;
                state <= STATE_SEN;
            end else begin
                delay_cnt<=delay_cnt-1;
            end             
        end		
		
		else if (state == STATE_SEN) begin
            spi_ncs_u <= 0;
            clk_active <= 0;
            bitno <= 7;
            adc_reset_n <= 0;
            adc_cnvst_n_o <= 0;
            data_shifted <=16'h0000;
            if (delay_cnt==0) begin
                delay_cnt <= 10;
                state <= STATE_WAIT;
            end else begin
                delay_cnt<=delay_cnt-1;
            end              
        end		
		
			
		else if (state == STATE_WAIT) begin
			spi_ncs_u <= 0;
			clk_active <= 0;
            adc_reset_n <= 0;
            adc_cnvst_n_o <= 1;
            delay_cnt <= 10;
            data_shifted <=16'h0000;
			if (adc_busy_i == 1'b0) begin
				state <= STATE_DATA;
				bitno <= 16;
				clk_active <= 1;
			end else begin
				state <= STATE_WAIT;
			end			
		end 
		
		else if (state == STATE_DATA) begin
			delay_cnt <= 10;
            if (bitno==0) begin
                rdata_be<=data_shifted;
                bitno <= 3;
                clk_active <= 0;
                state <= STATE_DELAY;
            end
            else if (bitno==1) begin
                data_shifted<={data_shifted[14:0], spi_sdin};
                clk_active <= 0;
                bitno<=bitno-1;
            end            
            
            else begin
                data_shifted<={data_shifted[14:0], spi_sdin};
                bitno<=bitno-1;
                clk_active <= 1;
            end
            
            
        end 
        
		else if (state == STATE_DELAY) begin
            spi_ncs_u <= 0;
            clk_active <= 0;
            adc_reset_n <= 0;
            adc_cnvst_n_o <= 1;
            data_shifted <=16'h0000;
            if (delay_cnt==0) begin
                delay_cnt <= 20;
                state <= STATE_TRANSEND;
            end else begin
                delay_cnt<=delay_cnt-1;
            end              
        end                
        
        
        

		else begin //state=STATE_TRANSEND
			spi_ncs_u <= 1;
			clk_active <= 0;
			data_shifted <=16'h0000;
            if (delay_cnt==0) begin
                delay_cnt <= 10;
                state <= STATE_IDLE;
            end else begin
                delay_cnt<=delay_cnt-1;
            end 			
		end
	end
end


endmodule
