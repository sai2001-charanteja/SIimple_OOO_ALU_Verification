.main clear

vsim -assertdebug -sv_lib C:/questasim64_2021.1/uvm-1.2/win64/uvm_dpi \
    work.alu_top +UVM_TESTNAME=alu_test

add wave -r sim:/alu_top/aif/*

#do wave.do

run -all



