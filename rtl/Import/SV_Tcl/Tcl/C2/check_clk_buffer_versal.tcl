#File: check_clk_buffer_versal.tcl
link_design -part [get_parts xcvc1902-viva1596-1LHP-i-L]
set hdio_banks [get_iobanks -filter "BANK_TYPE==BT_HIGH_DENSITY"]
set xpio_banks [get_iobanks -filter "BANK_TYPE==BT_XP"]
set gc_in_bank700 [get_package_pins -filter "PIN_FUNC=~*GC_XCC*" -of [get_iobanks 700]]
set gc_in_bank306 [get_package_pins -filter "PIN_FUNC=~*HDGC*" -of [get_iobanks 306]]
puts "#GC in each XPIO: [llength $gc_in_bank700]"
puts "#GC in each HDIO: [llength $gc_in_bank306]"
set xpcr [get_clock_regions X4Y0]
set bufgce_xpio  [get_sites -filter "SITE_TYPE==BUFGCE" -of $xpcr]
set bufgce_div   [get_sites -filter "SITE_TYPE==BUFGCE_DIV" -of $xpcr]
set bufgctrl     [get_sites -filter "SITE_TYPE==BUFGCTRL" -of $xpcr]
set hdcr [get_clock_regions X0Y4]
set bufgce_hdio  [get_sites *BUFGCE_HDIO* -of $hdcr]
set bufg_gt [get_sites -filter "SITE_TYPE==BUFG_GT" -of [get_clock_regions X0Y4]]
set bufg_ps [get_sites "BUFG_PS*" -of [get_clock_regions X1Y1]]
set bufg_fabric  [get_sites *BUFG_FABRIC* -of [get_clock_regions X1Y4]]
puts "#BUFGCE in each CR corresponding to XPIO: [llength $bufgce_xpio]"
puts "#BUFGCE_DIV in each CR corresponding to XPIO: [llength $bufgce_div]"
puts "#BUFGCTRL in each CR corresponding to XPIO: [llength $bufgctrl]"
puts "#BUFGCE in each CR corresponding to HDIO: [llength $bufgce_hdio]"
puts "#BUFG_GT in each CR adjacent to GT: [llength $bufg_gt]"
puts "#BUFG_PS in each CR adjacent to PS: [llength $bufg_ps]"
puts "#BUFG_FABRIC available in some CRs: [llength $bufg_fabric]"
mark_objects $bufgce_xpio -color red
mark_objects $bufgce_div -color yellow
mark_objects $bufgctrl -color green 
mark_objects $bufgce_hdio -color magenta
mark_objects $bufg_gt -color orange
mark_objects $bufg_ps -color blue
mark_objects $bufg_fabric -color cyan

