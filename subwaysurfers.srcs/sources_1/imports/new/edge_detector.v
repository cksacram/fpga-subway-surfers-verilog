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


module edge_detector(
input clk_i,
input button_o,
output edge_o
    );
wire btn_sync1, btn_sync2;
FDRE #(.INIT(1'b0)) s0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(button_o),  .Q(btn_sync1));
FDRE #(.INIT(1'b0)) s1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(btn_sync1), .Q(btn_sync2));

wire btn_prev;
FDRE #(.INIT(1'b0)) d0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(btn_sync2), .Q(btn_prev));

assign edge_o = btn_sync2 & ~btn_prev;
endmodule