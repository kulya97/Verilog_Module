# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set CLK_FRE [ipgui::add_param $IPINST -name "CLK_FRE" -parent ${Page_0}]
  set_property tooltip {主时钟频率MHz} ${CLK_FRE}
  set LOOP [ipgui::add_param $IPINST -name "LOOP" -parent ${Page_0}]
  set_property tooltip {是否循环定时，1循环定时，0单次定时} ${LOOP}
  set TIMING_US [ipgui::add_param $IPINST -name "TIMING_US" -parent ${Page_0}]
  set_property tooltip {定时时间us} ${TIMING_US}


}

proc update_PARAM_VALUE.CLK_FRE { PARAM_VALUE.CLK_FRE } {
	# Procedure called to update CLK_FRE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_FRE { PARAM_VALUE.CLK_FRE } {
	# Procedure called to validate CLK_FRE
	return true
}

proc update_PARAM_VALUE.LOOP { PARAM_VALUE.LOOP } {
	# Procedure called to update LOOP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOOP { PARAM_VALUE.LOOP } {
	# Procedure called to validate LOOP
	return true
}

proc update_PARAM_VALUE.TIMING_US { PARAM_VALUE.TIMING_US } {
	# Procedure called to update TIMING_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIMING_US { PARAM_VALUE.TIMING_US } {
	# Procedure called to validate TIMING_US
	return true
}


proc update_MODELPARAM_VALUE.CLK_FRE { MODELPARAM_VALUE.CLK_FRE PARAM_VALUE.CLK_FRE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_FRE}] ${MODELPARAM_VALUE.CLK_FRE}
}

proc update_MODELPARAM_VALUE.TIMING_US { MODELPARAM_VALUE.TIMING_US PARAM_VALUE.TIMING_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TIMING_US}] ${MODELPARAM_VALUE.TIMING_US}
}

proc update_MODELPARAM_VALUE.LOOP { MODELPARAM_VALUE.LOOP PARAM_VALUE.LOOP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOOP}] ${MODELPARAM_VALUE.LOOP}
}

