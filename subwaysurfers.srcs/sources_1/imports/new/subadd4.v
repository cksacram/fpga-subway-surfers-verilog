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


module subadd4(
input [3:0] A_i,
input [3:0] B_i,
input sub_i,
output [3:0] S_o,
output ovfl_o
    );
    wire [3:0] y_o;
    wire n;
    mux4bit n_select( .a(B_i), .b(~B_i), .s(sub_i), .y(y_o));
    add4 adder4(.A_i(A_i), .B_i(y_o), .cin_i(sub_i), .S_o(S_o), .ovfl_o(ovfl_o), .cout_o(n));
endmodule