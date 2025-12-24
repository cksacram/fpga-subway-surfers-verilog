`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 07:42:06 PM
// Design Name: 
// Module Name: top_lab5
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
module top_lab5(
    input clkin,
    input btnR,
    input btnC,
    input btnL,
    input btnD,
    input btnU,
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output Hsync,
    output Vsync,
    output dp
    );
    wire clk;
labVGA_clks not_so_slow(
.clkin(clkin),
.greset(btnD),
.clk(clk),
.digsel(digsel));
wire collision;
wire [15:0] hCount;
wire [15:0] vCount;
wire active_region;
pixeladdress px_top(.clk_i(clk), .hCount(hCount), .active_region(active_region), .vCount(vCount), .Hsync(Hsync), .Vsync(Vsync));
wire gobtnL;
edge_detector e_top(.clk_i(clk), .button_o(btnL), .edge_o(gobtnL));
wire gobtnR;
edge_detector e_top2(.clk_i(clk), .button_o(btnR), .edge_o(gobtnR));
wire btnU2;
edge_detector e_top4(.clk_i(clk), .button_o(btnU), .edge_o(btnU2));
//maybe don't need
wire player_center;
wire goleft = gobtnL & player_center & ~collision;
wire goright = gobtnR & player_center & ~collision;
//solid color test
 wire energy_empty_flag;
wire [1:0] lane;
wire gobtnU = btnU & player_center & ~energy_empty_flag;
wire hovering;
wire gobtnC;
edge_detector e_top3(.clk_i(clk), .button_o(btnC), .edge_o(gobtnC));
player_Fsm p_fsm_top(.clk_i(clk), .left(goleft), .right(goright), .hover(gobtnU & ~collision), .hover_on(hovering), .lane(lane), .Go(gobtnC));
wire frame_now = (hCount == 16'd799) & (vCount == 16'd524);
//may need to add
//wire q0;
//wire q1;
FDRE #(.INIT(1'b0)) ff0 (.C(clk), .R(1'b0),.CE(1'b1) ,.D(frame_now),.Q(q0));
FDRE #(.INIT(1'b0)) ff1 (.C(clk), .R(1'b0), .CE(1'b1), .D(q0), .Q(q1));

// frame is 1 for one clock when frame_now rises
assign frame_clocked = q0 & ~q1;
wire game_start = gobtnC;
wire [15:0] frame_count;
wire [15:0] frame_count_next;
wire game_running_q;
wire game_running_d = (game_running_q | game_start) & ~btnD;

FDRE #(.INIT(1'b0)) game_run_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(game_running_d), .Q (game_running_q));
//frame counter only runs while game_running_q
assign frame_count_next =~game_running_q ? 16'd0 : (frame_clocked ? frame_count + 16'd1 : frame_count);

flipflop frame_counter (.clk_i(clk), .CE(1'b1), .D(frame_count_next),.Q(frame_count));
wire [15:0] twos_flag  = 16'd120;  // tweak if needed
wire [15:0] eights_flag  = 16'd480;  // 2s + 6s
wire track_open_left = game_running_q;
wire track_open_right = game_running_q & (frame_count == twos_flag);
wire track_open_mid = game_running_q & (frame_count == eights_flag);
wire score_pulse;

solid_color solidcolor_top(
    .clk_i(clk),
    .active_lo(active_region),
    .hCount(hCount),
    .vCount(vCount),
    .frame_clocked(frame_clocked),
    .lane(lane),
    .R(vgaRed),
    .G(vgaGreen),
    .B(vgaBlue),
    .player_center(player_center),
    .hover_on(hovering),
    .energy_empty_flag(energy_empty_flag),
    .btnU(btnU),
    .start_left_trains(track_open_left),
    .start_middle_trains(track_open_mid),
    .start_right_trains(track_open_right),
    .collision(collision),
    .score_pulse(score_pulse),
    .god_mode(sw[3])
);
wire [7:0] score;
turkeyCounter scorecount(.clk_i(clk), .inc(score_pulse), .Q(score));
wire [3:0] ring;
ring_counter ring_top(
    .clk_i(clk),
    .advance_i(digsel), 
    .ring_o(ring)
);

assign an = ~ring;
wire [15:0] disp = {4'b0000, 4'b0000, score[7:4], score[3:0]};
wire [3:0] sel;  
selector sel_top (
    .Sel_i(ring),   
    .N_i (disp),   
    .H_o (sel)   
);
wire [6:0] seg_1;
hex7seg hex_top (
    .N_i (sel),
    .Seg_o(seg_1)
);

wire an0 = ring[0];  // an0
wire an1 = ring[1];  // an1
wire an2 = ring[2];  // an2
wire an3 = ring[3];  // an3
wire blank_an2 = an2;
wire blank_an3 = an3;
// all segments off = blank
wire [6:0] blank_seg = 7'b1111111;
wire show = blank_an2 | blank_an3;
assign seg = ({7{blank_an2}} & blank_seg) | 
({7{blank_an3}} & blank_seg) |({7{~show}} & seg_1);
//assign led[15] = hovering;
//assign led[14] = btnU;
//assign led[13] = energy_empty_flag;
assign led[3] = sw[3];
assign dp  = 1'b1;
endmodule
