#File: non_prj_force_replication.tcl
opt_design -directive Explore
place_design -directive Explore
phys_opt_design -directive Explore
phys_opt_design -force_replication_on_nets [get_nets [list netA netB netC]]
route_design -directive Explore
