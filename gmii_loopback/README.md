This design listen to the UDP port 1234 with the IP address
192.168.1.128 and echo back any packet received. It also respond
to arp requests.


The PHY is a Marvell 88E1111 and it only works as gmii (the tx_clk for the mii
is located in a non-clock pin).

The codes are a modified version of Alex Forencich verilog-ethernet codes, to 
allow only 1000mbps comunication (his codes creates a tri-mode mac)

## To program the fpga
    xsdb
    connect
    fpga -f fpga_rev100.bit

## To test the model

UDP connection:
    nc -u 192.168.1.128 1234

