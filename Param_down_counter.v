module Param_down_counter #(
    parameter int N = 8 // N is the number of bits in the counter
) (
    input logic clk,
    input logic rst,
    output logic done,
    output logic [$clog2(N):0] count
    );

    // Sequential logic for the down counter

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= N;
            done <= 0;
        end 
        else if (count == 0) begin
            count <= N;
            done <= 1;
        end
        else begin
            count <= count - 1;
            done <= 0;
        end
    end    
endmodule
