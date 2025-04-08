// Alarm Clock Module
// Handles alarm time setting and triggering with display management
`timescale 1ns / 1ps

module alarmClk(
    input wire clk,                    // System clock
    input wire [3:0] btn,             // Button inputs
    input wire sw0,                    // Alarm enable switch
    input wire [5:0] c_hour,          // Current hour
    input wire [5:0] c_min,           // Current minute
    input wire [5:0] c_sec,           // Current second
    input wire [5:0] a_hr,            // Alarm hour
    input wire [5:0] a_min,           // Alarm minute
    output reg [3:0] min1,            // Minutes tens digit
    output reg [3:0] min2,            // Minutes ones digit
    output reg [3:0] hr1,             // Hours tens digit
    output reg [3:0] hr2,             // Hours ones digit
    output reg alarm                   // Alarm trigger signal
);

    // Internal signals for digit conversion
    wire [3:0] c_hr1, c_hr2, c_min1, c_min2;
    wire [3:0] a_hr1, a_hr2, a_min1, a_min2;

    // State definitions
    localparam SHOW_CURRENT = 2'b00;
    localparam SHOW_ALARM = 2'b01;
    reg [1:0] display_state;
    reg [19:0] display_timer;  // Timer for temporary alarm time display

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

    // Alarm trigger logic with persistence
    always @(posedge clk) begin
        if (!sw0) begin
            alarm <= 1'b0;
        end
        else begin
            // Match current time with alarm time
            if ({c_hour, c_min} == {a_hr, a_min} && c_sec < 6'd59) begin
                alarm <= 1'b1;
            end
            else begin
                alarm <= 1'b0;
            end
        end
    end

    // Display control logic
    always @(posedge clk) begin
        // Reset timer and state when no buttons are pressed
        if (!btn_edge[2] && !btn_edge[3] && display_timer == 0) begin
            display_state <= SHOW_CURRENT;
        end
        // Button press handling
        else if (|btn_edge) begin
            case (btn_edge)
                4'b0100, 4'b1000: begin  // BTN2 or BTN3
                    display_state <= SHOW_ALARM;
                    display_timer <= 20'd1000000; // Show alarm time for ~1 second
                end
            endcase
        end
        // Timer countdown
        else if (display_timer > 0) begin
            display_timer <= display_timer - 1;
        end

        // Update display based on state
        case (display_state)
            SHOW_ALARM: begin
                hr1 <= a_hr1;
                hr2 <= a_hr2;
                min1 <= a_min1;
                min2 <= a_min2;
            end
            default: begin  // SHOW_CURRENT
                hr1 <= c_hr1;
                hr2 <= c_hr2;
                min1 <= c_min1;
                min2 <= c_min2;
            end
        endcase
    end

    // Binary to BCD conversion for display
    assign c_hr1 = c_hour / 6'd10;
    assign c_hr2 = c_hour % 6'd10;
    assign c_min1 = c_min / 6'd10;
    assign c_min2 = c_min % 6'd10;
    
    assign a_hr1 = a_hr / 6'd10;
    assign a_hr2 = a_hr % 6'd10;
    assign a_min1 = a_min / 6'd10;
    assign a_min2 = a_min % 6'd10;

endmodule