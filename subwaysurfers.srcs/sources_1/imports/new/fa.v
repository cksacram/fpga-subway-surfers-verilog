`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 09:28:41 PM
// Design Name: 
// Module Name: hex7seg
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


module fa(
    input A_i,
    input B_i,
    input cin_i,
    output S_o,
    output ovfl_o,
    output cout_o
    );
    assign S_o = (A_i^B_i)^cin_i;
    assign cout_o = ((A_i^B_i) & cin_i) | (B_i & A_i);
endmodule