`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 02:58:52 PM
// Design Name: 
// Module Name: countUD16L
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


module countUD16L(
input clk_i,
input up_i,
input dw_i,
input ld_i,
input [15:0] Din_i,
output [15:0] Q_o,
output utc_o,
output dtc_o
    );
  wire u0,u1,u2,u3;  
  wire d0,d1,d2,d3;  
  wire up0 = up_i;
  wire up1 = up_i & u0;
  wire up2 = up_i & u0 & u1;
  wire up3 = up_i & u0 & u1 & u2;

  wire dw0 = dw_i;
  wire dw1 = dw_i & d0;
  wire dw2 = dw_i & d0 & d1;
  wire dw3 = dw_i & d0 & d1 & d2;
countUD4L c1(.clk_i(clk_i), .up_i(up0), .dw_i(dw0), .ld_i(ld_i), .Din_i(Din_i[3:0]), 
.Q_o(Q_o[3:0]), .utc_o(u0), .dtc_o(d0));
countUD4L c2 (.clk_i(clk_i), .up_i(up1), .dw_i(dw1), .ld_i(ld_i), .Din_i(Din_i[7:4]), 
.Q_o(Q_o[7:4]), .utc_o(u1), .dtc_o(d1));
countUD4L c3 (.clk_i(clk_i), .up_i(up2), .dw_i(dw2), .ld_i(ld_i), .Din_i(Din_i[11:8]), 
.Q_o(Q_o[11:8]), .utc_o(u2), .dtc_o(d2));
countUD4L c4 (.clk_i(clk_i), .up_i(up3), .dw_i(dw3), .ld_i(ld_i), .Din_i(Din_i[15:12]), 
.Q_o(Q_o[15:12]), .utc_o(u3), .dtc_o(d3));
assign utc_o = &Q_o;   
assign dtc_o = ~|Q_o;
endmodule
