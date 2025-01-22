module Smart_Traffic_Light_System (
    input logic clk,
    input logic rst,
    input logic [1:0] i_bits,
    output logic [6:0] o_bits
    );

    enum logic [1:0] {
        F0, // 00
        F1, // 01
        F2, // 10
        F3, // 11
    } current_state, next_state;

    // next state combinational logic

    always_comb begin
        if (current_state == F0) begin
            if (i_bits == 2'b00)
                next_state = F0;
            else if (i_bits == 2'b01)
                next_state = F1;
         end
        else if (current_state == F1) begin
            if (i_bits == 2'b01)
                next_state = F1;
            else if (i_bits == 2'b11)
                next_state = F2;
        end
        else if (current_state == F2) begin
            if (i_bits == 2'b00)
                next_state = F3;
            else if (i_bits == 2'b01)
                next_state = F2;
        end
        else if (current_state == F3) begin
            if (i_bits == 2'b00)
                next_state = F3;
            else if (i_bits == 2'b10)
                next_state = F0;
        end
        else
            next_state = current_state;
    end

    // state register
    always_ff @(posedge clk) begin
        if (rst == 1) begin
            current_state <= F0;
        end
        else begin
            current_state <= next_state;
        end
    end

    // output logic

    always_comb begin
        if (current_state == F0) begin
            o_bits = 7'b0001100;
        end
        else if (current_state == F1) begin
            o_bits = 7'b1001010;
        end
        else if (current_state == F2) begin
            o_bits = 7'b0100001;
        end
        else if (current_state == F3) begin
            o_bits = 7'b1010001;
        end
    end


    
endmodule