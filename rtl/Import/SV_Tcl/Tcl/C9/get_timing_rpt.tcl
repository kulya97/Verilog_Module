#File: get_timing_rpt.tcl
set mynet [get_selected_objects]
report_timing -through $mynet -nworst 10 \
    -setup -name timing_rpt
