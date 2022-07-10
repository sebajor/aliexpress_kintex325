
module fpga #(
    parameter VIDEO_ID_CODE=4
)
(
    input wire clk_200mhz_p,
    input wire clk_200mhz_n,
    input wire btn3,
    output wire [7:0] leds,
    //tmds output 
    output wire [1:0] hdmi_clk,
    output wire [1:0] hdmi_d0,
    output wire [1:0] hdmi_d1,
    output wire [1:0] hdmi_d2,

    output wire hdmi_cec,
    input wire  hdmi_hdp,
    output wire hdmi_sda,
    output wire hdmi_scl
);


//I2C pins
assign hdmi_sda = 1'b1;
assign hdmi_scl = 1'b1;
assign hdmi_cec = 1'b1;


wire clk_200mhz;

IBUFGDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("FALSE"),
    .IOSTANDARD("DIFF_SSTL15")
) IBUFDS_inst (
    .I		(clk_200mhz_p),
    .IB		(clk_200mhz_n),
    .O		(clk_200mhz)
);

//for the 1280x720 we need the clk_pixel at 74.25 and the clk_pixel_x5 at 371.25
wire clk_pixel, clk_pixel_x5;
wire mmcm_clkfb, mmcm_locked;
wire mmcm_rst =1'b0;

// MMCM instance
// 200 MHz in, 
// VCO range: 600 MHz to 1200 MHz
// M = 18.5, D = 5 sets Fvco = 740 MHz (in range)
// Divide by 2 to get output frequency of 370 MHz
// Divide by 10 to get output frequency of 74 MHz
MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(18.5),       //2-64 with 0.125 steps
    .DIVCLK_DIVIDE(5),
    .CLKIN1_PERIOD(5.0),
    .CLKFBOUT_PHASE(0),
    .REF_JITTER1(0.010),
    .STARTUP_WAIT("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    
    .CLKOUT0_DIVIDE_F(2),       //1-128, with 0.125 step
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0),
    
    .CLKOUT1_DIVIDE(10),
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
    .CLKOUT6_PHASE(0)
)
clk_mmcm_inst (
    .CLKIN1(clk_200mhz),
    .CLKFBIN(mmcm_clkfb),
    .CLKFBOUT(mmcm_clkfb),
    .CLKFBOUTB(),
    .RST(mmcm_rst),
    .PWRDWN(1'b0),
    .CLKOUT0(clk_pixel_x5),
    .CLKOUT0B(),
    .CLKOUT1(clk_pixel),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .LOCKED(mmcm_locked)
);


assign leds = {{6{1'b1}}, ~mmcm_locked ,~hdmi_hdp};

//btn syncronizer 
reg [3:0] rst_btn =4'b0;
always@(posedge clk_pixel)begin
    rst_btn <= {rst_btn[2:0], btn3};
end


//cx: current x position of the pixel
//cy: current y position of the pixel

reg [23:0] rgb = 24'd0;
wire [9:0] cx, cy, screen_start_x, screen_start_y, frame_width, frame_height, screen_width, screen_height;
wire [2:0] tmds;
wire tmds_clock;

//always@(posedge clk_pixel)
//  rgb <= {cx == screen_start_x ? ~8'd0 : 8'd0, cy == screen_start_y ? ~8'd0 : 8'd0, cx == frame_width - 1'd1 || cy == frame_height - 1'd1 ? ~8'd0 : 8'd0};
wire [9:0] xor_pattern;
assign xor_pattern = cx ^cy;

always@(posedge clk_pixel)begin
    rgb <= {3{xor_pattern}};
end


dvi #(
    .VIDEO_ID_CODE(4)
) dvi_inst (
    .pxl_clk(clk_pixel),
    .pxl_clk_x5(clk_pixel_x5),
    .rgb(rgb),
    .phy_tmds_lanes({hdmi_d2, hdmi_d1, hdmi_d0}),   //{hdmi0_p,hdmi0_n, ....}
    .phy_tmds_clk(hdmi_clk),
    .cx(cx),
    .cy(cy),
    .frame_width(frame_width),
    .frame_height(frame_height),
    .screen_width(screen_width),
    .screen_height(screen_height),
    .screen_start_x(screen_start_x),
    .screen_start_y(screen_start_y)
);


endmodule
