# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "W_FIFODEPTH"

}

proc update_PARAM_VALUE.W_FIFODEPTH { PARAM_VALUE.W_FIFODEPTH } {
	# Procedure called to update W_FIFODEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_FIFODEPTH { PARAM_VALUE.W_FIFODEPTH } {
	# Procedure called to validate W_FIFODEPTH
	return true
}


proc update_MODELPARAM_VALUE.W_FIFODEPTH { MODELPARAM_VALUE.W_FIFODEPTH PARAM_VALUE.W_FIFODEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_FIFODEPTH}] ${MODELPARAM_VALUE.W_FIFODEPTH}
}

