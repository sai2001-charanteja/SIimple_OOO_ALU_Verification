.main clear

quit -sim

if {[file exists work]} {
    vdel -lib work -all
}

vlib work

vlog -sv ../RTL/alu_if.sv +acc
vlog -sv +acc ../RTL/alu_rtl.sv +acc
vlog -f filelist.f

