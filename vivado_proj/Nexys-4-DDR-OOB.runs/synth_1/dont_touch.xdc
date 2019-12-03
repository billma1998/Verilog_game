# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: D:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/constraints/Nexys4DDR_C.xdc

# IP: D:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/BRAM_1/BRAM_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==BRAM_1 || ORIG_REF_NAME==BRAM_1} -quiet] -quiet

# IP: D:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/Square_Root/Square_Root.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==Square_Root || ORIG_REF_NAME==Square_Root} -quiet] -quiet

# IP: D:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ddr/ddr.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==ddr || ORIG_REF_NAME==ddr} -quiet] -quiet

# IP: D:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ClkGen/ClkGen.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==ClkGen || ORIG_REF_NAME==ClkGen} -quiet] -quiet

# XDC: d:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/BRAM_1/BRAM_1_ooc.xdc

# XDC: d:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ddr/ddr/user_design/constraints/ddr.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==ddr || ORIG_REF_NAME==ddr} -quiet] -quiet

# XDC: d:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ddr/ddr/user_design/constraints/ddr_ooc.xdc

# XDC: d:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ClkGen/ClkGen_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==ClkGen || ORIG_REF_NAME==ClkGen} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: d:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ClkGen/ClkGen.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==ClkGen || ORIG_REF_NAME==ClkGen} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: d:/Github/releases/in-work/Nexys-4-DDR/Nexys-4-DDR-OOB/src/ip/ClkGen/ClkGen_ooc.xdc