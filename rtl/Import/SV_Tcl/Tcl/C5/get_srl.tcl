#File: get_srl.tcl
set mysrl [get_cells -hier -filter "REF_NAME=~SRL*"]
show_objects $mysrl -name SRL
set srl1 [get_cells -hier -filter \
    {IS_PRIMITIVE && REF_NAME =~ SRL* && (NAME =~ *_srl1)} -quiet]
set srl2 [get_cells -hier -filter \
    {IS_PRIMITIVE && REF_NAME =~ SRL* && (NAME =~ *_srl2)} -quiet]
set srl3 [get_cells -hier -filter \
    {IS_PRIMITIVE && REF_NAME =~ SRL* && (NAME =~ *_srl3)} -quiet]
