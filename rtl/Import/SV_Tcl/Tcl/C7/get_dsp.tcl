#File: get_dsp.tcl
set dsp_mult [get_cells -hier -filter "REF_NAME == DSP48E1 && USE_MULT != NONE"]
set dsp_no_mreg [filter $dsp_mult "MREG == 0"]
set dsp_no_preg [get_cells -hier -filter "REF_NAME == DSP48E1 && PREG == 0"]
if {[llength $dsp_no_mreg] > 0} { show_objects $dsp_no_mreg -name dsp_no_mreg}
if {[llength $dsp_no_preg] > 0} { show_objects $dsp_no_preg -name dsp_no_preg}
