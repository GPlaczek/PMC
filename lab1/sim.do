vcom -work work -2002 -explicit ./lab1/upcounter.vhd
vsim work.counter
view wave -title counter
view signals
add wave *

set X 1
set Y 257
set T2 5
set i 0

for {set i $X} {$i < $Y} {incr i} {
	force bus_in 10#[expr $X * $i] [expr $T2 * $i * 2] ns
}
run [expr $T2 * $Y * 2] ns
