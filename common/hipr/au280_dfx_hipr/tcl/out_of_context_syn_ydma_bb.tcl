set top_name ydma_bb
set_msg_config -id "Project 1-486" -new_severity "WARNING"
set dir "./src4level2/ydma_bb"
set contents [glob -nocomplain -directory $dir *]
foreach item $contents {
  if { [regexp {.*\.tcl} $item] } {
    source $item
  } else {
    add_files -norecurse $item
  }
}

set_param general.maxThreads  8
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]
set logFileId [open ./runOOC.log "w"]
set start_time [clock seconds]
set_param general.maxThreads  8
synth_design -top $top_name -part xcu280-fsvh2892-2L-e -mode out_of_context
write_checkpoint -force ./checkpoint/$top_name.dcp
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "syn: $total_seconds seconds"
report_utilization -hierarchical > utilization.rpt

