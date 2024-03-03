#File: check_ff_7fpga.tcl
set mypart [get_parts xc7k70tfbg484-3]
link_design -part $mypart
set slice SLICE_X0Y0
set ff_in_slice [get_bels -filter "TYPE==FF_INIT" \
    -of [get_sites $slice]]
set ffL_in_slice [get_bels -filter "TYPE==REG_INIT" \
    -of [get_sites $slice]]
puts "#N FF in one slice: \
    [expr {[llength $ff_in_slice] + [llength $ffL_in_slice]}]"

