// Button Handler Module
// Handles button inputs for alarm time adjustment
`timescale 1ns / 1ps

module buttons(
    input wire clk,              // System clock
    input wire enb,             // Enable signal
    input wire sw0,             // Alarm mode switch
    input wire sw1,             // Display mode switch
    input wire [3:0] btn,       // Button inputs
    output reg [5:0] a_hour,    // Alarm hours
    output reg [5:0] a_min      // Alarm minutes
);

    // Time limits
    localparam [5:0] MAX_HOUR = 6'd23;
    localparam [5:0] MAX_MIN = 6'd59;

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

    // Alarm time adjustment logic
    always @(posedge clk) begin
        if (|btn_edge) begin
            case (btn_edge)
                4'b0100: begin // BTN2: Adjust alarm minutes
                    if (a_min >= MAX_MIN) begin
                        a_min <= 0;
                        // Increment hour if minutes roll over
                        a_hour <= (a_hour >= MAX_HOUR) ? 0 : a_hour + 1;
                    end
                    else begin
                        a_min <= a_min + 1;
                    end
                end

                4'b1000: begin // BTN3: Adjust alarm hours
                    if (a_hour >= MAX_HOUR)
                        a_hour <= 0;
                    else
                        a_hour <= a_hour + 1;
                end
            endcase
        end
    end

endmodule