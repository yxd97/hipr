set cell_name ydma
set_msg_config -id "Project 1-486" -new_severity "WARNING"
open_checkpoint ./checkpoint/pfm_dynamic.dcp
update_design -black_box -cells ${cell_name}_1
write_checkpoint -force ./checkpoint/pfm_dynamic_bb.dcp

