#File: set_block_synth.tcl
set_property BLOCK_SYNTH.LUT_COMBINING 0 [get_cells usbEngine]
set_property BLOCK_SYNTH.CONTROL_SET_THRESHOLD 16 [get_cells fftEngine]
