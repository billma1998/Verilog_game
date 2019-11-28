onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+AccelerometerCtl2_2 -L xil_defaultlib -L secureip -O5 xil_defaultlib.AccelerometerCtl2_2

do {wave.do}

view wave
view structure

do {AccelerometerCtl2_2.udo}

run -all

endsim

quit -force
