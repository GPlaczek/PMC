vcom -2008 148071_148121_3.vhd pkg_symuli.vhd key_fsm_c_tb.vhd
vsim -voptargs=+acc work.key_fsm_c_tb
add wave *
run -all
wave zoom full
