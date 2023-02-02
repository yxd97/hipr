# # # SLR pblocks
# # create_pblock pblock_dynamic_SLR0
# # create_pblock pblock_dynamic_SLR1



# # # SLR0
# # resize_pblock pblock_dynamic_SLR0 -add    {CLOCKREGION_X0Y0:CLOCKREGION_X5Y3}
# # resize_pblock pblock_dynamic_SLR0 -remove {IOB_X0Y208:IOB_X0Y259}
# # resize_pblock pblock_dynamic_SLR0 -remove {IOB_X0Y52:IOB_X0Y103}
# # resize_pblock pblock_dynamic_SLR0 -add {CLOCKREGION_X6Y0:CLOCKREGION_X6Y0}
# # resize_pblock pblock_dynamic_SLR0 -add {SLICE_X206Y0:SLICE_X232Y29 DSP48E2_X30Y0:DSP48E2_X31Y5 RAMB18_X12Y0:RAMB18_X13Y11 RAMB36_X12Y0:RAMB36_X13Y5}
# # resize_pblock pblock_dynamic_SLR0 -add {BLI_HBM_APB_INTF_X25Y0:BLI_HBM_APB_INTF_X31Y0 BLI_HBM_AXI_INTF_X25Y0:BLI_HBM_AXI_INTF_X31Y0}

# # set_property SNAPPING_MODE ON [get_pblocks pblock_dynamic_SLR0]
# # set_property PARENT pblock_dynamic_region  [get_pblocks pblock_dynamic_SLR0]  -quiet

# # # SLR1
# # resize_pblock pblock_dynamic_SLR1 -add    {CLOCKREGION_X0Y4:CLOCKREGION_X5Y7}
# # resize_pblock pblock_dynamic_SLR1 -add    {CLOCKREGION_X6Y7:CLOCKREGION_X7Y7}
# # resize_pblock pblock_dynamic_SLR1 -remove {IOB_X0Y208:IOB_X0Y259}
# # resize_pblock pblock_dynamic_SLR1 -remove {IOB_X0Y52:IOB_X0Y103}

# # resize_pblock pblock_dynamic_SLR1 -add  {SLICE_X176Y325:SLICE_X219Y330 SLICE_X220Y300:SLICE_X221Y359 CONFIG_SITE_X0Y1:CONFIG_SITE_X0Y1}
# set_property PROHIBIT 1 [get_sites -range SLICE_X220Y300:SLICE_X221Y359]

# # set_property SNAPPING_MODE ON [get_pblocks pblock_dynamic_SLR1]
# # set_property PARENT pblock_dynamic_region  [get_pblocks pblock_dynamic_SLR1]  -quiet


# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR0] [get_cells level0_i/ulp/SLR0]
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR0] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem00] -quiet
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR0] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem01] -quiet
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR0] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem00_bram] -quiet
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR0] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem01_bram] -quiet

# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR1] [get_cells level0_i/ulp/SLR1]
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR1] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem02] -quiet
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR1] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem03] -quiet
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR1] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem02_bram] -quiet
# # add_cells_to_pblock [get_pblocks pblock_dynamic_SLR1] [get_cells level0_i/ulp/memory_subsystem/inst/memory/plram_mem03_bram] -quiet


# #######################################################################
# WARNING: WORKAROUND!
# #######################################################################
#
# These constraints are added as a workaround to CR-1038346 
# Remove these constraints when CR is resolved.
#
# Error codes: ERROR: [VPL 30-1112] 
#
# # set_property CONTAIN_ROUTING 0 [get_pblocks pblock_dynamic_SLR0]
# # set_property EXCLUDE_PLACEMENT 0 [get_pblocks pblock_dynamic_SLR0]
# # set_property CONTAIN_ROUTING 0 [get_pblocks pblock_dynamic_SLR1]
# # set_property EXCLUDE_PLACEMENT 0 [get_pblocks pblock_dynamic_SLR1]


set_false_path -through  [get_pins -hierarchical -filter {NAME=~level0_i/ulp/*lp_s_irq_cu_00*}]
set_false_path -through  [get_pins -hier -regexp .*mss_0/inst/hbm_inst/inst/.*_STACK.*/AXI_.*_ARESET_N.*]

# Need to Confirm that this BACKBONE constraint is needed in ulp's impl.xdc
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets level0_i/blp/blp_i/freerun_clk/bufg_div/U0/BUFGCE_O[0]]

set_property LOC MMCM_X0Y0 [get_cells level0_i/ulp/ulp_ucs/inst/aclk_hbm_hierarchy/clkwiz_hbm/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]

