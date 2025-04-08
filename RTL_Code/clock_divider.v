`timescale 1ns / 1ps

module get1hz(
    input wire clk,     // System clock input
    output reg enb      // 1Hz enable signal output
);
    // Clock division parameters
    localparam CLOCK_FREQ = 125000000;  // 125MHz system clock
    localparam [27:0] DIV_VALUE = CLOCK_FREQ - 1;
    
    // Counter for clock division
    reg [27:0] counter = 28'd0;
    
    // Clock division logic
    always @(posedge clk) begin
        if (counter >= DIV_VALUE) begin
            counter <= 28'd0;
            enb <= 1'b1;
        end
        else begin
            counter <= counter + 28'd1;
            enb <= 1'b0;
        end
    end

endmodule