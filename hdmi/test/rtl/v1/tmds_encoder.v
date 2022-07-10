`default_nettype none

/*
Based in https://github.com/hdl-util/hdmi/blob/master/src/tmds_channel.sv
*/


module tmds_encoder #(
    parameter CHANNEL = 0
) (
    input wire clk,
    input wire rst,

    input wire [7:0] din,
    input wire [3:0] island_data, //audio+other stuffs
    input wire din_valid,
    input wire [1:0] ctrl,
    input wire [2:0] mode,  //0:control, 1:video, 2:video guard, 3:island, 4:island guard
    output reg [9:0] tmds
);


//first stage of encoding. Encode each bit with the xor of the previous
//bits, also if the quantities of ones is greater than the zeros instead
//of a xor use a xnor

reg [2:0] cnt=0;
reg [8:0] q_m=0;
reg [9:0] q_out =0;

reg signed [4:0] N1q=0;
reg signed [4:0] N0q=0;

reg signed [4:0] acc=5'sd0, acc_add=5'sd0;

always@(posedge clk)begin
    acc <= acc+acc_add;
end


always@(*)begin
    cnt = din[0]+din[1]+din[2]+din[3]+din[4]+din[5]+din[6]+din[7];
    N1q = q_m[0]+q_m[1]+q_m[2]+q_m[3]+q_m[4]+q_m[5]+q_m[6]+q_m[7];
    N0q = 5'sd8-N1q;
end

//first encode scheme (xor and the xnor)
integer i;
always@(*)begin
    if(cnt>4'd4 ||((cnt==4'd4)&& din[0]))begin
        q_m[0] = din[0];
        for(i=0; i<7; i=i+1)begin
            q_m[i+1] = q_m[i] ~^ din[i+1];
        end
        q_m[8] = 1'b0;
    end
    else begin
        q_m[0] = din[0];
        for(i=0;i<7; i=i+1)begin
            q_m[i+1] = q_m[i] ^ din[i+1];
        end
        q_m[8] = 1'b1;
    end
end

//second encoding
always@(*) begin
    if(acc==0 || (N1q==N0q))begin
        if(q_m[8])begin
            q_out = {~q_m[8],q_m};
            acc_add = N1q-N0q;
        end
        else begin
            q_out = {~q_m[8], q_m[8], ~q_m[7:0]};
            acc_add = N0q-N1q;
        end
    end
    else begin
        if((~acc[0] && (N1q>N0q)) || (acc[0]&&(N1q<N0q)))begin
            q_out = {1'b1, q_m[8], ~q_m[7:0]};
            acc_add = (N0q - N1q) + (q_m[8] ? 5'sd2 : 5'sd0);
        end
        else begin
            q_out = {1'b0, q_m[8], q_m[7:0]};
            acc_add = (N1q - N0q) - (~q_m[8] ? 5'sd2 : 5'sd0);
        end
    end
end

//control data 
reg [9:0] control_coding;
always@(*)begin
    case(ctrl)
        2'b00: control_coding = 10'b1101010100;
        2'b01: control_coding = 10'b0010101011;
        2'b10: control_coding = 10'b0101010100;
        2'b11: control_coding = 10'b1010101011;
    endcase
end


//terc4 encoding
reg [9:0] terc4_coding;
always@(*)begin
    case(island_data)
        4'b0000 : terc4_coding = 10'b1010011100;
        4'b0001 : terc4_coding = 10'b1001100011;
        4'b0010 : terc4_coding = 10'b1011100100;
        4'b0011 : terc4_coding = 10'b1011100010;
        4'b0100 : terc4_coding = 10'b0101110001;
        4'b0101 : terc4_coding = 10'b0100011110;
        4'b0110 : terc4_coding = 10'b0110001110;
        4'b0111 : terc4_coding = 10'b0100111100;
        4'b1000 : terc4_coding = 10'b1011001100;
        4'b1001 : terc4_coding = 10'b0100111001;
        4'b1010 : terc4_coding = 10'b0110011100;
        4'b1011 : terc4_coding = 10'b1011000110;
        4'b1100 : terc4_coding = 10'b1010001110;
        4'b1101 : terc4_coding = 10'b1001110001;
        4'b1110 : terc4_coding = 10'b0101100011;
        4'b1111 : terc4_coding = 10'b1011000011;
    endcase
end

//video guard band
wire [9:0] video_guard_band;
generate
    if (CHANNEL == 0 || CHANNEL == 2)
        assign video_guard_band = 10'b1011001100;
    else
        assign video_guard_band = 10'b0100110011;
endgenerate

//data island guard
/*
wire [9:0] data_guard_band;
generate
    if (CHANNEL == 1 || CHANNEL == 2)
        assign data_guard_band = 10'b0100110011;
    else
        assign data_guard_band = (control_data == 2'b00) ? 10'b1010001110
            : control_data == 2'b01 ? 10'b1001110001
            : control_data == 2'b10 ? 10'b0101100011
            : 10'b1011000011;
endgenerate
*/



//apply the selected mode
always@(posedge clk)begin
    case(mode)
        3'd0: tmds <= control_coding;
        3'd1: tmds <= q_out;
        3'd2: tmds <= video_guard_band;
        3'd3: tmds <= terc4_coding;
        //3'd4: tmds <= data_guard_band;
        default: tmds <= q_out;
    endcase
end

endmodule
