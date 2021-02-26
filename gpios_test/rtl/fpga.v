`default_nettype none


module fpga (
    input wire clk_100mhz,
    output wire gpio_a1,
    output wire gpio_a2,
    output wire gpio_a3,
    output wire gpio_a5,
    output wire gpio_a6,
    output wire gpio_a7,
    output wire gpio_a8,
    output wire gpio_a10
);

wire clk_ibufg;

IBUFG clk_ibufg_inst(
    .I(clk_100mhz),
    .O(clk_ibufg)
);

reg [$clog2(50_000_000)-1:0] counter=0;
reg [3:0] gpio_counter=0;
reg reduce_clk_prev=0; 
always@(posedge clk_ibufg)begin
    counter <= counter+1;
    reduce_clk_prev <= counter[$clog2(50_000_000)-1];
    if(~reduce_clk_prev&& counter[$clog2(50_000_000)-1])begin
        //rising edge 
        if(gpio_counter == 11)
            gpio_counter <= 0;
        else
            gpio_counter <= gpio_counter+1;
    end
end

reg [6:0] gpios=0;
always@(posedge clk_ibufg)begin
    case(gpio_counter)
        4'd0:  gpios <=7'b0000001;
        4'd1:  gpios <=7'b0000010;
        4'd2:  gpios <=7'b0000100;
        4'd3:  gpios <=7'b0001000;
        4'd4:  gpios <=7'b0010000;
        4'd5:  gpios <=7'b0100000;
        4'd6:  gpios <=7'b1000000;
        4'd7:  gpios <=7'b0100000;
        4'd8:  gpios <=7'b0010000;
        4'd9:  gpios <=7'b0001000;
        4'd10: gpios <=7'b0000100;
        4'd11: gpios <=7'b0000010;
        default: gpios <=0;
    endcase
end

assign gpio_a10 = 1'b1;
assign {gpio_a1,gpio_a2,gpio_a3,gpio_a5,gpio_a6,gpio_a7,gpio_a8} = gpios;



endmodule
