title_menu:
	lda control_pad					; Up button check/routine
	eor control_old
	and control_pad
	and #up_punch
	beq @no_up
		lda $200+0
		cmp #$47
		beq :+
			sec
			sbc #$10
			sta $200+0
			sta $204+0
			dec cursor_position
:		jmp @done_controls
@no_up:
	lda control_pad					; Down button check/routine
	eor control_old
	and control_pad
	and #down_punch
	beq @no_down
		lda $200+0
		cmp #$87
		beq :+
			clc
			adc #$10
			sta $200+0
			sta $204+0
			inc cursor_position
:		jmp @done_controls
@no_down:
	lda control_pad					; Up button check/routine
	eor control_old
	and control_pad
	and #left_punch
	beq @no_left
		lda #$98
		sta $23c+0
		sta $240+0
		lda #$00
		sta cursor2_position
		lda #$01
		sta number_of_players
		jmp @done_controls
@no_left:
	lda control_pad					; Down button check/routine
	eor control_old
	and control_pad
	and #right_punch
	beq @no_right
		lda #$a8
		sta $23c+0
		sta $240+0
		lda #$01
		sta cursor2_position
		lda #$02
		sta number_of_players
		jmp @done_controls
@no_right:
	lda control_pad					; A button check/routine
	eor control_old
	and control_pad
	and #a_punch
	beq @done_controls
		lda $200+0
		cmp #$87
		beq @done_controls
			cmp #$77
			bne :+
			lda #$6f
			sta $200+0
			sta $204+0
			lda #$98
			sta $200+3
			lda #$a0
			sta $204+3
			lda #<juke_control
			sta loop_pointer+0
			lda #>juke_control
			sta loop_pointer+1
			lda #<bgm_nmi
			sta nmi_pointer+0
			lda #>bgm_nmi
			sta nmi_pointer+1
			rts
				
:			lda cursor_position
			sta prior_cursor_pos
			ldx #$05
			stx cursor_position
			ldx #$00
			lda #$f0
:			sta $200+0, x
			dex
			dex
			dex
			dex
			bne :-
			lda #$01
			jsr music_loadsong
			lda #<loop_screen_load
			sta loop_pointer+0
			lda #>loop_screen_load
			sta loop_pointer+1
@done_controls:

		ldx cursor_position
		lda game_pics_a, x
		sta screen_pointer+0
		lda game_pics_b, x
		sta screen_pointer+1
	rts


title_nmi:
	ldy #$00
	ldx #$00
:	lda #$21
	sta $2006
	lda title_offset_lo, x
	sta $2006
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	lda (screen_pointer), y
	sta $2007
	iny
	inx
	cpx #$08
	bne :-
	lda #$23
	sta $2006
	lda #$d5
	sta $2006
	lda (screen_pointer), y
	sta $2007
	sta $2007
	lda #$23
	sta $2006
	lda #$dd
	sta $2006
	lda (screen_pointer), y
	sta $2007
	sta $2007
	lda cursor_position
	cmp #$03
	bne :+
		lda #$21
		sta $2006
		lda #$d6
		sta $2006
		lda song_added
		sta $2007
:
	jmp finish_nmi
title_offset_lo:
	.byte $14,$34,$54,$74,$94,$b4,$d4,$f4

ppu_2000_offset:
	.byte %10000000, %10011000, %10011000
attribs_lo:
	.byte <ttt_attribs, <pegs_attribs1, <clik_attribs, <juke_lo, <credits_lo
attribs_hi:
	.byte >ttt_attribs, >pegs_attribs1, >clik_attribs, >juke_hi, >credits_hi
game_buffer_lo:
	.byte <ttt_board_0, <pegs_board_1, <clik_board_0, <juke_lo, <credits_lo, <blank_table1
game_buffer_hi:
	.byte >ttt_board_0, >pegs_board_1, >clik_board_0, >juke_hi, >credits_hi, >blank_table2

juke_lo:

juke_hi:

credits_lo:

credits_hi:



get_number_of_players:
	lda cursor_position
	cmp #$01
	bne :+
		lda #$01
		sta number_of_players
		rts
:	lda #$02
	sta number_of_players
	rts

players_1:
	.byte "1",$00,"PLAYER"
players_2:
	.byte "2",$00,"PLAYERS"

game_pics_a:
	.byte <ttt_table1,<peg_table1,<clik_table1,<juke_table1,<credit_table1,<blank_table1
game_pics_b:
	.byte >ttt_table1,>peg_table1,>clik_table1,>juke_table1,>credit_table1,>blank_table1
game_pics_c:
	.byte <ttt_table2,<peg_table2,<clik_table2,<juke_table2,<credit_table2,<blank_table2
game_pics_d:
	.byte >ttt_table2,>peg_table2,>clik_table2,>juke_table2,>credit_table2,>blank_table2

ttt_table1:
	.byte $00,$00,$27,$00,$00,$27,$96,$97
	.byte $00,$00,$2c,$00,$00,$2c,$98,$99
	.byte $2a,$2b,$2d,$2b,$2b,$2d,$2b,$28
	.byte $9a,$9b,$2c,$9a,$9b,$2c,$00,$00
ttt_table2:
	.byte $9c,$9d,$2c,$9c,$9d,$2c,$00,$00
	.byte $2a,$2b,$2d,$2b,$2b,$2d,$2b,$28
	.byte $00,$00,$2c,$00,$00,$2c,$96,$97
	.byte $00,$00,$29,$00,$00,$29,$98,$99
	.byte $55
peg_table1:
	.byte $00,$00,$00,$60,$61,$00,$00,$00
	.byte $00,$00,$62,$63,$64,$65,$00,$00
	.byte $00,$00,$66,$67,$68,$69,$00,$00
	.byte $00,$6a,$6b,$6c,$6d,$6e,$6f,$00
peg_table2:
	.byte $70,$71,$72,$73,$74,$75,$76,$77
	.byte $78,$79,$7a,$7b,$7c,$7d,$7e,$7f
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $ff
clik_table1:
	.byte $00,$80,$81,$81,$81,$81,$82,$00
	.byte $00,$83,$84,$85,$84,$85,$86,$00
	.byte $00,$83,$87,$87,$87,$87,$86,$00
	.byte $00,$83,$88,$89,$8a,$8b,$86,$00
clik_table2:
	.byte $00,$8c,$8d,$8e,$8d,$8e,$8f,$00
	.byte $00,$00,$90,$91,$92,$93,$00,$00
	.byte $00,$00,$00,$94,$95,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $aa
juke_table1:
	.byte $00,$b4,$00,$b4,$00,$b4,$00,$b4
	.byte $00,$b4,$00,$b4,$00,$b4,$00,$b4
	.byte $00,$b4,$00,$b4,$00,$b4,$00,$b4
	.byte $00,$b4,$00,$b4,$00,$b4,$00,$b4
juke_table2:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$30,$00,$3a,$00,$35,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $ff
credit_table1:
	.byte $ae,$45,$4e,$47,$49,$4e,$45,$ad
	.byte $44,$52,$41,$47,$4e,$53,$46,$31
	.byte $4c,$4f,$47,$4f,$ad,$00,$00,$00
	.byte $53,$48,$41,$57,$4e,$00,$43,$50
credit_table2:
	.byte $50,$52,$4f,$47,$52,$41,$4d,$ad
	.byte $52,$5b,$42,$52,$59,$41,$4e,$54
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $aa,$aa,$aa,$ab,$ab,$ab,$aa,$00
	.byte $ff
blank_table1:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
blank_table2:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $ff

animate_gamename_palette:						; Here is the animating palette code for the title screen.
	dec gamename_ticker							; This controls the letters in the title of the game
	bne :++										; and also the bouncing cursor. The LUTs for this code
		lda #$0a								; are located right below the subroutine.
		sta gamename_ticker						;
		ldx pal_increment								;
		cpx #$0b								;
		bne :+									;
			ldx #$00							;
			stx pal_increment							;
			jmp @next							;
:		inx										;
		stx pal_increment								;
		jmp @next								;
:	ldx pal_increment									;
	lda gamename_colors_for_animation1, x		;
	sta pal_address+2							;
	lda gamename_colors_for_animation2, x		;
	sta pal_address+1							;
	lda cursor_colors_for_flashing1, x			;
	sta pal_address+18							;
	lda cursor_colors_for_flashing2, x			;
	sta pal_address+17							;
	lda tooth_anim1, x							;
	sta pal_address+21							;
	lda tooth_anim2, x							;
	sta pal_address+22							;
	lda tooth_anim3, x							;
	sta pal_address+23							;
@next:											;
	rts											;

gamename_colors_for_animation1:
	.byte $0c, $1c, $2c, $3c, $2c, $1c, $0c, $1c, $2c, $3c, $2c, $1c	; Blue color in title going from darker to lighter blues
gamename_colors_for_animation2:
	.byte $30, $20, $10, $00, $10, $20, $30, $20, $10, $00, $10, $20	; Outline in title going from whites to grays
cursor_colors_for_flashing1:
	.byte $0f, $27, $0f, $27, $0f, $27, $0f, $27, $0f, $27, $0f, $27	; cursor palette animation to make the appearance of bouncing
cursor_colors_for_flashing2:			;
	.byte $27, $0f, $27, $0f, $27, $0f, $27, $0f, $27, $0f, $27, $0f	;
tooth_anim1:
	.byte $30, $30, $30, $30, $30, $30, $30, $30, $30, $38, $38, $38
tooth_anim2:
	.byte $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $38, $38
tooth_anim3:
	.byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $38


; Used to load "1 PLAYER" and "2 PLAYERS" on the title screen
;  after a game selection is made.
players_load:
	lda #$22
	sta $2006
	lda #$6a
	sta $2006
	ldx #$00
:	lda players_1, x
	sta $2007
	inx
	cpx #$08
	bne :-
	lda #$22
	sta $2006
	lda #$aa
	sta $2006
	ldx #$00
:	lda players_2, x
	sta $2007
	inx
	cpx #$09
	bne :-
	rts

; Used to erase "1 PLAYER" and "2 PLAYERS" from the title
;  screen if button 'B' is pressed.
players_erase:
	lda #$22
	sta $2006
	lda #$6a
	sta $2006
	ldx #$00
	txa
:	sta $2007
	inx
	cpx #$08
	bne :-
	lda #$22
	sta $2006
	lda #$aa
	sta $2006
	ldx #$00
	txa
:	sta $2007
	inx
	cpx #$09
	bne :-
	rts
	



code_check:
	.byte up_punch, up_punch, down_punch, down_punch
	.byte left_punch, right_punch, left_punch, right_punch
	.byte up_punch, up_punch

test_secret_controller_code:
	ldx code_offset
	lda control_pad
	eor control_old
	and control_pad
	and code_check, x
	beq :+
		lda #$10
		sta code_count
		lda code_offset
		clc
		adc #$01
		sta code_offset
		cmp #$0a
		bne :+
			lda #$01
			sta p1_set	;success
			rts
:	lda code_count
	beq :+
		sec
		sbc #$01
		sta code_count
		rts
:	lda #$00
	sta code_offset
	rts



code_check2:
	.byte down_punch, down_punch, down_punch, right_punch
	.byte right_punch, right_punch, down_punch

test_secret_controller_code2:
	ldx code2_offset
	lda control_pad
	eor control_old
	and control_pad
	and code_check2, x
	beq :+
		lda #$10
		sta code2_count
		lda code2_offset
		clc
		adc #$01
		sta code2_offset
		cmp #$07
		bne :+
			lda #$01
			sta pong_set	;success
			rts
:	lda code2_count
	beq :+
		sec
		sbc #$01
		sta code2_count
		rts
:	lda #$00
	sta code2_offset
	rts



black_it_out:
	ldx #$00
	lda #$0f
:	sta pal_address, x
	inx
	cpx #$20
	bne :-
	ldx #$00
	lda #$f0
:	sta $200+0, x
	dex
	bne :-
	lda #$01
	jsr music_loadsong
	lda #$3c
	sta one_second
	lda #$05
	sta big_seconds
	lda #<blank_nmi
	sta nmi_pointer
	lda #>blank_nmi
	sta nmi_pointer+1
	rts
black_it:
	ldx #$00
	lda #$0f
:	sta pal_address, x
	inx
	cpx #$20
	bne :-
	ldx #$00
	lda #$f0
:	sta $200+0, x
	dex
	bne :-
	rts
snail_wait_loop:
	lda one_second
	sec
	sbc #$01
	sta one_second
	beq :+
		jmp finito
:		lda #$3c
		sta one_second
		lda big_seconds
		sec
		sbc #$01
		sta big_seconds
		beq :+
			jmp finito
:
snail_start:
			jsr PPU_off
			ldx #$00
			lda #$00
			sta snail_winner
:			sta $400, x
			sta $500, x
			sta $600, x
			sta $700, x
			inx
			bne :-
			ldy #$00						; Load the title screen
			ldx #$04						;
			lda #<snail_nt					;
			sta screen_pointer				;
			lda #>snail_nt					;
			sta screen_pointer+1			;
			lda #$20						;
			sta $2006						;
			lda #$00						;
			sta $2006						;
:			lda (screen_pointer),y			;
			sta $2007						;
			iny								;
			bne :-							;
			inc screen_pointer+1			;
			dex								;
			bne :-							;
			ldx #$00						; Pull in bytes for sprites and their
:			lda snail_sprites, x			; attributes which are stored in the
			sta left_cursor, x				; 'the_sprites' table. Use X as an index
			inx								; to load and store each byte, which
			cpx #28							; get stored starting in $200, where
			bne :-							; 'left_cursor' is located at.
			lda #$12
			sta pal_address+1
			sta pal_address+19
			lda #$23
			sta pal_address+17
			lda #$26
			sta pal_address+21
			lda #$16
			sta pal_address+2
			sta pal_address+23
			lda #$27
			sta pal_address+3
			lda #$37
			sta pal_address+18
			sta pal_address+22
			ldx #$00
			lda #$01
:			sta $420, x
			sta $520, x
			sta $6b0, x
			sta $7b0, x
			inx
			cpx #$10
			bne :-
			ldx #$00
:			lda #$01
			sta $402, x
			sta $50d, x
			sta $602, x
			sta $70d, x
			txa
			clc
			adc #$10
			tax
			cpx #$00
			bne :-
			lda #$0f
			sta temp
			sta temp2
			lda #$04
			sta e_state+0
			sta e_state+1
			lda #$03
			sta e_state+2
			sta e_state+3
			lda #6
			sta p1_left
			lda #25
			sta p2_left
			lda #14
			sta p1_top
			sta p2_top

			jsr PPU_other_chr_with_sprites
	lda #$07
	jsr music_loadsong
			jmp snail_loop
finito:
	jsr nmi_wait
	jmp snail_wait_loop
