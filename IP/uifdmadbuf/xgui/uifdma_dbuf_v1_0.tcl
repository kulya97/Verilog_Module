# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set optinal [ipgui::add_group $IPINST -name "optinal" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "AXI_Lite" -parent ${optinal}
  ipgui::add_param $IPINST -name "ENABLE_READ" -parent ${optinal}
  ipgui::add_param $IPINST -name "ENABLE_WRITE" -parent ${optinal}
  ipgui::add_param $IPINST -name "VIDEO_ENABLE" -parent ${optinal}

  #Adding Group
  set axi_settings [ipgui::add_group $IPINST -name "axi settings" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "AXI_ADDR_WIDTH" -parent ${axi_settings}
  ipgui::add_param $IPINST -name "AXI_DATA_WIDTH" -parent ${axi_settings}

  #Adding Group
  set buf_settings [ipgui::add_group $IPINST -name "buf settings" -parent ${Page_0} -layout horizontal]
  #Adding Group
  set write_settings [ipgui::add_group $IPINST -name "write settings" -parent ${buf_settings}]
  ipgui::add_param $IPINST -name "W_BUFDEPTH" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_BASEADDR" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_DSIZEBITS" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_BUFSIZE" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_DATAWIDTH" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_XDIV" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_XSIZE" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_XSTRIDE" -parent ${write_settings}
  ipgui::add_param $IPINST -name "W_YSIZE" -parent ${write_settings}

  #Adding Group
  set read_settings [ipgui::add_group $IPINST -name "read settings" -parent ${buf_settings}]
  ipgui::add_param $IPINST -name "R_BUFDEPTH" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_BASEADDR" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_DSIZEBITS" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_BUFSIZE" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_DATAWIDTH" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_XDIV" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_XSIZE" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_XSTRIDE" -parent ${read_settings}
  ipgui::add_param $IPINST -name "R_YSIZE" -parent ${read_settings}




}

proc update_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to update AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to validate AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to update AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to validate AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_Lite { PARAM_VALUE.AXI_Lite } {
	# Procedure called to update AXI_Lite when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_Lite { PARAM_VALUE.AXI_Lite } {
	# Procedure called to validate AXI_Lite
	return true
}

proc update_PARAM_VALUE.ENABLE_READ { PARAM_VALUE.ENABLE_READ } {
	# Procedure called to update ENABLE_READ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_READ { PARAM_VALUE.ENABLE_READ } {
	# Procedure called to validate ENABLE_READ
	return true
}

proc update_PARAM_VALUE.ENABLE_WRITE { PARAM_VALUE.ENABLE_WRITE } {
	# Procedure called to update ENABLE_WRITE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_WRITE { PARAM_VALUE.ENABLE_WRITE } {
	# Procedure called to validate ENABLE_WRITE
	return true
}

proc update_PARAM_VALUE.R_BASEADDR { PARAM_VALUE.R_BASEADDR } {
	# Procedure called to update R_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_BASEADDR { PARAM_VALUE.R_BASEADDR } {
	# Procedure called to validate R_BASEADDR
	return true
}

proc update_PARAM_VALUE.R_BUFDEPTH { PARAM_VALUE.R_BUFDEPTH } {
	# Procedure called to update R_BUFDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_BUFDEPTH { PARAM_VALUE.R_BUFDEPTH } {
	# Procedure called to validate R_BUFDEPTH
	return true
}

proc update_PARAM_VALUE.R_BUFSIZE { PARAM_VALUE.R_BUFSIZE } {
	# Procedure called to update R_BUFSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_BUFSIZE { PARAM_VALUE.R_BUFSIZE } {
	# Procedure called to validate R_BUFSIZE
	return true
}

proc update_PARAM_VALUE.R_DATAWIDTH { PARAM_VALUE.R_DATAWIDTH } {
	# Procedure called to update R_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_DATAWIDTH { PARAM_VALUE.R_DATAWIDTH } {
	# Procedure called to validate R_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.R_DSIZEBITS { PARAM_VALUE.R_DSIZEBITS } {
	# Procedure called to update R_DSIZEBITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_DSIZEBITS { PARAM_VALUE.R_DSIZEBITS } {
	# Procedure called to validate R_DSIZEBITS
	return true
}

proc update_PARAM_VALUE.R_XDIV { PARAM_VALUE.R_XDIV } {
	# Procedure called to update R_XDIV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_XDIV { PARAM_VALUE.R_XDIV } {
	# Procedure called to validate R_XDIV
	return true
}

proc update_PARAM_VALUE.R_XSIZE { PARAM_VALUE.R_XSIZE } {
	# Procedure called to update R_XSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_XSIZE { PARAM_VALUE.R_XSIZE } {
	# Procedure called to validate R_XSIZE
	return true
}

proc update_PARAM_VALUE.R_XSTRIDE { PARAM_VALUE.R_XSTRIDE } {
	# Procedure called to update R_XSTRIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_XSTRIDE { PARAM_VALUE.R_XSTRIDE } {
	# Procedure called to validate R_XSTRIDE
	return true
}

proc update_PARAM_VALUE.R_YSIZE { PARAM_VALUE.R_YSIZE } {
	# Procedure called to update R_YSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_YSIZE { PARAM_VALUE.R_YSIZE } {
	# Procedure called to validate R_YSIZE
	return true
}

proc update_PARAM_VALUE.VIDEO_ENABLE { PARAM_VALUE.VIDEO_ENABLE } {
	# Procedure called to update VIDEO_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VIDEO_ENABLE { PARAM_VALUE.VIDEO_ENABLE } {
	# Procedure called to validate VIDEO_ENABLE
	return true
}

proc update_PARAM_VALUE.W_BASEADDR { PARAM_VALUE.W_BASEADDR } {
	# Procedure called to update W_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_BASEADDR { PARAM_VALUE.W_BASEADDR } {
	# Procedure called to validate W_BASEADDR
	return true
}

proc update_PARAM_VALUE.W_BUFDEPTH { PARAM_VALUE.W_BUFDEPTH } {
	# Procedure called to update W_BUFDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_BUFDEPTH { PARAM_VALUE.W_BUFDEPTH } {
	# Procedure called to validate W_BUFDEPTH
	return true
}

proc update_PARAM_VALUE.W_BUFSIZE { PARAM_VALUE.W_BUFSIZE } {
	# Procedure called to update W_BUFSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_BUFSIZE { PARAM_VALUE.W_BUFSIZE } {
	# Procedure called to validate W_BUFSIZE
	return true
}

proc update_PARAM_VALUE.W_DATAWIDTH { PARAM_VALUE.W_DATAWIDTH } {
	# Procedure called to update W_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_DATAWIDTH { PARAM_VALUE.W_DATAWIDTH } {
	# Procedure called to validate W_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.W_DSIZEBITS { PARAM_VALUE.W_DSIZEBITS } {
	# Procedure called to update W_DSIZEBITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_DSIZEBITS { PARAM_VALUE.W_DSIZEBITS } {
	# Procedure called to validate W_DSIZEBITS
	return true
}

proc update_PARAM_VALUE.W_XDIV { PARAM_VALUE.W_XDIV } {
	# Procedure called to update W_XDIV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_XDIV { PARAM_VALUE.W_XDIV } {
	# Procedure called to validate W_XDIV
	return true
}

proc update_PARAM_VALUE.W_XSIZE { PARAM_VALUE.W_XSIZE } {
	# Procedure called to update W_XSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_XSIZE { PARAM_VALUE.W_XSIZE } {
	# Procedure called to validate W_XSIZE
	return true
}

proc update_PARAM_VALUE.W_XSTRIDE { PARAM_VALUE.W_XSTRIDE } {
	# Procedure called to update W_XSTRIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_XSTRIDE { PARAM_VALUE.W_XSTRIDE } {
	# Procedure called to validate W_XSTRIDE
	return true
}

proc update_PARAM_VALUE.W_YSIZE { PARAM_VALUE.W_YSIZE } {
	# Procedure called to update W_YSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_YSIZE { PARAM_VALUE.W_YSIZE } {
	# Procedure called to validate W_YSIZE
	return true
}


proc update_MODELPARAM_VALUE.AXI_Lite { MODELPARAM_VALUE.AXI_Lite PARAM_VALUE.AXI_Lite } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_Lite}] ${MODELPARAM_VALUE.AXI_Lite}
}

proc update_MODELPARAM_VALUE.VIDEO_ENABLE { MODELPARAM_VALUE.VIDEO_ENABLE PARAM_VALUE.VIDEO_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VIDEO_ENABLE}] ${MODELPARAM_VALUE.VIDEO_ENABLE}
}

proc update_MODELPARAM_VALUE.ENABLE_WRITE { MODELPARAM_VALUE.ENABLE_WRITE PARAM_VALUE.ENABLE_WRITE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_WRITE}] ${MODELPARAM_VALUE.ENABLE_WRITE}
}

proc update_MODELPARAM_VALUE.ENABLE_READ { MODELPARAM_VALUE.ENABLE_READ PARAM_VALUE.ENABLE_READ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_READ}] ${MODELPARAM_VALUE.ENABLE_READ}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH { MODELPARAM_VALUE.AXI_DATA_WIDTH PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ADDR_WIDTH { MODELPARAM_VALUE.AXI_ADDR_WIDTH PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.W_BUFDEPTH { MODELPARAM_VALUE.W_BUFDEPTH PARAM_VALUE.W_BUFDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_BUFDEPTH}] ${MODELPARAM_VALUE.W_BUFDEPTH}
}

proc update_MODELPARAM_VALUE.W_DATAWIDTH { MODELPARAM_VALUE.W_DATAWIDTH PARAM_VALUE.W_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_DATAWIDTH}] ${MODELPARAM_VALUE.W_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.W_BASEADDR { MODELPARAM_VALUE.W_BASEADDR PARAM_VALUE.W_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_BASEADDR}] ${MODELPARAM_VALUE.W_BASEADDR}
}

proc update_MODELPARAM_VALUE.W_DSIZEBITS { MODELPARAM_VALUE.W_DSIZEBITS PARAM_VALUE.W_DSIZEBITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_DSIZEBITS}] ${MODELPARAM_VALUE.W_DSIZEBITS}
}

proc update_MODELPARAM_VALUE.W_XSIZE { MODELPARAM_VALUE.W_XSIZE PARAM_VALUE.W_XSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_XSIZE}] ${MODELPARAM_VALUE.W_XSIZE}
}

proc update_MODELPARAM_VALUE.W_XSTRIDE { MODELPARAM_VALUE.W_XSTRIDE PARAM_VALUE.W_XSTRIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_XSTRIDE}] ${MODELPARAM_VALUE.W_XSTRIDE}
}

proc update_MODELPARAM_VALUE.W_YSIZE { MODELPARAM_VALUE.W_YSIZE PARAM_VALUE.W_YSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_YSIZE}] ${MODELPARAM_VALUE.W_YSIZE}
}

proc update_MODELPARAM_VALUE.W_XDIV { MODELPARAM_VALUE.W_XDIV PARAM_VALUE.W_XDIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_XDIV}] ${MODELPARAM_VALUE.W_XDIV}
}

proc update_MODELPARAM_VALUE.W_BUFSIZE { MODELPARAM_VALUE.W_BUFSIZE PARAM_VALUE.W_BUFSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_BUFSIZE}] ${MODELPARAM_VALUE.W_BUFSIZE}
}

proc update_MODELPARAM_VALUE.R_BUFDEPTH { MODELPARAM_VALUE.R_BUFDEPTH PARAM_VALUE.R_BUFDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_BUFDEPTH}] ${MODELPARAM_VALUE.R_BUFDEPTH}
}

proc update_MODELPARAM_VALUE.R_DATAWIDTH { MODELPARAM_VALUE.R_DATAWIDTH PARAM_VALUE.R_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_DATAWIDTH}] ${MODELPARAM_VALUE.R_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.R_BASEADDR { MODELPARAM_VALUE.R_BASEADDR PARAM_VALUE.R_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_BASEADDR}] ${MODELPARAM_VALUE.R_BASEADDR}
}

proc update_MODELPARAM_VALUE.R_DSIZEBITS { MODELPARAM_VALUE.R_DSIZEBITS PARAM_VALUE.R_DSIZEBITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_DSIZEBITS}] ${MODELPARAM_VALUE.R_DSIZEBITS}
}

proc update_MODELPARAM_VALUE.R_XSIZE { MODELPARAM_VALUE.R_XSIZE PARAM_VALUE.R_XSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_XSIZE}] ${MODELPARAM_VALUE.R_XSIZE}
}

proc update_MODELPARAM_VALUE.R_XSTRIDE { MODELPARAM_VALUE.R_XSTRIDE PARAM_VALUE.R_XSTRIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_XSTRIDE}] ${MODELPARAM_VALUE.R_XSTRIDE}
}

proc update_MODELPARAM_VALUE.R_YSIZE { MODELPARAM_VALUE.R_YSIZE PARAM_VALUE.R_YSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_YSIZE}] ${MODELPARAM_VALUE.R_YSIZE}
}

proc update_MODELPARAM_VALUE.R_XDIV { MODELPARAM_VALUE.R_XDIV PARAM_VALUE.R_XDIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_XDIV}] ${MODELPARAM_VALUE.R_XDIV}
}

proc update_MODELPARAM_VALUE.R_BUFSIZE { MODELPARAM_VALUE.R_BUFSIZE PARAM_VALUE.R_BUFSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_BUFSIZE}] ${MODELPARAM_VALUE.R_BUFSIZE}
}

