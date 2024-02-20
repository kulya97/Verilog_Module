`timescale 1ns / 1ps
module h_delay#
(
	parameter[31:0]CNT = 32'h00ffff00
)(
	input i_clk,
	input i_rstn,
	output o_rstn
    );

reg[31:0] cnt = 32'd0;
reg r_rstn_d0;

/*count for clock*/
always@(posedge i_clk)
begin 
    if(!i_rstn)
    begin
       cnt<=32'd0; 
    end
    else if(cnt < CNT)begin
	   cnt <= cnt + 1'b1;
	end
    else
        cnt <= cnt;
end

/*generate output signal*/
always@(posedge i_clk)
begin
    if(!i_rstn)
    begin
        r_rstn_d0 <= 1'b0; 
    end
    else begin
	   r_rstn_d0 <= ( cnt == CNT);
	end
end	

assign o_rstn = r_rstn_d0;

endmodule

