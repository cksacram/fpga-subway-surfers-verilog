`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 06:16:31 PM
// Design Name: 
// Module Name: 16flipflop
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


module flipflop(
input clk_i,
input [15:0] D,
output [15:0] Q,
input CE
    );
FDRE #(.INIT(1'b0)) Q0 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[0]), .Q(Q[0]));
FDRE #(.INIT(1'b0)) Q1 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[1]), .Q(Q[1]));
FDRE #(.INIT(1'b0)) Q2 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[2]), .Q(Q[2]));
FDRE #(.INIT(1'b0)) Q3 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[3]), .Q(Q[3]));
FDRE #(.INIT(1'b0)) Q4 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[4]), .Q(Q[4]));
FDRE #(.INIT(1'b0)) Q5 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[5]), .Q(Q[5]));
FDRE #(.INIT(1'b0)) Q6 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[6]), .Q(Q[6]));
FDRE #(.INIT(1'b0)) Q7 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[7]), .Q(Q[7]));
FDRE #(.INIT(1'b0)) Q8 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[8]), .Q(Q[8]));
FDRE #(.INIT(1'b0)) Q9 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[9]), .Q(Q[9]));
FDRE #(.INIT(1'b0)) Q10 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[10]), .Q(Q[10]));
FDRE #(.INIT(1'b0)) Q11 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[11]), .Q(Q[11]));
FDRE #(.INIT(1'b0)) Q12 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[12]), .Q(Q[12]));
FDRE #(.INIT(1'b0)) Q13 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[13]), .Q(Q[13]));
FDRE #(.INIT(1'b0)) Q14 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[14]), .Q(Q[14]));
FDRE #(.INIT(1'b0)) Q15 (.C(clk_i), .R(1'b0), .CE(CE), .D(D[15]), .Q(Q[15]));

endmodule
