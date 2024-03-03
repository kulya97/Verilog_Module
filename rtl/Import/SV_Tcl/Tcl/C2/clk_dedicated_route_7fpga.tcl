#File: clk_dedicated_route_7fpga.tcl
set_property CLOCK_DEDICATED_ROUTE FALSE \
[get_nets -of [get_pins MMCME4_ADV_inst/CLKOUT0]]
set_property CLOCK_DEDICATED_ROUTE FALSE \
[get_nets -of [get_pins IBUF_inst/O]]
