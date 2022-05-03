vcom -2008 reg.vhd nowy_reg_tb.vhd
vsim -voptargs=+acc work.nowy_reg_tb
add wave *
run [expr 1000] ns
wave zoom full
dataset save sim nowy_reg_tb.wlf
