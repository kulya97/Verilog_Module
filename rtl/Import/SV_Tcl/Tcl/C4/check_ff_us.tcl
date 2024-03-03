#File: check_ff_us.tcl
set mypart [get_parts xcvu5p-flva2104-2-i]
link_design -part $mypart
set slice SLICE_X0Y0
set ff_in_slice [get_bels "*FF*" -of [get_sites $slice]]
puts "#N FF in one slice: [llength $ff_in_slice]"



