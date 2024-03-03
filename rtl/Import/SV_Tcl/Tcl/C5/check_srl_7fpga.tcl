#File: check_srl_7fpga.tcl
set mypart [get_parts xc7k70tfbg484-3]
link_design -part $mypart
set slice [get_sites SLICE_X2Y0]
set lutram_in_slice [get_bels -filter "TYPE==LUT_OR_MEM6" -of $slice]
puts "The number of LUTRAM in one SLICEM: [llength $lutram_in_slice]"
