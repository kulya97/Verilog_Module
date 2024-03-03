#File: cdc_constraint.tcl
set clk_tx_period [get_property PERIOD [get_clocks clk1]]
set clk_rx_period [get_property PERIOD [get_clocks clk2]]
set delay [expr {min($clk_tx_period, $clk_rx_period)}]
set_max_delay -from [get_pins reg_tx/C] -to [get_pins reg1/D] -datapath_only $delay
