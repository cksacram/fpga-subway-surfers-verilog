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


module ring_counter(
input clk_i,
input advance_i,
output [3:0] ring_o
    );
wire [3:0] D;
wire [3:0] q;
assign D = {q[0], q[3:1]};
  FDRE #(.INIT(1'b1)) ff0 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[0]), .Q(q[0]));
  FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[1]), .Q(q[1]));
  FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[2]), .Q(q[2]));
  FDRE #(.INIT(1'b0)) ff3 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[3]), .Q(q[3]));
  assign ring_o = q;
endmodule
