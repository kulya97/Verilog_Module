#File: async_fifo_timing.tcl
set wclk_freq 500
set rclk_freq 200
set wclk_period [expr {1.0 / double($wclk_freq) * 1000}]
set rclk_period [expr {1.0 / double($rclk_freq) * 1000}]
create_clock -name wclk -period $wclk_period [get_ports wclk]
create_clock -name rclk -period $rclk_period [get_ports rclk]
set delay [expr {min($wclk_period, $rclk_period)}]
set_max_delay -from [get_pins i_wptr_full/wptr_reg[*]/C] \
              -to [get_pins w2r_cdc_sync/din_d1_reg[*]/D] $delay 
set_max_delay -from [get_pins i_rptr_empty/rptr_reg[*]/C] \ 
              -to [get_pins r2w_cdc_sync/din_d1_reg[*]/D] $delay
