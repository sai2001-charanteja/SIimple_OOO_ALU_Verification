class alu_sequence extends uvm_sequence#(transaction);
    `uvm_object_utils(alu_sequence)

    transaction trx;

    function new(string name="alu_sequence");
        super.new(name);
        set_automatic_phase_objection(1);
    endfunction

    task body();
        trx = transaction::type_id::create("trx_alu_seq");
        // Reset Packet
        begin : RESET
            `uvm_info("ALU_SEQ","Reset Sequence has Started",UVM_MEDIUM)
            start_item(trx);
            void'(trx.randomize() with {rst_n == 0;});
            finish_item(trx);
            `uvm_info("ALU_SEQ","Reset Sequence has Finished",UVM_MEDIUM)
        end
        for(int idx=0;idx<10;idx++) begin
            `uvm_info("ALU_SEQ",$sformatf("[%0t] Sequence =%0d has started",$time, idx),UVM_MEDIUM)
            start_item(trx);
            void'(trx.randomize() with {rst_n == 1;});
            finish_item(trx);
            `uvm_info("ALU_SEQ",$sformatf("[%0t] Sequence =%0d has Finished",$time, idx),UVM_MEDIUM)
        end

    endtask

endclass