// Edge Detector Testbench
`timescale 1ns / 1ps

module edgeDetector_tb;
    // Test signals
    reg sig, clk;
    wire pulse;
    
    // Instantiate the Unit Under Test (UUT)
    edgeDetector uut(
        .sig(sig),
        .clk(clk),
        .p(pulse)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        sig = 0;
        #20;
        
        // Test case 1: Single pulse
        sig = 1;
        #10;
        sig = 0;
        #20;
        
        // Test case 2: Multiple transitions
        sig = 1;
        #10;
        sig = 0;
        #10;
        sig = 1;
        #10;
        sig = 0;
        #20;
        
        // Test case 3: Long high signal
        sig = 1;
        #50;
        sig = 0;
        #20;
        
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t sig=%b clk=%b pulse=%b", $time, sig, clk, pulse);
    end
endmodule
