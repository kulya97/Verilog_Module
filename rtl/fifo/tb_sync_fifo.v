`timescale 1ns/1ns
module tb_sync_fifo;
parameter 			WIDTH		=	16		;
parameter 			DEPTH		=	512    	;
parameter 			ADDR_WIDTH	=	9       ;
parameter 			PROG_EMPTY	=	100     ;
parameter 			PROG_FULL	=	400     ;
reg 				sys_clk		;
reg 				sys_rst		;
reg  [WIDTH-1:0]	din    		;
reg 				wr_en  		;
reg 				rd_en  		;
reg	 [11:0]			cnt			;	
wire [WIDTH-1:0]	dout		;
wire 				full        ;
wire 				empty       ;
wire 				prog_full   ;
wire 				prog_empty  ;
wire [ADDR_WIDTH-1:0]fifo_cnt   ;
 
initial	begin
	sys_clk		=	0;
	sys_rst		=	1;
	#100
	sys_rst		=	0;
end
always #5	sys_clk	=	~sys_clk;
 
always @ (posedge sys_clk or posedge sys_rst)begin
	if(sys_rst)
		cnt			<=		'b0;
	else
		cnt			<=		cnt + 1'd1;
end
always @ (posedge sys_clk or posedge sys_rst)begin
	if(sys_rst)begin
		wr_en		<=		1'b0;
		rd_en		<=		1'b0;
		din			<=		16'b0;
		end
	else if(cnt >= 'd10 && cnt <= DEPTH + 'd40)begin
		wr_en		<=		1'b1;
		rd_en		<=		1'b0;
		din			<=		din + 1'd1;
		end
	else if((cnt >= 'd100 + DEPTH) && (cnt <= 2*DEPTH + 'd140))begin
		wr_en		<=		1'b0;
		rd_en		<=		1'b1;
		din			<=		'b0;
		end
	else begin
		wr_en		<=		1'b0;
		rd_en		<=		1'b0;
		din			<=		'b0;
		end
end
syn_fifo#(
	.WIDTH			(	WIDTH		),
	.DEPTH			(	DEPTH		),
	.ADDR_WIDTH		(	ADDR_WIDTH	),
	.PROG_EMPTY		(	PROG_EMPTY	),
	.PROG_FULL		(	PROG_FULL	)
)u_syn_fifo(
	.sys_clk		(	sys_clk		),
	.sys_rst        (	sys_rst     ),
	.din            (	din         ),
	.wr_en          (	wr_en       ),
	.rd_en          (	rd_en       ),
	.dout           (	dout        ),
	.full           (	full        ),
	.empty          (	empty       ),
	.prog_full      (	prog_full   ),
	.prog_empty     (	prog_empty  ),
	.fifo_cnt       (	fifo_cnt    )
);
endmodule