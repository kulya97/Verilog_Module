#File: check_clk_resource_7fpga.tcl
set mypart [get_parts xc7k70tfbg484-3]
link_design -part $mypart
set mrcc_in_bank13 [get_package_pins -filter "IS_CLK_CAPABLE==1 && PIN_FUNC =~ *MRCC*" -of [get_iobanks 13]]
set srcc_in_bank13 [get_package_pins -filter "IS_CLK_CAPABLE==1 && PIN_FUNC =~ *SRCC*" -of [get_iobanks 13]]
set mybufg [get_sites *BUFG*]
puts "The number of BUFG in $mypart: [llength $mybufg]"
highlight_objects $mybufg -color red
set mybufh [get_sites "BUFH*"]
puts "The number of BUFH in $mypart: [llength $mybufh]"
set myclock_region [get_clock_regions]
set bufh_in_X0Y0 [get_sites "BUFH*" -of [get_clock_regions X0Y0]]
puts "The number of BUFH in clock region X0Y0: [llength $bufh_in_X0Y0]"
mark_objects $bufh_in_X0Y0 -color red
get_iobanks
set mybufr_in_X0Y0 [get_sites "BUFR*" -of [get_clock_regions X0Y0]]
set mybufio_in_X0Y0 [get_sites "BUFIO*" -of [get_clock_regions X0Y0]]
set mybufmr_in_X0Y0 [get_sites "BUFMR*" -of [get_clock_regions X0Y0]]
set mymmcm [get_sites *MMCM*]
mark_objects $mymmcm -color blue
set mymmcm_in_X0Y0 [get_sites "MMCM*" -of [get_clock_regions X0Y0]]
set mypll_in_X0Y0 [get_sites "PLL*" -of [get_clock_regions X0Y0]]
