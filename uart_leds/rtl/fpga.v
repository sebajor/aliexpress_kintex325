`default_nettype none
/*
`ifndef _include_
    `define _include_
    `include "uart_rx.v"
    `include "uart_tx.v"
`endif
*/

module fpga #(
    parameter CLK_FREQ = 100_000_000,
    parameter UART_BAUD_RATE = 115200
) (
    //clock: 100mhz
    input wire clk_100mhz,
    //buttons
    input wire btn3,
    input wire btn2,
    
    //leds
    output wire [7:0] leds,
    
    //uart
    input wire uart_rx,
    output wire uart_tx 
);



reg [$clog2(CLK_FREQ)-1:0] counter=0;
reg [6:0] leds_val = 0;
always@(posedge clk_100mhz)begin
    counter <= counter+1;
    if(&counter)
        leds_val <= leds_val+1;
    else 
        leds_val <= leds_val;
end


assign leds = {~leds_val, btn2};



wire [7:0] uart_tdata;
wire uart_tvalid, uart_tready;


uart_rx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(UART_BAUD_RATE),
    .N_BITS(8)
) uart_rx_inst (
    .rst(~btn3),
    .clk(clk_100mhz),
    .rx_data(uart_rx),  
    .uart_rx_tdata(uart_tdata),
    .uart_rx_tvalid(uart_tvalid),
    .uart_rx_tready(uart_tready)
);


uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(UART_BAUD_RATE)
) uart_tx_inst (
    //physical pins
    .clk(clk_100mhz),
    .tx_data(uart_tx),
    //input data
    .axis_tdata(uart_tdata),
    .axis_tvalid(uart_tvalid),
    .axis_tready(uart_tready)
);


endmodule
