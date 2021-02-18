#XDC constaints for kintex 325 from aliexpress
#part: XC7K325T-FFG676

#general configurations
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#clocks
#clk_100mhz could be 33 oe 25 depending on the switch
set_property -dict {LOC F17 IOSTANDARD LVCMOS33} [get_ports clk_100mhz]
create_clock -period 10.0 -name clk_100mhz -waveform {0.0 5.0} [get_ports clk_100mhz]

#set_property -dict {LOC AB11 IOSTANDARD DIFF_SSTL15} [get_ports clk_200mhz_p]
#set_property -dict {LOC AC11 IOSTANDARD DIFF_SSTL15} [get_ports clk_200mhz_n]
#create_clock -period 5.0 -name clk_200mhz [get_ports clk_200mhz_p]


#buttons
##check that the switch is in 3.3V, otherwise modify this
##the buttons are inverted, presed is 0 and not press is 1
set_property -dict {LOC C24 IOSTANDARD LVCMOS33} [get_ports btn3]
set_property -dict {LOC AC16 IOSTANDARD LVCMOS15} [get_ports btn2]


#leds, they are pull-up so 0 means the led lights up
set_property -dict {LOC AA2 IOSTANDARD LVCMOS15} [get_ports {leds[0]}]
set_property -dict {LOC AD5 IOSTANDARD LVCMOS15} [get_ports {leds[1]}]
set_property -dict {LOC W10 IOSTANDARD LVCMOS15} [get_ports {leds[2]}]
set_property -dict {LOC Y10 IOSTANDARD LVCMOS15} [get_ports {leds[3]}]
set_property -dict {LOC AE10 IOSTANDARD LVCMOS15} [get_ports {leds[4]}]
set_property -dict {LOC W11 IOSTANDARD LVCMOS15} [get_ports {leds[5]}]
set_property -dict {LOC V11 IOSTANDARD LVCMOS15} [get_ports {leds[6]}]
set_property -dict {LOC Y12 IOSTANDARD LVCMOS15} [get_ports {leds[7]}]

#uart ports
set_property -dict {LOC L25 IOSTANDARD LVCMOS33} [get_ports uart_rx]
set_property -dict {LOC M25 IOSTANDARD LVCMOS33} [get_ports uart_tx]






