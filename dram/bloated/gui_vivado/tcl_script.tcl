#create block design
create_bd_design "design_1"

#create microblaze
set_property -dict [list CONFIG.C_AREA_OPTIMIZED {0} CONFIG.C_D_AXI {1} CONFIG.C_ADDR_TAG_BITS {0} CONFIG.C_DCACHE_ADDR_TAG {0}] [get_bd_cells microblaze_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {0} axi_periph {Enabled} cache {None} clk {New External Port (100 MHz)} debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}}  [get_bd_cells microblaze_0]
endgroup

#clock port
startgroup
create_bd_port -dir I -type clk clk_100mhz
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports clk_100mhz]
endgroup

#connections
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {0} axi_periph {Enabled} cache {None} clk {/clk_100mhz (100 MHz)} debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}}  [get_bd_cells microblaze_0]

#add mig 
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
endgroup

#configure it
set_property -name {CONFIG.XML_INPUT_FILE} -value  {mig_a.prj} -objects [get_bd_cells mig_7series_0]
set_property -name {CONFIG.RESET_BOARD_INTERFACE} -value  {Custom} -objects [get_bd_cells mig_7series_0]
set_property -name {CONFIG.MIG_DONT_TOUCH_PARAM} -value  {Custom} -objects [get_bd_cells mig_7series_0]
set_property -name {CONFIG.BOARD_MIG_PARAM} -value  {Custom} -objects [get_bd_cells mig_7series_0]


