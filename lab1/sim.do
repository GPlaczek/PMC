vcom -work work -2002 -explicit /home/ise/Desktop/PMC/lab1/dummy.vhd
vsim work.dummy
view wave -title dummy
view signals
add wave *

set X 1
set Y 520
set T2 5
set i 0

for {set i $X} {$i < $Y} {incr i} {
	force bus_in 10#$i [expr $T2 * $i * 2] ns
}
run [expr $T2 * $Y * 2] ns
