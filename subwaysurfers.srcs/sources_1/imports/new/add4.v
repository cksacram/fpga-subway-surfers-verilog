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


module add4(
input [3:0] A_i, B_i,
input cin_i,
output [3:0] S_o,
output cout_o
    );
    wire [2:0] carry;
fa f0(.A_i(A_i[0]), .B_i(B_i[0]), .cin_i(cin_i), .S_o(S_o[0]), .cout_o(carry[0])); 
fa f1(.A_i(A_i[1]), .B_i(B_i[1]), .cin_i(carry[0]), .S_o(S_o[1]), .cout_o(carry[1]));
fa f2(.A_i(A_i[2]), .B_i(B_i[2]), .cin_i(carry[1]), .S_o(S_o[2]), .cout_o(carry[2]));
fa f3(.A_i(A_i[3]), .B_i(B_i[3]), .cin_i(carry[2]), .S_o(S_o[3]), .cout_o(cout_o));
endmodule