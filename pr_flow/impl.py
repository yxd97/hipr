# -*- coding: utf-8 -*-   

import os  
import subprocess
from pr_flow.gen_basic import gen_basic
import re
import pr_flow.syn 

class impl(gen_basic):

  # create one directory for each page 
  def create_page(self, operator):
    self.shell.re_mkdir(self.pr_dir+'/'+operator)
    self.shell.cp_file('./common/script_src/impl_page_'+self.prflow_params['board']+'.tcl', self.pr_dir+'/'+operator+'/impl_'+operator+'.tcl')
    tmp_dict = {'set operator'                : 'set operator '+operator,
                'set part'                    : 'set part '+self.prflow_params['part'],
                'set benchmark'               : 'set benchmark '+self.prflow_params['benchmark_name'],
                'set_property SCOPED_TO_CELLS': ''}
    tmp_dict['CELL_ANCHOR']     = 'set_property SCOPED_TO_CELLS { '+self.prflow_params['inst_name']+'/mono_inst/'+operator+'_inst } [get_files $page_dcp]'
    tmp_dict['set inst_name']   = 'set inst_name "'+self.prflow_params['inst_name']+'/mono_inst/'+operator+'_inst"'
    tmp_dict['set freq']        = 'set freq "'+ self.prflow_params['freq'] + '"'
    tmp_dict['set context_dcp'] = 'set context_dcp "../../F001_overlay_'+self.prflow_params['benchmark_name']+'_'+self.prflow_params['freq']+'/'+self.prflow_params['board']+'_dfx_hipr/checkpoint/'+operator+'.dcp"'

    self.shell.cp_dir('./common/constraints/'+self.prflow_params['board']+'_'+self.prflow_params['freq']+'/*', self.pr_dir+'/'+operator)
    self.shell.mkdir(self.pr_dir+'/'+operator+'/output')
    os.system('touch '+self.pr_dir+'/'+operator+'/output/_user_impl_clk.xdc')
    self.shell.replace_lines(self.pr_dir+'/'+operator+'/impl_'+operator+'.tcl', tmp_dict)
    self.shell.my_sed(self.pr_dir+'/'+operator+'/impl_'+operator+'.tcl', 
      {
        '/home/ylxiao/ws_211/prflow/workspace/F001_overlay': os.path.abspath(self.ydma_dir),
        '/opt/Xilinx/Vitis/2021.1/data/ip': '/opt/xilinx/2022.1/Vitis/2022.1/data/ip'
      }
    )
    self.shell.write_lines(self.pr_dir+'/'+operator+'/run.sh', self.shell.return_run_sh_list(self.prflow_params['Xilinx_dir'], 'impl_'+operator+'.tcl', self.prflow_params['back_end']), True)
    self.shell.write_lines(self.pr_dir+'/'+operator+'/main.sh', self.shell.return_main_sh_list(
                                                                                                  './run.sh', 
                                                                                                  self.prflow_params['back_end'], 
                                                                                                  'syn_'+operator, 
                                                                                                  'impl_'+operator, 
                                                                                                  self.prflow_params['grid'], 
                                                                                                  'qsub@qsub.com',
                                                                                                  self.prflow_params['mem'], 
                                                                                                  self.prflow_params['node'], 
                                                                                                   ), True)

  def create_false(self, operator):
    self.shell.re_mkdir(self.pr_dir+'/'+operator)
    str_list = ['#!/bin/bash -e',
                'touch ../../F005_bits_'+self.prflow_params['benchmark_name']+'_'+self.prflow_params['freq']+'/'+operator+'.bit']
    self.shell.write_lines(self.pr_dir+'/'+operator+'/run.sh', str_list, True)
    str_list = ['read_checkpoint: 0 seconds',
                'opt: 0 seconds',
                'place: 0 seconds',
                'opt_physical: 0 seconds',
                'route: 0 seconds',
                'bitgen: 0 seconds']
    self.shell.write_lines(self.pr_dir+'/'+operator+'/runLogImpl_'+operator+'.log', str_list)
    self.shell.write_lines(self.pr_dir+'/'+operator+'/main.sh', self.shell.return_main_sh_list(
                                                                                                  './run.sh', 
                                                                                                  self.prflow_params['back_end'], 
                                                                                                  'syn_'+operator, 
                                                                                                  'impl_'+operator, 
                                                                                                  self.prflow_params['grid'], 
                                                                                                  'qsub@qsub.com',
                                                                                                  self.prflow_params['mem'], 
                                                                                                  self.prflow_params['node'], 
                                                                                                   ), True)
 


  def create_shell_file(self):
  # local run:
  #   main.sh <- |_ execute each impl_page.tcl
  #
  # qsub run:
  #   qsub_main.sh <-|_ Qsubmit each qsub_run.sh <- impl_page.tcl
    pass   

  def run(self, operator):
    # mk work directory
    if self.prflow_params['gen_impl']==True:
      print ("gen_impl")
      self.shell.mkdir(self.pr_dir)
      self.shell.mkdir(self.bit_dir)
      print(self.bit_dir)
    
    # generate shell files for qsub run and local run
    #self.create_shell_file() 

    # create ip directories for all the pages
    map_target_exist, map_target = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'map_target')
    if map_target == 'HIPR':
      self.create_page(operator)
    else:
      self.create_false(operator)

