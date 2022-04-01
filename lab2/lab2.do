vcom -work work -2002 -explicit ./devices.vhd
vcom -work work -2002 -explicit ./gates.vhd
vcom -work work -2002 -explicit ./lab2.vhd

vsim work.licznik
view wave -title lab2
view signals
add wave *

force clr '1' 0 ns, '0' 10 ns
for {set i 0} {$i < 200000} {incr i} {
	force clk '0' [expr 5 * $i * 2] ns, '1' [expr 5 * ($i*2 + 1)] ns
}
run 10000 ns
