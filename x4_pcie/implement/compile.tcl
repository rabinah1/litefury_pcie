# Script to compile the FPGA with zynq processor system all the way to bit file.

close_project -quiet

open_project proj.xpr

update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

open_run synth_1

# Remove any existing LOC placement constraints from four specific PCIe transceiver cells
reset_property LOC [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[3].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
reset_property LOC [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
reset_property LOC [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[2].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
reset_property LOC [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[1].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]

# Hard-code the PCIe transceiver cell locations.
# By default, the Vivado XDMA block has
# - GTPE2_CHANNEL_X0Y7 --> pipe_lane[0]
# - GTPE2_CHANNEL_X0Y6 --> pipe_lane[1]
# - GTPE2_CHANNEL_X0Y5 --> pipe_lane[2]
# - GTPE2_CHANNEL_X0Y4 --> pipe_lane[3]
set_property LOC GTPE2_CHANNEL_X0Y7 [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[3].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
set_property LOC GTPE2_CHANNEL_X0Y6 [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
set_property LOC GTPE2_CHANNEL_X0Y5 [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[2].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
set_property LOC GTPE2_CHANNEL_X0Y4 [get_cells {system_i/xdma_0/inst/system_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[1].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]

launch_runs impl_1 -jobs 8
wait_on_run impl_1

open_run impl_1
file mkdir ./results
report_timing_summary   -file   ./results/timing.rpt
report_utilization      -file   ./results/utilization.rpt
report_io               -file   ./results/io.rpt
write_debug_probes      -force  ./results/top.ltx

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 3 [current_design]
set_property BITSTREAM.Config.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

#set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN ENABLE [current_design]
#set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN Div-1 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property CONFIG_MODE SPIx4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property CONFIG_VOLTAGE 3.3 [current_design]
#set_property CFGBVS VCCO [current_design]

write_bitstream -verbose -force ./results/top.bit

close_project


###################
