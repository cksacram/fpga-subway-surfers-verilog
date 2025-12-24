`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 11:03:17 PM
// Design Name: 
// Module Name: solid_color
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
module solid_color(
  input clk_i,
  input active_lo,       
  output [3:0] R, G, B,
  input frame_clocked,
  input [1:0] lane,   
  input [15:0] hCount,
  input [15:0] vCount,
  output player_center,
  input hover_on,
  input btnU,
  output energy_empty_flag,
  input start_left_trains,
  input start_middle_trains,
  input start_right_trains,
  output collision,
  output score_pulse,
  input god_mode
);
   //border constants are 8 pixels wide 
wire [15:0] border_width = 16'd8;
wire [15:0] energy_width = 16'd20;
wire [15:0] energy_length = 16'd192;
wire [15:0] track_width = 16'd60;
wire [15:0] track_length = 16'd464; // for now not actual length since controlled by length
wire [15:0] gap = 16'd10;
//wire [11:0] track_color = 12'h00F; // blue tracks
wire [11:0] train_color = 12'h00F;
wire [11:0] track_color = 12'h000; //black tracks
//wire [15:0] train_width = 16'd60;
wire [15:0] train_length = 16'd92;
wire [15:0] player_width = 16'd16;
wire [15:0] player_length = 16'd16;
wire [11:0] border_color = 12'hFFF;
wire [11:0] energy_level_color = 12'h0F0;
wire [11:0] player_level_color = 12'hFF0;
wire [11:0] hover_color = 12'hF0F; 
wire hover_phase;

wire hover_tick = frame_clocked & hover_on;
// 4 bit counter to control for flashing for hover
wire [3:0] hover_count;
wire [3:0] hover_count_next;
//next value for counter
assign hover_count_next =
 ~hover_on ? 4'd0 : (hover_tick ? (hover_count == 4'd15 ? 4'd0 : hover_count + 4'd1) : hover_count);
FDRE (.C(clk_i), .R(1'b0), .CE(1'b1), .D(hover_count_next[0]), .Q(hover_count[0]));
FDRE (.C(clk_i), .R(1'b0), .CE(1'b1), .D(hover_count_next[1]), .Q(hover_count[1]));
FDRE (.C(clk_i), .R(1'b0), .CE(1'b1), .D(hover_count_next[2]), .Q(hover_count[2]));
FDRE (.C(clk_i), .R(1'b0), .CE(1'b1), .D(hover_count_next[3]), .Q(hover_count[3]));
//toggle phase when counter hits 2 on a hover_tick
wire hover_toggle = hover_tick & (hover_count == 4'd15);
wire hover_phase_next =
~hover_on ? 1'b0 : hover_toggle ? ~hover_phase : hover_phase;
FDRE #(.INIT(1'b0)) hover_ff (.C (clk_i), .R (1'b0), .CE(1'b1), .D (hover_phase_next), .Q (hover_phase));
wire [11:0] player_color = hover_on ? hover_color : player_level_color;
  
  // solid red screen
wire [11:0] C = 12'h000;    //black
wire active_hi = ~active_lo;
//border
wire [15:0] x_right = 16'd640 - border_width;
wire [15:0] y_bottom = 16'd480 - border_width;
wire border_on = active_hi && ((hCount < border_width) || (hCount >= x_right) || 
(vCount < border_width) || (vCount >= y_bottom));
wire train0_on;
wire train01_on;
wire train1_on;
wire train11_on;
wire train2_on;
wire train21_on;
wire any_train = train0_on | train01_on | train1_on | train11_on | train2_on | train21_on;
wire player_on;
wire collision_touched = ~god_mode & ~hover_on & player_on & any_train;
wire collision_q;
//energy
wire [15:0] e_x0 = border_width;                  // 8
wire [15:0] e_x1 = e_x0 + energy_width;            // 28
wire [15:0] e_y0 = border_width;                  // 8
wire [15:0] e_y1 = e_y0 + energy_length;           // 200
//energyv2 so it doesn't hug the border
wire [15:0] e_x00 = border_width + 16'd10;                  // 8
wire [15:0] e_x11 = e_x00 + energy_width;            // 28
wire [15:0] e_y00 = border_width + 16'd10;                  // 8
wire [15:0] e_y11 = e_y00 + energy_length;  
//test for energy pretend half bar
wire [15:0] cx1 = 16'd424;
wire [15:0] energy_top; 
wire energy_start = (energy_top == 16'd0);
wire [15:0] energy_top_next;
wire energy_empty = (energy_top == e_y11);
wire energy_full = (energy_top == e_y00);
//wire hover_active = ~energy_empty & hover_on;
wire inc_energy = frame_clocked & ~hover_on & ~energy_full & ~btnU; //~hover_on & ~energy_full &~btnU
wire dec_energy = frame_clocked & & hover_on & ~energy_empty;
wire [15:0] energy_top_inc1 = energy_top - 16'd1;
wire [15:0] energy_top_dec1 = energy_top + 16'd1; 
assign energy_empty_flag = energy_empty;
assign energy_top_next =
energy_start ? e_y00 : // start full
collision_q ? energy_top : //test
dec_energy  ? energy_top_dec1 :
inc_energy  ? energy_top_inc1 : energy_top;
flipflop energy_reg ( .clk_i(clk_i), .CE(1'b1), .D(energy_top_next), .Q(energy_top));
wire energy_on = active_hi &&
(hCount >= e_x00) && (hCount < e_x11) && (vCount >= energy_top) && (vCount < e_y11);
//traintracks 2/3 of right side screen = {216, 632)
wire [15:0] center = 16'd108;
wire [15:0] t_x0 = border_width + 16'd208 + center; //324
wire [15:0] t_x1 = x_right; // 632
wire [15:0] t_track0 = t_x0 + track_width; // 384
wire [15:0] t_t1 = t_track0 + gap; //394
wire [15:0] t_track1 = t_t1 + track_width; //454
wire [15:0] t_t2 = t_track1 + gap; // 464
wire [15:0] t_track2 = t_t2 + track_width; //524
wire track_on0 = active_hi &&
(hCount >= t_x0) && (hCount < t_track0) && (vCount >= e_y0) && (vCount < y_bottom);
wire track_on1 = active_hi &&
(hCount >= t_t1) && (hCount < t_track1) && (vCount >= e_y0) && (vCount < y_bottom);
wire track_on2 = active_hi &&
(hCount >= t_t2) && (hCount < t_track2) && (vCount >= e_y0) && (vCount < y_bottom);
wire track_on = track_on0 | track_on1 | track_on2;

//lanes NEED CHANGE
wire [15:0] cx0 = 16'd354; // left  center
//wire [15:0] cx1 = 16'd424; // mid   center, moved up to assign wire for use later
wire [15:0] cx2 = 16'd494; // right center
wire [15:0] lanes_cx = (lane==2) ? cx2 : ((lane==1) ? cx1 : cx0);

wire collision_d = collision_q | collision_touched;
wire [15:0] ply_w = 16'd16, ply_h = 16'd16;
wire [15:0] ply_cy = 16'd352;                // pick a Y cent
wire [15:0] player_transition;
wire [15:0] player_trans_inc2  = player_transition + 16'd2;
wire [15:0] player_trans_dec2 = player_transition - 16'd2;
wire move_right = (player_transition < (lanes_cx - 16'd2));
wire move_left  = (player_transition > (lanes_cx + 16'd2));
//maybe delte these 2 lines later 
assign player_center = ~move_left & ~move_right;
wire [15:0] player_next =
(player_transition == 16'd0) ? lanes_cx :
collision_q  ? player_transition :
(move_right ? player_trans_inc2 :
(move_left  ? player_trans_dec2 : lanes_cx));
// flip flop for the transition
flipflop play_trans_flop(.clk_i(clk_i), .CE(frame_clocked), .D(player_next), .Q(player_transition));
wire [15:0] px0 = player_transition - 16'd8;
wire [15:0] px1 = player_transition + 16'd8;
wire [15:0] py0 = ply_cy - 16'd8;
wire [15:0] py1 = ply_cy + 16'd8;
assign player_on = (~active_lo) &&
(hCount >= px0) && (hCount < px1) && (vCount >= py0) && (vCount < py1);

    //train0 left track
wire [15:0] left_start_train = 16'd400;
wire train0_started;
wire [15:0] train0_top;
wire [15:0] train0_bottom;
wire train0_running;
wire train01_running;
wire [15:0] train01_top;
wire [15:0] train01_bottom;
 wire train0_started_next = start_left_trains |  (frame_clocked & train01_running & (train01_bottom == left_start_train));
fsmtrain left_train (.clk_i(clk_i), .frame_clocked(frame_clocked & ~collision_q), .start_i(train0_started_next & ~collision_q),  .train_top(train0_top), .train_bottom(train0_bottom), .running(train0_running));

// draw the train inside the left track band
wire [15:0] train0_draw_top = (train0_top < border_width) ? border_width : train0_top;
assign train0_on = active_hi &&
train0_running && // only when moving
(hCount >= t_x0) && (hCount < t_track0) &&
(vCount >= train0_draw_top) && (vCount < train0_bottom);
       //train 1 left track
wire train01_started;
wire train01_started_next = frame_clocked & train0_running & (train0_bottom == left_start_train);

fsmtrain left_train01 (.clk_i(clk_i), .frame_clocked(frame_clocked & ~collision_q), .start_i(train01_started_next & ~collision_q),  .train_top(train01_top), .train_bottom(train01_bottom), .running(train01_running));
wire [15:0] train01_draw_top = (train01_top < border_width) ? border_width : train01_top;
    
assign train01_on = active_hi &&
train01_running && // only when moving
(hCount >= t_x0) && (hCount < t_track0) &&
(vCount >= train01_draw_top) && (vCount < train01_bottom);
//middle
wire [15:0] middle_start_train = 16'd440;
wire train1_started;
wire [15:0] train1_top;
wire [15:0] train1_bottom;
wire train1_running;
wire train11_running;
wire [15:0] train11_top;
wire [15:0] train11_bottom;
wire train1_started_next = start_middle_trains |  (frame_clocked & train11_running & (train11_bottom == middle_start_train));
fsmtrain middle_train1 (.clk_i(clk_i), .frame_clocked(frame_clocked & ~collision_q), .start_i(train1_started_next & ~collision_q),  .train_top(train1_top), .train_bottom(train1_bottom), .running(train1_running));

// draw the train inside the left track band
wire [15:0] train1_draw_top = (train1_top < border_width) ? border_width : train1_top;
assign train1_on = active_hi &&
train1_running &&  // only when moving
(hCount >= t_t1) && (hCount < t_track1) &&
(vCount >= train1_draw_top) && (vCount < train1_bottom);
       //train 1 left track
wire train11_started;
wire train11_started_next = frame_clocked & train1_running & (train1_bottom == middle_start_train);


fsmtrain middle_train11 (.clk_i(clk_i), .frame_clocked(frame_clocked & ~collision_q), .start_i(train11_started_next & ~collision_q),  .train_top(train11_top), .train_bottom(train11_bottom), .running(train11_running));
wire [15:0] train11_draw_top = (train11_top < border_width) ? border_width : train11_top;

assign train11_on = active_hi &&
train11_running && // only when moving
(hCount >= t_t1) && (hCount < t_track1) &&
(vCount >= train11_draw_top) && (vCount < train11_bottom);
// right train
wire [15:0] right_start_train = 16'd400;
wire train2_started;
wire [15:0] train2_top;
wire [15:0] train2_bottom;
wire train2_running;
wire train21_running;
wire [15:0] train21_top;
wire [15:0] train21_bottom;
wire train2_started_next = start_right_trains |  (frame_clocked & train21_running & (train21_bottom == right_start_train));
fsmtrain right_train2 (.clk_i(clk_i), .frame_clocked(frame_clocked & ~collision_q), .start_i(train2_started_next & ~collision_q),  .train_top(train2_top), .train_bottom(train2_bottom), .running(train2_running));

// draw the train inside the left track band
wire [15:0] train2_draw_top = (train2_top < border_width) ? border_width : train2_top;
assign train2_on = active_hi &&
train2_running && // only when moving
(hCount >= t_t2) && (hCount < t_track2) &&
(vCount >= train2_draw_top) && (vCount < train2_bottom);
       //train 1 left track
wire train21_started;
wire train21_started_next = frame_clocked & train2_running & (train2_bottom == right_start_train);


fsmtrain right_train21 (.clk_i(clk_i), .frame_clocked(frame_clocked & ~collision_q), .start_i(train21_started_next & ~collision_q),  .train_top(train21_top), .train_bottom(train21_bottom), .running(train21_running));
wire [15:0] train21_draw_top = (train21_top < border_width) ? border_width : train21_top;

assign train21_on = active_hi &&
train21_running &&  // only when moving
(hCount >= t_t2) && (hCount < t_track2) &&
(vCount >= train21_draw_top) && (vCount < train21_bottom);
                 
FDRE #(.INIT(1'b0)) collision_ff (.C(clk_i), .R(btnD), .CE(1'b1), .D (collision_d), .Q (collision_q));
assign collision = collision_q;
wire collision_phase;
wire collision_tick = frame_clocked & collision_q;

wire [3:0] coll_count;
wire [3:0] coll_count_next;
assign coll_count_next =
~collision_q ? 4'd0 : // reset counter when no collision
(collision_tick ? (coll_count == 4'd15 ? 4'd0 : coll_count + 4'd1) : coll_count); // wrap after 4
// counter flip-flops
FDRE (.C(clk_i), .R(btnD), .CE(1'b1), .D(coll_count_next[0]), .Q(coll_count[0]));
FDRE (.C(clk_i), .R(btnD), .CE(1'b1), .D(coll_count_next[1]), .Q(coll_count[1]));
FDRE (.C(clk_i), .R(btnD), .CE(1'b1), .D(coll_count_next[2]), .Q(coll_count[2]));
FDRE (.C(clk_i), .R(btnD), .CE(1'b1), .D(coll_count_next[3]), .Q(coll_count[3]));
// toggle phase when counter hits 15 (for speed of flash) on a collision_tick
wire coll_toggle = collision_tick & (coll_count == 4'd15);
wire collision_phase_next =
~collision_q  ? 1'b0 : // when collision ends, reset phase
coll_toggle  ? ~collision_phase : // toggle every 3rd frame
collision_phase;
FDRE #(.INIT(1'b0)) collision_blink_ff (.C(clk_i), .R(btnD), .CE(1'b1), .D(collision_phase_next), .Q(collision_phase));

wire player_visible_normal = ~hover_on ? player_on : (~hover_phase) & player_on;
wire player_visible =
collision_q ? (collision_phase & player_on) :  // flash when collision
player_visible_normal;
                  
wire [11:0] rgb_in = border_on ? border_color :  // border on top
energy_on ? energy_level_color :
player_visible ? player_color :
train0_on  ? train_color :
train01_on  ? train_color :
train1_on ? train_color :
train11_on ? train_color :
train2_on  ? train_color :
train21_on ? train_color :
track_on   ? track_color :
C;
wire [15:0] score_row = py1; //+ 16'd1;
// left lane
wire train0_score_pulse  =
~collision_q   &&   // don't score after collision   // in left lane
train0_running &&   //only while a train moving
frame_clocked  &&
(train0_top == score_row);

wire train01_score_pulse =
~collision_q && // don't score after collision   // in left lane
train01_running && //only while a train moving
frame_clocked  &&
(train01_top == score_row);
// middle lane
wire train1_score_pulse =
~collision_q && // don't score after collision   // in left lane
train1_running && //only while a train moving
frame_clocked  &&
(train1_top == score_row);

wire train11_score_pulse =
~collision_q && // don't score after collision   // in left lane
train11_running && //only while a train moving
frame_clocked  &&
(train11_top == score_row);

wire train2_score_pulse =
~collision_q && // don't score after collision   // in left lane
train2_running && //only while a train moving
frame_clocked  &&
(train2_top == score_row);

wire train21_score_pulse =
~collision_q && // don't score after collision   // in left lane
train21_running && //only while a train moving
frame_clocked  &&
(train21_top == score_row);
assign score_pulse =
train0_score_pulse  | train01_score_pulse | train1_score_pulse  | train11_score_pulse | train2_score_pulse  | train21_score_pulse;
wire [11:0] rgb = active_hi ? rgb_in : 12'h000;
assign R = rgb[11:8];
assign G = rgb[7:4];
assign B = rgb[3:0];

endmodule
