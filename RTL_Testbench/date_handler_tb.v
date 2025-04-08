// Date Handler Module Testbench
`timescale 1ns / 1ps

module date_handler_tb;
    // Test signals
    reg clk, enb, sw1;
    reg [3:0] btn;
    reg [5:0] hr, min, sec;
    wire [3:0] mm1, mm2, dd1, dd2;
    
    // Instantiate the Unit Under Test (UUT)
    mmdd uut(
        .clk(clk),
        .enb(enb),
        .sw1(sw1),
        .btn(btn),
        .hr(hr),
        .min(min),
        .sec(sec),
        .mm1(mm1),
        .mm2(mm2),
        .dd1(dd1),
        .dd2(dd2)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        enb = 0;
        sw1 = 0;
        btn = 4'b0000;
        hr = 0; min = 0; sec = 0;
        #10;
        
        // Test case 1: Initial state
        #10;
        
        // Test case 2: Increment day
        btn = 4'b0001;  // BTN0
        #10;
        btn = 4'b0000;
        #10;
        
        // Test case 3: Increment month
        btn = 4'b0010;  // BTN1
        #10;
        btn = 4'b0000;
        #10;
        
        // Test case 4: Day rollover at month end
        // Set to January 31st
        repeat(30) begin
            btn = 4'b0001;
            #10;
            btn = 4'b0000;
            #10;
        end
        
        // Test case 5: February handling
        btn = 4'b0010;  // Move to February
        #10;
        btn = 4'b0000;
        repeat(28) begin
            btn = 4'b0001;
            #10;
            btn = 4'b0000;
            #10;
        end
        
        // Test case 6: Automatic date rollover
        hr = 23; min = 59; sec = 59;
        enb = 1;
        #20;
        enb = 0;
        
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t date=%d%d/%d%d", 
                 $time, mm1, mm2, dd1, dd2);
    end

endmodule
