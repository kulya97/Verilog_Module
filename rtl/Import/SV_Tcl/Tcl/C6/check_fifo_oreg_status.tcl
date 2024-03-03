#File: check_fifo_oreg_status.tcl
set family us 
if {$family == 7} {
    set prim_type BMEM.fifo.* 
} else {
    set prim_type BLOCKRAM.FIFO.* 
}
set myfifo [get_cells -hier -filter "PRIMITIVE_TYPE =~ $prim_type"] 
set myfifo_without_oreg {}
if {[llength $myfifo] > 0} {
    foreach i_myfifo $myfifo {
        set oreg_status [get_property DO_REG $i_myfifo]
        if {$oreg_status == 0} {
            lappend myfifo_without_oreg $i_myfifo
        }
    }
}
if {[llength $myfifo_without_oreg] > 0} {
    show_objects $myfifo_without_oreg -name FIFO_REVIEW
} else {
    puts "All FIFOs use embedded registers"
}

