transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Code/Quartus/garland/garland_logic.vhd}
vcom -93 -work work {D:/Code/Quartus/garland/RGB_LED.vhd}
vcom -93 -work work {D:/Code/Quartus/garland/RGB_logic.vhd}

