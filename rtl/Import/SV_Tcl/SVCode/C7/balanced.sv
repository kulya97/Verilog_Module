//Inputs are registered AREG=BREG=1
always @(posedge <clk>) begin
	<ar_d> <= <ar>;
	<ai_d> <= <ai>;
	<bi_d> <= <bi>;
	<br_d> <= <br>;
end

//Balance Pipeline ADREG=0
assign	<addcommon> = <ar_d> - <ai_d>;
assign 	<addr> = <br_d> - <bi_d>;
assign	<addi> = <br_d> + <bi_d>;

//Common factor (ar-ai)*bi, shared for calculations of real & imaginary final
//products
assign <multcommon> = <bi_d> * <addcommon>;
assign <multr> = <ar_d> * <addr>;
assign <multi> = <ai_d> * <addi>;

//Multiplier outputs are registered MREG=1
always @(posedge <clk>) begin
	<multcommon_d> <= <multcommon>;
	<multr_d> <= <multr>;
	<multi_d> <= <multi>;
end

//Complex outputs are registered PREG=1
always @(posedge <clk>) begin
	<pr> <=  <multcommon_d> + <multr_d>;
	<pi> <=  <multcommon_d> + <multi_d>;
end
