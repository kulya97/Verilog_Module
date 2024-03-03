#File: check_srl_us.tcl
set mypart [get_parts xcvu5p-flva2104-2-i]
link_design -part $mypart
set slice [get_sites SLICE_X1Y0]
set lutram_in_slice [get_bels -filter "NAME=~*6LUT" -of $slice]
puts "The number of LUTRAM in one SLICEM: [llength $lutram_in_slice]"
