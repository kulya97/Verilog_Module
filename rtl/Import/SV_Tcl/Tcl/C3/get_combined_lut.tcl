#File: get_combined_lut.tcl
set combined_lut [get_cells -hier -filter {SOFT_HLUTNM != "" || HLUTNM != ""}]
puts "Number of Combined LUT: [llength $combined_lut]"
get_property SOFT_HLUTNM $combined_lut
get_property HLUTNM $combined_lut
