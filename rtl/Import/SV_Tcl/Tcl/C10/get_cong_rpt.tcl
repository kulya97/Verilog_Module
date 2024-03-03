#File: get_cong_rpt.tcl
report_design_analysis -congestion -name cong_rpt1
report_design_analysis -complexity -timing -setup -max_paths 100 \
    -congestion -name cong_rpt2
