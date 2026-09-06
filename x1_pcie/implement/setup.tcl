# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs

create_project -part xc7a100tfgg484-2 -force proj
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
# Using the SYNTH_CHECKPOINT_MODE you can specify that the block design will be synthesized as
# part of the top-level design, during global synthesis. Do this by setting SYNTH_CHECKPOINT_MODE
# to NONE, disabling the generation of the OOC (out-of-context) synthesis checkpoint for the block design.
# Otherwise, the block design will be synthesized OOC from the rest of the design.
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

read_vhdl ../source/system_wrapper.vhd
read_xdc ../source/top.xdc

close_project
