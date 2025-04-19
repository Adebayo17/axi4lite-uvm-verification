interface axi_if #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 32)(input logic ACLK, input logic ARESETn);

    // Write Address Channel
    logic [ADDR_WIDTH-1:0] AWADDR;
    logic                  AWVALID;
    logic                  AWREADY;

    // Write Data Channel
    logic [DATA_WIDTH-1:0] WDATA;
    logic                  WVALID;
    logic                  WREADY;

    // Write Response Channel
    logic [1:0]            BRESP;
    logic                  BVALID;
    logic                  BREADY;

    // Read Address Channel
    logic [ADDR_WIDTH-1:0] ARADDR;
    logic                  ARVALID;
    logic                  ARREADY;

    // Read Data Channel
    logic [DATA_WIDTH-1:0] RDATA;
    logic [1:0]            RRESP;
    logic                  RVALID;
    logic                  RREADY;

    modport dut_mp (
        input  ACLK, ARESETn,
        input  AWADDR, AWVALID, WDATA, WVALID, BREADY,
        output AWREADY, WREADY, BRESP, BVALID,
        input  ARADDR, ARVALID, RREADY,
        output ARREADY, RDATA, RRESP, RVALID
    );

    modport tb_mp (
        input  ACLK, ARESETn,
        output AWADDR, AWVALID, WDATA, WVALID, BREADY,
        input  AWREADY, WREADY, BRESP, BVALID,
        output ARADDR, ARVALID, RREADY,
        input  ARREADY, RDATA, RRESP, RVALID
    );

endinterface
