#File: check_bram_us.tcl
set mypart [get_parts xcvu5p-flva2104-2-i]
link_design -part $mypart
set slr [get_slrs SLR0]
set bram_one_slr [get_sites RAMB36* -of $slr]
set x {}
set y {}
foreach bram_one_slr_i $bram_one_slr {
    set loc [lindex [split $bram_one_slr_i _] 1]
    set xy  [split $loc XY]
    lappend x [lindex $xy 1]
    lappend y [lindex $xy 2]
}
set col_index_slr [lsort -integer -unique $x]
set row_index_slr [lsort -integer -unique $y]

set cr [get_clock_regions X0Y0]
set brams_one_cr [get_sites RAMB36* -of $cr]
set x {}
set y {}
foreach brams_one_cr_i $brams_one_cr {
    set loc [lindex [split $brams_one_cr_i _] 1]
    set xy [split $loc XY]
    lappend x [lindex $xy 1]
    lappend y [lindex $xy 2]
}
set col_index [lsort -integer -unique $x]
set row_index [lsort -integer -unique $y]
puts "Number of Block RAM columns in SLR $slr: [llength $col_index_slr]"
puts "Height of SLR by Block RAM: [llength $row_index_slr]"
puts "Number of Block RAM columns in CR $cr: [llength $col_index]"
puts "Height of CR by Block RAM: [llength $row_index]"
