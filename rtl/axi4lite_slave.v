module axi4lite_slave #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32
)(
    input                   ACLK,
    input                   ARESETn,

    // Write Address Channel
    input  [ADDR_WIDTH-1:0] AWADDR,
    input                   AWVALID,
    output                  AWREADY,

    // Write Data Channel
    input  [DATA_WIDTH-1:0] WDATA,
    input                   WVALID,
    output                  WREADY,

    // Write Response Channel
    output [1:0]            BRESP,
    output                  BVALID,
    input                   BREADY,

    // Read Address Channel
    input  [ADDR_WIDTH-1:0] ARADDR,
    input                   ARVALID,
    output                  ARREADY,

    // Read Data Channel
    output [DATA_WIDTH-1:0] RDATA,
    output [1:0]            RRESP,
    output                  RVALID,
    input                   RREADY
);

    localparam NUM_REGS = 4;

    reg [DATA_WIDTH-1:0] regs [0:NUM_REGS-1];
    reg [1:0] state;

    assign AWREADY = 1'b1;
    assign WREADY  = 1'b1;
    assign ARREADY = 1'b1;
    assign BRESP   = 2'b00;
    assign RRESP   = 2'b00;
    assign BVALID  = AWVALID & WVALID;
    assign RVALID  = ARVALID;

    wire [1:0] reg_sel_w = AWADDR[3:2];
    wire [1:0] reg_sel_r = ARADDR[3:2];

    // Write logic
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            regs[0] <= '0;
            regs[1] <= '0;
            regs[2] <= '0;
            regs[3] <= '0;
        end else if (AWVALID & WVALID) begin
            if (reg_sel_w < NUM_REGS)
                regs[reg_sel_w] <= WDATA;
        end
    end

    // Read logic
    assign RDATA = (reg_sel_r < NUM_REGS) ? regs[reg_sel_r] : '0;

endmodule



// module axi4lite_slave #(
//     parameter ADDR_WIDTH = 4,
//     parameter DATA_WIDTH = 32
// )(
//     input wire                  ACLK,
//     input wire                  ARESETn,

//     // Write Address Channel
//     input wire [ADDR_WIDTH-1:0] AWADDR,
//     input wire                  AWVALID,
//     output wire                 AWREADY,

//     // Write Data Channel
//     input wire [DATA_WIDTH-1:0] WDATA,
//     input wire [(DATA_WIDTH/8)-1:0] WSTRB,
//     input wire                  WVALID,
//     output wire                 WREADY,
    
//     // Write Response Channel
//     output wire [1:0]           BRESP,
//     output wire                 BVALID,
//     input wire                  BREADY,
    
//     // Read Address Channel
//     input wire [ADDR_WIDTH-1:0] ARADDR,
//     input wire                  ARVALID,
//     output wire                 ARREADY,
    
//     // Read Data Channel
//     output wire [DATA_WIDTH-1:0] RDATA,
//     output wire [1:0]           RRESP,
//     output wire                 RVALID,
//     input wire                  RREADY
// );

//     localparam NUM_REGS = 4;
    
//     // Internal registers
//     reg [DATA_WIDTH-1:0] REG0, REG1, REG2, REG3;
//     reg [DATA_WIDTH-1:0] read_data;
//     reg [1:0]            bresp_reg, rresp_reg;
//     reg                  bvalid_reg, rvalid_reg;

//     // Write Address Ready
//     assign AWREADY = AWVALID;

//     // Write Data Ready
//     assign WREADY = WVALID;

//     // Write Response
//     assign BRESP = bresp_reg;
//     assign BVALID = bvalid_reg;

//     // Read Address Ready
//     assign ARREADY = ARVALID;

//     // Read Data and Response
//     assign RDATA = read_data;
//     assign RRESP = rresp_reg;
//     assign RVALID = rvalid_reg;

//     // Write operation
//     always @(posedge ACLK or negedge ARESETn) begin
//         if (!ARESETn) begin
//             REG0 <= 0;
//             REG1 <= 0;
//             REG2 <= 0;
//             REG3 <= 0;
//             bresp_reg <= 2'b00;
//             bvalid_reg <= 1'b0;
//         end else if (AWVALID && WVALID) begin
//             case (AWADDR[ADDR_WIDTH-1:2]) // Address decoding
//                 2'b00: REG0 <= WDATA;
//                 2'b01: REG1 <= WDATA;
//                 2'b10: REG2 <= WDATA;
//                 2'b11: REG3 <= WDATA;
//                 default: ;
//             endcase
//             bresp_reg <= 2'b00; // OKAY response
//             bvalid_reg <= 1'b1;
//         end else if (BREADY) begin
//             bvalid_reg <= 1'b0;
//         end
//     end

//     // Read operation
//     always @(posedge ACLK or negedge ARESETn) begin
//         if (!ARESETn) begin
//             read_data <= 0;
//             rresp_reg <= 2'b00;
//             rvalid_reg <= 1'b0;
//         end else if (ARVALID) begin
//             case (ARADDR[ADDR_WIDTH-1:2]) // Address decoding
//                 2'b00: read_data <= REG0;
//                 2'b01: read_data <= REG1;
//                 2'b10: read_data <= REG2;
//                 2'b11: read_data <= REG3;
//                 default: read_data <= 0;
//             endcase
//             rresp_reg <= 2'b00; // OKAY response
//             rvalid_reg <= 1'b1;
//         end else if (RREADY) begin
//             rvalid_reg <= 1'b0;
//         end
//     end

// endmodule