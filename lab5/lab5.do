vcom -2008 clk_gen_1Hz_v6.vhd cntr_Nbcd_load.vhd mux.vhd led8_drv.vhd key_fsm_c.vhd edge_detector.vhd debounceN.vhd top_fsm.vhd ip_pkg.vhd debounceN_tb.vhd
vsim -voptargs=+acc work.debounceN_tb
add wave *
run -all
wave zoom full
