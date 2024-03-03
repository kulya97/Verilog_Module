#File: check_bufg_ps.tcl
link_design -part [get_parts xczu4eg-fbvb900-1-e]
set bufg_ps [get_sites "BUFG_PS*"]
llength $bufg_ps
mark_objects $bufg_ps -color red
