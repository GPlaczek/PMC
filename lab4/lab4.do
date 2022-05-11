vcom -2008 key_fsm_c.vhd pkg_symuli.vhd key_fsm_c_tb.vhd
vsim -voptargs=+acc work.key_fsm_c_tb
add wave *
run -all
wave zoom full
