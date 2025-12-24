`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 04:21:09 PM
// Design Name: 
// Module Name: fsmtrain
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fsmtrain(
    input clk_i,
    input frame_clocked,
    input start_i, 
    output [15:0] train_top,  
    output [15:0] train_bottom,
    output running
    );
    wire [2:0] D;
    wire [2:0] Q;
//  wire [6:0] rnd;
    wire [15:0] screen_height = 16'd480;        
    wire [15:0] train_start_y = 16'd0;
    wire [15:0] bottom_q;
    wire [15:0] bottom_d;
    wire [15:0] bottom_inc1 = bottom_q + 16'd1;

    // length register
    wire [15:0] length_q;
    wire [15:0] length_d;

    // top = bottom - length
    wire [15:0] top_raw = bottom_q - length_q;
    wire [15:0] actual_top = (bottom_q > length_q) ? top_raw : 16'd0;
  
    wire offscreen = (actual_top >= screen_height);
    wire [6:0] rnd;
    lfsr rng (.clk_i(clk_i), .frame_clocked(frame_clocked), .rand (rnd));

    // random wait time
    wire [7:0] rand_wait_raw = {1'b0, rnd};   
    wire [7:0] rand_wait = (rand_wait_raw == 8'd0) ? 8'd1 : rand_wait_raw;
//    wire [7:0] rand_wait = rand_wait_raw + 8'd32;

    wire [5:0] rand_set = rnd[5:0];
    wire [15:0] rand_length = 16'd60 + {10'd0, rand_set};  // 60 to 123
     
    wire [7:0] wait_q;
    wire wait_finished;
    time_counter wait_counter (
    .clk_i(clk_i),
    .ld_i(Q[0] & start_i), // load random time when leaving idle
    .dw_i(Q[1] & frame_clocked & ~wait_finished), // count down 1 per frame in wait
    .Din_i(rand_wait),
    .q_o(wait_q)
    );
    assign wait_finished = (wait_q == 8'd0);
   
    //Idle
    assign D[0] = (Q[0] & ~start_i) | (Q[2] & offscreen);
    // Wait
    assign D[1] = (Q[0] & start_i) | (Q[1] & ~wait_finished);
    // Move
    assign D[2] = (Q[1] & wait_finished) | (Q[2] & ~offscreen);
    //one hot 
    FDRE #(.INIT(1'b1)) idle (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) wait_ff (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) move (.C(clk_i),.R(1'b0), .CE(1'b1), .D(D[2]), .Q(Q[2]));
    
    assign bottom_d = (Q[0] | Q[1]) ? train_start_y : (Q[2] & frame_clocked & ~offscreen)  ? bottom_inc1  : bottom_q;
    flipflop train_positon (
    .clk_i(clk_i),
    .CE(1'b1),
    .D(bottom_d),
    .Q(bottom_q)
    );

    // load new random length on start_i
    assign length_d = (Q[0] & start_i) ? rand_length : length_q;
    flipflop length (
    .clk_i(clk_i),
    .CE(1'b1),
    .D(length_d),
    .Q(length_q)
    );
     assign train_top = actual_top;
    assign train_bottom = bottom_q;
    assign running = Q[2];
endmodule
