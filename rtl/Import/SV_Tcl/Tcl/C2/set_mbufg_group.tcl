#File: set_mbufg_group.tcl
set_property MBUFG_GROUP group_0 [get_nets -of_objects \
    [get_pins clk_wizard_0/inst/clock_primitive_inst/BUFG_clkout1_inst/O]]
set_property MBUFG_GROUP group_0 [get_nets -of_objects \
    [get_pins clk_wizard_0/inst/clock_primitive_inst/BUFG_clkout2_inst/O]]
