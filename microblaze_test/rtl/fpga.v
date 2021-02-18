//`default_nettype none


module fpga (
    input wire clk_100mhz,
    input wire btn3
);

system_wrapper wrapper(
    .Clk(clk_100mhz),
    .reset_rtl_0(btn3)
);


endmodule 
