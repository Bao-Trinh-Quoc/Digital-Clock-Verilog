// Clock Divider Testbench
`timescale 1ns / 1ps

module clock_divider_tb;
    // Test signals
    reg clk;
    wire enb;
    
    // For testbench, we'll use a smaller division ratio
    // Instantiate the Unit Under Test (UUT)
    get1hz uut(
        .clk(clk),
        .enb(enb)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Let it run for a few cycles
        #2000000;  // Run for 2ms to see multiple enable pulses
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t clk=%b enb=%b", $time, clk, enb);
    end

    // Optional: Save waves
    initial begin
        $dumpfile("clock_divider.vcd");
        $dumpvars(0, clock_divider_tb);
    end
endmodule
