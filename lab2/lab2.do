vcom -2008 devices.vhd gates.vhd lab2.vhd

vsim work.counter

add wav clk q tc rst ce

force clk 0 0ns, 1 5ns -r 10ns
force ce 0 0ns, 1 10ns
force rst 1 0ns, 0 10ns

run [expr 148080*10]ns
