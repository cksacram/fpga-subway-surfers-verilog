`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 04:11:32 PM
// Design Name: 
// Module Name: Add8
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


module Add8(
input [7:0] A_i, B_i,
input cin_i,
output [7:0] S_o,
output cout_o,
output ovfl_o
    );
    wire [6:0] carry;
fa f0(.A_i(A_i[0]), .B_i(B_i[0]), .cin_i(cin_i), .S_o(S_o[0]), .cout_o(carry[0])); 
fa f1(.A_i(A_i[1]), .B_i(B_i[1]), .cin_i(carry[0]), .S_o(S_o[1]), .cout_o(carry[1]));
fa f2(.A_i(A_i[2]), .B_i(B_i[2]), .cin_i(carry[1]), .S_o(S_o[2]), .cout_o(carry[2]));
fa f3(.A_i(A_i[3]), .B_i(B_i[3]), .cin_i(carry[2]), .S_o(S_o[3]), .cout_o(carry[3]));
fa f4(.A_i(A_i[4]), .B_i(B_i[4]), .cin_i(carry[3]), .S_o(S_o[4]), .cout_o(carry[4]));
fa f5(.A_i(A_i[5]), .B_i(B_i[5]), .cin_i(carry[4]), .S_o(S_o[5]), .cout_o(carry[5]));
fa f6(.A_i(A_i[6]), .B_i(B_i[6]), .cin_i(carry[5]), .S_o(S_o[6]), .cout_o(carry[6]));
fa f7(.A_i(A_i[7]), .B_i(B_i[7]), .cin_i(carry[6]), .S_o(S_o[7]), .cout_o(cout_o));
assign ovfl_o = carry[6] ^ cout_o;
endmodule
