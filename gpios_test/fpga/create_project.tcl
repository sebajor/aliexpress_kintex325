create_project -force -part xc7k325t-ffg676-2  fpga
add_files -fileset sources_1 defines.v
add_files -fileset sources_1 ../rtl/fpga.v
add_files -fileset constrs_1 ../fpga.xdc
exit
