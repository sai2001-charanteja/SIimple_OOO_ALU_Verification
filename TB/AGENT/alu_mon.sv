class alu_mon extends uvm_monitor;
    `uvm_component_utils(alu_mon)

    uvm_analysis_port#(transaction) send;
    virtual alu_if vif;
    function new(string name="alu_mon",uvm_component parent =null);
        super.new(name,parent);

    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send",this);
        if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif))
            `uvm_fatal("CONFIG_DB_ERROR","Uuable to config interface")

    endfunction 

    task run_phase(uvm_phase phase);
        transaction req_trx,rsp_trx,rst_trx;
        fork
            forever begin
                req_trx = transaction::type_id::create("req_trx");

                while(vif.cb_mon.req_valid!== 1) @(vif.cb_mon);

                req_trx.kind = REQ;
                req_trx.req_a = vif.cb_mon.req_a;
                req_trx.req_b = vif.cb_mon.req_b;
                req_trx.req_id = vif.cb_mon.req_id;
                req_trx.req_op = vif.cb_mon.req_op;
                req_trx.req_valid = vif.cb_mon.req_valid;

                send.write(req_trx);
                @(vif.cb_mon) ;   
            end


            forever begin
                rsp_trx = transaction::type_id::create("rsp_trx");

                while(vif.cb_mon.rsp_valid!== 1) @(vif.cb_mon);

                rsp_trx.kind = RSP;
                rsp_trx.rsp_id = vif.cb_mon.rsp_id;
                rsp_trx.rsp_data = vif.cb_mon.rsp_data;
                rsp_trx.rsp_valid = vif.cb_mon.rsp_valid;

                send.write(rsp_trx);
                @(vif.cb_mon);
            end

            forever begin
                rst_trx = transaction::type_id::create("rst_trx");
                wait (vif.rst_n === 1'b0);

                rst_trx.kind = RST;
                rst_trx.rst_n = vif.rst_n;
                send.write(rst_trx);

                wait (vif.rst_n === 1'b1);
    

            end

        join




    endtask

endclass