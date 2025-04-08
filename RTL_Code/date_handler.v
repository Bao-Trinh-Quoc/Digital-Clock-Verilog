// Month and Date Handler Module
// Handles calendar date functionality with proper month length handling
`timescale 1ns / 1ps

module mmdd(
    input wire clk,                     // System clock
    input wire enb,                     // Enable signal
    input wire sw1,                     // Mode switch
    input wire [3:0] btn,              // Button inputs
    input wire [5:0] hr, min, sec,     // Time inputs for day rollover
    output wire [3:0] mm1, mm2,        // Month display outputs (tens, ones)
    output wire [3:0] dd1, dd2         // Day display outputs (tens, ones)
);

    // Calendar parameters
    localparam [5:0] MAX_MONTH = 6'd12;
    reg [5:0] mm, dd;

    // Month lengths lookup
    reg [5:0] month_length;
    always @(*) begin
        case (mm)
            6'd4, 6'd6, 6'd9, 6'd11: month_length = 6'd30;    // 30 days
            6'd2:                     month_length = 6'd28;    // February (non-leap year)
            default:                  month_length = 6'd31;    // 31 days
        end
    end

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

    // Date adjustment and rollover logic
    always @(posedge clk) begin
        // Initialize if month is invalid
        if (mm == 0) begin
            mm <= 6'd1;
            dd <= 6'd1;
        end
        // Button controls when sw1 is off (date adjustment mode)
        else if (|btn_edge && !sw1) begin
            case (btn_edge)
                4'b0001: begin // BTN0: Increment day
                    if (dd >= month_length) begin
                        dd <= 6'd1;
                        mm <= (mm >= MAX_MONTH) ? 6'd1 : mm + 6'd1;
                    end
                    else dd <= dd + 6'd1;
                end
                4'b0010: begin // BTN1: Increment month
                    mm <= (mm >= MAX_MONTH) ? 6'd1 : mm + 6'd1;
                    // Adjust day if it exceeds new month's length
                    if (dd > month_length) dd <= month_length;
                end
            endcase
        end
        // Automatic date rollover at midnight
        else if (enb && hr >= 6'd23 && min >= 6'd59 && sec >= 6'd59) begin
            if (dd >= month_length) begin
                dd <= 6'd1;
                mm <= (mm >= MAX_MONTH) ? 6'd1 : mm + 6'd1;
            end
            else dd <= dd + 6'd1;
        end
    end

    // Display output assignments
    assign mm1 = mm / 6'd10;
    assign mm2 = mm % 6'd10;
    assign dd1 = dd / 6'd10;
    assign dd2 = dd % 6'd10;

endmodule