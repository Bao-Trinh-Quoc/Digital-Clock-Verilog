// Edge Detector Module
// Detects rising edges on input signals for debounced button handling
`timescale 1ns / 1ps

module edgeDetector(
    input wire sig,     // Input signal to detect edges on
    input wire clk,     // System clock
    output wire p       // Pulse output (high for one clock after rising edge)
);
    // Two-stage flip-flop for metastability handling
    reg [1:0] sig_ff;
    
    always @(posedge clk) begin
        sig_ff[0] <= sig;        // Sample input
        sig_ff[1] <= sig_ff[0];  // Second stage
    end
    
    // Rising edge detection: Output high only on 0->1 transition
    assign p = sig_ff[0] & ~sig_ff[1];

endmodule

