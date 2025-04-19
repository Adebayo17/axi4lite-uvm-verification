`timescale 1ns/1ps

import uvm_pkg::*;

`include "uvm_macros.svh"

`include "testbench/axi_pkg.sv"

module top_tb;

    // Clock and Reset
    logic ACLK = 0;
    logic ARESETn = 0;

    always #5 ACLK = ~ACLK;  // 100 MHz

    // Interface instance
    axi_if axi_vif(.*);  // connects ACLK, ARESETn

    // DUT
    axi4lite_slave dut (
        .ACLK     (ACLK),
        .ARESETn  (ARESETn),
        .AWADDR   (axi_vif.AWADDR),
        .AWVALID  (axi_vif.AWVALID),
        .AWREADY  (axi_vif.AWREADY),
        .WDATA    (axi_vif.WDATA),
        .WVALID   (axi_vif.WVALID),
        .WREADY   (axi_vif.WREADY),
        .BRESP    (axi_vif.BRESP),
        .BVALID   (axi_vif.BVALID),
        .BREADY   (axi_vif.BREADY),
        .ARADDR   (axi_vif.ARADDR),
        .ARVALID  (axi_vif.ARVALID),
        .ARREADY  (axi_vif.ARREADY),
        .RDATA    (axi_vif.RDATA),
        .RRESP    (axi_vif.RRESP),
        .RVALID   (axi_vif.RVALID),
        .RREADY   (axi_vif.RREADY)
    );

    // UVM run block
    initial begin
        // Set interface into UVM config DB
        uvm_config_db#(virtual axi_if)::set(null, "*", "vif", axi_vif);

        // Reset sequence
        #20 ARESETn = 1;

        // Start UVM
        run_test("axi_test");
    end

endmodule
