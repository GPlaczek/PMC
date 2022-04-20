vcom -2008 devices.vhd gates.vhd lab2.vhd

vsim work.counter -debugdb

add wav clk q tc rst ce

force clk 0 0ns, 1 50ns -r 100ns
force rst 1 0ns, 0 100ns
force ce 0 0ns, 1 100ns

run [expr 148080*100]ns

wave zoom full

//add schematic -full sim:/counter
