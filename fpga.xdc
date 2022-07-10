#XDC constaints for kintex 325 from aliexpress
#part: XC7K325T-FFG676

#general configurations
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

##CFGVS selects the IO voltage of the banks 0,14,15 (if Vbanks=3.3 or 2.5
##connect to VCC, else connect it to gnd. 

#clocks
#clk_100mhz could be 33 oe 25 depending on the switch
#set_property -dict {LOC F17 IOSTANDARD LVCMOS33} [get_ports clk_100mhz]
#create_clock -period 10.0 -name clk_100mhz -waveform {0.0 5.0} [get_ports clk_100mhz]

set_property -dict {LOC AB11 IOSTANDARD DIFF_SSTL15} [get_ports clk_200mhz_p]
set_property -dict {LOC AC11 IOSTANDARD DIFF_SSTL15} [get_ports clk_200mhz_n]
create_clock -period 5.0 -name clk_200mhz [get_ports clk_200mhz_p]


#buttons
##check that the switch is in 3.3V, otherwise modify this
##the buttons are inverted, presed is 0 and not press is 1
set_property -dict {LOC C24 IOSTANDARD LVCMOS33} [get_ports btn3]
#set_property -dict {LOC AC16 IOSTANDARD LVCMOS15} [get_ports btn2]


#leds, they are pull-up so 0 means the led lights up
#set_property -dict {LOC AA2 IOSTANDARD LVCMOS15} [get_ports {leds[0]}]
#set_property -dict {LOC AD5 IOSTANDARD LVCMOS15} [get_ports {leds[1]}]
#set_property -dict {LOC W10 IOSTANDARD LVCMOS15} [get_ports {leds[2]}]
#set_property -dict {LOC Y10 IOSTANDARD LVCMOS15} [get_ports {leds[3]}]
#set_property -dict {LOC AE10 IOSTANDARD LVCMOS15} [get_ports {leds[4]}]
#set_property -dict {LOC W11 IOSTANDARD LVCMOS15} [get_ports {leds[5]}]
#set_property -dict {LOC V11 IOSTANDARD LVCMOS15} [get_ports {leds[6]}]
#set_property -dict {LOC Y12 IOSTANDARD LVCMOS15} [get_ports {leds[7]}]


#uart ports
#set_property -dict {LOC L25 IOSTANDARD LVCMOS33} [get_ports uart_rx]
#set_property -dict {LOC M25 IOSTANDARD LVCMOS33} [get_ports uart_tx]

##gmii a
##the tx_clk is driven by a non clock pin :(
set_property -dict {LOC C12  IOSTANDARD LVCMOS25} [get_ports a_phy_rx_clk] ;
set_property -dict {LOC H14  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[0]}]
set_property -dict {LOC J14  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[1]}]
set_property -dict {LOC J13  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[2]}]
set_property -dict {LOC H13  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[3]}]
set_property -dict {LOC B15  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[4]}]
set_property -dict {LOC A15  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[5]}]
set_property -dict {LOC B14  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[6]}]
set_property -dict {LOC A14  IOSTANDARD LVCMOS25} [get_ports {a_phy_rxd[7]}]
set_property -dict {LOC G14  IOSTANDARD LVCMOS25} [get_ports a_phy_rx_dv]
set_property -dict {LOC F14  IOSTANDARD LVCMOS25} [get_ports a_phy_rx_er]

set_property -dict {LOC F13  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports a_phy_gtx_clk] ;# from U37.E2 TXC_GTXCLK

#set_property -dict {LOC E12  IOSTANDARD LVCMOS25} [get_ports a_phy_tx_clk] ;# from U37.D1 TXCLK

set_property -dict {LOC G12  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[0]}] ;# from U37.F1 TXD0
set_property -dict {LOC E11  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[1]}] ;# from U37.G2 TXD1
set_property -dict {LOC G11  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[2]}] ;# from U37.G3 TXD2
set_property -dict {LOC C14  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[3]}] ;# from U37.H1 TXD3
set_property -dict {LOC D14  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[4]}] ;# from U37.H2 TXD4
set_property -dict {LOC C13  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[5]}] ;# from U37.H3 TXD5
set_property -dict {LOC C11  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[6]}] ;# from U37.J1 TXD6
set_property -dict {LOC D13  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {a_phy_txd[7]}] ;# from U37.J2 TXD7
set_property -dict {LOC F12  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports a_phy_tx_en] ;# from U37.E1 TXCTL_TXEN
set_property -dict {LOC E13  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports a_phy_tx_er] ;# from U37.F2 TXER

#create_clock -period 40.000 -name phy_tx_clk [get_ports a_phy_tx_clk]
create_clock -period 8.000 -name a_phy_rx_clk [get_ports a_phy_rx_clk]

set_property -dict {LOC K15  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports a_phy_mdio]
set_property -dict {LOC M16  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports a_phy_mdc]



##gmii b
##the tx_clk is driven by a non clock pin :(
#set_property -dict {LOC E10  IOSTANDARD LVCMOS25} [get_ports b_phy_rx_clk] ;
#set_property -dict {LOC A13  IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[0]}]
#set_property -dict {LOC B12 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[1]}]
#set_property -dict {LOC B11 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[2]}]
#set_property -dict {LOC A10 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[3]}]
#set_property -dict {LOC B10 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[4]}]
#set_property -dict {LOC A9 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[5]}]
#set_property -dict {LOC B9 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[6]}]
#set_property -dict {LOC A8 IOSTANDARD LVCMOS25} [get_ports {b_phy_rxd[7]}]
#set_property -dict {LOC A12 IOSTANDARD LVCMOS25} [get_ports b_phy_rx_dv]
#set_property -dict {LOC D10 IOSTANDARD LVCMOS25} [get_ports b_phy_rx_er]

#set_property -dict {LOC D8 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports b_phy_gtx_clk] ;# from U37.E2 TXC_GTXCLK

#set_property -dict {LOC C9 IOSTANDARD LVCMOS25} [get_ports b_phy_tx_clk] ;# from U37.D1 TXCLK

#set_property -dict {LOC H11 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[0]}] ;# from U37.F1 TXD0
#set_property -dict {LOC J11 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[1]}] ;# from U37.G2 TXD1
#set_property -dict {LOC H9 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[2]}] ;# from U37.G3 TXD2
#set_property -dict {LOC J10 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[3]}] ;# from U37.H1 TXD3
#set_property -dict {LOC H12 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[4]}] ;# from U37.H2 TXD4
#set_property -dict {LOC F10 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[5]}] ;# from U37.H3 TXD5
#set_property -dict {LOC G10 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[6]}] ;# from U37.J1 TXD6
#set_property -dict {LOC F9 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {b_phy_txd[7]}] ;# from U37.J2 TXD7
#set_property -dict {LOC F8 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports b_phy_tx_en] ;# from U37.E1 TXCTL_TXEN
#set_property -dict {LOC D9 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports b_phy_tx_er] ;# from U37.F2 TXER

#create_clock -period 40.000 -name phy_tx_clk [get_ports a_phy_tx_clk]
#create_clock -period 8.000 -name b_phy_rx_clk [get_ports b_phy_rx_clk]

#set_property -dict {LOC G9  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports b_phy_mdio]
#set_property -dict {LOC H8  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports b_phy_mdc]



#hdmi pins
#set_property -dict {LOC P21 IOSTANDARD TMDS_33} [get_ports {hdmi_clk[0]}] ;#n
#set_property -dict {LOC R21 IOSTANDARD TMDS_33} [get_ports {hdmi_clk[1]}] ;#p
#set_property -dict {LOC M19 IOSTANDARD TMDS_33} [get_ports {hdmi_d0[0]}]
#set_property -dict {LOC N18 IOSTANDARD TMDS_33} [get_ports {hdmi_d0[1]}]
#set_property -dict {LOC M22 IOSTANDARD TMDS_33} [get_ports {hdmi_d1[0]}]
#set_property -dict {LOC M21 IOSTANDARD TMDS_33} [get_ports {hdmi_d1[1]}]
#set_property -dict {LOC K26 IOSTANDARD TMDS_33} [get_ports {hdmi_d2[0]}]
#set_property -dict {LOC K25 IOSTANDARD TMDS_33} [get_ports {hdmi_d2[1]}]

#set_property -dict {LOC M26 IOSTANDARD LVCMOS33} [get_ports hdmi_cec]
#set_property -dict {LOC N26 IOSTANDARD LVCMOS33} [get_ports hdmi_hdp]
#set_property -dict {LOC K21 IOSTANDARD LVCMOS33} [get_ports hdmi_scl]
#set_property -dict {LOC L23 IOSTANDARD LVCMOS33} [get_ports hdmi_sda]


#GPIOS 2.54 pinheader: There are 50 pins here, check the schematics!
#row 4,9,14 are GND; row 15 is NC and row 16 is [3.3, 2.5, NC, 3.3, 2.5]

#Some are differential pairs I am going to put them that way
#Note: bank 0,14,15 are multi-task and the userIO are named IO_LXXY_# and IO_XX_#
#where L indicates a differential pair,  Y=p|n and # is the bank number
#A,B columns
#set_property -dict {LOC J20 IOSTANDARD LVCMOS33} [get_ports gpio_a1] ;#IO_L19N_T3_A21_VREF_15
#set_property -dict {LOC K20 IOSTANDARD LVCMOS33} [get_ports gpio_b1] ;#IO_L19P_T3_A22_15

#set_property -dict {LOC G20 IOSTANDARD LVCMOS33} [get_ports gpio_a2]  ;#IO_L18N_T2_A23_15
#set_property -dict {LOC H19 IOSTANDARD LVCMOS33} [get_ports gpio_b2]  ;#IO_L18P_T2_A24_15

#set_property -dict {LOC L20 IOSTANDARD LVCMOS33} [get_ports gpio_a3]  ;#IO_L21N_T3_DQS_A18_15
#set_property -dict {LOC L19 IOSTANDARD LVCMOS33} [get_ports gpio_b3]  ;#IO_L21P_T3_DQS_15

#set_property -dict {LOC E20 IOSTANDARD LVCMOS33} [get_ports gpio_a5]  ;#IO_L17N_T2_A25_15
#set_property -dict {LOC F19 IOSTANDARD LVCMOS33} [get_ports gpio_b5]  ;#IO_L17P_T2_A26_15

#set_property -dict {LOC H18 IOSTANDARD LVCMOS33} [get_ports gpio_a6]  ;#IO_L14N_T2_SRCC_15
#set_property -dict {LOC H17 IOSTANDARD LVCMOS33} [get_ports gpio_b6]  ;#IO_L14P_T2_SRCC_15

#set_property -dict {LOC F18 IOSTANDARD LVCMOS33} [get_ports gpio_a7]  ;#IO_L11N_T1_SRCC_AD12N_15
#set_property -dict {LOC G17 IOSTANDARD LVCMOS33} [get_ports gpio_b7]  ;#IO_L11P_T1_SRCC_AD12P_15

#set_property -dict {LOC G16 IOSTANDARD LVCMOS33} [get_ports gpio_a8]  ;#IO_L7N_T1_AD10N_15
#set_property -dict {LOC H16 IOSTANDARD LVCMOS33} [get_ports gpio_b8]  ;#IO_L7P_T1_AD10P_15

#set_property -dict {LOC F24 IOSTANDARD LVCMOS33} [get_ports gpio_a10]  ;#IO_L14N_T2_SRCC_14
#set_property -dict {LOC G24 IOSTANDARD LVCMOS33} [get_ports gpio_b10]  ;#IO_L14P_T2_SRCC_14

#set_property -dict {LOC F20 IOSTANDARD LVCMOS33} [get_ports gpio_a11]  ;#IO_L16N_T2_A27_15
#set_property -dict {LOC G19 IOSTANDARD LVCMOS33} [get_ports gpio_b11]  ;#IO_L16P_T2_A28_15

#set_property -dict {LOC L18 IOSTANDARD LVCMOS33} [get_ports gpio_a12]  ;#IO_L23N_T3_FWE_B_15
#set_property -dict {LOC M17 IOSTANDARD LVCMOS33} [get_ports gpio_b12]  ;#IO_L23P_T3_FOE_B_15

#set_property -dict {LOC H24 IOSTANDARD LVCMOS33} [get_ports gpio_a13]  ;#IO_L20N_T3_A07_D23_14
#set_property -dict {LOC H23 IOSTANDARD LVCMOS33} [get_ports gpio_b13]  ;#IO_L20P_T3_A08_D24_14

#C column, the diff pair is contained in the same column
#C1,C9,C12,C14 =GND; C5,C6,C13,C15,C16 =NC

#set_property -dict {LOC D19 IOSTANDARD LVCMOS33} [get_ports gpio_c2]  ;#IO_L15P_T2_DQS_15
#set_property -dict {LOC D20 IOSTANDARD LVCMOS33} [get_ports gpio_c3]  ;#IO_L15N_T2_DQS_ADV_B_15

#set_property -dict {LOC D18 IOSTANDARD LVCMOS33} [get_ports gpio_c7]  ;#IO_L13N_T2_MRCC_15
#set_property -dict {LOC E18 IOSTANDARD LVCMOS33} [get_ports gpio_c8]  ;#IO_L13P_T2_MRCC_15

#set_property -dict {LOC E16 IOSTANDARD LVCMOS33} [get_ports gpio_c10]  ;#IO_L10N_T1_AD4N_15
#set_property -dict {LOC E15 IOSTANDARD LVCMOS33} [get_ports gpio_c11]  ;#IO_L10P_T1_AD4P_15

#D,E columns

#set_property -dict {LOC J18 IOSTANDARD LVCMOS33} [get_ports gpio_d1]  ;#IO_L20P_T3_A20_15
#set_property -dict {LOC J19 IOSTANDARD LVCMOS33} [get_ports gpio_e1]  ;#IO_L20N_T3_A19_15

#set_property -dict {LOC L17 IOSTANDARD LVCMOS33} [get_ports gpio_d2]  ;#IO_L24P_T3_RS1_15
#set_property -dict {LOC K18 IOSTANDARD LVCMOS33} [get_ports gpio_e2]  ;#IO_L24N_T3_RS0_15

#set_property -dict {LOC K16 IOSTANDARD LVCMOS33} [get_ports gpio_d3]  ;#IO_L22P_T3_A17_15
#set_property -dict {LOC K17 IOSTANDARD LVCMOS33} [get_ports gpio_e3]  ;#IO_L22N_T3_A16_15

#set_property -dict {LOC C19 IOSTANDARD LVCMOS33} [get_ports gpio_d5]  ;#IO_L4P_T0_AD9P_15
#set_property -dict {LOC B19 IOSTANDARD LVCMOS33} [get_ports gpio_e5]  ;#IO_L4N_T0_AD9N_15

#set_property -dict {LOC C18 IOSTANDARD LVCMOS33} [get_ports gpio_d6]  ;#IO_L5N_T0_AD2N_15
#set_property -dict {LOC C17 IOSTANDARD LVCMOS33} [get_ports gpio_e6]  ;#IO_L5P_T0_AD2P_15

#set_property -dict {LOC C16 IOSTANDARD LVCMOS33} [get_ports gpio_d7]  ;#IO_L1P_T0_AD0P_15
#set_property -dict {LOC B16 IOSTANDARD LVCMOS33} [get_ports gpio_e7]  ;#IO_L1N_T0_AD0N_15

#set_property -dict {LOC D15 IOSTANDARD LVCMOS33} [get_ports gpio_d8]  ;#IO_L6P_T0_15
#set_property -dict {LOC D16 IOSTANDARD LVCMOS33} [get_ports gpio_e8]  ;#IO_L6N_T0_VREF_15

#set_property -dict {LOC G15 IOSTANDARD LVCMOS33} [get_ports gpio_d10]  ;#IO_L8P_T1_AD3P_15
#set_property -dict {LOC F15 IOSTANDARD LVCMOS33} [get_ports gpio_e10]  ;#IO_L8N_T1_AD3N_15

#set_property -dict {LOC J15 IOSTANDARD LVCMOS33} [get_ports gpio_d11]  ;#IO_L9P_T1_DQS_AD11P_15
#set_property -dict {LOC J16 IOSTANDARD LVCMOS33} [get_ports gpio_e11]  ;#IO_L9N_T1_DQS_AD11N_15

#set_property -dict {LOC A18 IOSTANDARD LVCMOS33} [get_ports gpio_d12]  ;#IO_L2P_T0_AD8P_15
#set_property -dict {LOC A19 IOSTANDARD LVCMOS33} [get_ports gpio_e12]  ;#IO_L2N_T0_AD8N_15

#set_property -dict {LOC B17 IOSTANDARD LVCMOS33} [get_ports gpio_d13]  ;#IO_L3P_T0_DQS_AD1P_15
#set_property -dict {LOC A17 IOSTANDARD LVCMOS33} [get_ports gpio_e13]  ;#IO_L3N_T0_DQS_AD1N_15
