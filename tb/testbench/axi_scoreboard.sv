`ifndef AXI_SCOREBOARD_SV
`define AXI_SCOREBOARD_SV

class axi_scoreboard extends uvm_component;
    `uvm_component_utils(axi_scoreboard)

    uvm_analysis_imp #(axi_transaction, axi_scoreboard) item_collected_export;

    // Local model of register state
    bit [31:0] ref_model [4];

    function new(string name = "axi_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        foreach (ref_model[i]) ref_model[i] = 32'hDEADBEEF; // Init with default
    endfunction

    function void write(axi_transaction tr);
        if (tr.is_write) begin
            if (tr.addr[3:2] < 4) begin
                ref_model[tr.addr[3:2]] = tr.data;
                `uvm_info("SCORE", $sformatf("WRITE update: addr[%0d] = 0x%0h", tr.addr[3:2], tr.data), UVM_LOW)
            end
        end else begin
            if (tr.addr[3:2] < 4) begin
                bit [31:0] expected = ref_model[tr.addr[3:2]];
                if (tr.read_data !== expected) begin
                    `uvm_error("SCORE", $sformatf("READ MISMATCH: addr[%0d] expected=0x%0h, got=0x%0h",
                        tr.addr[3:2], expected, tr.read_data))
                end else begin
                    `uvm_info("SCORE", $sformatf("READ OK: addr[%0d] = 0x%0h", tr.addr[3:2], tr.read_data), UVM_LOW)
                end
            end
        end
    endfunction

endclass

`endif
