#File: report_max_clock_skew.tcl
proc report_max_clock_skew {max_paths} {
    set clks [get_clocks] 
    set f [open skew.csv w]
    
    foreach ana_ele [list setup hold] {
        foreach i_clks $clks {
            if { [llength [get_timing_paths \
                -from  $i_clks -to  $i_clks]] == 0} {
                puts "No timing paths found for clock $i_clks"
                continue
            }	
            set skew_val [get_property SKEW \
                [get_timing_paths -from $i_clks \
                -to $i_clks -max $max_paths -$ana_ele]]
            set skew_val_abs [list]
            foreach val $skew_val {
                lappend skew_val_abs [expr abs($val)]
            }
            set max_skew_abs [lindex \
                [lsort -decreasing $skew_val_abs] 0]
            if {[lsearch $skew_val $max_skew_abs]== -1} {
                set max_skew_val [expr $max_skew_abs * (-1)]
            } else {
                set max_skew_val $max_skew_abs
            }
            puts "The max clock skew of Clock \ 
                $i_clks ($ana_ele) = $max_skew_val"
            puts $f [join "$i_clks $ana_ele $max_skew_val" ,]
        }
    }
    close $f
}
