set cur_dir [pwd]
puts $cur_dir
set bd_dir $cur_dir/fpga/fpga.srcs/sources_1/bd/system 

#create_bd_design "design_1"
create_bd_design system

#istantiate and configure microblaze
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
endgroup
set_property -dict [list CONFIG.C_AREA_OPTIMIZED {1} CONFIG.C_D_AXI {1} \
    CONFIG.G_TEMPLATE_LIST {8} CONFIG.C_USE_MSR_INSTR {1} CONFIG.C_USE_PCMP_INSTR {1} \
    CONFIG.C_USE_REORDER_INSTR {0} CONFIG.C_USE_BARREL {1} CONFIG.C_USE_HW_MUL {1} \
    CONFIG.C_ADDR_TAG_BITS {0} CONFIG.C_CACHE_BYTE_SIZE {4096} CONFIG.C_DCACHE_ADDR_TAG {0} \
    CONFIG.C_DCACHE_BYTE_SIZE {4096} CONFIG.C_MMU_DTLB_SIZE {2} CONFIG.C_MMU_ITLB_SIZE {1} \
    CONFIG.C_MMU_ZONES {2}] [get_bd_cells microblaze_0]

#block automation
startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {0} \
        axi_periph {Enabled} cache {None} clk {New External Port (100 MHz)} \
        debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}}  [get_bd_cells microblaze_0]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins rst_Clk_100M/ext_reset_in]

#instantiate a dual port ram, connected to the microblaze with addr 0x40000000
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
endgroup

startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/Clk (100 MHz)} \
        Clk_slave {Auto} Clk_xbar {Auto} Master {/microblaze_0 (Periph)} Slave {/axi_bram_ctrl_0/S_AXI} \
        intc_ip {Auto} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
    apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
endgroup
set_property offset 0x40000000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_bram_ctrl_0_Mem0}]


##create the wrapper for the platform (modify the path)
#make_wrapper -files [get_files /home/seba/Workspace/aliexpress_kintex325/microblaze_test/gui_vivado/project_1/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top
#import_files -force -norecurse /home/seba/Workspace/aliexpress_kintex325/microblaze_test/gui_vivado/project_1/project_1.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
make_wrapper -files [get_files $bd_dir/system.bd] -top
import_files -force -norecurse $bd_dir/system_wrapper.v

