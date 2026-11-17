module alu_top;
    logic        clk;
    
    always #5 clk = !clk;

    alu_if aif(clk);
     import alu_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
     `include "alu_test.sv"
    ooo_engine engine (
    .clk(clk),
    .rst_n(aif.rst_n),
    .req_valid(aif.req_valid),
    .req_id(aif.req_id ),
    .req_a(aif.req_a ),
    .req_b(aif.req_b ),
    .req_op(aif.req_op ),
    .busy(aif.busy ),
    .rsp_valid(aif.rsp_valid ),
    .rsp_id(aif.rsp_id ),
    .rsp_data(aif.rsp_data)
    );

    initial begin
        clk = 0;
        uvm_config_db#(virtual alu_if)::set(null,"*","vif",aif);
        
        run_test();
    end

endmodule