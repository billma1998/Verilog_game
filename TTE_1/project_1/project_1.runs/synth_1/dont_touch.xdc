# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/DDR.xdc

# IP: ip/AccelerometerCtl2_2/AccelerometerCtl2_2.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==AccelerometerCtl2_2 || ORIG_REF_NAME==AccelerometerCtl2_2} -quiet] -quiet

# XDC: ip/AccelerometerCtl2_2/project_1.srcs/constrs_1/imports/Desktop/Nexys4DDR_Master.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==AccelerometerCtl2_2 || ORIG_REF_NAME==AccelerometerCtl2_2} -quiet] {/U0 } ]/U0 ] -quiet] -quiet
