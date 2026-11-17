interface alu_if(input clk);

    logic        rst_n;
    logic        req_valid;
    logic [3:0]  req_id;
    logic [7:0]  req_a;
    logic [7:0]  req_b;
    logic [1:0]  req_op;
    logic busy;

    logic        rsp_valid;
    logic [3:0]  rsp_id;
    logic [15:0] rsp_data;

    clocking cb@(posedge clk);
        output req_valid, req_id, req_a, req_b, req_op;
        input busy;
    endclocking

    clocking cb_mon@(posedge clk);  
        input req_valid, req_id, req_a, req_b, req_op,busy;
        input rsp_valid, rsp_id, rsp_data;
    endclocking


endinterface