`ifndef AXI_TEST_SV
`define AXI_TEST_SV

class axi_test extends uvm_test;
    `uvm_component_utils(axi_test)

    axi_env env;

    function new(string name = "axi_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_smoke_seq seq = axi_smoke_seq::type_id::create("seq");
        seq.start(env.agent.seqr);
        phase.raise_objection(this);
        #(100); // let scoreboarding finish
        phase.drop_objection(this);
    endtask

endclass

`endif
