vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"../../../../../testgame2/testgame2.srcs/sources_1/ip/AccelerometerCtl2_2/project_1.srcs/sources_1/new/SPI_if.vhd" \
"../../../../../testgame2/testgame2.srcs/sources_1/ip/AccelerometerCtl2_2/project_1.srcs/sources_1/new/ADXL362Ctrl.vhd" \
"../../../../../testgame2/testgame2.srcs/sources_1/ip/AccelerometerCtl2_2/project_1.srcs/sources_1/new/AccelArithmetics.vhd" \
"../../../../../testgame2/testgame2.srcs/sources_1/ip/AccelerometerCtl2_2/project_1.srcs/sources_1/new/AccelerometerCtl.vhd" \
"../../../../../testgame2/testgame2.srcs/sources_1/ip/AccelerometerCtl2_2/sim/AccelerometerCtl2_2.vhd" \


