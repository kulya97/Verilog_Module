#File: check_bram_oreg_status.tcl
#fn: file name
#family: 7 or us => 7 stands for 7 series FPGA
#                => us stands for UltraScale/UltraScale+
proc check_bram_oreg_status {family fn} {
    switch -exact -- $family {
        7 {
            set prim_type BMEM.bram.*
            set dout_name [list DOADO DOBDO]
        }
        default {
            set prim_type BLOCKRAM.BRAM.*
            set dout_name [list DOUTADOUT DOUTBDOUT]
        }
    }
    set fid [open ${fn}.csv w]
    puts $fid "BRAM_NAME, DOA_REG, CLKA_FREQ(MHZ), DOB_REG, CLKB_FREQ(MHZ)"

    set bram [get_cells -hierarchical -filter "PRIMITIVE_TYPE =~ $prim_type"] 
    set bram_without_oreg {}
    foreach i_bram $bram {
        foreach i_dout_name $dout_name {
            set dout_pin [get_pins $i_bram/${i_dout_name}*]
            set is_connected 0
            foreach i_dout_pin $dout_pin {
                set connected_status [get_property IS_CONNECTED $i_dout_pin]
                set is_connected [expr {$is_connected || $connected_status}]
            }
            if {[string first A $i_dout_name] != -1} {
                if {$is_connected == 1} {
                    puts "$i_bram: $i_dout_name is connected"
                    set doa_reg_status [get_property DOA_REG $i_bram]  
                    set clka [get_clocks -of [get_pins $i_bram/CLKARDCLK]]
                    set clka_period [get_property PERIOD $clka]
                    set clka_freq [expr {1 / $clka_period * 1000.0}]
                } else {
                    puts "$i_bram: $i_dout_name is unconnected"
                    set doa_reg_status X 
                    set clka_freq U
                }
            } else {
                if {$is_connected == 1} {
                    puts "$i_bram: $i_dout_name is connected"
                    set dob_reg_status [get_property DOB_REG $i_bram]  
                    set clkb [get_clocks -of [get_pins $i_bram/CLKBWRCLK]]
                    set clkb_period [get_property PERIOD $clkb]
                    set clkb_freq [expr {1 / $clkb_period * 1000.0}]
                } else {
                    puts "$i_bram: $i_dout_name is unconnected"
                    set dob_reg_status X 
                    set clka_freq U
                }
            }
        }
        if {$doa_reg_status == 0 || $dob_reg_status == 0} {
            puts $fid "$i_bram, $doa_reg_status, $clka_freq, $dob_reg_status, $clkb_freq"
            lappend bram_without_oreg $i_bram
        }
    }
    set num_bram [llength $bram_without_oreg]
    if {$num_bram > 0} {
        show_objects -name BRAM_REVIEW $bram_without_oreg
        puts "$num_bram BRAMs should be reviewed!"
    } else {
        puts "${fn}.csv is empty and can be deleted."
    }
    close $fid
}

set family 7
set fn bram_review_0912
check_bram_oreg_status $family $fn

    
    
