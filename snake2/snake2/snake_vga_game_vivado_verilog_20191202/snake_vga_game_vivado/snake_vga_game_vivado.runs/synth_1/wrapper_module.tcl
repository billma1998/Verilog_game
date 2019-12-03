# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7vx485tffg1157-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir F:/2018project/snake/snake_vga_game_vivado/snake_vga_game_vivado/snake_vga_game_vivado.cache/wt [current_project]
set_property parent.project_path F:/2018project/snake/snake_vga_game_vivado/snake_vga_game_vivado/snake_vga_game_vivado.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
add_files f:/2018project/snake/snake_vga_game_vivado/ex5_image_256x256_rom.coe
add_files -quiet F:/2018project/snake/snake_vga_game_vivado/snake_vga_game_vivado/snake_vga_game_vivado.runs/char_rom_synth_1/char_rom.dcp
set_property used_in_implementation false [get_files F:/2018project/snake/snake_vga_game_vivado/snake_vga_game_vivado/snake_vga_game_vivado.runs/char_rom_synth_1/char_rom.dcp]
read_verilog -library xil_defaultlib {
  F:/2018project/snake/snake_vga_game_vivado/src/LDSR8.v
  F:/2018project/snake/snake_vga_game_vivado/src/LDSR7.v
  F:/2018project/snake/snake_vga_game_vivado/src/VGA_Interface.v
  F:/2018project/snake/snake_vga_game_vivado/src/Colour_Memory.v
  F:/2018project/snake/snake_vga_game_vivado/src/clk_div.v
  F:/2018project/snake/snake_vga_game_vivado/src/Seg7Display.v
  F:/2018project/snake/snake_vga_game_vivado/src/Multiplexer_2way.v
  F:/2018project/snake/snake_vga_game_vivado/src/Generic_counter.v
  F:/2018project/snake/snake_vga_game_vivado/src/Navigation_State_Machine.v
  F:/2018project/snake/snake_vga_game_vivado/src/Vga_module.v
  F:/2018project/snake/snake_vga_game_vivado/src/Snake_Control.v
  F:/2018project/snake/snake_vga_game_vivado/src/Master_State_Machine.v
  F:/2018project/snake/snake_vga_game_vivado/src/Target_Generate.v
  F:/2018project/snake/snake_vga_game_vivado/src/wrapper_module.v
}
read_xdc F:/2018project/snake/snake_vga_game_vivado/snake_vga_game_vivado/snake_vga_game_vivado.srcs/constrs_1/new/snake_top.xdc
set_property used_in_implementation false [get_files F:/2018project/snake/snake_vga_game_vivado/snake_vga_game_vivado/snake_vga_game_vivado.srcs/constrs_1/new/snake_top.xdc]

synth_design -top wrapper_module -part xc7vx485tffg1157-1
write_checkpoint -noxdef wrapper_module.dcp
catch { report_utilization -file wrapper_module_utilization_synth.rpt -pb wrapper_module_utilization_synth.pb }