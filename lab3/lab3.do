vcom -2008 reg.vhd nowy_reg_tb.vhd
vsim -voptargs=+acc work.reg_tb
add wave *
run [expr 1000] ns
wave zoom full
dataset save sim reg_tb.wlf
