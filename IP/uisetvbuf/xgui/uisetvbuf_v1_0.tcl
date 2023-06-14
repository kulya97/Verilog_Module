# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BUF_DELAY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BUF_LENTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.BUF_DELAY { PARAM_VALUE.BUF_DELAY } {
	# Procedure called to update BUF_DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUF_DELAY { PARAM_VALUE.BUF_DELAY } {
	# Procedure called to validate BUF_DELAY
	return true
}

proc update_PARAM_VALUE.BUF_LENTH { PARAM_VALUE.BUF_LENTH } {
	# Procedure called to update BUF_LENTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUF_LENTH { PARAM_VALUE.BUF_LENTH } {
	# Procedure called to validate BUF_LENTH
	return true
}


proc update_MODELPARAM_VALUE.BUF_DELAY { MODELPARAM_VALUE.BUF_DELAY PARAM_VALUE.BUF_DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUF_DELAY}] ${MODELPARAM_VALUE.BUF_DELAY}
}

proc update_MODELPARAM_VALUE.BUF_LENTH { MODELPARAM_VALUE.BUF_LENTH PARAM_VALUE.BUF_LENTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUF_LENTH}] ${MODELPARAM_VALUE.BUF_LENTH}
}

