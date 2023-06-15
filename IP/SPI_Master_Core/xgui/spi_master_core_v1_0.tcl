# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set CHANNEL [ipgui::add_param $IPINST -name "CHANNEL" -parent ${Page_0}]
  set_property tooltip {spi通道数} ${CHANNEL}
  set CLK_DIV [ipgui::add_param $IPINST -name "CLK_DIV" -parent ${Page_0}]
  set_property tooltip {时钟分频系数} ${CLK_DIV}
  set CPHA [ipgui::add_param $IPINST -name "CPHA" -parent ${Page_0}]
  set_property tooltip {时钟相位 H sck第二个跳变沿采样，L sck第一个跳变沿采样} ${CPHA}
  set CPOL [ipgui::add_param $IPINST -name "CPOL" -parent ${Page_0}]
  set_property tooltip {时钟极性 ，H idle时为高} ${CPOL}
  set REG_WIDTH [ipgui::add_param $IPINST -name "REG_WIDTH" -parent ${Page_0}]
  set_property tooltip {读写数据位宽} ${REG_WIDTH}


}

proc update_PARAM_VALUE.CHANNEL { PARAM_VALUE.CHANNEL } {
	# Procedure called to update CHANNEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL { PARAM_VALUE.CHANNEL } {
	# Procedure called to validate CHANNEL
	return true
}

proc update_PARAM_VALUE.CLK_DIV { PARAM_VALUE.CLK_DIV } {
	# Procedure called to update CLK_DIV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_DIV { PARAM_VALUE.CLK_DIV } {
	# Procedure called to validate CLK_DIV
	return true
}

proc update_PARAM_VALUE.CPHA { PARAM_VALUE.CPHA } {
	# Procedure called to update CPHA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CPHA { PARAM_VALUE.CPHA } {
	# Procedure called to validate CPHA
	return true
}

proc update_PARAM_VALUE.CPOL { PARAM_VALUE.CPOL } {
	# Procedure called to update CPOL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CPOL { PARAM_VALUE.CPOL } {
	# Procedure called to validate CPOL
	return true
}

proc update_PARAM_VALUE.REG_WIDTH { PARAM_VALUE.REG_WIDTH } {
	# Procedure called to update REG_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REG_WIDTH { PARAM_VALUE.REG_WIDTH } {
	# Procedure called to validate REG_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.CHANNEL { MODELPARAM_VALUE.CHANNEL PARAM_VALUE.CHANNEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL}] ${MODELPARAM_VALUE.CHANNEL}
}

proc update_MODELPARAM_VALUE.REG_WIDTH { MODELPARAM_VALUE.REG_WIDTH PARAM_VALUE.REG_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REG_WIDTH}] ${MODELPARAM_VALUE.REG_WIDTH}
}

proc update_MODELPARAM_VALUE.CPOL { MODELPARAM_VALUE.CPOL PARAM_VALUE.CPOL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CPOL}] ${MODELPARAM_VALUE.CPOL}
}

proc update_MODELPARAM_VALUE.CPHA { MODELPARAM_VALUE.CPHA PARAM_VALUE.CPHA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CPHA}] ${MODELPARAM_VALUE.CPHA}
}

proc update_MODELPARAM_VALUE.CLK_DIV { MODELPARAM_VALUE.CLK_DIV PARAM_VALUE.CLK_DIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_DIV}] ${MODELPARAM_VALUE.CLK_DIV}
}

