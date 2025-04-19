`ifndef AXI_DRIVER_SV
`define AXI_DRIVER_SV

class axi_driver extends uvm_driver #(axi_transaction);
    `uvm_component_utils(axi_driver)

    virtual axi_if vif;

    function new(string name = "axi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set for driver")
    endfunction

    task run_phase(uvm_phase phase);
        axi_transaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            if (tr.is_write) begin
                drive_write(tr);
            end else begin
                drive_read(tr);
            end
            seq_item_port.item_done();
        end
    endtask

    task drive_write(axi_transaction tr);
        // Address
        vif.AWADDR  <= tr.addr;
        vif.AWVALID <= 1;
        // Data
        vif.WDATA   <= tr.data;
        vif.WVALID  <= 1;
        vif.BREADY  <= 1;

        wait (vif.AWREADY && vif.WREADY);
        @(posedge vif.ACLK);

        // Clear handshake
        vif.AWVALID <= 0;
        vif.WVALID  <= 0;
        vif.BREADY  <= 0;
        `uvm_info("DRV", $sformatf("WRITE addr=0x%0h data=0x%0h", tr.addr, tr.data), UVM_MEDIUM)
    endtask

    task drive_read(axi_transaction tr);
        // Address
        vif.ARADDR  <= tr.addr;
        vif.ARVALID <= 1;
        vif.RREADY  <= 1;

        wait (vif.ARREADY);
        @(posedge vif.ACLK);

        // Deassert ARVALID
        vif.ARVALID <= 0;

        wait (vif.RVALID);
        tr.read_data = vif.RDATA;
        @(posedge vif.ACLK);
        vif.RREADY <= 0;

        `uvm_info("DRV", $sformatf("READ addr=0x%0h -> data=0x%0h", tr.addr, tr.read_data), UVM_MEDIUM)
    endtask

endclass

`endif
