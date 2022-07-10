`default_nettype none

//oserdes to output tmds data
module hdmi_phy #(
    parameter N_CHANNELS =3
) (
    input wire rst,
    input wire clk_pixel,
    input wire clk_pixel_x5,
    input wire [29:0] tmds_internal,

    output wire [5:0] tmds_lane,    //diferential output
    output wire [1:0] tmds_clk
);
//like tmds are 10 bits and one oserdes accept just 8 we need to 
//cascade two of them

wire [2:0] tmds;
generate
genvar i;
for(i=0; i<N_CHANNELS; i=i+1)begin
    wire [1:0] shift_out;
    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"),   // output rate (DDR,SDR)
        .DATA_RATE_TQ("SDR"),   // 3 state rate (DDR,BUF,SDR)
        .DATA_WIDTH(10),       // input data width (parallel) 
        .INIT_OQ(1'b0),   // Initial value of OQ
        .INIT_TQ(1'b0),         // Initial value of TQ
        .SERDES_MODE("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
       ) 
       OSERDES_master_inst (
          .OFB(),               // out: data Feedback path 
          .OQ(tmds[i]),         // outp: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
          .SHIFTOUT1(),
          .SHIFTOUT2(),
          .TBYTEOUT(),          //out Byte group tristate
          .TFB(),            // out: 3-state control
          .TQ(),              // out: 3-state control
          .CLK(clk_pixel_x5),            // in: High speed clock
          .CLKDIV(clk_pixel),      // in: Divided clock
          // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
          .D1(tmds_internal[10*i]),
          .D2(tmds_internal[10*i+1]),
          .D3(tmds_internal[10*i+2]),
          .D4(tmds_internal[10*i+3]),
          .D5(tmds_internal[10*i+4]),
          .D6(tmds_internal[10*i+5]),
          .D7(tmds_internal[10*i+6]),
          .D8(tmds_internal[10*i+7]),
          .OCE(1'b1),             // in: Output data clock enable
          .RST(rst),             // 1-bit input: Reset
          // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
          .SHIFTIN1(shift_out[0]),
          .SHIFTIN2(shift_out[1]),
          // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
          .T1(1'b0),
          .T2(1'b0),
          .T3(1'b0),
          .T4(1'b0),
          .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
          .TCE(1'b0)              // inp: 3-state clock enable
       );

    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"),   // output rate (DDR,SDR)
        .DATA_RATE_TQ("SDR"),   // 3 state rate (DDR,BUF,SDR)
        .DATA_WIDTH(10),       // input data width (parallel) 
        .INIT_OQ(1'b0),   // Initial value of OQ
        .INIT_TQ(1'b0),         // Initial value of TQ
        .SERDES_MODE("SLAVE"), // MASTER, SLAVE
        .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
       )
       OSERDES_slave_inst (
          .OFB(),               // out: data Feedback path 
          .OQ(),         // outp: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
          .SHIFTOUT1(shift_out[0]),
          .SHIFTOUT2(shift_out[1]),
          .TBYTEOUT(),          //out Byte group tristate
          .TFB(),            // out: 3-state control
          .TQ(),              // out: 3-state control
          .CLK(clk_pixel_x5),            // in: High speed clock
          .CLKDIV(clk_pixel),      // in: Divided clock
          // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
          .D1(1'b0),
          .D2(1'b0),
          .D3(tmds_internal[10*i+8]),
          .D4(tmds_internal[10*i+9]),
          .D5(),
          .D6(),
          .D7(),
          .D8(),
          .OCE(1'b1),             // in: Output data clock enable
          .RST(rst),             // 1-bit input: Reset
          // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
          .SHIFTIN1(),
          .SHIFTIN2(),
          // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
          .T1(1'b0),
          .T2(1'b0),
          .T3(1'b0),
          .T4(1'b0),
          .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
          .TCE(1'b0)              // inp: 3-state clock enable
       );
    
    OBUFDS #(
		.IOSTANDARD	("DEFAULT"),
		.SLEW		("FAST")
	)OBUFDS_tmds_data(
		.I		(tmds[i]),
		.O		(tmds_lane[2*i+1]),
		.OB		(tmds_lane[2*i])
	);
end
endgenerate

OBUFDS #(
	.IOSTANDARD	("DEFAULT"),
	.SLEW		("FAST")
)OBUFDS_tmds_clk(
	.I		(clk_pixel_x5),
	.O		(tmds_clk[1]),
	.OB		(tmds_clk[0])
);


endmodule
