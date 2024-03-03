#File: check_bel_in_slice.tcl
set mypart [get_parts xc7k70tfbg484-3]
link_design -part $mypart
set slice [get_sites SLICE_X0Y0]
set lut6 [get_bels -of $slice -filter "NAME =~ *6LUT"]
set f7mux [get_bels -of $slice -filter "NAME =~ *F7*"]
set f8mux [get_bels -of $slice -filter "NAME =~ *F8*"]
set f9mux [get_bels -of $slice -filter "NAME =~ *F9*"]
puts "#N LUT6 in one SLICE: [llength $lut6]"
puts "#N F7MUX in one SLICE: [llength $f7mux]"
puts "#N F8MUX in one SLICE: [llength $f8mux]"
puts "#N F9MUX in one SLICE: [llength $f9mux]"
