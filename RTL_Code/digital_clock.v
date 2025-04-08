// Digital Clock Module
// This module handles the core clock functionality including time keeping and adjustment
`timescale 1ns / 1ps

module digital_clock(
    input wire clk,              // System clock
    input wire enb,             // Enable signal (1Hz)
    input wire sw0,             // Alarm mode switch
    input wire sw1,             // Time/Date display mode switch
    input wire sw2,             // Stopwatch mode switch
    input wire [3:0] btn,       // Button inputs
    output reg [5:0] hour,      // Hours (0-23)
    output reg [5:0] min,       // Minutes (0-59)
    output reg [5:0] sec        // Seconds (0-59)
);

    // Parameters for time limits
    localparam MAX_HOUR = 6'd23;
    localparam MAX_MIN  = 6'd59;
    localparam MAX_SEC  = 6'd59;

    // Button edge detection
    wire [3:0] btn_edge;
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : btn_edges
            edgeDetector edge_det(
                .sig(btn[i]),
                .clk(clk),
                .p(btn_edge[i])
            );
        end
    endgenerate

    // Time adjustment logic
    always @(posedge clk) begin
        if (|btn_edge && !sw2) begin
            case (btn_edge)
                4'b0001: begin // BTN0: Adjust minutes
                    if (sw1) begin
                        if (min >= MAX_MIN) begin
                            min <= 0;
                            hour <= (hour >= MAX_HOUR) ? 0 : hour + 1;
                        end
                        else min <= min + 1;
                    end
                end
                4'b0010: begin // BTN1: Adjust hours
                    if (sw1) begin
                        hour <= (hour >= MAX_HOUR) ? 0 : hour + 1;
                    end
                end
            endcase
        end
        // Normal time keeping
        else if (enb) begin
            if (sec >= MAX_SEC) begin
                sec <= 0;
                if (min >= MAX_MIN) begin
                    min <= 0;
                    hour <= (hour >= MAX_HOUR) ? 0 : hour + 1;
                end
                else min <= min + 1;
            end
            else sec <= sec + 1;
        end
    end

endmodule