vlib work

# compiling verilog files

vlog ../tb/altera_sim/altera_mf.v

vlog ../rtl/waveform_draw/one_screen_fifo.v
vlog ../rtl/numbers_mem/numbers_mem.v
vlog ../rtl/waveform_draw/one_screen_ram.v

# compiling systemerilog files

vlog ../rtl/vga_ctrl/pixels_if.sv
vlog ../rtl/watches/time_if.sv
vlog ../rtl/vga_ctrl/vga_if.sv
vlog ../rtl/watches/watches_ctrl_if.sv
vlog ../rtl/adc_ctrl/adc_ctrl_if.sv

vlog ../rtl/numbers_mem/num_sync.sv
vlog ../rtl/numbers_mem/num_to_pix.sv


vlog ../rtl/time_draw.sv

vlog ../rtl/watches/sec_pll.v
vlog ../rtl/watches/watches_hour_cnt.sv
vlog ../rtl/watches/watches_min_cnt.sv
vlog ../rtl/watches/watches_sec_cnt.sv
vlog ../rtl/watches/watches.sv

vlog ../rtl/vga_ctrl/vga_mux.sv

vlog ../rtl/default_draw.sv

vlog ../rtl/adc_ctrl/adc_resampler.sv

vlog ../rtl/waveform_draw/waveform_draw.sv

vlog ../rtl/main_waveform.sv

vlog top_tb.sv

# top_tb is name for your testbench module

vsim -novopt top_tb

#adding all waveforms in hex view
add wave -r -hex *

# running simulation for 1000 nanoseconds
# you can change for run -all for infinity simulation :-)
run -all
