`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 12:25:21 AM
// Design Name: 
// Module Name: lsfr_7bit
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


module lfsr(
    input clk_i,
    input frame_clocked,
    output [6:0] rand
    );
    wire bit_shifter;
    assign bit_shifter = rand[5] ^ rand[6];
    wire ce = frame_clocked;
    FDRE #(.INIT(1'b1)) r0 (.C(clk_i), .R(1'b0), .CE(ce), .D(bit_shifter), .Q(rand[0]));
    FDRE #(.INIT(1'b0)) r1 (.C(clk_i), .R(1'b0), .CE(ce), .D(rand[0]), .Q(rand[1]));
    FDRE #(.INIT(1'b0)) r2 (.C(clk_i), .R(1'b0), .CE(ce), .D(rand[1]), .Q(rand[2]));
    FDRE #(.INIT(1'b0)) r3 (.C(clk_i), .R(1'b0), .CE(ce), .D(rand[2]), .Q(rand[3]));
    FDRE #(.INIT(1'b0)) r4 (.C(clk_i), .R(1'b0), .CE(ce), .D(rand[3]), .Q(rand[4]));
    FDRE #(.INIT(1'b0)) r5 (.C(clk_i), .R(1'b0), .CE(ce), .D(rand[4]), .Q(rand[5]));
    FDRE #(.INIT(1'b0)) r6 (.C(clk_i), .R(1'b0), .CE(ce), .D(rand[5]), .Q(rand[6]));
endmodule
