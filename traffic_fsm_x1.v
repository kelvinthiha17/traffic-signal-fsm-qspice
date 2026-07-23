// Automatically generated .v file on Tue Jul 21 15:45:46 2026
//

module traffic_fsm_x1 ( clk, rst, walk, main_red, main_amber, main_green, cross_red, cross_amber, cross_green ) ;
// You will probably want to flush out the nature of these port declarations:
   input reg clk;
   input reg rst;
   input reg walk;
   output reg main_red;
   output reg main_amber;
   output reg main_green;
   output reg cross_red;
   output reg cross_amber;
   output reg cross_green;

   // Implement the module here
   // State encoding
parameter S0 = 2'b00;  // Main Green, Cross Red (default)
parameter S1 = 2'b01;  // Main Amber, Cross Red
parameter S2 = 2'b10;  // Main Red, Cross Green
parameter S3 = 2'b11;  // Main Red, Cross Amber

reg [1:0] state;    // 2-bit register to hold current state
reg [3:0] counter;  // 4-bit counter to time how long we stay in each state

// State transition logic
always @(posedge clk or posedge rst) begin
    if (rst) begin // if rst is 1, set state to s0 and counter back to 0
        state <= S0;
        counter <= 0;
    end
    else begin // otherwise this was a clock tick, run the state machine
        case (state)
            S0: begin
                if (walk) begin // if walk button is pressed, move to state s1
                    state <= S1;
                    counter <= 0; // reset counter so s1 starts timing from 0
                end
            end
            S1: begin
                if (counter == 3) begin // waited 4 cycles, move to s2
                    state <= S2;
                    counter <= 0;
                end
                else counter <= counter + 1; // keep counting
            end
            S2: begin
                if (counter == 7) begin // waited 8 cycles, move to s3
                    state <= S3;
                    counter <= 0;
                end
                else counter <= counter + 1;
            end
            S3: begin
                if (counter == 3) begin // waited 4 cycles, back to s0
                    state <= S0;
                    counter <= 0;
                end
                else counter <= counter + 1;
            end
        endcase
    end
end

// Output logic (combinational, based on current state)
always @(*) begin
    // Default: everything off
    main_red = 0; main_amber = 0; main_green = 0;
    cross_red = 0; cross_amber = 0; cross_green = 0;

    case (state) // turn on the right lights for the current state
        S0: begin main_green = 1; cross_red = 1; end   // main green, cross red
        S1: begin main_amber = 1; cross_red = 1; end   // main amber, cross red
        S2: begin main_red = 1; cross_green = 1; end   // main red, cross green
        S3: begin main_red = 1; cross_amber = 1; end   // main red, cross amber
    endcase
end
endmodule
