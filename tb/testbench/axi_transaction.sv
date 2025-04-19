`ifndef AXI_TRANSACTION_SV
`define AXI_TRANSACTION_SV

class axi_transaction extends uvm_sequence_item;
    rand bit [3:0] addr;
    rand bit [31:0] data;
    rand bit is_write; // 1 = write, 0 = read
         bit [31:0] read_data; // for monitor or scoreboard

    `uvm_object_utils_begin(axi_transaction)
        `uvm_field_int(addr,       UVM_ALL_ON)
        `uvm_field_int(data,       UVM_ALL_ON)
        `uvm_field_int(is_write,   UVM_ALL_ON)
        `uvm_field_int(read_data,  UVM_ALL_ON | UVM_NOPACK) // not randomized
    `uvm_object_utils_end

    function new(string name = "axi_transaction");
        super.new(name);
    endfunction

    constraint addr_align { addr[1:0] == 2'b00; } // align to word boundary
endclass

`endif


//
// What You Just Created:
// - A transaction class that models both read and write AXI operations
// - Fields are randomized using UVM's built-in `rand` + `constraint`
// - `read_data` is used for scoreboarding later, not randomized