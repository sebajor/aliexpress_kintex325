
module fpga (
    input wire clk_100mhz,
    input wire clk_200mhz_p, clk_200mhz_n,
    
    input wire btn3 //rst button

);


wire Clk;
wire [31:0]M00_AXI_0_araddr;
wire [1:0]M00_AXI_0_arburst;
wire [3:0]M00_AXI_0_arcache;
wire [7:0]M00_AXI_0_arlen;
wire [0:0]M00_AXI_0_arlock;
wire [2:0]M00_AXI_0_arprot;
wire [3:0]M00_AXI_0_arqos;
wire M00_AXI_0_arready;
wire [3:0]M00_AXI_0_arregion;
wire [2:0]M00_AXI_0_arsize;
wire M00_AXI_0_arvalid;
wire [31:0]M00_AXI_0_awaddr;
wire [1:0]M00_AXI_0_awburst;
wire [3:0]M00_AXI_0_awcache;
wire [7:0]M00_AXI_0_awlen;
wire [0:0]M00_AXI_0_awlock;
wire [2:0]M00_AXI_0_awprot;
wire [3:0]M00_AXI_0_awqos;
wire M00_AXI_0_awready;
wire [3:0]M00_AXI_0_awregion;
wire [2:0]M00_AXI_0_awsize;
wire M00_AXI_0_awvalid;
wire M00_AXI_0_bready;
wire [1:0]M00_AXI_0_bresp;
wire M00_AXI_0_bvalid;
wire [31:0]M00_AXI_0_rdata;
wire M00_AXI_0_rlast;
wire M00_AXI_0_rready;
wire [1:0]M00_AXI_0_rresp;
wire M00_AXI_0_rvalid;
wire [31:0]M00_AXI_0_wdata;
wire M00_AXI_0_wlast;
wire M00_AXI_0_wready;
wire [3:0]M00_AXI_0_wstrb;
wire M00_AXI_0_wvalid;
wire [31:0]M01_AXI_0_araddr;
wire [2:0]M01_AXI_0_arprot;
wire [0:0]M01_AXI_0_arready;
wire [0:0]M01_AXI_0_arvalid;
wire [31:0]M01_AXI_0_awaddr;
wire [2:0]M01_AXI_0_awprot;
wire [0:0]M01_AXI_0_awready;
wire [0:0]M01_AXI_0_awvalid;
wire [0:0]M01_AXI_0_bready;
wire [1:0]M01_AXI_0_bresp;
wire [0:0]M01_AXI_0_bvalid;
wire [31:0]M01_AXI_0_rdata;
wire [0:0]M01_AXI_0_rready;
wire [1:0]M01_AXI_0_rresp;
wire [0:0]M01_AXI_0_rvalid;
wire [31:0]M01_AXI_0_wdata;
wire [0:0]M01_AXI_0_wready;
wire [3:0]M01_AXI_0_wstrb;
wire [0:0]M01_AXI_0_wvalid;
wire reset_rtl_0;




system_wrapper system_wrapper_inst (
    .Clk(Clk),
    .M00_AXI_0_araddr(M00_AXI_0_araddr),
    .M00_AXI_0_arburst(M00_AXI_0_arburst),
    .M00_AXI_0_arcache(M00_AXI_0_arcache),
    .M00_AXI_0_arlen(M00_AXI_0_arlen),
    .M00_AXI_0_arlock(M00_AXI_0_arlock),
    .M00_AXI_0_arprot(M00_AXI_0_arprot),
    .M00_AXI_0_arqos(M00_AXI_0_arqos),
    .M00_AXI_0_arready(M00_AXI_0_arready),
    .M00_AXI_0_arregion(M00_AXI_0_arregion),
    .M00_AXI_0_arsize(M00_AXI_0_arsize),
    .M00_AXI_0_arvalid(M00_AXI_0_arvalid),
    .M00_AXI_0_awaddr(M00_AXI_0_awaddr),
    .M00_AXI_0_awburst(M00_AXI_0_awburst),
    .M00_AXI_0_awcache(M00_AXI_0_awcache),
    .M00_AXI_0_awlen(M00_AXI_0_awlen),
    .M00_AXI_0_awlock(M00_AXI_0_awlock),
    .M00_AXI_0_awprot(M00_AXI_0_awprot),
    .M00_AXI_0_awqos(M00_AXI_0_awqos),
    .M00_AXI_0_awready(M00_AXI_0_awready),
    .M00_AXI_0_awregion(M00_AXI_0_awregion),
    .M00_AXI_0_awsize(M00_AXI_0_awsize),
    .M00_AXI_0_awvalid(M00_AXI_0_awvalid),
    .M00_AXI_0_bready(M00_AXI_0_bready),
    .M00_AXI_0_bresp(M00_AXI_0_bresp),
    .M00_AXI_0_bvalid(M00_AXI_0_bvalid),
    .M00_AXI_0_rdata(M00_AXI_0_rdata),
    .M00_AXI_0_rlast(M00_AXI_0_rlast),
    .M00_AXI_0_rready(M00_AXI_0_rready),
    .M00_AXI_0_rresp(M00_AXI_0_rresp),
    .M00_AXI_0_rvalid(M00_AXI_0_rvalid),
    .M00_AXI_0_wdata(M00_AXI_0_wdata),
    .M00_AXI_0_wlast(M00_AXI_0_wlast),
    .M00_AXI_0_wready(M00_AXI_0_wready),
    .M00_AXI_0_wstrb(M00_AXI_0_wstrb),
    .M00_AXI_0_wvalid(M00_AXI_0_wvalid),
    .M01_AXI_0_araddr(M01_AXI_0_araddr),
    .M01_AXI_0_arprot(M01_AXI_0_arprot),
    .M01_AXI_0_arready(M01_AXI_0_arready),
    .M01_AXI_0_arvalid(M01_AXI_0_arvalid),
    .M01_AXI_0_awaddr(M01_AXI_0_awaddr),
    .M01_AXI_0_awprot(M01_AXI_0_awprot),
    .M01_AXI_0_awready(M01_AXI_0_awready),
    .M01_AXI_0_awvalid(M01_AXI_0_awvalid),
    .M01_AXI_0_bready(M01_AXI_0_bready),
    .M01_AXI_0_bresp(M01_AXI_0_bresp),
    .M01_AXI_0_bvalid(M01_AXI_0_bvalid),
    .M01_AXI_0_rdata(M01_AXI_0_rdata),
    .M01_AXI_0_rready(M01_AXI_0_rready),
    .M01_AXI_0_rresp(M01_AXI_0_rresp),
    .M01_AXI_0_rvalid(M01_AXI_0_rvalid),
    .M01_AXI_0_wdata(M01_AXI_0_wdata),
    .M01_AXI_0_wready(M01_AXI_0_wready),
    .M01_AXI_0_wstrb(M01_AXI_0_wstrb),
    .M01_AXI_0_wvalid(M01_AXI_0_wvalid),
    .reset_rtl_0(reset_rtl_0)
);








endmodule 
