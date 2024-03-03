#File: check_ff_versal.tcl
set mypart [get_parts xcvc1902-vsva2197-2MP-e-S]
link_design -part $mypart
set slice SLICE_X40Y0
set ff_in_slice [get_bels -filter "TYPE==FF" -of [get_sites $slice]]
puts "#N FF in one slice: [llength $ff_in_slice]"
