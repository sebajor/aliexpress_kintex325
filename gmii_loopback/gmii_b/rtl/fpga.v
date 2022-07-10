module fpga (
    /*  clock: 200mhz
        reset: push button, pulled-up
        */
    input wire clk_200mhz_p,
    input wire clk_200mhz_n,
    input wire btn3,

    //leds
    output wire [7:0] leds,

    /*
        Ethernet: 1000BASE-T GMII
    */
    input  wire       b_phy_rx_clk,
    input  wire [7:0] b_phy_rxd,
    input  wire       b_phy_rx_dv,
    input  wire       b_phy_rx_er,
    output wire       b_phy_gtx_clk,
    output wire [7:0] b_phy_txd,
    output wire       b_phy_tx_en,
    output wire       b_phy_tx_er
    //input  wire       phy_tx_clk
);

wire reset = ~btn3;

wire clk_200_mhz_ibufg;

//internal 125MHz clk
wire clk_mmcm_out;
wire clk_int;
wire rst_int;

wire mmcm_rst = reset;
wire mmcm_locked;
wire mmcm_clkfb;

IBUFGDS
clk_200mhz_ibufgds_inst(
    .I(clk_200mhz_p),
    .IB(clk_200mhz_n),
    .O(clk_200mhz_ibufg)
);


// MMCM instance
// 200 MHz in, 125 MHz out
// PFD range: 10 MHz to 500 MHz
// VCO range: 600 MHz to 1440 MHz
// M = 5, D = 1 sets Fvco = 1000 MHz (in range)
// Divide by 8 to get output frequency of 125 MHz
MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKOUT0_DIVIDE_F(8),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0),
    .CLKOUT1_DIVIDE(8),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT1_PHASE(0),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT2_PHASE(0),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT3_PHASE(0),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT4_PHASE(0),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT5_PHASE(0),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT6_PHASE(0),
    .CLKFBOUT_MULT_F(5),
    .CLKFBOUT_PHASE(0),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.010),
    .CLKIN1_PERIOD(5.0),
    .STARTUP_WAIT("FALSE"),
    .CLKOUT4_CASCADE("FALSE")
)
clk_mmcm_inst (
    .CLKIN1(clk_200mhz_ibufg),
    .CLKFBIN(mmcm_clkfb),
    .RST(mmcm_rst),
    .PWRDWN(1'b0),
    .CLKOUT0(clk_mmcm_out),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(mmcm_clkfb),
    .CLKFBOUTB(),
    .LOCKED(mmcm_locked)
);

BUFG
clk_bufg_inst (
    .I(clk_mmcm_out),
    .O(clk_int)
);

sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk_int),
    .rst(~mmcm_locked),
    .out(rst_int)
);

fpga_core #(
    .TARGET("XILINX")
) core_inst (
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    .clk(clk_int),
    .rst(rst_int),
    //gpios
    .leds(leds),
    /*
     * Ethernet: 1000BASE-T GMII
     */
    .phy_rx_clk(b_phy_rx_clk),
    .phy_rxd(b_phy_rxd),
    .phy_rx_dv(b_phy_rx_dv),
    .phy_rx_er(b_phy_rx_er),
    .phy_gtx_clk(b_phy_gtx_clk),
    .phy_txd(b_phy_txd),
    .phy_tx_en(b_phy_tx_en),
    .phy_tx_er(b_phy_tx_er)
);


endmodule
