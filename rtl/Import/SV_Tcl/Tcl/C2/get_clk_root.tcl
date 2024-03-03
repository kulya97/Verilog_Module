#File: get_clk_root.tcl
set clk_net [get_nets clk_gen/sys_clk]
set clk_root [get_property CLOCK_ROOT $clk_net]
puts "Clock root: $clk_root"
report_clock_utilization -clock_roots_only -name clock_root
set loads [get_cells -of [get_pins -of $clk_net -leaf]]
puts "#Loads of $clk_net: [llength $loads]"
highlight_objects $loads -color red
report_clock_utilization -clock_roots_only -name clock_root


