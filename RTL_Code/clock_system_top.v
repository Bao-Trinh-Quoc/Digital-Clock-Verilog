// Digital Clock System Top Module
// Integrates all clock functionalities: time, date, alarm, and stopwatch
`timescale 1ns / 1ps

module combine(
    // Display outputs
    output reg [3:0] led1, led2, led3, led4,  // 7-segment display digits
    output wire l_red, l_blue,                 // Alarm indicator LEDs
    
    // Control inputs
    input wire sw0,      // Alarm enable
    input wire sw1,      // Display mode (time/date)
    input wire sw2,      // Stopwatch mode
    input wire sw3,      // Stopwatch control
    input wire [3:0] btn,// Button inputs
    input wire clk       // System clock
);

    // Internal time and display signals
    wire enb;                   // 1Hz enable
    wire al_on;                 // Alarm active
    wire [5:0] hr, min, sec;   // Current time
    wire [5:0] a_hr, a_min;    // Alarm time
    
    // Display digit signals
    wire [3:0] h1, h2;         // Hours display
    wire [3:0] m1, m2;         // Minutes display
    wire [3:0] dd1, dd2;       // Day display
    wire [3:0] mm1, mm2;       // Month display
    wire [3:0] sw_min1, sw_min2, sw_sec1, sw_sec2;  // Stopwatch display

    // Clock generation
    get1hz clock_div(
        .clk(clk),
        .enb(enb)
    );

    // Time and date handling
    digital_clock main_clock(
        .clk(clk),
        .enb(enb),
        .sw0(sw0),
        .sw1(sw1),
        .sw2(sw2),
        .btn(btn),
        .hour(hr),
        .min(min),
        .sec(sec)
    );

    // Alarm functionality
    buttons alarm_control(
        .clk(clk),
        .enb(enb),
        .sw0(sw0),
        .sw1(sw1),
        .btn(btn),
        .a_hour(a_hr),
        .a_min(a_min)
    );

    alarmClk alarm_display(
        .clk(clk),
        .btn(btn),
        .sw0(sw0),
        .c_hour(hr),
        .c_min(min),
        .c_sec(sec),
        .a_hr(a_hr),
        .a_min(a_min),
        .min1(m1),
        .min2(m2),
        .hr1(h1),
        .hr2(h2),
        .alarm(al_on)
    );

    // Date handling
    mmdd date_control(
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

    // Stopwatch functionality
    stop_watch timer(
        .clk(clk),
        .enb(enb),
        .sw3(sw3),
        .sw2(sw2),
        .btn0(btn[0]),
        .sw_min1(sw_min1),
        .sw_min2(sw_min2),
        .sw_sec1(sw_sec1),
        .sw_sec2(sw_sec2)
    );

    // Alarm indicator
    policeSiren alert(
        .enb(al_on),
        .clk_in(clk),
        .clk_out_red(l_red),
        .clk_out_blue(l_blue)
    );

    // Display multiplexing logic
    always @(*) begin
        if (sw2 && sw1) begin
            // Stopwatch mode
            led1 = sw_min1;
            led2 = sw_min2;
            led3 = sw_sec1;
            led4 = sw_sec2;
        end
        else if (sw1) begin
            // Time display mode
            led1 = h1;
            led2 = h2;
            led3 = m1;
            led4 = m2;
        end
        else begin
            // Date display mode
            led1 = mm1;
            led2 = mm2;
            led3 = dd1;
            led4 = dd2;
        end
    end

endmodule