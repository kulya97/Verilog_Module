`timescale 1ns/1ps

module tb;

//-------------------------------------------
int                     fsdbDump        ;
integer                 seed            ;

//clk / rstn    
logic                   clk             ;
logic                   wr_clk          ;
logic                   wr_rst_n        ;
logic                   rd_clk          ;
logic                   rd_rst_n        ;
logic                   wr_clk_r        ;
logic                   rd_clk_r        ;
wire                    wr_clk_rise     ;
wire                    rd_clk_rise     ;

//sig
logic           [4:0]   wr_array[$]     ;
logic           [4:0]   rd_array[$]     ;

logic                   wr              ;
logic                   rd              ;
logic           [4:0]   wr_dat          ;
wire            [4:0]   rd_dat          ;
wire                    rd_dat_vld      ;

wire                    almost_full     ;
wire                    almost_empty    ;
wire                    full            ;
wire                    empty           ;
logic                   sample_full     ;
logic                   sample_empty    ;

wire            [3:0]   wr_num          ;
wire            [3:0]   rd_num          ;

integer                 wr_cnt          ;
integer                 rd_cnt          ;
integer                 cnt             ;

int                     file1           ;
int                     file2           ;

//-------------------------------------------
// Format for time reporting
initial    $timeformat(-9, 3, " ns", 0);
initial
begin
	if (!$value$plusargs("seed=%d", seed))
		seed = 100;
	$srandom(seed);
	$display("seed = %d\n", seed);

	if(!$value$plusargs("fsdbDump=%d",fsdbDump))
		fsdbDump = 1;
	if (fsdbDump)
	begin
		$fsdbDumpfile("tb.fsdb");
		$fsdbDumpvars(0);
		$fsdbDumpMDA("tb.u_afifo.my_memory");
	end
end


//-----------------------------------------------------------
initial
begin
	wr_clk = 1'b0; 
	#1;
	forever 
	begin
		#(1e9/(2.0*40e6)) wr_clk = ~wr_clk;
	end
end


initial
begin
	wr_rst_n = 0;
	#30 wr_rst_n = 1;
end


initial
begin
	rd_clk = 1'b0; 
	#2;
	forever 
	begin
		#(1e9/(2.0*20e6)) rd_clk = ~rd_clk;
	end
end


initial
begin
	rd_rst_n     = 0;
	#40 rd_rst_n = 1;
end


initial
begin
	clk = 1'b0; 
	#3;
	forever 
	begin
		#(1e9/(2.0*1e9)) clk = ~clk;
	end
end


initial
begin
	wr_clk_r = 0;   

	forever
	begin
		@(posedge clk);
		if (wr_clk)
			#0.1 wr_clk_r = 1;
		else
			#0.1 wr_clk_r = 0;
	end
end


initial
begin
	rd_clk_r = 0;   

	forever
	begin
		@(posedge clk);
		if (rd_clk)
			#0.1 rd_clk_r = 1;
		else
			#0.1 rd_clk_r = 0;
	end
end


assign wr_clk_rise = wr_clk & ~wr_clk_r;
assign rd_clk_rise = rd_clk & ~rd_clk_r;


initial
begin
	wr           = 0;
	rd           = 0;
	wr_dat       = 0;
	wr_cnt       = 0;
	rd_cnt       = 0;
	sample_full  = 0;
	sample_empty = 0;

	@(posedge rd_rst_n);   

	forever
	begin
		@(posedge clk);
		if (rd_cnt >= 1e4)
			break;

		fork
			begin
				if (wr_clk_rise)
				begin
					sample_full  = full;
					#1;
					wr = {$random(seed)}%2;

					if ((~sample_full) & wr)
					begin
						wr_array[wr_cnt] ={$random(seed)}%32;
						wr_dat = wr_array[wr_cnt];
						wr_cnt = wr_cnt + 1; 
					end
					else
						wr = 0;
				end
			end

			begin
				if (rd_clk_rise)
				begin
					sample_empty = empty;

					if (rd_dat_vld)
					begin
						rd_array[rd_cnt] = rd_dat;
						rd_cnt = rd_cnt + 1;
					end

					#1;
					rd = {$random(seed)}%2;
					if (~((~sample_empty) & rd))
						rd = 0;
				end
			end
		join
	end

	//check
	file1 = $fopen("wr_fifo.txt","w");
	file2 = $fopen("rd_fifo.txt","w");
	for (cnt=0; cnt<rd_cnt; cnt++)
	begin
		if (rd_array[cnt] != wr_array[cnt])
			$display("err in address: %d", cnt);

		$fdisplay(file1, "%x",wr_array[cnt]);
		$fdisplay(file2, "%x",rd_array[cnt]);
	end
	$fclose(file1);
	$fclose(file2);

	$finish;
end

//------------------------------------------------------------
afifo     
#(
	.DEEPWID    (3) ,
	.DEEP       (8) ,
	.BITWID     (5)    
)
u_afifo
(
	.wr_clk             (wr_clk             ),//i                
	.wr_rst_n           (wr_rst_n           ),//i                
	.wr                 (wr                 ),//i                
	.wr_dat             (wr_dat             ),//i[BITWID-1:0]    

	.rd_clk             (rd_clk             ),//i
	.rd_rst_n           (rd_rst_n           ),//i
	.rd                 (rd                 ),//i                
	.rd_dat             (rd_dat             ),//o[BITWID-1:0]     
	.rd_dat_vld         (rd_dat_vld         ),//o

	.cfg_almost_full    (6                  ),//i[DEEPWID-1:0]   
	.cfg_almost_empty   (2                  ),//i[DEEPWID-1:0]   
	.almost_full        (almost_full        ),//o                
	.almost_empty       (almost_empty       ),//o                
	.full               (full               ),//o                
	.empty              (empty              ),//o                      
	.wr_num             (wr_num             ),//o[DEEPWID:0]
	.rd_num             (rd_num             ) //o[DEEPWID:0]
);

endmodule

