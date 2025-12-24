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


module selector(
input [3:0] Sel_i,
input [15:0] N_i,
input [3:0] H_o
    );
    assign H_o =
    ({4{Sel_i[3]}} & N_i[15:12]) |
    ({4{Sel_i[2]}} & N_i[11:8])  |
    ({4{Sel_i[1]}} & N_i[7:4])   |
    ({4{Sel_i[0]}} & N_i[3:0]);
endmodule