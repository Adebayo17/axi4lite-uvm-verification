`ifndef AXI_SMOKE_SEQ_SV
`define AXI_SMOKE_SEQ_SV

class axi_smoke_seq extends uvm_sequence #(axi_transaction);
    `uvm_object_utils(axi_smoke_seq)

    function new(string name = "axi_smoke_seq");
        super.new(name);
    endfunction

    task body();
        axi_transaction tr;

        // WRITE to reg[0]
        tr = axi_transaction::type_id::create("tr_write0");
        tr.addr = 4'h0;
        tr.data = 32'hCAFEBABE;
        tr.is_write = 1;
        start_item(tr);
        finish_item(tr);

        // WRITE to reg[1]
        tr = axi_transaction::type_id::create("tr_write1");
        tr.addr = 4'h4;
        tr.data = 32'h12345678;
        tr.is_write = 1;
        start_item(tr);
        finish_item(tr);

        // READ from reg[0]
        tr = axi_transaction::type_id::create("tr_read0");
        tr.addr = 4'h0;
        tr.is_write = 0;
        start_item(tr);
        finish_item(tr);

        // READ from reg[1]
        tr = axi_transaction::type_id::create("tr_read1");
        tr.addr = 4'h4;
        tr.is_write = 0;
        start_item(tr);
        finish_item(tr);
    endtask

endclass

`endif
