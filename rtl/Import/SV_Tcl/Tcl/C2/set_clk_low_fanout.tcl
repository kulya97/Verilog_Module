#File: set_clk_low_fanout.tcl
set_property CLOCK_LOW_FANOUT TRUE [get_nets -of \
    [get_pins clkOut0_bufg_inst/O]]
