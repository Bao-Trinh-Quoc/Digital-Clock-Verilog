// Digital Clock System Testbench
`timescale 1s / 1s

module clock_system_tb; 
    reg clk;
    reg sw0, sw1, sw2, sw3;
    reg [3:0] btn;
    wire [3:0]led1, led2;
    wire [3:0]led3, led4;
    wire l_red, l_blue;

    // Instantiate the Unit Under Test (UUT)
    combine uut(
        .led1(led1), 
        .led2(led2), 
        .led3(led3), 
        .led4(led4), 
        .l_red(l_red), 
        .l_blue(l_blue), 
        .sw0(sw0), 
        .sw1(sw1), 
        .sw2(sw2), 
        .sw3(sw3), 
        .btn(btn), 
        .clk(clk)
    );

    // Clock generation
    initial
        clk = 0;
    always
        #1 clk = ~clk;

    // Test stimulus
    initial begin 
        // Test case 1: Normal time display
        #2
            sw0 = 0; sw1 = 1; sw2 = 1; sw3 = 1;
            btn = 4'b0000;
            
        // Test case 2: Stopwatch control
        #1 
            sw0 = 0; sw1 = 1; sw2 = 1; sw3 = 0;
            btn = 4'b0000;
            
        // Test case 3: Button press
        #1 
            sw0 = 0; sw1 = 1; sw2 = 1; sw3 = 1;
            btn = 4'b0001;
    end

    // Monitor outputs
    initial begin
        $monitor("time=%g, sw0=%b, sw1=%b, sw2=%b, sw3=%b, btn=%b, led1=%b, led2=%b, led3=%b, led4=%b, l_red=%b, l_blue=%b",
                $time, sw0, sw1, sw2, sw3, btn, led1, led2, led3, led4, l_red, l_blue);
    end

endmodule
