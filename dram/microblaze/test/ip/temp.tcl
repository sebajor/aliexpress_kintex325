set cur_dir [pwd]
set bd_dir $cur_dir/fpga.srcs/sources_1/bd/system
cd ..
set origin [pwd]
cd $cur_dir


#create_bd_design "system"
create_bd_design system

#instantiate a microblaze
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
endgroup
set_property -dict [list CONFIG.C_AREA_OPTIMIZED {1} CONFIG.C_D_AXI {1} \
    CONFIG.G_TEMPLATE_LIST {8} CONFIG.C_USE_MSR_INSTR {1} CONFIG.C_USE_PCMP_INSTR {1} \
    CONFIG.C_USE_REORDER_INSTR {0} CONFIG.C_USE_BARREL {1} CONFIG.C_USE_HW_MUL {1} \
    CONFIG.C_ADDR_TAG_BITS {0} CONFIG.C_CACHE_BYTE_SIZE {4096} CONFIG.C_DCACHE_ADDR_TAG {0} \
    CONFIG.C_DCACHE_BYTE_SIZE {4096} CONFIG.C_MMU_DTLB_SIZE {2} CONFIG.C_MMU_ITLB_SIZE {1} \
    CONFIG.C_MMU_ZONES {2}] [get_bd_cells microblaze_0]


##create the memories for ilmb and dlmb 
##also create an external port for the clock (100mhz)
startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {0} axi_periph {Enabled} cache {None} clk {New External Port (100 MHz)} debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}}  [get_bd_cells microblaze_0]
endgroup

#interconect 
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 intercon0 
    set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] [get_bd_cells intercon0]
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins rst_Clk_100M/ext_reset_in]

#microblaze as master of the interconnect
connect_bd_intf_net [get_bd_intf_pins microblaze_0/M_AXI_DP] -boundary_type upper [get_bd_intf_pins intercon0/S00_AXI]

#make axi external 
startgroup
    make_bd_intf_pins_external  [get_bd_intf_pins intercon0/M00_AXI]
    make_bd_intf_pins_external  [get_bd_intf_pins intercon0/M01_AXI]
endgroup

#parameters for axil port
set_property -dict [list CONFIG.PROTOCOL {AXI4LITE}] [get_bd_intf_ports M01_AXI_0]
assign_bd_address [get_bd_addr_segs {M01_AXI_0/Reg }]
set_property offset 0x40000000 [get_bd_addr_segs {microblaze_0/Data/SEG_M01_AXI_0_Reg}]
set_property range 16K [get_bd_addr_segs {microblaze_0/Data/SEG_M01_AXI_0_Reg}]


##parameters for mig port 
set_property -dict [list CONFIG.PROTOCOL {AXI4}] [get_bd_intf_ports M00_AXI_0]
assign_bd_address [get_bd_addr_segs {M00_AXI_0/Reg }]
set_property offset 0x80000000 [get_bd_addr_segs {microblaze_0/Data/SEG_M00_AXI_0_Reg}]
set_property range 1G [get_bd_addr_segs {microblaze_0/Data/SEG_M00_AXI_0_Reg}]
set_property USAGE memory [get_bd_addr_segs -of_objects [ get_bd_intf_ports M00_AXI_0]]

#connect clocks of the interconnect
startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/Clk (100 MHz)" }  [get_bd_pins intercon0/S00_ACLK]
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/Clk (100 MHz)" }  [get_bd_pins intercon0/M00_ACLK]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/Clk (100 MHz)" }  [get_bd_pins intercon0/ACLK]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/Clk (100 MHz)" }  [get_bd_pins intercon0/M01_ACLK]

# make_wrapper -files [get_files $bd_dir/system.bd] -top
# import_files -force -norecurse $bd_dir/hdl/system_wrapper.v

##create mig 
create_ip -name mig_7series -vendor xilinx.com -library ip -version 4.2 -module_name mig_7series_0

##xilinx have problems with paths with upercase! >:(
set_property -name {CONFIG.XML_INPUT_FILE} -value [ puts $origin/ip/mig_a.prj ] -objects [get_ips mig_7series_0]



