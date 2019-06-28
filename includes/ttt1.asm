ttt_spr_stuffs:
	.byte $5d,$c4,$02,$78
	.byte $5d,$c5,$02,$80
	.byte $ff,$9e,$03,$0e	; p1_strike1
	.byte $ff,$9e,$03,$12	; p1_strike2
	.byte $ff,$9e,$03,$16	; p1_strike3
	.byte $ff,$9f,$03,$de	; p2_strike1
	.byte $ff,$9f,$03,$e2	; p2_strike2
	.byte $ff,$9f,$03,$e6	; p2_strike3
	.byte $f0,$50,$01,$e0
	.byte $f0,$55,$01,$e0
	.byte $f0,$53,$01,$e0
	.byte $f0,$48,$01,$e0
	.byte $f0,$53,$01,$e8
	.byte $f0,$54,$01,$e8
	.byte $f0,$41,$01,$e8
	.byte $f0,$52,$01,$e8
	.byte $f0,$54,$01,$e8
	.byte $f0,$c4,$00,$f0
	.byte $f0,$c4,$00,$f0
	.byte $f0,$c4,$00,$f0
	.byte $f0,$c5,$00,$f0
	.byte $f0,$c5,$00,$f0
	.byte $f0,$c5,$00,$f0
ttt_strikes:
	ldx #$00
	ldy #$00
@strike_show:
	lda p1_strike_count, x
	beq @increase
		cmp #$01
		bne :+
			lda #$1a
			sta p1_strike1+0, y
			jmp @increase
:		lda p1_strike_count, x
		cmp #$02
		bne :+
			iny
			iny
			iny
			iny
			lda #$1a
			sta p1_strike1+0, y
			jmp @increase
:	lda p1_strike_count, x
	cmp #$03
	bne @increase
	tya
	clc
	adc #$08
	tay
	lda #$1a
	sta p1_strike1+0, y
@increase:
	ldy #$0c
	inx
	cpx #$02
	bne @strike_show
	rts


ttt_setup:
	lda scroll_it
	beq @switch_loop
		lda scroll_y
		clc
		adc #$01
		sta scroll_y
		cmp #$ef
		bne @done_loop
			lda #$04
			sta cursor_position
			ldx #$00
:			lda ttt_spr_stuffs, x
			sta ttt_left_cursor, x
			inx
			cpx #92
			bne :-
			lda #$00
			sta scroll_it
			sta temp
			sta temp2
			lda #$00
			sta pal_address+1
			lda #$10
			sta pal_address+2
			sta pal_address+22
			lda #$30
			sta pal_address+3
			sta pal_address+23
			lda #$05
			jsr music_loadsong
			jmp end_loop
@switch_loop:
	lda #<ttt_play0
	sta loop_pointer+0
	lda #>ttt_play0
	sta loop_pointer+1
	lda #<ttt_nmi0
	sta nmi_pointer+0
	lda #>ttt_nmi0
	sta nmi_pointer+1
@done_loop:
	jmp end_loop
ttt_nada:
	jmp finish_nmi
ttt_nothing:
	jmp end_loop

ttt_cursor_y:
	.byte $1d, $1d, $1d, $5d, $5d, $5d, $9d, $9d, $9d
ttt_cursor_x:
	.byte $38, $78, $b8, $38, $78, $b8, $38, $78, $b8
ttt_addy_lo:
	.byte $a6, $ae, $b6, $a6, $ae, $b6, $a6, $ae, $b6
ttt_addy_hi:
	.byte $28, $28, $28, $29, $29, $29, $2a, $2a, $2a
ttt_player1:
	.byte "PLAYER",$00,"1"
ttt_player2:
	.byte "PLAYER",$00,"2"
ttt_cpu:
	.byte $00,$00,"CPU",$00,$00,$00

ttt_play0:
	lda p2_strike_count
	cmp #$03
	bne :++
		lda number_of_players
		cmp #$02
		bne :+
			lda #$06
			jsr music_loadsong
:		lda #$00
		sta temp_8bit_3
		lda #<ttt_win1_loop
		sta loop_pointer+0
		lda #>ttt_win1_loop
		sta loop_pointer+1
		lda #<ttt_win2_done
		sta nmi_pointer+0
		lda #>ttt_win2_done
		sta nmi_pointer+1
		jmp end_loop
:
	ldx #$00
:	lda top_left, x
	beq :+
		inx
		cpx #$09
		bne :-
			lda #$07
			jsr music_loadsfx
			lda #$00
			sta temp_8bit_3
			lda #<ttt_nothing
			sta loop_pointer+0
			lda #>ttt_nothing
			sta loop_pointer+1
			lda #<ttt_win2_clear
			sta nmi_pointer+0
			lda #>ttt_win2_clear
			sta nmi_pointer+1
			jmp end_loop
:
	ldx cursor_position
	lda ttt_cursor_y, x
	sta ttt_left_cursor
	sta ttt_right_cursor
	lda ttt_cursor_x, x
	sta ttt_left_cursor+3
	clc
	adc #$08
	sta ttt_right_cursor+3
	jsr ttt_controls_p1

	lda number_of_players
	cmp #$02
	beq :+
		jsr start_p2
	jsr flash_start
:
	jmp end_loop
ttt_nmi0:
	lda temp_8bit_0
	beq @done_nmi
		ldy temp_8bit_1
		lda hi_ppu_addy
		sta $2006
		lda lo_ppu_addy
		sta $2006
:		lda (screen_pointer), y
		sta $2007
		iny
		cpy #$04
		bne :-
			sty temp_8bit_1
			lda lo_ppu_addy
			clc
			adc #$20
			sta lo_ppu_addy
			lda #<ttt_nothing
			sta loop_pointer+0
			lda #>ttt_nothing
			sta loop_pointer+1
			lda #<ttt_nmi1
			sta nmi_pointer+0
			lda #>ttt_nmi1
			sta nmi_pointer+1
			lda #$05
			jsr music_loadsfx
@done_nmi:
	jmp finish_nmi
ttt_nmi1:
	ldy temp_8bit_1
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
:	lda (screen_pointer), y
	sta $2007
	iny
	cpy #$08
	bne :-
			sty temp_8bit_1
		lda lo_ppu_addy
		clc
		adc #$20
		sta lo_ppu_addy
		lda #<ttt_nmi2
		sta nmi_pointer+0
		lda #>ttt_nmi2
		sta nmi_pointer+1
@done_nmi:
	jmp finish_nmi
ttt_nmi2:
	ldy temp_8bit_1
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
:	lda (screen_pointer), y
	sta $2007
	iny
	cpy #$0c
	bne :-
		sty temp_8bit_1
		lda lo_ppu_addy
		clc
		adc #$20
		sta lo_ppu_addy
		inc hi_ppu_addy
		lda #<ttt_nmi3
		sta nmi_pointer+0
		lda #>ttt_nmi3
		sta nmi_pointer+1
@done_nmi:
	jmp finish_nmi
ttt_nmi3:
	lda $151
	ldy temp_8bit_1
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
:	lda (screen_pointer), y
	sta $2007
	iny
	cpy #$10
	bne :-
	lda number_of_players
	cmp #$02
	beq :++
		ldx #$00
		lda #$28
		sta $2006
		lda #$4c
		sta $2006
:		lda ttt_cpu, x
		sta $2007
		inx
		cpx #$08
		bne :-
		jmp :+++
:	ldx #$00
	lda #$28
	sta $2006
	lda #$4c
	sta $2006
:	lda ttt_player2, x
	sta $2007
	inx
	cpx #$08
	bne :-
:	lda #$15
	sta pal_address+25
	lda #$05
	sta pal_address+26
	lda #$04
	sta cursor_position
	lda #<ttt_do_tests1
	sta loop_pointer+0
	lda #>ttt_do_tests1
	sta loop_pointer+1
	lda #<ttt_nada
	sta nmi_pointer+0
	lda #>ttt_nada
	sta nmi_pointer+1
	lda #$00
	sta temp_8bit_0
@done_nmi:
	jmp finish_nmi
	

ttt_win2_done:
	lda number_of_players
	cmp #$02
	beq :+
		lda #$29
		sta $2006
		lda #$ce
		sta $2006
		lda #$a0
		sta $2007
		lda #$a1
		sta $2007
		lda #$a2
		sta $2007
		lda #$a3
		sta $2007
		lda #$29
		sta $2006
		lda #$ee
		sta $2006
		lda #$4c
		sta $2007
		lda #$4f
		sta $2007
		lda #$53
		sta $2007
		lda #$45
		sta $2007
		jmp finish_nmi
:
	lda #$29
	sta $2006
	lda #$ce
	sta $2006
	lda #$00
	sta $2007
	lda #$50
	sta $2007
	lda #$32
	sta $2007
	lda #$00
	sta $2007
	lda #$29
	sta $2006
	lda #$ee
	sta $2006
	lda #$57
	sta $2007
	lda #$49
	sta $2007
	lda #$4e
	sta $2007
	lda #$53
	sta $2007
	jmp finish_nmi

ttt_win1_done:
	lda #$29
	sta $2006
	lda #$ce
	sta $2006
	lda #$00
	sta $2007
	lda #$50
	sta $2007
	lda #$31
	sta $2007
	lda #$00
	sta $2007
	lda #$29
	sta $2006
	lda #$ee
	sta $2006
	lda #$57
	sta $2007
	lda #$49
	sta $2007
	lda #$4e
	sta $2007
	lda #$53
	sta $2007
	lda number_of_players
	cmp #$01
	bne :+
		lda #$53
		sta slydog
		lda #$4c
		sta slydog+1
		lda #$59
		sta slydog+2
:
	jmp finish_nmi
ttt_win1_loop:
	dec temp_8bit_3
	bne :+
		jmp reset
:	lda temp_8bit_3
	cmp #$3c
	bne :++
		ldx #$00
		lda #$f0
:		sta left_cursor+0, y
		iny
		iny
		iny
		iny
		bne :-
:
	jmp end_loop
ttt_playa:
	lda p1_strike_count
	cmp #$03
	bne :+
		lda #$06
		jsr music_loadsong
		lda #$00
		sta temp_8bit_3
		lda #<ttt_win1_loop
		sta loop_pointer+0
		lda #>ttt_win1_loop
		sta loop_pointer+1
		lda #<ttt_win1_done
		sta nmi_pointer+0
		lda #>ttt_win1_done
		sta nmi_pointer+1
		jmp end_loop
:
	ldx #$00
:	lda top_left, x
	beq :+
		inx
		cpx #$09
		bne :-
			lda #$07
			jsr music_loadsfx
			lda #$00
			sta temp_8bit_3
			lda #<ttt_nothing
			sta loop_pointer+0
			lda #>ttt_nothing
			sta loop_pointer+1
			lda #<ttt_win1_clear
			sta nmi_pointer+0
			lda #>ttt_win1_clear
			sta nmi_pointer+1
			jmp end_loop
:
	ldx cursor_position
	lda ttt_cursor_y, x
	sta ttt_left_cursor
	sta ttt_right_cursor
	lda ttt_cursor_x, x
	sta ttt_left_cursor+3
	clc
	adc #$08
	sta ttt_right_cursor+3
	jsr start_off
	lda number_of_players
	cmp #$01
	beq :+
		jsr ttt_controls_p2
		jmp :++
:	lda #$3c
	sta e_state
	lda #<cpu_win_test
	sta loop_pointer+0
	lda #>cpu_win_test
	sta loop_pointer+1
	lda #<ttt_nada
	sta nmi_pointer+0
	lda #>ttt_nada
	sta nmi_pointer+1
:
	jmp end_loop
ttt_nmia:
	lda temp_8bit_0
	beq @done_nmi
		ldy temp_8bit_1
		lda hi_ppu_addy
		sta $2006
		lda lo_ppu_addy
		sta $2006
:		lda (screen_pointer), y
		sta $2007
		iny
		cpy #$04
		bne :-
			sty temp_8bit_1
			lda lo_ppu_addy
			clc
			adc #$20
			sta lo_ppu_addy
			lda #<ttt_nothing
			sta loop_pointer+0
			lda #>ttt_nothing
			sta loop_pointer+1
			lda #<ttt_nmib
			sta nmi_pointer+0
			lda #>ttt_nmib
			sta nmi_pointer+1
			lda #$06
			jsr music_loadsfx
@done_nmi:
	jmp finish_nmi
ttt_nmib:
	ldy temp_8bit_1
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
:	lda (screen_pointer), y
	sta $2007
	iny
	cpy #$08
	bne :-
			sty temp_8bit_1
		lda lo_ppu_addy
		clc
		adc #$20
		sta lo_ppu_addy
		lda #<ttt_nmic
		sta nmi_pointer+0
		lda #>ttt_nmic
		sta nmi_pointer+1
@done_nmi:
	jmp finish_nmi
ttt_nmic:
	ldy temp_8bit_1
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
:	lda (screen_pointer), y
	sta $2007
	iny
	cpy #$0c
	bne :-
		sty temp_8bit_1
		lda lo_ppu_addy
		clc
		adc #$20
		sta lo_ppu_addy
		inc hi_ppu_addy
		lda #<ttt_nmid
		sta nmi_pointer+0
		lda #>ttt_nmid
		sta nmi_pointer+1
@done_nmi:
	jmp finish_nmi
ttt_nmid:
	ldy temp_8bit_1
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
:	lda (screen_pointer), y
	sta $2007
	iny
	cpy #$10
	bne :-
		ldx #$00
		lda #$28
		sta $2006
		lda #$4c
		sta $2006
:		lda ttt_player1, x
		sta $2007
		inx
		cpx #$08
		bne :-
		lda #<ttt_do_tests2
		sta loop_pointer+0
		lda #>ttt_do_tests2
		sta loop_pointer+1
		lda #<ttt_nada
		sta nmi_pointer+0
		lda #>ttt_nada
		sta nmi_pointer+1
		lda #$00
		sta temp_8bit_0
		
	lda #$04
	sta cursor_position
	lda #$21
	sta pal_address+25
	lda #$11
	sta pal_address+26
@done_nmi:
	jmp finish_nmi





x_tiles:
	.byte $c6,$c7,$00,$c8
	.byte $00,$c9,$ca,$cb
	.byte $00,$cc,$cd,$ce
	.byte $cf,$d0,$00,$d1

o_tiles:
	.byte $d2,$d3,$d4,$d5
	.byte $d6,$00,$00,$5d
	.byte $5e,$00,$00,$3a
	.byte $3b,$3c,$3d,$3e


ttt_controls_p1:
	lda control_pad
	eor control_old
	and control_pad
	and #up_punch
	beq @no_up
		lda cursor_position
		cmp #$03
		bcc :+
			sec
			sbc #$03
			sta cursor_position
			jmp @no_a
:		clc
		adc #$06
		sta cursor_position
		jmp @no_a
@no_up:
	lda control_pad
	eor control_old
	and control_pad
	and #down_punch
	beq @no_down
		lda cursor_position
		cmp #$06
		bcs :+
			clc
			adc #$03
			sta cursor_position
			jmp @no_a
:		sec
		sbc #$06
		sta cursor_position
		jmp @no_a
@no_down:
	lda control_pad
	eor control_old
	and control_pad
	and #left_punch
	beq @no_left
		lda ttt_left_cursor+3
		cmp #$38
		beq :+
			dec cursor_position
			jmp @no_a
:		lda cursor_position
		clc
		adc #$02
		sta cursor_position
		jmp @no_a
@no_left:
	lda control_pad
	eor control_old
	and control_pad
	and #right_punch
	beq @no_right
		lda ttt_left_cursor+3
		cmp #$b8
		beq :+
			inc cursor_position
			jmp @no_a
:		lda cursor_position
		sec
		sbc #$02
		sta cursor_position
		jmp @no_a
@no_right:
	lda control_pad
	eor control_old
	and control_pad
	and #a_punch
	beq @no_a
		ldx cursor_position
		lda top_left, x
		bne @no_a
			ldx cursor_position
			lda #$01
			sta top_left, x
			sta temp_8bit_0
			lda ttt_addy_lo, x
			sta lo_ppu_addy
			lda ttt_addy_hi, x
			sta hi_ppu_addy
			lda #<x_tiles
			sta screen_pointer+0
			lda #>x_tiles
			sta screen_pointer+1
			ldy #$00
			sty temp_8bit_1
			lda #$f0
			sta ttt_left_cursor
			sta ttt_right_cursor
@no_a:
	rts

ttt_controls_p2:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #up_punch
	beq @no_up
		lda cursor_position
		cmp #$03
		bcc :+
			sec
			sbc #$03
			sta cursor_position
			jmp @no_a
:		clc
		adc #$06
		sta cursor_position
		jmp @no_a
@no_up:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #down_punch
	beq @no_down
		lda cursor_position
		cmp #$06
		bcs :+
			clc
			adc #$03
			sta cursor_position
			jmp @no_a
:		sec
		sbc #$06
		sta cursor_position
		jmp @no_a
@no_down:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #left_punch
	beq @no_left
		lda ttt_left_cursor+3
		cmp #$38
		beq :+
			dec cursor_position
			jmp @no_a
:		lda cursor_position
		clc
		adc #$02
		sta cursor_position
		jmp @no_a
@no_left:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #right_punch
	beq @no_right
		lda ttt_left_cursor+3
		cmp #$b8
		beq :+
			inc cursor_position
			jmp @no_a
:		lda cursor_position
		sec
		sbc #$02
		sta cursor_position
		jmp @no_a
@no_right:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #a_punch
	beq @no_a
		ldx cursor_position
		lda top_left, x
		bne @no_a
			lda #$02
			sta top_left, x
			sta temp_8bit_0
			lda ttt_addy_lo, x
			sta lo_ppu_addy
			lda ttt_addy_hi, x
			sta hi_ppu_addy
			lda #<o_tiles
			sta screen_pointer+0
			lda #>o_tiles
			sta screen_pointer+1
			ldy #$00
			sty temp_8bit_1
			lda #$f0
			sta ttt_left_cursor
			sta ttt_right_cursor
@no_a:
	rts


flash_start:
	lda number_of_players
	cmp #$02
	bne :+
		rts
:	lda temp_8bit_2
	cmp #$30
	bne :+
		lda #$00
		sta temp_8bit_2
:	cmp #$18
	bcc :++
		ldx #$00
:		lda ttt_push_start, x
		sta push1, x
		inx
		cpx #36
		bne :-
		jmp :++
:	jsr start_off
:	inc temp_8bit_2
	rts
start_off:
	ldx #$00
	lda #$f0
:	sta push1, x
	inx
	cpx #36
	bne :-
	rts
ttt_push_start:
	.byte $28,$50,$01,$e0
	.byte $30,$55,$01,$e0
	.byte $38,$53,$01,$e0
	.byte $40,$48,$01,$e0
	.byte $30,$53,$01,$e8
	.byte $38,$54,$01,$e8
	.byte $40,$41,$01,$e8
	.byte $48,$52,$01,$e8
	.byte $50,$54,$01,$e8
ttt_board_0:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$32,$00,$00,$00,$00,$35,$36,$37,$38,$00,$00,$00,$00,$33,$00
	.byte $00,$00,$00,$00,$00,$01,$02,$00,$00,$01,$02,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00

	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00
	.byte $00,$00,$07,$08,$08,$05,$06,$08,$08,$05,$06,$08,$08,$09,$00,$00
	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00

	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00
	.byte $00,$00,$07,$08,$08,$05,$06,$08,$08,$05,$06,$08,$08,$09,$00,$00
	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$03,$04,$00,$00,$03,$04,$00,$00,$00,$00,$00

	.byte $00,$00,$00,$00,$00,$0a,$0b,$00,$00,$0a,$0b,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
ttt_attribs:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $00,$00,$44,$11,$44,$11,$00,$00
	.byte $00,$50,$54,$51,$54,$51,$50,$00, $00,$00,$44,$11,$44,$11,$00,$00
	.byte $00,$50,$54,$51,$54,$51,$50,$00, $00,$00,$44,$11,$44,$11,$00,$00
	.byte $00,$00,$f4,$f1,$f4,$f1,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00
;$04,$01,$04,$01,--^ BEFORE ATTRIBUTE CHANGE
ttt_clear_lo:
	.byte $a6,$c6,$e6,$06, $ae,$ce,$ee,$0e, $b6,$d6,$f6,$16
	.byte $a6,$c6,$e6,$06, $ae,$ce,$ee,$0e, $b6,$d6,$f6,$16
	.byte $a6,$c6,$e6,$06, $ae,$ce,$ee,$0e, $b6,$d6,$f6,$16
ttt_clear_hi:
	.byte $28,$28,$28,$29, $28,$28,$28,$29, $28,$28,$28,$29
	.byte $29,$29,$29,$2a, $29,$29,$29,$2a, $29,$29,$29,$2a
	.byte $2a,$2a,$2a,$2b, $2a,$2a,$2a,$2b, $2a,$2a,$2a,$2b

win_tests_lo:
	.byte <toph_test, <midh_test, <both_test, <leftv_test
	.byte <midv_test, <rightv_test, <diagl_test, <diagr_test
win_tests_hi:
	.byte >toph_test, >midh_test, >both_test, >leftv_test
	.byte >midv_test, >rightv_test, >diagl_test, >diagr_test
toph_test:
	.byte <top_left, <top_middle, <top_right
midh_test:
	.byte <mid_left, <mid_middle, <mid_right
both_test:
	.byte <bot_left, <bot_middle, <bot_right
leftv_test:
	.byte <top_left, <mid_left, <bot_left
midv_test:
	.byte <top_middle, <mid_middle, <bot_middle
rightv_test:
	.byte <top_right, <mid_right, <bot_right
diagl_test:
	.byte <top_left, <mid_middle, <bot_right
diagr_test:
	.byte <top_right, <mid_middle, <bot_left

win_y_lo:
	.byte <toph_y, <midh_y,   <both_y,  <leftv_y
	.byte <midv_y, <rightv_y, <diagl_y, <diagr_y
win_y_hi:
	.byte >toph_y, >midh_y,   >both_y,  >leftv_y
	.byte >midv_y, >rightv_y, >diagl_y, >diagr_y
win_x_lo:
	.byte <toph_x, <midh_x,   <both_x,  <leftv_x
	.byte <midv_x, <rightv_x, <diagl_x, <diagr_x
win_x_hi:
	.byte >toph_x, >midh_x,   >both_x,  >leftv_x
	.byte >midv_x, >rightv_x, >diagl_x, >diagr_x
toph_y:
	.byte $1d,$1d,$1d
toph_x:
	.byte $38,$78,$b8
midh_y:
	.byte $5d,$5d,$5d
midh_x:
	.byte $38,$78,$b8
both_y:
	.byte $9d,$9d,$9d
both_x:
	.byte $38,$78,$b8
leftv_y:
	.byte $1d,$5d,$9d
leftv_x:
	.byte $38,$38,$38
midv_y:
	.byte $1d,$5d,$9d
midv_x:
	.byte $78,$78,$78
rightv_y:
	.byte $1d,$5d,$9d
rightv_x:
	.byte $b8,$b8,$b8
diagl_y:
	.byte $1d,$5d,$9d
diagl_x:
	.byte $38,$78,$b8
diagr_y:
	.byte $9d,$5d,$1d
diagr_x:
	.byte $38,$78,$b8

ttt_do_tests1:
	ldx #$00
	stx temp_8bit_1
@begin_tests:
	ldx temp_8bit_1
	lda win_tests_lo, x
	sta screen_pointer+0
	lda win_tests_hi, x
	sta screen_pointer+1
	ldy #$00
:	lda (screen_pointer), y
	tax
	lda $00, x
	cmp #$01
	bne :+
		iny
		cpy #$03
		bne :-
			inc p1_strike_count
			lda #$21
			sta pal_address+17
			lda #$11
			sta pal_address+18
			lda #$f0
			sta ttt_left_cursor+0
			sta ttt_right_cursor+0
			lda #$b4
			sta temp_8bit_3
			jsr ttt_line
			lda #<ttt_win1
			sta loop_pointer+0
			lda #>ttt_win1
			sta loop_pointer+1
			lda #<ttt_nada
			sta nmi_pointer+0
			lda #>ttt_nada
			sta nmi_pointer+1
			jmp end_loop
:	inc temp_8bit_1
	lda temp_8bit_1
	cmp #$08
	bne @begin_tests

	
@end_loop:
	lda #<ttt_playa
	sta loop_pointer+0
	lda #>ttt_playa
	sta loop_pointer+1
	lda #<ttt_nmia
	sta nmi_pointer+0
	lda #>ttt_nmia
	sta nmi_pointer+1
	jmp end_loop

ttt_win1:
	dec temp_8bit_3
	bne :+
			lda #$07
			jsr music_loadsfx
		lda #<ttt_nothing
		sta loop_pointer+0
		lda #>ttt_nothing
		sta loop_pointer+1
		lda #<ttt_win1_clear
		sta nmi_pointer+0
		lda #>ttt_win1_clear
		sta nmi_pointer+1
			lda #$f0
			sta win_spr0a
			sta win_spr1a
			sta win_spr2a
			sta win_spr0b
			sta win_spr1b
			sta win_spr2b
		jmp end_loop
:	lda temp_8bit_3
	cmp #$3c
	bne :+
		jsr ttt_strikes
:
	jmp end_loop

ttt_win1_clear:
	ldx temp_8bit_3
	ldy #$00
	lda ttt_clear_hi, x
	sta $2006
	lda ttt_clear_lo, x
	sta $2006
	lda #$00
:	sta $2007
	iny
	cpy #$04
	bne :-
		inx
		stx temp_8bit_3
		cpx #36
		bne :++
			lda #<ttt_playa
			sta loop_pointer+0
			lda #>ttt_playa
			sta loop_pointer+1
			lda #<ttt_nmia
			sta nmi_pointer+0
			lda #>ttt_nmia
			sta nmi_pointer+1
			ldx #$00
			txa
:			sta top_left, x
			inx
			cpx #$09
			bne :-
:
	jmp finish_nmi



ttt_line:
	ldx temp_8bit_1
	lda win_y_lo, x
	sta game_pic_pointer+0
	lda win_y_hi, x
	sta game_pic_pointer+1
	lda win_x_lo, x
	sta game_pic_pointer2+0
	lda win_x_hi, x
	sta game_pic_pointer2+1
	ldx #$00
	ldy #$00
:	lda (game_pic_pointer), y
	sta win_spr0a+0, x
	sta win_spr0b+0, x
	lda (game_pic_pointer2), y
	sta win_spr0a+3, x
	clc
	adc #$08
	sta win_spr0b+3, x
	inx
	inx
	inx
	inx
	iny
	cpy #$03
	bne :-
	rts

ttt_do_tests2:
	ldx #$00
	stx temp_8bit_1
@begin_tests:
	ldx temp_8bit_1
	lda win_tests_lo, x
	sta screen_pointer+0
	lda win_tests_hi, x
	sta screen_pointer+1
	ldy #$00
:	lda (screen_pointer), y
	tax
	lda $00, x
	cmp #$02
	bne :+
		iny
		cpy #$03
		bne :-
			inc p2_strike_count
			lda #$15
			sta pal_address+17
			lda #$05
			sta pal_address+18
			lda #$f0
			sta ttt_left_cursor+0
			sta ttt_right_cursor+0
			lda #$b4
			sta temp_8bit_3
			jsr ttt_line
			lda #<ttt_win2
			sta loop_pointer+0
			lda #>ttt_win2
			sta loop_pointer+1
			lda #<ttt_nada
			sta nmi_pointer+0
			lda #>ttt_nada
			sta nmi_pointer+1
			jmp end_loop
:	inc temp_8bit_1
	lda temp_8bit_1
	cmp #$08
	bne @begin_tests

	
@end_loop:
	lda #<ttt_play0
	sta loop_pointer+0
	lda #>ttt_play0
	sta loop_pointer+1
	lda #<ttt_nmi0
	sta nmi_pointer+0
	lda #>ttt_nmi0
	sta nmi_pointer+1
	jmp end_loop


ttt_win2:
	dec temp_8bit_3
	bne :+
			lda #$07
			jsr music_loadsfx
		lda #<ttt_nothing
		sta loop_pointer+0
		lda #>ttt_nothing
		sta loop_pointer+1
		lda #<ttt_win2_clear
		sta nmi_pointer+0
		lda #>ttt_win2_clear
		sta nmi_pointer+1
			lda #$f0
			sta win_spr0a
			sta win_spr1a
			sta win_spr2a
			sta win_spr0b
			sta win_spr1b
			sta win_spr2b
		jmp end_loop
:	lda temp_8bit_3
	cmp #$3c
	bne :+
		jsr ttt_strikes
:
	jmp end_loop

ttt_win2_clear:

	ldx temp_8bit_3
	ldy #$00
	lda ttt_clear_hi, x
	sta $2006
	lda ttt_clear_lo, x
	sta $2006
	lda #$00
:	sta $2007
	iny
	cpy #$04
	bne :-
		inx
		stx temp_8bit_3
		cpx #36
		bne :++
			lda #<ttt_play0
			sta loop_pointer+0
			lda #>ttt_play0
			sta loop_pointer+1
			lda #<ttt_nmi0
			sta nmi_pointer+0
			lda #>ttt_nmi0
			sta nmi_pointer+1
			ldx #$00
			txa
:			sta top_left, x
			inx
			cpx #$09
			bne :-
:
	jmp finish_nmi





cpu_win_test:
	lda e_state							; When it's the computer's turn, have a
	beq :+								;  counter that gives it an appearance of
		dec e_state						;	'thinking'
		jmp @finished							; Jump to the end if counter is still going.
:	ldx temp									; 
	cpx #$06
	bne @setup_test
			jmp @go_next
@setup_test:
	ldx temp
	lda cpu_table_win_lo, x						; (2,2,0) (0,2,2) (2,0,2)
	sta cpu_pointer+0
	lda cpu_table_win_hi, x
	sta cpu_pointer+1
@check_all_eight:
	ldx temp2
	lda win_tests_lo, x						; the 8 different ways to win
	sta test_pointer+0
	lda win_tests_hi, x
	sta test_pointer+1
	ldy #$00
@setup_bytes:
	lda (test_pointer), y
	sta cpu_test_bytes, y
	iny
	cpy #3
	bne @setup_bytes
		ldy #$00
@begin_tests:
		ldx cpu_test_bytes, y
		lda $00, x
		bne :+
			sty test_byte						; store offset where 0 is
:		lda $00, x
		cmp (cpu_pointer), y
		bne @not_equal
			iny
			cpy #3
			bne @begin_tests
				ldy test_byte
				ldx cpu_test_bytes, y
				txa
				sec
				sbc #$33
				sta ttt_cursor_match
				lda #$20
				sta cursor_wait
				lda #<ttt_cpu_moving
				sta loop_pointer+0
				lda #>ttt_cpu_moving
				sta loop_pointer+1
				lda #<ttt_nada
				sta nmi_pointer+0
				lda #>ttt_nada
				sta nmi_pointer+1
				ldx #$00
				stx temp
				stx temp2
				jmp end_loop
@not_equal:
	ldx temp2
	inx
	stx temp2
	cpx #$08
	beq :+
		jmp @finished
:		ldx #$00
		stx temp2
		ldx temp
		inx
		stx temp
		cpx #$06
		beq @go_next
			jmp @finished
@go_next:
	lda top_left								; This run of tests are caveats to make the
	cmp #$01									;  CPU unbeatable against savvy tic tac toe
	bne :+										;  players. The first two strings of tests
		lda mid_right							;  are to check if the player placed an X
		cmp #$01								;  in a corner, then placed one on the
		bne :+									;  opposite side middle, in order to set up
			lda top_right						;  the computer to fail when the player has
			bne :+								;  two ways to win, and the computer can 
				lda #$02						;  obviously only block one of them. We only
				sta ttt_cursor_match				;  need to check two situations for this, 
				jmp @done						;  because the order the computer selects
:	lda bot_left								;  its basic moves would prevent the other
	cmp #$01									;  two from happening in the first place.
	bne :+										;
		lda mid_right							;
		cmp #$01								;
		bne :+									;
			lda bot_right						;
			bne :+								;
				lda #$08						;
				sta ttt_cursor_match				;
				jmp @done						;
:	lda bot_left
	cmp #$01
	bne :+
		lda top_right
		bne :+
			lda #$02
			sta ttt_cursor_match
			jmp @done
:	lda top_right
	cmp #$01
	bne :+
		lda bot_left
		bne :+
			lda #$06
			sta ttt_cursor_match
			jmp @done
:	lda bot_right
	cmp #$01
	bne :+
		lda top_left
		bne :+
			lda #$00
			sta ttt_cursor_match
			jmp @done
:	lda top_left
	cmp #$01
	bne :+
		lda bot_right
		bne :+
			lda #$08
			sta ttt_cursor_match
			jmp @done
:
	ldy #$00
@cpu_basic:
	ldx cpu_order, y
	lda $00, x
	bne :+
		lda cpu_pos, y
		sta ttt_cursor_match
		jmp @done
:	iny
	cpy #$0c
	bne @cpu_basic
@done:
	lda #$20
	sta cursor_wait
	lda #<ttt_cpu_moving
	sta loop_pointer+0
	lda #>ttt_cpu_moving
	sta loop_pointer+1
	lda #<ttt_nada
	sta nmi_pointer+0
	lda #>ttt_nada
	sta nmi_pointer+1
	ldx #$00
	stx temp
	stx temp2
@finished:
	jmp end_loop

cpu_order:
	.byte <mid_middle, <bot_left, <top_left, <top_right, <bot_right, <top_middle, <mid_right, <mid_left, <bot_middle
cpu_pos:
	.byte         $04,       $06,       $00,        $02,        $08,         $01,        $05,       $03,         $07

cpu_table_win_lo:
	.byte <cpu_table_win1, <cpu_table_win2, <cpu_table_win3, <cpu_test_block1, <cpu_test_block2, <cpu_test_block3
cpu_table_win_hi:
	.byte >cpu_table_win1, >cpu_table_win2, >cpu_table_win3, >cpu_test_block1, >cpu_test_block2, >cpu_test_block3
cpu_table_win1:
	.byte $02,$02,$00
cpu_table_win2:
	.byte $00,$02,$02
cpu_table_win3:
	.byte $02,$00,$02
cpu_test_block1:
	.byte $01,$01,$00
cpu_test_block2:
	.byte $00,$01,$01
cpu_test_block3:
	.byte $01,$00,$01

ttt_cpu_moving:
	ldx cursor_position
	lda ttt_cursor_y, x
	sta ttt_left_cursor
	sta ttt_right_cursor
	lda ttt_cursor_x, x
	sta ttt_left_cursor+3
	clc
	adc #$08
	sta ttt_right_cursor+3

	dec cursor_wait
	bne @not_now
		lda #$20
		sta cursor_wait
	lda ttt_cursor_match
	cmp cursor_position
	bne @not_equal
			tax
			lda #$02
			sta top_left, x
			sta temp_8bit_0
			lda ttt_addy_lo, x
			sta lo_ppu_addy
			lda ttt_addy_hi, x
			sta hi_ppu_addy
			lda #<o_tiles
			sta screen_pointer+0
			lda #>o_tiles
			sta screen_pointer+1
			ldy #$00
			sty temp_8bit_1
			lda #$f0
			sta ttt_left_cursor
			sta ttt_right_cursor
		lda #<ttt_nothing
		sta loop_pointer+0
		lda #>ttt_nothing
		sta loop_pointer+1
		lda #<ttt_nmia
		sta nmi_pointer+0
		lda #>ttt_nmia
		sta nmi_pointer+1
		jmp end_loop
@not_equal:
	bcc @do_less_than
		inc cursor_position
		jmp end_loop
@do_less_than:
	dec cursor_position
@not_now:
	jmp end_loop


start_p2:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #start_punch
	beq @no_start
		lda #$00
		sta temp_8bit_0
		sta temp_8bit_1
		sta temp_8bit_2
		sta temp_8bit_3
		sta temp
		sta temp2
		sta cursor_wait
		sta e_state
		lda #$21
		sta pal_address+25
		lda #$11
		sta pal_address+26
		lda #$0f
		sta pal_address+22
		sta pal_address+23
		lda #$00
		sta p1_strike_count
		sta p2_strike_count
		lda #$f0
			sta ttt_left_cursor+0
			sta ttt_right_cursor+0
		sta p1_strike1
		sta p1_strike2
		sta p1_strike3
		sta p2_strike1
		sta p2_strike2
		sta p2_strike3
			sta win_spr0a
			sta win_spr1a
			sta win_spr2a
			sta win_spr0b
			sta win_spr1b
			sta win_spr2b
		lda #$02
		sta number_of_players
		lda #$04
		sta cursor_position
		jsr music_loadsfx
		lda #<ttt_nothing
		sta loop_pointer+0
		lda #>ttt_nothing
		sta loop_pointer+1
		lda #<ttt_win2_clear
		sta nmi_pointer+0
		lda #>ttt_win2_clear
		sta nmi_pointer+1
@no_start:
	rts



