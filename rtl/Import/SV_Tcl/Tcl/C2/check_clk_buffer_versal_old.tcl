#File: check_clk_buffer_versal.tcl
link_design -part [get_parts xcvc1902-viva1596-1LHP-i-L]
set bufg_fabric  [get_sites *BUFG_FABRIC*]
set bufgce_hdio  [get_sites *BUFGCE_HDIO*]
set bufgce_xpio  [get_sites *BUFGCE_X*]
set bufgce_div   [get_sites *BUFGCE_DIV*]
set bufgctrl     [get_sites *BUFGCTRL*]
set bufg_gt      [get_sites *BUFG_GT*]
set bufg_gt_sync [get_sites *BUFG_GT_SYNC*]
set bufg_ps      [get_sites *BUFG_PS*]
mark_objects $bufg_fabric -color red
mark_objects $bufgce_hdio -color green
mark_objects $bufgce_xpio -color blue
mark_objects $bufg_gt     -color cyan
mark_objects $bufgce_div  -color magenta
mark_objects $bufgctrl    -color yellow
mark_objects $bufg_ps     -color orange

set vnoc [get_sites *VNOC*]
highlight_objects $vnoc -color green


