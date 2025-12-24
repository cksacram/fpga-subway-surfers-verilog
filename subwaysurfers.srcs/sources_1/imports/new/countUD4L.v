`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 09:26:50 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
input clk_i,
input up_i,
input dw_i,
input ld_i,
input [3:0] Din_i,
output [3:0] Q_o,
output utc_o,
output dtc_o
    );
    wire [3:0] S_O;
    wire cout_O;
    wire coo;
    wire [3:0] c_u, c_d;
    wire [3:0] Q;
    assign Q_o = Q;
add4 countup (.A_i(Q), .B_i(4'b0001), .cin_i(1'b0), .S_o(c_u), .cout_o(cout_O));
add4 countdown (.A_i(Q), .B_i(4'b1111), .cin_i(1'b0), .S_o(c_d), .cout_o(coo));
    wire sel_load = ld_i;
    wire sel_up   = ~ld_i &  up_i & ~dw_i;
    wire sel_down = ~ld_i & ~up_i &  dw_i;
    wire sel_none = ~(sel_load | sel_up | sel_down);
    //mux between different states
wire [3:0] D = ({4{sel_load}} & Din_i) |({4{sel_up}} & c_u) |({4{sel_down}} & c_d)
|({4{sel_none}} & Q);
  
    FDRE #(.INIT(1'b0)) Q0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) Q2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) Q3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[3]), .Q(Q[3]));
     assign utc_o = &Q;    
    assign dtc_o = ~|Q; 
endmodule
