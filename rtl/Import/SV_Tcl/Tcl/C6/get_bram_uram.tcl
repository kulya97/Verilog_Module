#File: get_bram_uram.tcl
#For US/US+
set prim_type BLOCKRAM.BRAM.* 
set prim_type BLOCKRAM.URAM.* 
set prim_type BLOCKRAM.FIFO.* 
set dout_name {DOUTADOUT DOUTBDOUT}
#For 7 Seris
set prim_type BMEM.bram.* 
set prim_type BMEM.fifo.* 
set dout_name {DOADO DOBDO}

set fid [open bram_review.csv w]
puts $fid "BRAM_NAME, DOA_REG, CLKA_FREQ(MHZ), DOB_REG, CLKB_FREQ(MHZ)"

set bram [get_cells -hier -filter "PRIMITIVE_TYPE =~ $prim_type"] 
set bram_without_reg {}
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
    }
}
close $fid




