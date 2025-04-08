`timescale 1ns / 1ps
// Seven-Segment Display Module
// Converts 4-bit binary input to 7-segment display output
`timescale 1ns / 1ps

module display(
    output reg [6:0] led,     // 7-segment LED segments (active low)
    input wire [3:0] led_in   // 4-bit binary input (0-9)
);

    // Segment encoding: abcdefg (0 = ON, 1 = OFF)
    localparam [6:0] DIGIT_0 = 7'b0000001;  // 0
    localparam [6:0] DIGIT_1 = 7'b1001111;  // 1
    localparam [6:0] DIGIT_2 = 7'b0010010;  // 2
    localparam [6:0] DIGIT_3 = 7'b0000110;  // 3
    localparam [6:0] DIGIT_4 = 7'b1001100;  // 4
    localparam [6:0] DIGIT_5 = 7'b0100100;  // 5
    localparam [6:0] DIGIT_6 = 7'b0100000;  // 6
    localparam [6:0] DIGIT_7 = 7'b0001111;  // 7
    localparam [6:0] DIGIT_8 = 7'b0000000;  // 8
    localparam [6:0] DIGIT_9 = 7'b0000100;  // 9
    localparam [6:0] DIGIT_OFF = 7'b1111111; // All segments off

    // Segment mapping logic
    always @(*) begin
        case (led_in)
            4'd0: led = DIGIT_0;
            4'd1: led = DIGIT_1;
            4'd2: led = DIGIT_2;
            4'd3: led = DIGIT_3;
            4'd4: led = DIGIT_4;
            4'd5: led = DIGIT_5;
            4'd6: led = DIGIT_6;
            4'd7: led = DIGIT_7;
            4'd8: led = DIGIT_8;
            4'd9: led = DIGIT_9;
            default: led = DIGIT_OFF;
        endcase
    end

endmodule