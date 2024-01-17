# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "CLK_FRE"
  ipgui::add_param $IPINST -name "BPS"
  ipgui::add_param $IPINST -name "IDLE_CYCLE"
  ipgui::add_param $IPINST -name "REG_WIDTH"

}

proc update_PARAM_VALUE.BPS { PARAM_VALUE.BPS } {
	# Procedure called to update BPS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BPS { PARAM_VALUE.BPS } {
	# Procedure called to validate BPS
	return true
}

proc update_PARAM_VALUE.CLK_FRE { PARAM_VALUE.CLK_FRE } {
	# Procedure called to update CLK_FRE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_FRE { PARAM_VALUE.CLK_FRE } {
	# Procedure called to validate CLK_FRE
	return true
}

proc update_PARAM_VALUE.IDLE_CYCLE { PARAM_VALUE.IDLE_CYCLE } {
	# Procedure called to update IDLE_CYCLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IDLE_CYCLE { PARAM_VALUE.IDLE_CYCLE } {
	# Procedure called to validate IDLE_CYCLE
	return true
}

proc update_PARAM_VALUE.REG_WIDTH { PARAM_VALUE.REG_WIDTH } {
	# Procedure called to update REG_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REG_WIDTH { PARAM_VALUE.REG_WIDTH } {
	# Procedure called to validate REG_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.CLK_FRE { MODELPARAM_VALUE.CLK_FRE PARAM_VALUE.CLK_FRE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_FRE}] ${MODELPARAM_VALUE.CLK_FRE}
}

proc update_MODELPARAM_VALUE.BPS { MODELPARAM_VALUE.BPS PARAM_VALUE.BPS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BPS}] ${MODELPARAM_VALUE.BPS}
}

proc update_MODELPARAM_VALUE.IDLE_CYCLE { MODELPARAM_VALUE.IDLE_CYCLE PARAM_VALUE.IDLE_CYCLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IDLE_CYCLE}] ${MODELPARAM_VALUE.IDLE_CYCLE}
}

proc update_MODELPARAM_VALUE.REG_WIDTH { MODELPARAM_VALUE.REG_WIDTH PARAM_VALUE.REG_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REG_WIDTH}] ${MODELPARAM_VALUE.REG_WIDTH}
}

