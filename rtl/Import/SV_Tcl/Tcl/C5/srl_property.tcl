#File: srl_property.tcl
set_property REG_TO_SRL TRUE [get_cells usbEngine/q_reg]
set_property SRL_TO_REG TRUE [get_cells usbEngine/d_srl3]
set_property SRL_STAGES_TO_REG_INPUT 1 [get_cells usbEngine/d_srl3]
set_property SRL_STAGES_TO_REG_OUTPUT 1 [get_cells usbEngine/d_srl3]
