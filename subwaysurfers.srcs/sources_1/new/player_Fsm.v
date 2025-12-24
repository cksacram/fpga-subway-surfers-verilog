`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 02:25:28 AM
// Design Name: 
// Module Name: player_Fsm
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


module player_Fsm(
input clk_i,
input left,
input Go,
input right,
input hover,
output [1:0] lane,
output hover_on
    );
    wire left_only = left & ~right & ~hover;
    wire right_only = right & ~left & ~hover;
    wire none = ~right & ~left & ~hover;
    wire hover_only = ~right & ~left & hover;
    wire [4:0] D;
    wire [4:0] Q;
    wire go = Go & none;
    //idle 
    assign D[4] = (Q[4] & ~go); 
    //aka middle
    assign D[0] = Q[4] & go | Q[0] & none | Q[1] & right_only | Q[2] & left_only | Q[3] & none;
    //left
    assign D[1] = ((Q[0] & left_only)  |(Q[1] & ~right_only));
    // right 
    assign D[2] = ((Q[0] & right_only) | (Q[2] & ~left_only));
    //hover
    assign D[3] = (Q[0] & hover_only)| Q[3] & hover;
    
    FDRE #(.INIT(1'b0)) Q0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) Q2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) Q3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[3]), .Q(Q[3]));
    FDRE #(.INIT(1'b1)) Q4 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[4]), .Q(Q[4]));
    assign hover_on = Q[3];
    assign lane = Q[1] ? 2'd0 : (Q[2] ? 2'd2 : 2'd1);
endmodule
