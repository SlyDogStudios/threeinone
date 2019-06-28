; x00
nmi_num:	 		.res 1
control_pad:		.res 1
control_old:		.res 1
control_pad2:		.res 1
control_old2:		.res 1
no_control:			.res 1
no_control2:		.res 1
nmi_pointer:		.res 2
screen_pointer:		.res 2
game_pic_addy_hi:	.res 1	; x0b
game_pic_addy_lo:	.res 1	; x0c
game_pic_pointer:	.res 2	; x0d 0e
game_pic_pointer2:	.res 2	; x0f 10
; x11
attribs_pointer:	.res 2
pic_offset:			.res 1
cursor2_position:	.res 1
cursor_position:	.res 1
prior_cursor_pos:	.res 1
menu_pointer:		.res 2
gamename_ticker:	.res 1
temp:				.res 1	; x1a
switch_menu_item:	.res 1
temp2:				.res 1	; x1c
players_select:		.res 1
number_of_players:	.res 1
unpack_count:		.res 1
; x20
metatile_index:		.res 1
switch_controls:	.res 1
lo_ppu_addy:		.res 1
hi_ppu_addy:		.res 1
game_select:		.res 1
scroll_x:			.res 1
scroll_y:			.res 1
scroll_it:			.res 1
switch_to_attributes:	.res 1
start_game:			.res 1
start_gameplay:		.res 1
make_move:			.res 1	; x2b
which_player:		.res 1	; x2c
reg2000_save:		.res 1
reg2001_save:		.res 1
code_count:			.res 1
code_offset:		.res 1
; x30
one_second:			.res 1
big_seconds:		.res 1
; DO NOT ADD ANY OTHER RESERVE BYTES BEFORE THIS COMMENT. TIC TAC TOE
;  RELIES ON SUBTRACTING 30 TO GET A PROPER OFFSET FOR... STUFF
;ttt
top_left:			.res 1	; x33
top_middle:			.res 1
top_right:			.res 1
mid_left:			.res 1
mid_middle:			.res 1
mid_right:			.res 1
bot_left:			.res 1
bot_middle:			.res 1
bot_right:			.res 1
test_pointer:		.res 2
cursor_offset:		.res 1
test_byte:			.res 1
ttt_winner:			.res 1	; x40
cpu_pointer:		.res 2
cpu_pointer_offset:	.res 1
cpu_test_bytes:		.res 3
; x40
set_cpu:			.res 1
p1_strike_count:	.res 1
p2_strike_count:	.res 1
clearing_ttt:		.res 1
clear_board_offset:	.res 1 ; x4b
ttt_print_winner:	.res 1
ttt_win_offset:		.res 1

;CLIK
p1_left:			.res 1	; x4e
p1_right:			.res 1
p1_top:				.res 1	; x50
p1_bottom:			.res 1
p2_left:			.res 1
p2_right:			.res 1
p2_top:				.res 1
p2_bottom:			.res 1
e_hit_left:			.res 4	; x56 57 58 59
e_hit_right:		.res 4	; x5a 5b 5c 5d
e_hit_top:			.res 4
e_hit_bottom:		.res 4
e_state:			.res 4
e_speed:			.res 4
spark_left:			.res 1
spark_right:		.res 1
spark_top:			.res 1
spark_bottom:		.res 1
p1_spark_result:	.res 1
p2_spark_result:	.res 1
p1_coll_result:		.res 1
p2_coll_result:		.res 1
players_result:		.res 1
spark_count:		.res 1		; used for enemy speed offset
spark_counter:		.res 1		; how many have been picked up
p1_pickup:			.res 1
p2_pickup:			.res 1
spark_state:		.res 1
rand_num:			.res 1
e_anim_count:		.res 1
beat_game:			.res 1
game_over:			.res 1

;pegboard
p1_peg01:			.res 1
p1_peg02:			.res 1
p1_peg03:			.res 1
p1_peg04:			.res 1
p1_peg05:			.res 1
p1_peg06:			.res 1
p1_peg07:			.res 1
p1_peg08:			.res 1
p1_peg09:			.res 1
p1_peg10:			.res 1
p1_peg11:			.res 1
p1_peg12:			.res 1
p1_peg13:			.res 1
p1_peg14:			.res 1
p1_peg15:			.res 1

p2_peg01:			.res 1
p2_peg02:			.res 1
p2_peg03:			.res 1
p2_peg04:			.res 1
p2_peg05:			.res 1
p2_peg06:			.res 1
p2_peg07:			.res 1
p2_peg08:			.res 1
p2_peg09:			.res 1
p2_peg10:			.res 1
p2_peg11:			.res 1
p2_peg12:			.res 1
p2_peg13:			.res 1
p2_peg14:			.res 1
p2_peg15:			.res 1

p1_cursor_pos:		.res 1
p2_cursor_pos:		.res 1
p1_prior_cursor:	.res 1
p2_prior_cursor:	.res 1
p1_set:				.res 1
p2_set:				.res 1
p1_locked:			.res 1
p2_locked:			.res 1
p1_held_offset:		.res 1
p2_held_offset:		.res 1
p1_held_address:	.res 2
p2_held_address:	.res 2
p1_jump_address:	.res 2
p2_jump_address:	.res 2
p1_make_move:		.res 1
p2_make_move:		.res 1
snail_winner:		.res 1

that_win_test:		.res 1
song_offset:		.res 1

secret_code_yes:	.res 1

pal_increment:		.res 1
ttt_cursor_match:	.res 1
cursor_wait:		.res 1
loop_pointer:		.res 2
temp_8bit_0:		.res 1
temp_8bit_1:		.res 1
temp_8bit_2:		.res 1
temp_8bit_3:		.res 1


addy_lo:		.res 1
addy_hi:		.res 1

pal_address:		.res 32
