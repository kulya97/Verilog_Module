# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "XMDA_REQ_NUM" -parent ${Page_0}


}

proc update_PARAM_VALUE.XMDA_REQ_NUM { PARAM_VALUE.XMDA_REQ_NUM } {
	# Procedure called to update XMDA_REQ_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.XMDA_REQ_NUM { PARAM_VALUE.XMDA_REQ_NUM } {
	# Procedure called to validate XMDA_REQ_NUM
	return true
}


proc update_MODELPARAM_VALUE.XMDA_REQ_NUM { MODELPARAM_VALUE.XMDA_REQ_NUM PARAM_VALUE.XMDA_REQ_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XMDA_REQ_NUM}] ${MODELPARAM_VALUE.XMDA_REQ_NUM}
}

