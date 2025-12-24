`timescale 1ns / 1ps
module turkeyCounter(
input clk_i,
input inc,
input dec,
output [7:0] Q,
output neg_o,
output won_o,
output lost_o
    );
    wire [7:0] c_u;
    wire [7:0] c_d;
    wire cout_O;
    wire coo;
Add8 countup (.A_i(Q), .B_i(8'b00000001), .cin_i(1'b0), .S_o(c_u), .cout_o(cout_O));
Add8 countdown (.A_i(Q), .B_i(8'b11111111), .cin_i(1'b0), .S_o(c_d), .cout_o(coo));
//wire min = &(Q ~^'b1100);
//wire max = &(Q ~^ 4'b0100);
    wire sel_up   = inc & ~dec;
    wire sel_down = dec & ~inc;
    wire sel_none = ~(sel_up | sel_down);
    //mux between different states
wire [7:0] D = ({8{sel_up}} & c_u) |({8{sel_down}} & c_d)
|({8{sel_none}} & Q);
  
    FDRE #(.INIT(1'b0)) Q0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) Q2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) Q3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[3]), .Q(Q[3]));
    FDRE #(.INIT(1'b0)) Q4 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[4]), .Q(Q[4]));
    FDRE #(.INIT(1'b0)) Q5 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[5]), .Q(Q[5]));
    FDRE #(.INIT(1'b0)) Q6 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[6]), .Q(Q[6]));
    FDRE #(.INIT(1'b0)) Q7 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D[7]), .Q(Q[7]));
    assign neg_o = Q[7]; 
//    assign won_o = max;
//    assign lost_o = min;
endmodule
    