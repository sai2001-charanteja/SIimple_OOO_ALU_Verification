class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)

    alu_env env;

    function new(string name="alu_test",uvm_component parent = null);
        super.new(name,parent);

    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = alu_env::type_id::create("env",this);


        //uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agnt.seqr.main_phase","default_sequence",alu_sequence::get_type());
        

    endfunction

    task run_phase(uvm_phase phase);
        alu_sequence seq = alu_sequence::type_id::create("seq");
        alu_sequence seq1 = alu_sequence::type_id::create("seq");
        phase.phase_done.set_drain_time(this, 200ns);
        phase.raise_objection(this,"Test Started");

        seq.start(env.m_agnt.seqr);
        seq1.start(env.m_agnt.seqr);


        phase.drop_objection(this,"Test Completed");
    endtask

endclass