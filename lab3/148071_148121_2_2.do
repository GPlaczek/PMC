vcom -2008 gates.vhd devices.vhd counter.vhd 148071_148121_2_2.vhd
vsim -voptargs=+acc work.counter_tb
add wave *
run -all
wave zoom full
