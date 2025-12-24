`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 12:28:44 PM
// Design Name: 
// Module Name: mux4bit
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


module mux4bit(
input [3:0] a,
input [3:0] b,
input       s,
output [3:0] y
    );
assign y = ({4{s}} & b) | ({4{~s}} & a);
endmodule
