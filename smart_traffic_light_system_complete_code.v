module Smart_Traffic_Light_System (
    input logic clk,                 // Input clock signal
    input logic rst,                 // Reset signal
    output logic [6:0] traffic_lights // Output traffic light signals
);

    // Internal signals
    logic amber_timer_en;            // Enable signal for amber timer
    logic timer_done;                // Timer done signal
    logic [2:0] millie_seconds;      // Milliseconds counter (debugging)
    logic [3:0] seconds;             // Seconds counter (debugging)
    logic [1:0] stls_input;          // Input to the STLS module
    logic [1:0] stls_state;          // Current state of the STLS module
    logic [6:0] stls_output;         // Output from the STLS module

    // Timer module instance
    Timer_module timer (
        .clk(clk),
        .rst(rst),
        .done(timer_done),
        .millie_seconds(millie_seconds),
        .seconds(seconds)
    );

    // State transition logic for amber_timer_en and STLS input
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            amber_timer_en <= 0;     // Reset amber_timer_en
            stls_input <= 2'b00;    // Reset input to STLS module
        end
        else begin
            // Enable timer when amber_timer_en is high
            if (amber_timer_en) begin
                if (timer_done) begin
                    amber_timer_en <= 0;       // Disable amber_timer_en
                    stls_input <= 2'b10;       // Set input to 10 to trigger next state
                end
            end
            else if (stls_output[6]) begin    // Check STLS amber_timer_en output
                amber_timer_en <= 1;          // Enable amber_timer_en
                stls_input <= 2'b00;          // Reset input to STLS while timer runs
            end
        end
    end

    // After timer_done is high, clear it after a few clock cycles
    logic [2:0] timer_done_counter; // 3-bit counter for delay
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            timer_done_counter <= 3'd0;
        end
        else if (timer_done) begin
            timer_done_counter <= timer_done_counter + 1;
            if (timer_done_counter == 3'd4) begin // Hold timer_done for 4 clock cycles
                timer_done_counter <= 3'd0;
                timer_done <= 0; // Reset timer_done
            end
        end
    end

    // STLS Moore machine instance
    STLS_moore stls (
        .clk(clk),
        .rst(rst),
        .i_bits(stls_input),
        .o_bits(stls_output)
    );

    // Output traffic light signals
    assign traffic_lights = stls_output;

endmodule
