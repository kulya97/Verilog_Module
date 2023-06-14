# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set BPS [ipgui::add_param $IPINST -name "BPS" -parent ${Page_0}]
  set_property tooltip {波特率} ${BPS}
  set CLK_FRE [ipgui::add_param $IPINST -name "CLK_FRE" -parent ${Page_0}]
  set_property tooltip {时钟频率MHz} ${CLK_FRE}
  set IDLE_CYCLE [ipgui::add_param $IPINST -name "IDLE_CYCLE" -parent ${Page_0}]
  set_property tooltip {触发空闲中断的时间，单位是传输一个bit时间} ${IDLE_CYCLE}
  set REG_WIDTH [ipgui::add_param $IPINST -name "REG_WIDTH" -parent ${Page_0}]
  set_property tooltip {输出寄存器位宽} ${REG_WIDTH}


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

