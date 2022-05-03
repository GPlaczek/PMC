vcom -2008 gates.vhd devices.vhd counter.vhd counter_tb.vhd
vsim -voptargs=+acc work.counter_tb
add wave *
run -all
wave zoom full
