#File: get_load.tcl
set mynet [get_selected_objects]
set myload [get_cells -of [get_pins -leaf -of \
    [get_nets $mynet] -filter "DIRECTION==IN"]]
show_objects $myload -name myload
