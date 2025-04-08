// Police Siren Effect Module
// Generates alternating red/blue LED signals for alarm indication
`timescale 1ns / 1ps

module policeSiren(
    input wire enb,              // Alarm enable
    input wire clk_in,          // System clock
    output reg clk_out_red,     // Red LED control
    output reg clk_out_blue     // Blue LED control
);
    // Parameters for timing control
    localparam FLASH_FREQ = 125000000;  // 125MHz / 2 = 0.5Hz flash rate
    localparam [27:0] MAX_COUNT = FLASH_FREQ - 1;
    
    // Counter for LED alternation
    reg [27:0] counter;
    
    // LED control logic
    always @(posedge clk_in) begin
        if (enb) begin
            // Update counter
            if (counter >= MAX_COUNT)
                counter <= 28'd0;
            else
                counter <= counter + 28'd1;
                
            // Control LED outputs
            clk_out_red <= (counter < MAX_COUNT/2);
            clk_out_blue <= (counter >= MAX_COUNT/2);
        end
        else begin
            // Reset when disabled
            counter <= 28'd0;
            clk_out_red <= 1'b0;
            clk_out_blue <= 1'b0;
        end
    end

endmodule