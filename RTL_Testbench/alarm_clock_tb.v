// Alarm Clock Module Testbench
`timescale 1ns / 1ps

module alarm_clock_tb;
    // Test signals
    reg clk;
    reg [3:0] btn;
    reg sw0;
    reg [5:0] c_hour, c_min, c_sec;
    reg [5:0] a_hr, a_min;
    wire [3:0] min1, min2, hr1, hr2;
    wire alarm;
    
    // Instantiate the Unit Under Test (UUT)
    alarmClk uut(
        .clk(clk),
        .btn(btn),
        .sw0(sw0),
        .c_hour(c_hour),
        .c_min(c_min),
        .c_sec(c_sec),
        .a_hr(a_hr),
        .a_min(a_min),
        .min1(min1),
        .min2(min2),
        .hr1(hr1),
        .hr2(hr2),
        .alarm(alarm)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        btn = 4'b0000;
        sw0 = 0;
        c_hour = 6'd12;
        c_min = 6'd0;
        c_sec = 6'd0;
        a_hr = 6'd12;
        a_min = 6'd0;
        #10;
        
        // Test case 1: Enable alarm
        sw0 = 1;
        #10;
        
        // Test case 2: Alarm match condition
        c_hour = 6'd12;
        c_min = 6'd0;
        c_sec = 6'd0;
        #20;
        
        // Test case 3: View alarm time
        btn = 4'b0100;  // BTN2
        #1000000;  // Wait for display timer
        btn = 4'b0000;
        #20;
        
        // Test case 4: No match condition
        c_hour = 6'd13;
        #20;
        
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t sw0=%b alarm=%b display=%d%d:%d%d", 
                 $time, sw0, alarm, hr1, hr2, min1, min2);
    end

endmodule
