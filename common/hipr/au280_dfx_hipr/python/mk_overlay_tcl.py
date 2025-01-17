#!/usr/bin/env python
import argparse
import os


parser = argparse.ArgumentParser()
parser.add_argument('workspace')
parser.add_argument('-t', '--top',       type=str, default="no_func", help="set top function name for out of context synthesis")
parser.add_argument('-f', '--file_name', type=str, default="no_func", help="set output file name prefix")
parser.add_argument('-a', '--app_name',  type=str, default="no_func", help="set output file name prefix")

args      = parser.parse_args()
workspace = args.workspace
top_name  = args.top
file_name = args.file_name
app_name  = args.app_name

F001_dir=''

def find_required_file(line):
    if (line.replace('get_files','') != line):
        line = line.replace('-all', '')
        line = line.replace('[', '')
        line = line.replace(']', '')
        file = line.split('get_files')[-1].strip()
        return file
    return None

# prepare the tcl file to restore the top dcp file
file_in = open(workspace+'/_x/link/vivado/vpl/prj/prj.runs/impl_1/'+file_name+'.tcl', 'r')
file_out = open(workspace+'/_x/link/vivado/vpl/prj/prj.runs/impl_1/'+file_name+'_mk_overlay_'+app_name+'.tcl', 'w')
copy_enable = True
lines = file_in.readlines()
custom_dcp_xdc_included = False
for line in lines:
  if copy_enable:
    if (line.replace('add_files', '') != line):
      file_out.write('# ' + line)
    elif (line.replace('write_checkpoint -force', '') != line):
      file_out.write('write_checkpoint -force design_route.dcp\n')
    elif (line.replace('write_bitstream -force', '') != line):
      file_out.write('\n')
      for p in range(2, 24): file_out.write('report_utilization -pblocks p_'+str(p)+' > ../../../../../../../../../utilization'+str(p)+'.rpt\n') # utilization_anchor
      file_out.write('pr_recombine -cell level0_i/ulp\n')
      file_out.write('write_bitstream -force -cell level0_i/ulp ./dynamic_region.bit\n')
    elif (line.replace('set_property SCOPED_TO_REF', '') != line):
      if 'bd_2e55.bmm' in find_required_file(line).split('/'):
        file_out.write("add_files " + find_required_file(line) + '\n')
        file_out.write(line)
    elif (line.replace('set_property SCOPED_TO_CELLS', '') != line):
      if 'calibration_ddr.elf' in find_required_file(line).split('/'):
        file_out.write("add_files " + find_required_file(line) + '\n')
        file_out.write(line)
      else:
        file_out.write('# ' + line)
      if custom_dcp_xdc_included:
        continue
      file_out.write('add_files ../../../../../../../au280_dfx_hipr/checkpoint/hw_bb_divided.dcp\n') # hw_bb_divided_anchor
      # page_dcp_anchor
      file_out.write('add_files ../../../../../../../../../../'+str(F001_dir)+'/au280_dfx_hipr/xdc/sub.xdc\n')
      file_out.write('set_property SCOPED_TO_CELLS {level0_i/ulp/ydma_1/page2_inst level0_i/ulp/ydma_1/page3_inst level0_i/ulp/ydma_1/page4_inst level0_i/ulp/ydma_1/page5_inst level0_i/ulp/ydma_1/page6_inst level0_i/ulp/ydma_1/page7_inst level0_i/ulp/ydma_1/page8_inst level0_i/ulp/ydma_1/page9_inst level0_i/ulp/ydma_1/page10_inst level0_i/ulp/ydma_1/page11_inst level0_i/ulp/ydma_1/page12_inst level0_i/ulp/ydma_1/page13_inst level0_i/ulp/ydma_1/page14_inst level0_i/ulp/ydma_1/page15_inst level0_i/ulp/ydma_1/page16_inst level0_i/ulp/ydma_1/page17_inst level0_i/ulp/ydma_1/page18_inst  level0_i/ulp/ydma_1/page19_inst level0_i/ulp/ydma_1/page20_inst level0_i/ulp/ydma_1/page21_inst level0_i/ulp/ydma_1/page22_inst level0_i/ulp/ydma_1/page23_inst}  [get_files ../../../../../../../au280_dfx_hipr/checkpoint/page.dcp] \n') # scope_anchor
      file_out.write('set_property USED_IN {implementation} [get_files ../../../../../../../../../../'+str(F001_dir)+'/au280_dfx_hipr/xdc/sub.xdc]\n')
      file_out.write('set_property PROCESSING_ORDER LATE [get_files ../../../../../../../../../../'+str(F001_dir)+'/au280_dfx_hipr/xdc/sub.xdc]\n')
      custom_dcp_xdc_included = True
    elif (line.replace('reconfig_partitions', '') != line):
      file_out.write('# ' + line)
      file_out.write('link_design -mode default -part xcu280-fsvh2892-2L-e -reconfig_partitions { level0_i/ulp/ydma_1/page2_inst level0_i/ulp/ydma_1/page3_inst level0_i/ulp/ydma_1/page4_inst level0_i/ulp/ydma_1/page5_inst level0_i/ulp/ydma_1/page6_inst level0_i/ulp/ydma_1/page7_inst level0_i/ulp/ydma_1/page8_inst level0_i/ulp/ydma_1/page9_inst level0_i/ulp/ydma_1/page10_inst level0_i/ulp/ydma_1/page11_inst level0_i/ulp/ydma_1/page12_inst level0_i/ulp/ydma_1/page13_inst level0_i/ulp/ydma_1/page14_inst level0_i/ulp/ydma_1/page15_inst level0_i/ulp/ydma_1/page16_inst level0_i/ulp/ydma_1/page17_inst level0_i/ulp/ydma_1/page18_inst  level0_i/ulp/ydma_1/page19_inst level0_i/ulp/ydma_1/page20_inst level0_i/ulp/ydma_1/page21_inst level0_i/ulp/ydma_1/page22_inst level0_i/ulp/ydma_1/page23_inst } -top level0_wrapper\n')
    else:
      file_out.write(line)

file_in.close()
file_out.close()

file_in   = open(workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/impl.xdc', 'r')
file_out  = open(workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/.impl.xdc', 'w')

for line in file_in:
  if (line.replace('SLR', '') != line):
    file_out.write('# ' + line)
  else:
    file_out.write(line)

file_in.close()
file_out.close()
os.system('mv '+workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/.impl.xdc ' + workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/impl.xdc')

file_in   = open(workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/preopt.tcl', 'r')
file_out  = open(workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/.preopt.tcl', 'w')

for line in file_in:
  if (line.replace('SLR', '') != line):
    file_out.write('# ' + line)
  else:
    file_out.write(line)

file_in.close()
file_out.close()
os.system('mv '+ workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/.preopt.tcl ' + workspace+'/_x/link/vivado/vpl/.local/hw_platform/tcl_hooks/preopt.tcl')
