`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2025 07:17:52 PM
// Design Name: 
// Module Name: time_counter
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


module time_counter(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [7:0] Din_i,
    output [7:0] q_o
    );

wire [3:0] q_hi = q_o[7:4];
wire [3:0] q_lo = q_o[3:0];
  wire [3:0] din_lo = Din_i[3:0];
  wire [3:0] din_hi =  Din_i[7:4];
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
countUD4L c1(.clk_i(clk_i), .up_i(up0), .dw_i(dw0), .ld_i(ld_i), .Din_i(din_lo), 
.Q_o(q_lo), .utc_o(u0), .dtc_o(d0));
countUD4L c2 (.clk_i(clk_i), .up_i(up1), .dw_i(dw1), .ld_i(ld_i), .Din_i(din_hi), 
.Q_o(q_hi), .utc_o(u1), .dtc_o(d1));
assign q_o = {q_hi, q_lo};
endmodule
