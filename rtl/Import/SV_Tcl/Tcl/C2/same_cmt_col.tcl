#File: same_cmt_col.tcl
#For UltraScale/UltraScale+
set_property CLOCK_DEDICATED_ROUTE SAME_CMT_COLUMN \
    [get_nets -of [get_pins BUFG_inst_0/O]]
#For 7 Series FPGA
set_property CLOCK_DEDICATED_ROUTE BACKBONE\
    [get_nets -of [get_pins BUFG_inst_0/O]]
set_property LOC MMCME3_ADV_X1Y2 [get_cells MMCME3_ADV_inst_0]
set_property LOC MMCME3_ADV_X1Y0 [get_cells MMCME3_ADV_inst_1]
