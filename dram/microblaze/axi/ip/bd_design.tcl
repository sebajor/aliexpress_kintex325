set cur_dir [pwd]
set bd_dir $cur_dir/fpga.srcs/sources_1/bd/system
cd ..
set origin [pwd]
cd $cur_dir


#here we create a mig project using the ipi, and usign a microblaze as a master
#The main things you have to know are:
#   1) ref clk:200 mhz for the idelayctrl
#   2) sys ref: used to generate the ddr3 clock, is the input of the pll
#       if its 200 you could use the same clock for the ref.
#   3) ui clk: is the oserdes clock (in our case like we select 4:1 is 533/4=133
#       this is the clock that is used to interface with the logic of the controller


#create_bd_design "system"
create_bd_design system

#instantiate mig
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
endgroup

#to configure the mig we need to copy the prj into the generated folder of the mig (stupid vivado)
#
file copy $origin/ip/mig_a.prj $bd_dir/ip/system_mig_7series_0_0/mig_a.prj

#configure mig
set_property -dict [list CONFIG.XML_INPUT_FILE {mig_a.prj} CONFIG.RESET_BOARD_INTERFACE {Custom} CONFIG.MIG_DONT_TOUCH_PARAM {Custom}] [get_bd_cells mig_7series_0]

#make ddr3 signals external
startgroup
    make_bd_intf_pins_external  [get_bd_intf_pins mig_7series_0/DDR3]
endgroup

#create ports for the 200mhz clock
startgroup
    create_bd_port -dir I -type clk clk_200mhz_p
    set_property CONFIG.FREQ_HZ 200000000 [get_bd_ports clk_200mhz_p]
    create_bd_port -dir I -type clk clk_200mhz_n
    set_property CONFIG.FREQ_HZ 200000000 [get_bd_ports clk_200mhz_n]
endgroup

#connect clock
connect_bd_net [get_bd_ports clk_200mhz_p] [get_bd_pins mig_7series_0/sys_clk_p]
connect_bd_net [get_bd_ports clk_200mhz_n] [get_bd_pins mig_7series_0/sys_clk_n]



#add microblaze
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
endgroup

#configure microblaze
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {1} \
                    axi_periph {Enabled} cache {None} clk {/mig_7series_0/ui_clk (133 MHz)} \
                    debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}} \
                    [get_bd_cells microblaze_0]

#connect 
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (133 MHz)} Clk_slave {/mig_7series_0/ui_clk (133 MHz)} Clk_xbar {/mig_7series_0/ui_clk (133 MHz)} Master {/microblaze_0 (Periph)} Slave {/mig_7series_0/S_AXI} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins mig_7series_0/sys_rst]


#add debugging leds
create_bd_port -dir O led0
create_bd_port -dir O led1
startgroup
    connect_bd_net [get_bd_ports led0] [get_bd_pins mig_7series_0/init_calib_complete]
	connect_bd_net [get_bd_ports led1] [get_bd_pins mig_7series_0/mmcm_locked]
endgroup

make_wrapper -files [get_files $bd_dir/system.bd] -top
import_files -force -norecurse $bd_dir/hdl/system_wrapper.v


