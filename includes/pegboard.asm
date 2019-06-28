pegboard_play_nmi:
	lda temp
	cmp #$ff
	bne @test_2p_win
		lda number_of_players
		cmp #$01
		beq @congrats
			lda #$29
			sta $2006
			lda #$8c
			sta $2006
			ldx #$00
:			lda p1_peg_winner, x
			sta $2007
			inx
			cpx #(pegboard_loop - p2_peg_winner)
			bne :-
			lda #$2a
			sta $2006
			lda #$2c
			sta $2006
			ldx #$00
:			lda p1_peg_winner, x
			sta $2007
			inx
			cpx #(pegboard_loop - p2_peg_winner)
			bne :-
			jmp finish_nmi
@congrats:
		lda #$28
		sta $2006
		lda #$ed
		sta $2006
		ldx #$00
:		lda congrats_maysuhj, x
		sta $2007
		inx
		cpx #(p1_jumper - congrats_maysuhj)
		bne :-
		jmp finish_nmi
@test_2p_win:
	lda temp2
	cmp #$ff
	bne @done
		lda #$29
		sta $2006
		lda #$8c
		sta $2006
		ldx #$00
:		lda p2_peg_winner, x
		sta $2007
		inx
		cpx #(pegboard_loop - p2_peg_winner)
		bne :-
		lda #$2a
		sta $2006
		lda #$2c
		sta $2006
		ldx #$00
:		lda p2_peg_winner, x
		sta $2007
		inx
		cpx #(pegboard_loop - p2_peg_winner)
		bne :-
@done:
	jmp finish_nmi

p1_peg_winner:
	.byte "P1",$00,"WINS",$5c
p2_peg_winner:
	.byte "P2",$00,"WINS",$5c

pegboard_loop:
	lda scroll_it
	beq @start_game
		lda #$0f
		sta pal_address+10
		sta pal_address+11
		lda scroll_y
		clc
		adc #$01
		sta scroll_y
		cmp #$ef
		beq :+
			jmp @nmi
:			lda #$00
			sta temp
			sta temp2
			sta p1_prior_cursor
			sta p2_prior_cursor
			sta scroll_it
			sta switch_menu_item
			tax
			lda number_of_players
			cmp #$01
			beq :++
:			lda pegboard_sprites, x
			sta p1cursor, x
			inx
			cpx #8
			bne :-
			jmp :++
:			lda pegboard_sprites, x
			sta p1cursor, x
			inx
			cpx #4
			bne :-
:			ldx #$01
			txa
			stx start_game
			dex
:			sta p1_peg01, x
			inx
			cpx #30
			bne :-
			lda #$29
			sta pal_address+21
			lda #$30
			sta pal_address+23
			lda #$15
			sta pal_address+27
			lda #$0b
			jsr music_loadsong
			bne @nmi					; Always branch to wait for one more NMI
@start_game:
	lda start_game
	beq @nmi
		lda temp
		cmp #$ff
		beq :+
			lda temp2
			cmp #$ff
			beq :+
				jmp :+++
:				lda one_second					; This loop is just a delay to allow
				sec                             ;  the music to play out before setting
				sbc #$01						;  the reset flag (reset_game) to allow
				sta one_second					;  for a reset to happen (snail.asm).
				bne @nmi						;
					lda #$3c					;
					sta one_second				;
					lda big_seconds				;
					sec							;
					sbc #$01					;
					sta big_seconds				;
					bne @nmi					;
						lda number_of_players
						cmp #$01
						bne :+
							lda #$44
							sta slydog+3
							lda #$4f
							sta slydog+4
							lda #$47
							sta slydog+5
							jsr nmi_wait
:						jmp reset				;
:		lda number_of_players
		cmp #$02
		beq :+
			jsr animate_pegs_palette
			jsr insert_player2
:		lda number_of_players
		cmp #$01
		beq @only_one_player
			jsr p2_one_peg_check
			jsr p2_is_moving
			lda p2_make_move
			bne @p2_moving
				jsr p2_peg_control
@p2_moving:
				jsr the_p2_sprites_back
@only_one_player:
		jsr p1_one_peg_check
		jsr p1_is_moving
		lda p1_make_move
		bne @p1_moving
			jsr p1_peg_control
@p1_moving:
			jsr the_p1_sprites_back
@nmi:
;	jsr nmi_wait
	jmp end_loop	;pegboard_loop

insert_player2:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #start_punch
	beq @no_start
		lda #$02
		sta number_of_players
		ldx #$00
:		lda pegboard_sprites, x
		sta p1cursor, x
		inx
		cpx #8
		bne :-
		ldx #$00
		stx p1_set
		stx p2_set
		stx p1_locked
		stx p2_locked
:		lda #$ff
		sta p1_sprites_y, x
		sta p2_sprites_y, x
		lda #$01
		sta p1_peg01, x
		sta p2_peg01, x
		sta p1_sprites_attribs, x
		sta p2_sprites_attribs, x
		inx
		cpx #$0f
		bne :-
		stx pal_address+10
		stx pal_address+11
		lda #$04
		jsr music_loadsfx
@no_start:
	rts

cursor_up_x:
	.byte       $00,      $00,      $00,      $01,      $02,      $02,      $03,      $04
	.byte       $05,      $05,      $06,      $07,      $08,      $09,      $09
cursor_down_x:
	.byte       $01,      $03,      $04,      $06,      $07,      $08,      $0a,      $0b
	.byte       $0c,      $0d,      $0a,      $0b,      $0c,      $0d,      $0e
;p1_menu_table:
;	.byte <p1_peg01,<p1_peg02,<p1_peg03,<p1_peg04,<p1_peg05,<p1_peg06,<p1_peg07,<p1_peg08
;	.byte <p1_peg09,<p1_peg10,<p1_peg11,<p1_peg12,<p1_peg13,<p1_peg14,<p1_peg15
p1_cursor_y:
	.byte       $28,      $30,      $30,      $38,      $38,      $38,      $40,      $40
	.byte       $40,      $40,      $48,      $48,      $48,      $48,      $48
p1_cursor_x:
	.byte       $3c,      $36,      $42,      $31,      $3c,      $47,      $2b,      $36
	.byte       $42,      $4d,      $26,      $31,      $3c,      $47,      $52

p2_cursor_y:
	.byte       $a8,      $b0,      $b0,      $b8,      $b8,      $b8,      $c0,      $c0
	.byte       $c0,      $c0,      $c8,      $c8,      $c8,      $c8,      $c8
p2_cursor_x:
	.byte       $bc,      $b6,      $c2,      $b1,      $bc,      $c7,      $ab,      $b6
	.byte       $c2,      $cd,      $a6,      $b1,      $bc,      $c7,      $d2





p1_is_moving:
			lda p1_make_move
			beq @done_move
				sec
				sbc #$01
				sta p1_make_move
				bne :+
					sta p1_locked
					rts
:				cmp #$28
				bne :+
					ldy p1_prior_cursor
					lda #$00
					sta p1_peg01, y
					lda #$ff
					sta p1_sprites_y, y
					ldy p1_cursor_pos
					lda #$02
					sta p1_sprites_attribs, y
					lda p1_cursor_y, y
					sta p1_sprites_y, y
					lda #$01
					sta p1_peg01, y
					jmp @done_move				
:				cmp #$18
				bne :+
					ldy p1_held_offset
					lda (p1_jump_address), y
					tax
					lda #$00
					sta p1_peg01, x
					lda #$ff
					sta p1_sprites_y, x
					jmp @done_move
:				cmp #$08
				bne @done_move
					ldy p1_cursor_pos
					lda #$01
					sta p1_sprites_attribs, y
@done_move:
	rts

p2_is_moving:
			lda p2_make_move
			beq @done_move
				sec
				sbc #$01
				sta p2_make_move
				bne :+
					sta p2_locked
					rts
:				cmp #$28
				bne :+
					ldy p2_prior_cursor
					lda #$00
					sta p2_peg01, y
					lda #$ff
					sta p2_sprites_y, y
					ldy p2_cursor_pos
					lda #$02
					sta p2_sprites_attribs, y
					lda p2_cursor_y, y
					sta p2_sprites_y, y
					lda #$01
					sta p2_peg01, y
					jmp @done_move				
:				cmp #$18
				bne :+
					ldy p2_held_offset
					lda (p2_jump_address), y
					tax
					lda #$00
					sta p2_peg01, x
					lda #$ff
					sta p2_sprites_y, x
					jmp @done_move
:				cmp #$08
				bne @done_move
					ldy p2_cursor_pos
					lda #$01
					sta p2_sprites_attribs, y
@done_move:
	rts




p1_one_peg_check:
	ldx #$00
	stx temp
:	lda p1_peg01, x
	beq :+
		inc temp
:	inx
	cpx #$0f
	bne :--
	lda temp
	cmp #$02
	bcc :+
		rts
:	lda #$ff
	sta temp
	lda #$04
	sta big_seconds
	lda #$3c
	sta one_second
			lda #$03
			jsr music_loadsong
	rts

p2_one_peg_check:
	ldx #$00
	stx temp2
:	lda p2_peg01, x
	beq :+
		inc temp2
:	inx
	cpx #$0f
	bne :--
	lda temp2
	cmp #$02
	bcc :+
		rts
:	lda #$ff
	sta temp2
	lda #$04
	sta big_seconds
	lda #$3c
	sta one_second
			lda #$03
			jsr music_loadsong
	rts

congrats_maysuhj:
	.byte "CONGRATULATIONS",$5c
p1_jumper:
	ldx #$01
	stx p1_held_offset
	lda p1_cursor_pos
	asl a
	tay
	lda p1_possible+1, y
	pha
	lda p1_possible, y
	pha
	rts
p2_jumper:
	ldx #$01
	stx p2_held_offset
	lda p2_cursor_pos
	asl a
	tay
	lda p2_possible+1, y
	pha
	lda p2_possible, y
	pha
	rts
p1_possible:
	.addr peg1_1-1,peg1_2-1,peg1_3-1,peg1_4-1,peg1_5-1,peg1_6-1,peg1_7-1,peg1_8-1
	.addr peg1_9-1,peg1_10-1,peg1_11-1,peg1_12-1,peg1_13-1,peg1_14-1,peg1_15-1
p2_possible:
	.addr peg2_1-1,peg2_2-1,peg2_3-1,peg2_4-1,peg2_5-1,peg2_6-1,peg2_7-1,peg2_8-1
	.addr peg2_9-1,peg2_10-1,peg2_11-1,peg2_12-1,peg2_13-1,peg2_14-1,peg2_15-1
peg1_1:
	lda #<peg1_hold
	sta p1_held_address+0
	lda #>peg1_hold
	sta p1_held_address+1
	lda #<peg1_jump
	sta p1_jump_address+0
	lda #>peg1_jump
	sta p1_jump_address+1
	lda peg1_hold, x
	sta p1_cursor_pos
	rts
peg1_2:
	lda #<peg2_hold
	sta p1_held_address+0
	lda #>peg2_hold
	sta p1_held_address+1
	lda #<peg2_jump
	sta p1_jump_address+0
	lda #>peg2_jump
	sta p1_jump_address+1
	lda peg2_hold, x
	sta p1_cursor_pos
	rts
peg1_3:
	lda #<peg3_hold
	sta p1_held_address+0
	lda #>peg3_hold
	sta p1_held_address+1
	lda #<peg3_jump
	sta p1_jump_address+0
	lda #>peg3_jump
	sta p1_jump_address+1
	lda peg3_hold, x
	sta p1_cursor_pos
	rts
peg1_4:
	lda #<peg4_hold
	sta p1_held_address+0
	lda #>peg4_hold
	sta p1_held_address+1
	lda #<peg4_jump
	sta p1_jump_address+0
	lda #>peg4_jump
	sta p1_jump_address+1
	lda peg4_hold, x
	sta p1_cursor_pos
	rts
peg1_5:
	lda #<peg5_hold
	sta p1_held_address+0
	lda #>peg5_hold
	sta p1_held_address+1
	lda #<peg5_jump
	sta p1_jump_address+0
	lda #>peg5_jump
	sta p1_jump_address+1
	lda peg5_hold, x
	sta p1_cursor_pos
	rts
peg1_6:
	lda #<peg6_hold
	sta p1_held_address+0
	lda #>peg6_hold
	sta p1_held_address+1
	lda #<peg6_jump
	sta p1_jump_address+0
	lda #>peg6_jump
	sta p1_jump_address+1
	lda peg6_hold, x
	sta p1_cursor_pos
	rts
peg1_7:
	lda #<peg7_hold
	sta p1_held_address+0
	lda #>peg7_hold
	sta p1_held_address+1
	lda #<peg7_jump
	sta p1_jump_address+0
	lda #>peg7_jump
	sta p1_jump_address+1
	lda peg7_hold, x
	sta p1_cursor_pos
	rts
peg1_8:
	lda #<peg8_hold
	sta p1_held_address+0
	lda #>peg8_hold
	sta p1_held_address+1
	lda #<peg8_jump
	sta p1_jump_address+0
	lda #>peg8_jump
	sta p1_jump_address+1
	lda peg8_hold, x
	sta p1_cursor_pos
	rts
peg1_9:
	lda #<peg9_hold
	sta p1_held_address+0
	lda #>peg9_hold
	sta p1_held_address+1
	lda #<peg9_jump
	sta p1_jump_address+0
	lda #>peg9_jump
	sta p1_jump_address+1
	lda peg9_hold, x
	sta p1_cursor_pos
	rts
peg1_10:
	lda #<peg10_hold
	sta p1_held_address+0
	lda #>peg10_hold
	sta p1_held_address+1
	lda #<peg10_jump
	sta p1_jump_address+0
	lda #>peg10_jump
	sta p1_jump_address+1
	lda peg10_hold, x
	sta p1_cursor_pos
	rts
peg1_11:
	lda #<peg11_hold
	sta p1_held_address+0
	lda #>peg11_hold
	sta p1_held_address+1
	lda #<peg11_jump
	sta p1_jump_address+0
	lda #>peg11_jump
	sta p1_jump_address+1
	lda peg11_hold, x
	sta p1_cursor_pos
	rts
peg1_12:
	lda #<peg12_hold
	sta p1_held_address+0
	lda #>peg12_hold
	sta p1_held_address+1
	lda #<peg12_jump
	sta p1_jump_address+0
	lda #>peg12_jump
	sta p1_jump_address+1
	lda peg12_hold, x
	sta p1_cursor_pos
	rts
peg1_13:
	lda #<peg13_hold
	sta p1_held_address+0
	lda #>peg13_hold
	sta p1_held_address+1
	lda #<peg13_jump
	sta p1_jump_address+0
	lda #>peg13_jump
	sta p1_jump_address+1
	lda peg13_hold, x
	sta p1_cursor_pos
	rts
peg1_14:
	lda #<peg14_hold
	sta p1_held_address+0
	lda #>peg14_hold
	sta p1_held_address+1
	lda #<peg14_jump
	sta p1_jump_address+0
	lda #>peg14_jump
	sta p1_jump_address+1
	lda peg14_hold, x
	sta p1_cursor_pos
	rts
peg1_15:
	lda #<peg15_hold
	sta p1_held_address+0
	lda #>peg15_hold
	sta p1_held_address+1
	lda #<peg15_jump
	sta p1_jump_address+0
	lda #>peg15_jump
	sta p1_jump_address+1
	lda peg15_hold, x
	sta p1_cursor_pos
	rts
peg1_hold:
	.byte $ff,$03,$05,$ff
peg1_jump:
	.byte $ff,$01,$02,$ff
peg2_hold:
	.byte $ff,$06,$08,$ff
peg2_jump:
	.byte $ff,$03,$04,$ff
peg3_hold:
	.byte $ff,$07,$09,$ff
peg3_jump:
	.byte $ff,$04,$05,$ff
peg4_hold:
	.byte $ff,$0a,$0c,$05,$00,$ff
peg4_jump:
	.byte $ff,$06,$07,$04,$01,$ff
peg5_hold:
	.byte $ff,$0b,$0d,$ff
peg5_jump:
	.byte $ff,$07,$08,$ff
peg6_hold:
	.byte $ff,$00,$03,$0c,$0e,$ff
peg6_jump:
	.byte $ff,$02,$04,$08,$09,$ff
peg7_hold:
	.byte $ff,$01,$08,$ff
peg7_jump:
	.byte $ff,$03,$07,$ff
peg8_hold:
	.byte $ff,$02,$09,$ff
peg8_jump:
	.byte $ff,$04,$08,$ff
peg9_hold:
	.byte $ff,$06,$01,$ff
peg9_jump:
	.byte $ff,$07,$04,$ff
peg10_hold:
	.byte $ff,$07,$02,$ff
peg10_jump:
	.byte $ff,$08,$05,$ff
peg11_hold:
	.byte $ff,$03,$0c,$ff
peg11_jump:
	.byte $ff,$06,$0b,$ff
peg12_hold:
	.byte $ff,$04,$0d,$ff
peg12_jump:
	.byte $ff,$07,$0c,$ff
peg13_hold:
	.byte $ff,$0a,$03,$05,$0e,$ff
peg13_jump:
	.byte $ff,$0b,$07,$08,$0d,$ff
peg14_hold:
	.byte $ff,$0b,$04,$ff
peg14_jump:
	.byte $ff,$0c,$08,$ff
peg15_hold:
	.byte $ff,$0c,$05,$ff
peg15_jump:
	.byte $ff,$0d,$09,$ff
peg2_1:
	lda #<peg1_hold
	sta p2_held_address+0
	lda #>peg1_hold
	sta p2_held_address+1
	lda #<peg1_jump
	sta p2_jump_address+0
	lda #>peg1_jump
	sta p2_jump_address+1
	lda peg1_hold, x
	sta p2_cursor_pos
	rts
peg2_2:
	lda #<peg2_hold
	sta p2_held_address+0
	lda #>peg2_hold
	sta p2_held_address+1
	lda #<peg2_jump
	sta p2_jump_address+0
	lda #>peg2_jump
	sta p2_jump_address+1
	lda peg2_hold, x
	sta p2_cursor_pos
	rts
peg2_3:
	lda #<peg3_hold
	sta p2_held_address+0
	lda #>peg3_hold
	sta p2_held_address+1
	lda #<peg3_jump
	sta p2_jump_address+0
	lda #>peg3_jump
	sta p2_jump_address+1
	lda peg3_hold, x
	sta p2_cursor_pos
	rts
peg2_4:
	lda #<peg4_hold
	sta p2_held_address+0
	lda #>peg4_hold
	sta p2_held_address+1
	lda #<peg4_jump
	sta p2_jump_address+0
	lda #>peg4_jump
	sta p2_jump_address+1
	lda peg4_hold, x
	sta p2_cursor_pos
	rts
peg2_5:
	lda #<peg5_hold
	sta p2_held_address+0
	lda #>peg5_hold
	sta p2_held_address+1
	lda #<peg5_jump
	sta p2_jump_address+0
	lda #>peg5_jump
	sta p2_jump_address+1
	lda peg5_hold, x
	sta p2_cursor_pos
	rts
peg2_6:
	lda #<peg6_hold
	sta p2_held_address+0
	lda #>peg6_hold
	sta p2_held_address+1
	lda #<peg6_jump
	sta p2_jump_address+0
	lda #>peg6_jump
	sta p2_jump_address+1
	lda peg6_hold, x
	sta p2_cursor_pos
	rts
peg2_7:
	lda #<peg7_hold
	sta p2_held_address+0
	lda #>peg7_hold
	sta p2_held_address+1
	lda #<peg7_jump
	sta p2_jump_address+0
	lda #>peg7_jump
	sta p2_jump_address+1
	lda peg7_hold, x
	sta p2_cursor_pos
	rts
peg2_8:
	lda #<peg8_hold
	sta p2_held_address+0
	lda #>peg8_hold
	sta p2_held_address+1
	lda #<peg8_jump
	sta p2_jump_address+0
	lda #>peg8_jump
	sta p2_jump_address+1
	lda peg8_hold, x
	sta p2_cursor_pos
	rts
peg2_9:
	lda #<peg9_hold
	sta p2_held_address+0
	lda #>peg9_hold
	sta p2_held_address+1
	lda #<peg9_jump
	sta p2_jump_address+0
	lda #>peg9_jump
	sta p2_jump_address+1
	lda peg9_hold, x
	sta p2_cursor_pos
	rts
peg2_10:
	lda #<peg10_hold
	sta p2_held_address+0
	lda #>peg10_hold
	sta p2_held_address+1
	lda #<peg10_jump
	sta p2_jump_address+0
	lda #>peg10_jump
	sta p2_jump_address+1
	lda peg10_hold, x
	sta p2_cursor_pos
	rts
peg2_11:
	lda #<peg11_hold
	sta p2_held_address+0
	lda #>peg11_hold
	sta p2_held_address+1
	lda #<peg11_jump
	sta p2_jump_address+0
	lda #>peg11_jump
	sta p2_jump_address+1
	lda peg11_hold, x
	sta p2_cursor_pos
	rts
peg2_12:
	lda #<peg12_hold
	sta p2_held_address+0
	lda #>peg12_hold
	sta p2_held_address+1
	lda #<peg12_jump
	sta p2_jump_address+0
	lda #>peg12_jump
	sta p2_jump_address+1
	lda peg12_hold, x
	sta p2_cursor_pos
	rts
peg2_13:
	lda #<peg13_hold
	sta p2_held_address+0
	lda #>peg13_hold
	sta p2_held_address+1
	lda #<peg13_jump
	sta p2_jump_address+0
	lda #>peg13_jump
	sta p2_jump_address+1
	lda peg13_hold, x
	sta p2_cursor_pos
	rts
peg2_14:
	lda #<peg14_hold
	sta p2_held_address+0
	lda #>peg14_hold
	sta p2_held_address+1
	lda #<peg14_jump
	sta p2_jump_address+0
	lda #>peg14_jump
	sta p2_jump_address+1
	lda peg14_hold, x
	sta p2_cursor_pos
	rts
peg2_15:
	lda #<peg15_hold
	sta p2_held_address+0
	lda #>peg15_hold
	sta p2_held_address+1
	lda #<peg15_jump
	sta p2_jump_address+0
	lda #>peg15_jump
	sta p2_jump_address+1
	lda peg15_hold, x
	sta p2_cursor_pos
	rts

p1_peg_control:
	lda control_pad
	eor control_old
	and control_pad
	and #up_punch
	beq @no_up
		lda p1_locked
		bne @no_up
			ldx p1_cursor_pos
			lda cursor_up_x, x
			sta p1_cursor_pos
			jmp @do_cursor
@no_up:
	lda control_pad
	eor control_old
	and control_pad
	and #down_punch
	beq @no_down
		lda p1_locked
		bne @no_down
			ldx p1_cursor_pos
			lda cursor_down_x, x
			sta p1_cursor_pos
			jmp @do_cursor
@no_down:
	lda control_pad
	eor control_old
	and control_pad
	and #left_punch
	beq @no_left
		lda p1_locked
		beq :++
			ldy p1_held_offset
			dey
			lda (p1_held_address), y
			cmp #$ff
			beq :+
				sta p1_cursor_pos
				sty p1_held_offset
:			jmp @do_cursor
			
:		lda p1_cursor_pos
		beq :+
			sec
			sbc #$01
			sta p1_cursor_pos
			jmp @do_cursor
:		lda #$0e
		sta p1_cursor_pos
		jmp @do_cursor
@no_left:
	lda control_pad
	eor control_old
	and control_pad
	and #right_punch
	beq @no_right
		lda p1_locked
		beq :++
			ldy p1_held_offset
			iny
			lda (p1_held_address), y
			cmp #$ff
			beq :+
				sta p1_cursor_pos
				sty p1_held_offset
:			jmp @do_cursor

:		lda p1_cursor_pos
		cmp #$0e
		beq :+
			clc
			adc #$01
			sta p1_cursor_pos
			jmp @do_cursor
:		lda #$00
		sta p1_cursor_pos
		jmp @do_cursor
@no_right:
	lda control_pad
	eor control_old
	and control_pad
	and #a_punch
	beq @no_a
		lda p1_set
		bne @set
			ldy p1_cursor_pos
			lda #$00
			sta p1_peg01, y
			tay
:			lda peg1_sprites, y
			sta p1peg01, y
			iny
			cpy #60
			bne :-
			jsr p1_associate_sprites
			lda #$ff
			ldy p1_cursor_pos
			sta p1_sprites_y, y
			lda #$01
			sta p1_set
			jmp @do_cursor
@set:
	lda p1_locked
	bne @jump_peg
		ldy p1_cursor_pos
		sty p1_prior_cursor
		lda p1_peg01, y
		beq @cant_do
				lda #$02
				sta p1_sprites_attribs, y
				sta p1_locked
				jsr p1_jumper
				jmp @do_cursor
@cant_do:
	jmp @no_a
@jump_peg:
	lda $150
	ldy p1_cursor_pos
	lda p1_peg01, y
	bne @nope
		ldy p1_held_offset
		lda (p1_jump_address), y
		tax
		lda p1_peg01, x
		beq @nope
			lda #$30
			sta p1_make_move
			jmp @do_cursor
@nope:
@no_a:
	lda control_pad
	eor control_old
	and control_pad
	and #b_punch
	beq @no_b
		lda p1_prior_cursor
		sta p1_cursor_pos
		ldx #$00
		stx p1_locked
		lda #$01
:		sta p1_sprites_attribs, x
		inx
		cpx #$0f
		bne :-
		jmp @do_cursor
@no_b:
	lda control_pad
	and #select_punch
	beq @no_select2
		lda control_pad
		and #start_punch
		beq @no_select2
			ldx #$00
			lda #$ff
:			sta $200, x
			dex
			bne :-
			jsr nmi_wait
			jmp reset
@no_select2:
	lda control_pad
	eor control_old
	and control_pad
	and #select_punch
	beq @no_select
		ldx #$00
		stx p1_set
		stx p1_locked
:		lda #$ff
		sta p1_sprites_y, x
		lda #$01
		sta p1_peg01, x
		sta p1_sprites_attribs, x
		inx
		cpx #$0f
		bne :-
@no_select:
@do_cursor:
	ldx p1_cursor_pos
	lda p1_cursor_y, x
	sta p1cursor
	lda p1_cursor_x, x
	sta p1cursor+3
@done_control:
	rts





p2_peg_control:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #up_punch
	beq @no_up
		lda p2_locked
		bne @no_up
			ldx p2_cursor_pos
			lda cursor_up_x, x
			sta p2_cursor_pos
			jmp @do_cursor
@no_up:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #down_punch
	beq @no_down
		lda p2_locked
		bne @no_down
			ldx p2_cursor_pos
			lda cursor_down_x, x
			sta p2_cursor_pos
			jmp @do_cursor
@no_down:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #left_punch
	beq @no_left
		lda p2_locked
		beq :++
			ldy p2_held_offset
			dey
			lda (p2_held_address), y
			cmp #$ff
			beq :+
				sta p2_cursor_pos
				sty p2_held_offset
:			jmp @do_cursor
			
:		lda p2_cursor_pos
		beq :+
			sec
			sbc #$01
			sta p2_cursor_pos
			jmp @do_cursor
:		lda #$0e
		sta p2_cursor_pos
		jmp @do_cursor
@no_left:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #right_punch
	beq @no_right
		lda $150
		lda p2_locked
		beq :++
			ldy p2_held_offset
			iny
			lda (p2_held_address), y
			cmp #$ff
			beq :+
				sta p2_cursor_pos
				sty p2_held_offset
:			jmp @do_cursor

:		lda p2_cursor_pos
		cmp #$0e
		beq :+
			clc
			adc #$01
			sta p2_cursor_pos
			jmp @do_cursor
:		lda #$00
		sta p2_cursor_pos
		jmp @do_cursor
@no_right:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #a_punch
	beq @no_a
		lda p2_set
		bne @set
			ldy p2_cursor_pos
			lda #$00
			sta p2_peg01, y
			tay
:			lda peg2_sprites, y
			sta p2peg01, y
			iny
			cpy #60
			bne :-
			jsr p2_associate_sprites
			lda #$ff
			ldy p2_cursor_pos
			sta p2_sprites_y, y
			lda #$01
			sta p2_set
			jmp @do_cursor
@set:
	lda p2_locked
	bne @jump_peg
		ldy p2_cursor_pos
		sty p2_prior_cursor
		lda p2_peg01, y
		beq @cant_do
				lda #$02
				sta p2_sprites_attribs, y
				sta p2_locked
				jsr p2_jumper
				jmp @do_cursor
@cant_do:
	jmp @no_a
@jump_peg:
	ldy p2_cursor_pos
	lda p2_peg01, y
	bne @nope
		ldy p2_held_offset
		lda (p2_jump_address), y
		tax
		lda p2_peg01, x
		beq @nope
			lda #$30
			sta p2_make_move
			jmp @do_cursor
@nope:
@no_a:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #b_punch
	beq @no_b
		lda p2_prior_cursor
		sta p2_cursor_pos
		ldx #$00
		stx p2_locked
		lda #$01
:		sta p2_sprites_attribs, x
		inx
		cpx #$0f
		bne :-
		jmp @do_cursor
@no_b:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #select_punch
	beq @no_select
		ldx #$00
		stx p2_set
		stx p2_locked
:		lda #$ff
		sta p2_sprites_y, x
		lda #$01
		sta p2_peg01, x
		sta p2_sprites_attribs, x
		inx
		cpx #$0f
		bne :-
@no_select:
@do_cursor:
	ldx p2_cursor_pos
	lda p2_cursor_y, x
	sta p2cursor
	lda p2_cursor_x, x
	sta p2cursor+3
@done_control:
	rts

p2_associate_sprites:
	ldx #$00
	ldy #$00
:	lda peg2_sprites+0, y
	sta p2_sprites_y, x
	lda peg2_sprites+3, y
	sta p2_sprites_x, x
	lda peg2_sprites+1, y
	sta p2_sprites_tile, x
	lda peg2_sprites+2, y
	sta p2_sprites_attribs, x
	iny
	iny
	iny
	iny
	inx
	cpx #$0f
	bne :-	
	rts
the_p2_sprites_back:
	ldx #$00
	ldy #$00
:	lda p2_sprites_y, x
	sta p2peg01+0, y
	lda p2_sprites_x, x
	sta p2peg01+3, y
	lda p2_sprites_tile, x
	sta p2peg01+1, y
	lda p2_sprites_attribs, x
	sta p2peg01+2, y
	iny
	iny
	iny
	iny
	inx
	cpx #$0f
	bne :-	
	rts
p1_associate_sprites:
	ldx #$00
	ldy #$00
:	lda peg1_sprites+0, y
	sta p1_sprites_y, x
	lda peg1_sprites+3, y
	sta p1_sprites_x, x
	lda peg1_sprites+1, y
	sta p1_sprites_tile, x
	lda peg1_sprites+2, y
	sta p1_sprites_attribs, x
	iny
	iny
	iny
	iny
	inx
	cpx #$0f
	bne :-	
	rts
the_p1_sprites_back:
	ldx #$00
	ldy #$00
:	lda p1_sprites_y, x
	sta p1peg01+0, y
	lda p1_sprites_x, x
	sta p1peg01+3, y
	lda p1_sprites_tile, x
	sta p1peg01+1, y
	lda p1_sprites_attribs, x
	sta p1peg01+2, y
	iny
	iny
	iny
	iny
	inx
	cpx #$0f
	bne :-	
	rts

animate_pegs_palette:							; Here is the animating palette code for the title screen.
	dec gamename_ticker							; This controls the letters in the title of the game
	bne :++										; and also the bouncing cursor. The LUTs for this code
		lda #$0a								; are located right below the subroutine.
		sta gamename_ticker						;
		ldx switch_menu_item					;
		cpx #$05								;
		bne :+									;
			ldx #$00							;
			stx switch_menu_item				;
			jmp @next							;
:		inx										;
		stx switch_menu_item					;
		jmp @next								;
:	ldx switch_menu_item						;
	lda number_of_players
	cmp #$01
	bne @next
		lda game_select
		cmp #$01
		beq :+
			lda words_palette1, x
			sta pal_address+10
			lda words_palette2, x
			sta pal_address+11
			jmp @next
:		lda words_palette1, x					; used for tic tac toe
		sta pal_address+22						;
		lda words_palette2, x					;
		sta pal_address+23						;
@next:
	rts

pegs_board_0:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

pegs_attribs0:
	.byte $00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00

pegs_board_1:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$1d,$1e,$00,$00,$00,$00,$00,$22,$23,$24,$25,$00,$00
	.byte $00,$00,$19,$1a,$1b,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.byte $00,$00,$15,$16,$17,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$1f,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$21,$00

	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$22,$23,$24,$26,$00,$00,$00,$00,$00,$1d,$1e,$00,$00,$00
	.byte $00,$00,$00,$27,$28,$29,$00,$00,$00,$00,$19,$1a,$1b,$1c,$00,$00

	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$16,$17,$18,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

pegs_attribs1:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $ff,$bf,$af,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

pegboard_sprites:
	.byte $ff,$8f,$01,$ff
	.byte $ff,$8f,$01,$ff
peg1_sprites:
	.byte $28,$af,$01,$3c
	.byte $30,$af,$01,$36
	.byte $30,$af,$01,$42
	.byte $38,$af,$01,$31
	.byte $38,$af,$01,$3c
	.byte $38,$af,$01,$47
	.byte $40,$af,$01,$2b
	.byte $40,$af,$01,$36
	.byte $40,$af,$01,$42
	.byte $40,$af,$01,$4d
	.byte $48,$af,$01,$26
	.byte $48,$af,$01,$31
	.byte $48,$af,$01,$3c
	.byte $48,$af,$01,$47
	.byte $48,$af,$01,$52
peg2_sprites:
	.byte $a8,$af,$01,$bc
	.byte $b0,$af,$01,$b6
	.byte $b0,$af,$01,$c2
	.byte $b8,$af,$01,$b1
	.byte $b8,$af,$01,$bc
	.byte $b8,$af,$01,$c7
	.byte $c0,$af,$01,$ab
	.byte $c0,$af,$01,$b6
	.byte $c0,$af,$01,$c2
	.byte $c0,$af,$01,$cd
	.byte $c8,$af,$01,$a6
	.byte $c8,$af,$01,$b1
	.byte $c8,$af,$01,$bc
	.byte $c8,$af,$01,$c7
	.byte $c8,$af,$01,$d2
