`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 06:06:14 PM
// Design Name: 
// Module Name: pixeladdress
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


module pixeladdress(
input clk_i,
output [15:0] hCount,
output [15:0] vCount,
output active_region,
output Hsync,
output Vsync
    );
wire hWrap  = (hCount == 16'd799);
countUD16L h (.clk_i(clk_i), .up_i(~hWrap), .dw_i(1'b0), .ld_i(hWrap), .Din_i(16'd0), .Q_o(hCount));
wire vMax = (vCount == 16'd524);
wire vEnd  = hWrap & vMax;
wire vWrap = hWrap & ~vMax;
countUD16L v (.clk_i(clk_i), .up_i(vWrap), .dw_i(1'b0), .ld_i(vEnd), .Din_i(16'b0), .Q_o(vCount));
assign active_region = (hCount >= 16'd640) | (vCount >= 16'd480); // may need change
assign Hsync = (hCount < 16'd655) | (hCount > 16'd750); // may need change
assign Vsync = (vCount < 16'd489) | (vCount > 16'd490); // may need change
endmodule
