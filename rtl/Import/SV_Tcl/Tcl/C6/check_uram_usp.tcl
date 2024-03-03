#File: check_uram_usp.tcl
set mypart [get_parts xcvu5p-flva2104-2-i]
link_design -part $mypart
set slr [get_slrs SLR0]
set uram_one_slr [get_sites URAM288* -of $slr]
set x {}
set y {}
foreach uram_one_slr_i $uram_one_slr {
    set loc [lindex [split $uram_one_slr_i _] 1]
    set xy  [split $loc XY]
    lappend x [lindex $xy 1]
    lappend y [lindex $xy 2]
}
set col_index_slr [lsort -integer -unique $x]
set row_index_slr [lsort -integer -unique $y]
highlight_objects $uram_one_slr -color red
set cr_with_uram [lsort -unique [get_property CLOCK_REGION $uram_one_slr]]

set cr [get_clock_regions [lindex $cr_with_uram 0]]
set urams_one_cr [get_sites URAM288* -of $cr]
set x {}
set y {}
foreach urams_one_cr_i $urams_one_cr {
    set loc [lindex [split $urams_one_cr_i _] 1]
    set xy [split $loc XY]
    lappend x [lindex $xy 1]
    lappend y [lindex $xy 2]
}
set col_index [lsort -integer -unique $x]
set row_index [lsort -integer -unique $y]
puts "Number of URAM columns in SLR $slr: [llength $col_index_slr]"
puts "Height of SLR by URAM: [llength $row_index_slr]"
puts "Number of URAM columns in CR $cr: [llength $col_index]"
puts "Height of CR by URAM: [llength $row_index]"
