class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)
    uvm_sequencer#(transaction) seqr;
    alu_driver drvr;
    alu_mon mon;

    function new(string name="alu_agent",uvm_component parent = null);
        super.new(name,parent);

    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
        drvr = alu_driver::type_id::create("drvr",this);
        mon = alu_mon::type_id::create("mon",this);

    endfunction

    function void connect_phase(uvm_phase phase);
        drvr.seq_item_port.connect(seqr.seq_item_export);
        
    endfunction

endclass