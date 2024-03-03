#File: check_clk_resource_us.tcl
set mypart [get_parts xcku040-fbva676-1-c]
link_design -part $mypart
set gc_in_bank44 [get_package_pins -of [get_iobanks 44]\
    -filter "IS_GLOBAL_CLK"]
puts "The number of global clock pins in each bank: [llength $gc_in_bank44]"
The number of global clock pins in each bank: 8
mark_objects $gc_in_bank44 -color red
set cr [get_clock_regions -of [get_iobanks 44]]
set bufgce_in_x0y0 [get_sites -filter "SITE_TYPE==BUFGCE" \
    -of [get_clock_regions $cr]]
set bufgce_div_in_x0y0 [get_sites -filter "SITE_TYPE==BUFGCE_DIV" \
    -of [get_clock_regions $cr]]
set bufgctrl_in_x0y0 [get_sites -filter "SITE_TYPE==BUFGCTRL" \
    -of [get_clock_regions $cr]]
set bufce_leaf_in_x0y0 [get_sites "BUFCE_LEAF*" \
    -of [get_clock_regions $cr]]
set bufg_gt_in_x3y0 [get_sites -filter "SITE_TYPE==BUFG_GT" \
    -of [get_clock_regions X3Y0]]
set mmcm_in_x0y0 [get_sites "MMCM*" -of [get_clock_regions $cr]]
set pll_in_x0y0 [get_sites "PLL*" -of [get_clock_regions $cr]]
puts "#BUFGCE in each clock region: [llength $bufgce_in_x0y0]"
#BUFGCE in each clock region: 24
puts "#BUFGCE_DIV in each clock region: [llength $bufgce_div_in_x0y0]"
#BUFGCE_DIV in each clock region: 4
puts "#BUFGCTRL in each clock region: [llength $bufgctrl_in_x0y0]"
#BUFGCTRL in each clock region: 8
puts "#BUFCE_LEAF in each clock region: [llength $bufce_leaf_in_x0y0]"
#BUFCE_LEAF in each clock region: 32
puts "#BUFG_GT in clock region containing GT: [llength $bufg_gt_in_x3y0]"
#BUFG_GT in clock region containing GT: 24
puts "#MMCM in each clock region: [llength $mmcm_in_x0y0]"
#MMCM in each clock region: 1
puts "#PLL in each clock region: [llength $pll_in_x0y0]"
#PLL in each clock region: 10
mark_object $bufgce_in_x0y0 -color green
mark_object $bufgce_div_in_x0y0 -color blue
mark_object $bufgctrl_in_x0y0 -color yellow 
mark_object $bufce_leaf_in_x0y0 -color magenta
mark_object $bufg_gt_in_x3y0 -color red 
mark_object $mmcm_in_x0y0 -color cyan 
mark_object $pll_in_x0y0 -color orange
