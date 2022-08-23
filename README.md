# Aliexpress kintex 325


https://es.aliexpress.com/item/1005001275162791.html


To build the projects you need to add to the vivado to the PATH

## TODO

- [ ] Complete the xdc file
- [x] Automatic building using vivado in batch mode
- [x] UART-led basic test
- [x] GPIOs
- [ ] DRAM model
- [x] Gbe model
- [ ] 10Gbe model
- [x] HDMI model 
- [ ] SATA model
- [ ] PCIe model
- [ ] HPC LPC model test




##NOTES:
- The gmii_a txclk is placed in E12, and the gmii_b txclk is placed in C9,
 which are non-clock capable pin. So I think it only could work a 1000mbps.


