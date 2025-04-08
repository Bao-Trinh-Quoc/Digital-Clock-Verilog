// Alarm Indicator (Police Siren) Testbench
`timescale 1ns / 1ps

module alarm_indicator_tb;
    // Test signals
    reg enb, clk_in;
    wire clk_out_red, clk_out_blue;
    
    // Instantiate the Unit Under Test (UUT)
    policeSiren uut(
        .enb(enb),
        .clk_in(clk_in),
        .clk_out_red(clk_out_red),
        .clk_out_blue(clk_out_blue)
    );
    
    // Clock generation - using faster clock for simulation
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;  // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        enb = 0;
        #100;
        
        // Test case 1: Enable siren
        enb = 1;
        #2000000;  // Run for a few LED transitions
        
        // Test case 2: Disable siren
        enb = 0;
        #100;
        
        // Test case 3: Short enable pulses
        repeat(3) begin
            enb = 1;
            #1000000;
            enb = 0;
            #500000;
        end
        
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t enb=%b red=%b blue=%b", 
                 $time, enb, clk_out_red, clk_out_blue);
    end

    // Optional: Save waveforms
    initial begin
        $dumpfile("alarm_indicator.vcd");
        $dumpvars(0, alarm_indicator_tb);
    end

endmodule
