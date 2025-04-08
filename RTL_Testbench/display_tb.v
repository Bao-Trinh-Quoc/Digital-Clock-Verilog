// Seven-Segment Display Testbench
`timescale 1ns / 1ps

module display_tb;
    // Test signals
    reg [3:0] led_in;
    wire [6:0] led;
    
    // Instantiate the Unit Under Test (UUT)
    display uut(
        .led(led),
        .led_in(led_in)
    );
    
    // Test stimulus
    initial begin
        // Test all digits 0-9
        led_in = 4'd0;
        #10;
        
        // Loop through all digits
        for(integer i = 1; i <= 9; i = i + 1) begin
            led_in = i;
            #10;
        end
        
        // Test invalid input
        led_in = 4'd10;
        #10;
        led_in = 4'd15;
        #10;
        
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t input=%d segments=%b", $time, led_in, led);
    end

endmodule
