#File: change_clk_root.tcl
set clk_net [get_nets clk_gen/sys_clk]
set_property USER_CLOCK_ROOT X5Y5 [get_nets $clk_net]
route_design -unroute -nets [get_nets $clk_net]
update_clock_routing
