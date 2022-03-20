# parametry zadania
set X 1
set Y 257
set T2 5
set res 0

# kompilacja makra
vcom -work upcounter -2002 -explicit ./upcounter.vhd

vsim upcounter.counter
view wave -title counter
view signals
add wave *
force reset 1 0, 0 10ns
force clk 0 0, [expr [set $res {$res+$X}]] $T2 -r [expr {$T2*2}]
run [expr {$Y *2*$T2}] ns