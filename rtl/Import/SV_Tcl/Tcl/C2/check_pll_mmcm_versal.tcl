#File: check_pll_mmem_versal.tcl
link_design -part [get_parts xcvc1902-viva1596-1LHP-i-L]
set mmcm [get_sites "MMCM*"]
set dpll [get_sites "DPLL*"]
set xpll [get_sites "XPLL*"]
mark_objects $dpll -color green
mark_objects $mmcm -color yellow
mark_objects $xpll -color cyan
set mmcm_in_x0y0 [get_sites "MMCM*" -of [get_clock_regions X0Y0]] 
set dpll_in_x0y0 [get_sites "DPLL*" -of [get_clock_regions X0Y0]] 
set xpll_in_x0y0 [get_sites "XPLL*" -of [get_clock_regions X0Y0]] 
set dpll_in_x0y4 [get_sites "DPLL*" -of [get_clock_regions X0Y4]] 
puts "#MMCM in each XPIO bank: [llength $mmcm_in_x0y0]"
puts "#DPLL in each XPIO bank: [llength $dpll_in_x0y0]"
puts "#XPLL in each XPIO bank: [llength $xpll_in_x0y0]"
puts "#DPLL in each CR adjacent to GT: [llength $dpll_in_x0y4]"
