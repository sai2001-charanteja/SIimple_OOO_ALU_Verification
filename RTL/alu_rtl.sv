module ooo_engine (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        req_valid,
    input  logic [3:0]  req_id,
    input  logic [7:0]  req_a,
    input  logic [7:0]  req_b,
    input  logic [1:0]  req_op,
    output logic        busy,
    output logic        rsp_valid,
    output logic [3:0]  rsp_id,
    output logic [15:0] rsp_data
);

    // Simple internal storage for outstanding requests
    typedef struct {
        logic        valid;
        logic [3:0]  id;
        logic [7:0]  a;
        logic [7:0]  b;
        logic [1:0]  op;
        int          delay;
    } request_t;

    request_t requests[4];

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rsp_valid <= 0;
            rsp_id    <= 0;
            rsp_data  <= 0;

            foreach (requests[i]) begin
                requests[i].valid <= 0;
            end

        end else begin

            rsp_valid <= 0;

            // Accept new request
            if (req_valid) begin

                foreach (requests[i]) begin
                    if (!requests[i].valid) begin

                        requests[i].valid <= 1;
                        requests[i].id    <= req_id;
                        requests[i].a     <= req_a;
                        requests[i].b     <= req_b;
                        requests[i].op    <= req_op;

                        // Different operations take different cycles
                        case (req_op)
                            2'b00: requests[i].delay <= 3; // ADD
                            2'b01: requests[i].delay <= 1; // SUB
                            2'b10: requests[i].delay <= 4; // MUL
                            2'b11: requests[i].delay <= 2; // XOR
                        endcase

                        break;
                    end
                end
            end

            // Process outstanding requests
            foreach (requests[i]) begin

                if (requests[i].valid) begin

                    if (requests[i].delay > 0)
                        requests[i].delay--;

                    if (requests[i].delay == 0) begin

                        rsp_valid <= 1;
                        rsp_id    <= requests[i].id;

                        case (requests[i].op)
                            2'b00: rsp_data <= requests[i].a + requests[i].b;
                            2'b01: rsp_data <= requests[i].a - requests[i].b;
                            2'b10: rsp_data <= requests[i].a * requests[i].b;
                            2'b11: rsp_data <= requests[i].a ^ requests[i].b;
                        endcase

                        requests[i].valid <= 0;

                        break;
                    end
                end
            end


        end
    end

    assign busy = requests[0].valid & requests[1].valid &
                  requests[2].valid & requests[3].valid;
endmodule