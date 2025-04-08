// Stopwatch Module
// Implements a digital stopwatch with start/stop and reset functionality
`timescale 1s / 1s

module stop_watch (
    input wire clk,              // System clock
    input wire enb,             // Enable signal (1Hz)
    input wire sw3,             // Start/Stop control
    input wire sw2,             // Stopwatch mode enable
    input wire btn0,            // Reset button
    output reg [3:0] sw_min1,   // Minutes tens digit
    output reg [3:0] sw_min2,   // Minutes ones digit
    output reg [3:0] sw_sec1,   // Seconds tens digit
    output reg [3:0] sw_sec2    // Seconds ones digit
);

    // Parameters
    localparam [6:0] MAX_MIN = 7'd99;  // Maximum minutes (99)
    localparam [6:0] MAX_SEC = 7'd59;  // Maximum seconds (59)

    // Internal registers
    reg [6:0] min, sec;        // Time counters
    reg run;                   // Running state
    wire reset;               // Reset signal

    // Edge detection for reset button
    edgeDetector e(
        .sig(btn0),
        .clk(clk),
        .p(reset)
    );

    // Start/Stop control
    always @(sw3) begin
        run <= sw3;  // Start when sw3 is high, stop when low
    end

    // Main stopwatch logic
    always @(posedge clk) begin
        if (sw2) begin  // Only operate in stopwatch mode
            if (reset) begin
                // Reset counters
                min <= 0;
                sec <= 0;
            end
            else if (enb && run) begin
                // Normal counting operation
                if (sec >= MAX_SEC) begin
                    sec <= 0;
                    if (min >= MAX_MIN)
                        min <= 0;  // Roll over at 99:59
                    else
                        min <= min + 1;
                end
                else begin
                    sec <= sec + 1;
                end
            end

            // Update display outputs - always active for immediate display update
            // Minutes display
            sw_min1 <= min / 7'd10;
            sw_min2 <= min % 7'd10;
            
            // Seconds display
            sw_sec1 <= sec / 7'd10;
            sw_sec2 <= sec % 7'd10;
        end
    end

endmodule