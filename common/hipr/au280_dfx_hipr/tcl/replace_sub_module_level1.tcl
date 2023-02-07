set kl_name ydma_bb
set_msg_config -id "Project 1-486" -new_severity "WARNING"
add_files ./checkpoint/pfm_dynamic_bb.dcp
add_files ./checkpoint/${kl_name}.dcp
set_property SCOPED_TO_CELLS { ydma_1 } [get_files ./checkpoint/${kl_name}.dcp]
link_design -mode default -part xcu280-fsvh2892-2L-e -top ulp
write_checkpoint -force ./checkpoint/pfm_dynamic_new_bb.dcp


