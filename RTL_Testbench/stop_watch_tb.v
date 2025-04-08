// Stopwatch Module Testbench
`timescale 1s / 1s

module stop_watch_tb;
    // Test signals
    reg clk, enb, sw3, sw2, btn0;
    wire [3:0] sw_min1, sw_min2, sw_sec1, sw_sec2;
    
    // Instantiate the Unit Under Test (UUT)
    stop_watch uut(
        .clk(clk),
        .enb(enb),
        .sw3(sw3),
        .sw2(sw2),
        .btn0(btn0),
        .sw_min1(sw_min1),
        .sw_min2(sw_min2),
        .sw_sec1(sw_sec1),
        .sw_sec2(sw_sec2)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;  // 1Hz clock for simulation
    end
    
    // Enable signal generation (1Hz)
    always begin
        enb = 1;
        #1;
        enb = 0;
        #1;
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        sw2 = 1;  // Enable stopwatch mode
        sw3 = 0;  // Initially stopped
        btn0 = 0; // Reset button
        #2;
        
        // Test case 1: Start counting
        sw3 = 1;
        #10;
        
        // Test case 2: Stop counting
        sw3 = 0;
        #2;
        
        // Test case 3: Reset while stopped
        btn0 = 1;
        #1;
        btn0 = 0;
        #2;
        
        // Test case 4: Start counting again
        sw3 = 1;
        #65;  // Run past a minute
        
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t sw3=%b btn0=%b display=%d%d:%d%d", 
                 $time, sw3, btn0, sw_min1, sw_min2, sw_sec1, sw_sec2);
    end

endmodule
