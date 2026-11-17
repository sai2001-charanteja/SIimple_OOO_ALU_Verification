class alu_scb extends uvm_scoreboard;
    `uvm_component_utils(alu_scb)
    uvm_analysis_imp#(transaction,alu_scb) imp;

    transaction queue[$];
    int missing_packets;
    int matched;
    int mis_matched;

    function new(string name="alu_scb",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        imp = new("imp",this);

    endfunction


    function void write(transaction trx);
        case(trx.kind)
            REQ: begin
                `uvm_info("SCB","Received a Request transaction from Monitor",UVM_MEDIUM);
                queue.push_back(trx);
            end
            RSP: begin
                int temp_q[$];
                `uvm_info("SCB","Received a Response transaction from Monitor",UVM_MEDIUM);
                temp_q = queue.find_first_index with (item.req_id == trx.rsp_id);
                if(temp_q.size() == 0)
                    missing_packets++;
                else begin 
                    
                    compare(queue[temp_q[0]],trx);
                    queue.delete(temp_q[0]);

                end
            end
            RST: begin 
            queue.delete();
            `uvm_info("SCB","Received a Rst transaction from Monitor",UVM_MEDIUM);
            end
        endcase

    endfunction


    function void compare(transaction req, transaction rsp);
        bit [15:0] res;
       case (req.req_op)
            2'b00: res = req.req_a + req.req_b;
            2'b01: res = req.req_a - req.req_b;
            2'b10: res = req.req_a * req.req_b;
            2'b11: res = req.req_a ^ req.req_b;
        endcase

        if(res == rsp.rsp_data) matched++;
        else begin 
            `uvm_info("SCB",$sformatf("id = %0d, a = %0d, b = %0d, op = %0d,Expected = %0d , Actual = %0d",req.req_id,req.req_a,req.req_b, req.req_op, res,rsp.rsp_data),UVM_MEDIUM);    
            mis_matched++; 
            
        end

        

    endfunction


    function void extract_phase(uvm_phase phase);
        if(mis_matched == 0)
            if(missing_packets == 0 && matched !=0) begin
                `uvm_info("SCB","TEST PASS",UVM_MEDIUM)
            end else if(missing_packets !=0 )`uvm_info("SCB","TEST FAIL ",UVM_MEDIUM)

        else `uvm_info("SCB","TEST FAIL",UVM_MEDIUM)

        `uvm_info("SCB",$sformatf("Missing Packets = %0d, Matched = %0d, MisMatched =  %0d",missing_packets,matched,mis_matched),UVM_MEDIUM)
    endfunction
endclass