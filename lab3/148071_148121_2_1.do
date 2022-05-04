vcom -2008 reg.vhd 148071_148121_2_1.vhd
vsim -voptargs=+acc work.nowy_reg_tb
add wave *
run [expr 1000] ns
wave zoom full
dataset save sim nowy_reg_tb.wlf
