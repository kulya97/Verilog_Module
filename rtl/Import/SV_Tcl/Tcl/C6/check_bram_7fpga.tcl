#File: check_bram_7fpga.tcl
set mypart [get_parts xc7k70tfbg484-3]
link_design -part $mypart
set bram36_one_col [get_sites "RAMB36_X0Y*" -of [get_slrs SLR0]]
puts "The number of RAMB36 in one column: [llength $bram36_one_col]"
set bram18_one_col [get_sites "RAMB18_X0Y*" -of [get_slrs SLR0]]
puts "The number of RAMB18 in one column: [llength $bram18_one_col]"
