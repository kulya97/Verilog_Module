#File: check_srl_versal.tcl
set mypart [get_parts xcvc1902-vsva2197-2MP-e-S]
link_design -part $mypart
set slice [get_sites SLICE_X79Y52]
set lutram_in_slice [get_bels -filter "TYPE==SLICEM_LUT6" -of $slice]
puts "The number of LUTRAM in one SLICEM: [llength $lutram_in_slice]"
