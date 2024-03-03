#File: check_uram_oreg_status.tcl
#fn: file name
proc check_uram_oreg_status {fn} {
    set prim_type BLOCKRAM.URAM.*
    set dout_name [list DOUT_A DOUT_B]
    set fid [open ${fn}.csv w]
    puts $fid "URAM_NAME, OREG_A, OREG_B, CLK_FREQ(MHZ)"

    set uram [get_cells -hierarchical -filter "PRIMITIVE_TYPE =~ $prim_type"] 
    set uram_without_oreg {}
    foreach i_uram $uram {
        foreach i_dout_name $dout_name {
            set dout_pin [get_pins $i_uram/${i_dout_name}*]
            set is_connected 0
            foreach i_dout_pin $dout_pin {
                set connected_status [get_property IS_CONNECTED $i_dout_pin]
                set is_connected [expr {$is_connected || $connected_status}]
            }
            if {[string first A $i_dout_name] != -1} {
                if {$is_connected == 1} {
                    puts "$i_uram: $i_dout_name is connected"
                    set doa_reg_status [get_property OREG_A $i_uram]  
                } else {
                    puts "$i_uram: $i_dout_name is unconnected"
                    set doa_reg_status X 
                }
            } else {
                if {$is_connected == 1} {
                    puts "$i_uram: $i_dout_name is connected"
                    set dob_reg_status [get_property OREG_B $i_uram]  
                } else {
                    puts "$i_uram: $i_dout_name is unconnected"
                    set dob_reg_status X 
                }
            }
        }
        if {$doa_reg_status == FALSE || $dob_reg_status == FALSE} {
            set clk [get_clocks -of [get_pins $i_uram/CLK]]
            set clk_period [get_property PERIOD $clk]
            set clk_freq [expr {1 / $clk_period * 1000.0}]
            puts $fid "$i_uram, $doa_reg_status, $dob_reg_status, $clk_freq"
            lappend uram_without_oreg $i_uram
        }
    }
    set num_uram [llength $uram_without_oreg]
    if {$num_uram > 0} {
        show_objects -name BRAM_REVIEW $uram_without_oreg
        puts "$num_uram BRAMs should be reviewed!"
    } else {
        puts "${fn}.csv is empty and can be deleted."
    }
    close $fid
}
    
set fn uram_review_0912    
check_uram_oreg_status $fn
    
