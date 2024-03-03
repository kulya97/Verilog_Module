#File: check_dsp_us.tcl
set mypart [get_parts xcvu5p-flva2104-2-i]
link_design -part $mypart
set slr [get_slrs SLR0]
set site_type DSP48E2
set dsp_one_slr [get_sites -filter "SITE_TYPE == $site_type" -of $slr]
set x {}
set y {}
foreach dsp_one_slr_i $dsp_one_slr {
    set loc [lindex [split $dsp_one_slr_i _] 1]
    set xy  [split $loc XY]
    lappend x [lindex $xy 1]
    lappend y [lindex $xy 2]
}
set col_index_slr [lsort -integer -unique $x]
set row_index_slr [lsort -integer -unique $y]

set cr [get_clock_regions X0Y0]
set dsps_one_cr [get_sites -filter "SITE_TYPE == $site_type" -of $cr]
set x {}
set y {}
foreach dsps_one_cr_i $dsps_one_cr {
    set loc [lindex [split $dsps_one_cr_i _] 1]
    set xy [split $loc XY]
    lappend x [lindex $xy 1]
    lappend y [lindex $xy 2]
}
set col_index [lsort -integer -unique $x]
set row_index [lsort -integer -unique $y]
puts "Number of $site_type columns in $slr : [llength $col_index_slr]"
puts "Height of SLR by $site_type : [llength $row_index_slr]"
puts "Number of $site_type columns in CR $cr : [llength $col_index]"
puts "Height of CR by $site_type : [llength $row_index]"
