`default_nettype none
//`include "tmds_encoder.v"
//`include "hdmi_phy.v"
/* Based in https://github.com/hdl-util/hdmi/blob/master/src/hdmi.sv
*/

module dvi #(
    parameter VIDEO_ID_CODE = 1,
    //1:640x480 pxl_clk:25mhz; 2,3:720x480 pxl_clk:27mhz
    //4:1280x720 pxl_clk: 74.176


     //parameter int BIT_WIDTH = (VIDEO_ID_CODE < 4) ? 10 :( (VIDEO_ID_CODE == 4) ? 11 : 12),
    parameter BIT_WIDTH = VIDEO_ID_CODE < 4 ? 10 : 11,
    parameter BIT_HEIGHT = VIDEO_ID_CODE == 16 ? 11: 10

) (
    input wire clk_pixel_x5,
    input wire clk_pixel,
    input wire [23:0] rgb,
   
    //phy output (differential)
    output wire [5:0] tmds,
    output wire [1:0] tmds_clk,

    //pixel position
    output reg [BIT_WIDTH-1:0] cx = {BIT_WIDTH{1'b0}},
    output reg [BIT_HEIGHT-1:0] cy = {BIT_HEIGHT{1'b0}},

    output wire [BIT_WIDTH-1:0] frame_width,
    output wire [BIT_HEIGHT-1:0] frame_height,
    output wire [BIT_WIDTH-1:0] screen_width,
    output wire [BIT_HEIGHT-1:0] screen_height,
    output wire [BIT_WIDTH-1:0] screen_start_x,
    output wire [BIT_HEIGHT-1:0] screen_start_y
);
//clock of the serdes is 5 times the pixel clock, like the data is ddr we
//have 10 times more throughput

localparam NUM_CHANNELS = 3;
wire hsync, vsync;

generate 
    case(VIDEO_ID_CODE)
        1:
        begin
            localparam VIDEO_RATE = 25.2E6;
            assign frame_width = 800;
            assign frame_height = 525;
            assign screen_width = 640;
            assign screen_height = 480;
            assign hsync = ~(cx >= 16 && cx < 16 + 96);
            assign vsync = ~(cy >= 10 && cy < 10 + 2);
            end
        2, 3:
        begin
            localparam VIDEO_RATE = 27.027E6;
            assign frame_width = 858;
            assign frame_height = 525;
            assign screen_width = 720;
            assign screen_height = 480;
            assign hsync = ~(cx >= 16 && cx < 16 + 62);
            assign vsync = ~(cy >= 9 && cy < 9 + 6);
            end
        4:
        begin
            localparam VIDEO_RATE = 74.25E6;
            assign frame_width = 1650;
            assign frame_height = 750;
            assign screen_width = 1280;
            assign screen_height = 720;
            assign hsync = cx >= 110 && cx < 110 + 40;
            assign vsync = cy >= 5 && cy < 5 + 5;
        end
    endcase
    assign screen_start_x = frame_width - screen_width;
    assign screen_start_y = frame_height - screen_height;
endgenerate


//cx, cy counters
always@(posedge clk_pixel)begin
    if(cx==frame_width-1)
        cx <= 0;
    else 
        cx <= cx+1;
end
always@(posedge clk_pixel)begin
    if(cy==frame_height)
        cy <= 0;
    else
        cy <= cy+1;
end


reg video_data_period =1;
always@(posedge clk_pixel)begin
    video_data_period <= (cx>= screen_start_x && cy>=screen_start_y);
end

wire [2:0] mode= video_data_period;    //switch between video and control
wire [23:0] video_data = rgb;
wire [5:0] control_data = {4'd0, vsync, hsync};
wire [11:0] data_island = 12'd0;

//tmds encoders
wire [29:0] tmds_internal;
genvar i;
generate 
    for (i=0; i<NUM_CHANNELS; i=i+1)begin
        tmds_encoder #(.CHANNEL(i))
        tmds_encoder_isnt (        
            .clk(clk_pixel),
            .rst(1'b0),
            .din(video_data[8*i+:8]),
            .island_data(4'b0), //audio+other stuffs
            .din_valid(1'b1),
            .ctrl(control_data[i*2+1:i*2]),
            .mode(mode),  //0:control(), 1:video(), 2:video guard(), 3:island(), 4:island guard
            .tmds(tmds_internal[10*i+:10])
    );
    end
endgenerate

//phy

hdmi_phy #(
    .N_CHANNELS(3)
) dvi_phy (
    .rst(1'b0),
    .clk_pixel(clk_pixel),
    .clk_pixel_x5(clk_pixel_x5),
    .tmds_internal(tmds_internal),

    .tmds_lane(tmds),    //diferential output
    .tmds_clk(tmds_clk)
);







endmodule
