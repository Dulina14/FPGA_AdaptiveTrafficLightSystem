module Timer_module (
    input logic clk,
    input logic rst,
    output logic done,
    output logic [2:0] millie_seconds,
    output logic [2:0] seconds,
    );

    logic millie_seconds_done, seconds_done;

    Param_down_counter #(
        .N(5)
    ) millie_seconds_counter (
        .clk(clk),
        .rst(rst),
        .done(millie_seconds_done),
        .count(millie_seconds)
    );

    Param_down_counter #(
        .N(7)
    ) seconds_counter (
        .clk(clk),
        .rst(millie_seconds_done),
        .done(seconds_done),
        .count(seconds)
    );

    assign done = seconds_done && millie_seconds_done;

endmodule
