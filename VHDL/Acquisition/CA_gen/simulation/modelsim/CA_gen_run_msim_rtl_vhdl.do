transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {/home/nishant/Documents/CA_test/CA_gen.vhd}
vcom -2008 -work work {/home/nishant/Documents/CA_test/CA_NRZ.vhd}

vcom -2008 -work work {/home/nishant/Documents/CA_test/CA_gen_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  CA_gen_tb

add wave *
view structure
view signals
run -all
