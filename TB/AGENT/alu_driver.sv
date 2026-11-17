class alu_driver extends uvm_driver#(transaction);
    `uvm_component_utils(alu_driver)

    virtual alu_if vif;


    function new(string name = "alu_driver",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif))
            `uvm_fatal("CONFIG_ERROR","Unable to access the interface")
        

    endfunction


    task run_phase(uvm_phase phase);
        transaction trx;

        forever begin
            `uvm_info("DRVR",$sformatf("[%0t] WAITING ....",$time),UVM_MEDIUM)
            seq_item_port.get_next_item(trx);
            `uvm_info("DRVR",$sformatf("[%0t] STARTED ....",$time),UVM_MEDIUM)
            drive(trx);
            seq_item_port.item_done();
            `uvm_info("DRVR",$sformatf("[%0t] FINISHED ....",$time),UVM_MEDIUM)
        end

    endtask


    task automatic drive(transaction trx);
        
        while(vif.busy) @(vif.cb);

        vif.rst_n <= trx.rst_n;
        vif.cb.req_valid <= 1'b1;

        vif.cb.req_id <= trx.req_id;
        vif.cb.req_a <= trx.req_a; 
        vif.cb.req_b <= trx.req_b; 
        vif.cb.req_op <= trx.req_op; 
        @(vif.cb);
        vif.cb.req_valid <= 1'b0;
    endtask

endclass