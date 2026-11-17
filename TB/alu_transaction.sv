typedef enum {REQ,RSP,RST} pkt_type;

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)

    rand bit        rst_n;
    rand bit        req_valid;
    randc bit [3:0]  req_id;
    rand bit [7:0]  req_a;
    rand bit [7:0]  req_b;
    rand bit [1:0]  req_op;
        bit        rsp_valid;
        bit [3:0]  rsp_id;
        bit [15:0] rsp_data;


    bit [3:0] last_ids[$:15];
    pkt_type kind;
    
    function new(string name ="transaction");
        super.new(name);
    endfunction

    constraint c_valid{
        // Reset
        rst_n inside {[0:1]};

        // req_valid i ignore while driving
        req_valid inside {[0:1]};


        req_a inside {[0:255]};

        req_b inside {[0:255]};

        req_op inside {[0:3]};



    }

    function void post_randomize();


    endfunction


endclass