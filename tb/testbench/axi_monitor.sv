`ifndef AXI_MONITOR_SV
`define AXI_MONITOR_SV

class axi_monitor extends uvm_component;
    `uvm_component_utils(axi_monitor)

    uvm_analysis_port #(axi_transaction) ap;
    virtual axi_if vif;

    function new(string name = "axi_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set for monitor")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            // Sample write
            if (vif.AWVALID && vif.AWREADY && vif.WVALID && vif.WREADY) begin
                axi_transaction tr = new();
                tr.addr = vif.AWADDR;
                tr.data = vif.WDATA;
                tr.is_write = 1;
                ap.write(tr);
                `uvm_info("MON", $sformatf("WRITE seen: addr=0x%0h, data=0x%0h", tr.addr, tr.data), UVM_LOW)
            end

            // Sample read
            if (vif.ARVALID && vif.ARREADY && vif.RVALID && vif.RREADY) begin
                axi_transaction tr = new();
                tr.addr = vif.ARADDR;
                tr.read_data = vif.RDATA;
                tr.is_write = 0;
                ap.write(tr);
                `uvm_info("MON", $sformatf("READ seen: addr=0x%0h, data=0x%0h", tr.addr, tr.read_data), UVM_LOW)
            end

            @(posedge vif.ACLK);
        end
    endtask

endclass

`endif
