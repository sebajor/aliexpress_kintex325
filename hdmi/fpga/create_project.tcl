create_project -force -part xc7k325t-ffg676-2  fpga
add_files -fileset sources_1 defines.v
add_files -fileset sources_1 ../rtl/fpga.v
add_files -fileset sources_1 ../rtl/hdmi_phy_intf.v
add_files -fileset sources_1 ../rtl/tmds_encoder.v
add_files -fileset sources_1 ../rtl/dvi.v
add_files -fileset constrs_1 ../fpga.xdc
exit
