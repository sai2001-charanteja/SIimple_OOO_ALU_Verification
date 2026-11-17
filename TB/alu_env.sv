class alu_env extends uvm_env;
    `uvm_component_utils(alu_env)

    alu_agent m_agnt;
    alu_scb scb;

    function new(string name = "alu_env",uvm_component parent = null);
        super.new(name,parent);

    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_agnt = alu_agent::type_id::create("m_agnt",this);
        scb = alu_scb::type_id::create("scb",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_agnt.mon.send.connect(scb.imp);
        
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
          super.end_of_elaboration_phase(phase);

            uvm_test_done.set_drain_time(this,200ns);
            
    endfunction

    // The sequence runs as main_phase default_sequence, so its objection is
    // raised on the MAIN phase. The drain time must go on that phase's objection
    // (uvm_test_done is the run_phase objection, which nobody raises here).
    
    

endclass