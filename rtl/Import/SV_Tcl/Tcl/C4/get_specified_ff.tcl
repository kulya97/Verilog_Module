#File: get_specified_ff.tcl
set ref_name FDRE
set myff [get_cells -hier -filter "REF_NAME==$ref_name"]
if {[llength $myff] > 0} {
  show_objects $myff -name "my$ref_name"
}

