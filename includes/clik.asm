clik_sprites:
	.byte $b0,$c4,$01,$58 ; p1_left_head
	.byte $b0,$c5,$01,$60 ; p1_right_head
	.byte $b8,$c6,$01,$58 ; p1_left_bot
	.byte $b8,$c7,$01,$60 ; p1_right_bot
	.byte $b0,$c4,$02,$98 ; p2_left_head
	.byte $b0,$c5,$02,$a0 ; p2_right_head
	.byte $b8,$c6,$02,$98 ; p2_left_bot
	.byte $b8,$c7,$02,$a0 ; p2_right_bot
	.byte $ff,$c0,$03,$ff ; virus_pickup
	.byte $24,$c1,$03,$40 ; e1_left
	.byte $24,$c2,$03,$48 ; e1_mid
	.byte $24,$c3,$03,$50 ; e1_right
	.byte $54,$c1,$03,$78 ; e2_left
	.byte $54,$c2,$03,$80 ; e2_mid
	.byte $54,$c3,$03,$88 ; e2_right
	.byte $74,$c1,$03,$40 ; e3_left
	.byte $74,$c2,$03,$48 ; e3_mid
	.byte $74,$c3,$03,$50 ; e3_right
	.byte $a4,$c1,$03,$c8 ; e4_left
	.byte $a4,$c2,$03,$d0 ; e4_mid
	.byte $a4,$c3,$03,$d8 ; e4_right
	.byte $d8,$30,$01,$50 ; p1_score_tens
	.byte $d8,$30,$01,$58 ; p1_score_ones
	.byte $d8,$30,$01,$a0 ; p2_score_tens
	.byte $d8,$30,$01,$a8 ; p2_score_ones
	.byte $d8,$c0,$03,$44 ; virus_p1
	.byte $d8,$c0,$03,$b4 ; virus_p2
	.byte $d0,$50,$01,$30 ; P
	.byte $d0,$31,$01,$38 ; 1
	.byte $d0,$50,$01,$c0 ; P
	.byte $d0,$32,$01,$c8 ; 2
	.byte $ff,$ac,$01,$70 ; energy1
	.byte $ff,$ac,$01,$78 ; energy2
	.byte $ff,$ac,$01,$80 ; energy3

clik_sprite_palette:
	.byte $21,$00,$30, $0f,$29,$00,$30, $0f,$00,$12,$38

clik_board_0:
	.byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
	.byte $0c,$0c,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$0c,$0c
	.byte $0c,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0e,$0c
	.byte $0c,$0c,$11,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$13,$0c,$0c

	.byte $0c,$0c,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$0c,$0c
	.byte $0c,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0e,$0c
	.byte $0c,$0c,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$0c,$0c
	.byte $0c,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0e,$0c

	.byte $0c,$0c,$11,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$13,$0c,$0c
	.byte $0c,$0c,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$0c,$0c
	.byte $0c,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0e,$0c
	.byte $0c,$0c,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$0c,$0c

	.byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
	.byte $0c,$0c,$00,$00,$00,$00,$00,$00,$00,$27,$28,$29,$00,$00,$0c,$0c
	.byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
	.byte $0c,$0c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0c,$0c

clik_attribs:
	.byte $55,$55,$55,$55,$55,$55,$55,$55, $59,$55,$55,$55,$55,$55,$55,$56
	.byte $95,$55,$55,$55,$55,$55,$55,$65, $95,$55,$ff,$ff,$ff,$ff,$55,$65
	.byte $55,$55,$55,$55,$55,$55,$55,$55, $59,$55,$55,$55,$55,$55,$55,$56
	.byte $55,$55,$55,$55,$f5,$f5,$55,$55, $55,$55,$55,$55,$55,$55,$55,$55

bounding_init:
	.byte $5a,$65,$b2,$be
	.byte $9a,$a5,$b2,$be
	.byte $40,$78,$40,$c8 ; e_hit_left
	.byte $58,$90,$58,$e0 ; e_hit_right
	.byte $24,$54,$74,$a4 ; e_hit_top
	.byte $2a,$5a,$7a,$aa ; e_hit_bottom

e1_speed:
	.byte $01,$02,$01,$01,$02,$02,$03,$03,$03,$04
	.byte $04,$03,$04,$04,$04,$04,$04,$04,$04,$04
e2_speed:
	.byte $02,$01,$02,$02,$01,$03,$02,$04,$03,$04
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
e3_speed:
	.byte $01,$02,$02,$03,$02,$02,$03,$03,$04,$03
	.byte $03,$04,$04,$04,$04,$04,$04,$04,$04,$04
e4_speed:
	.byte $01,$01,$01,$02,$03,$03,$03,$02,$03,$04
	.byte $04,$04,$03,$04,$04,$04,$04,$04,$04,$04

beat_clik:
	.byte "CONGRATULATIONS",$5c
p1_wins:
	.byte "P1",$00,"WINS",$5c
p2_wins:
	.byte "P2",$00,"WINS",$5c
its_over:
	.byte "GAME",$00,"OVER"

spark_x:
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4
	.byte $34,$44,$74,$84,$b4,$c4
spark_y:
	.byte $14,$14,$14,$14,$14,$14,$14,$14,$14,$14
	.byte $24,$24,$24,$24,$24,$24,$24,$24,$24,$24
	.byte $34,$34,$34,$34,$34,$34,$34,$34,$34,$34
	.byte $44,$44,$44,$44,$44,$44,$44,$44,$44,$44
	.byte $54,$54,$54,$54,$54,$54,$54,$54,$54,$54
	.byte $64,$64,$64,$64,$64,$64,$64,$64,$64,$64
	.byte $74,$74,$74,$74,$74,$74,$74,$74,$74,$74
	.byte $84,$84,$84,$84,$84,$84,$84,$84,$84,$84
	.byte $94,$94,$94,$94,$94,$94,$94,$94,$94,$94
	.byte $a4,$a4,$a4,$a4,$a4,$a4,$a4,$a4,$a4,$a4
	.byte $b4,$b4,$b4,$b4,$b4,$b4

elec_walls_palette:
	.byte $17,$16,$15,$14,$15,$16
virus_pal1:
	.byte $38,$12,$38,$12,$38,$12
virus_pal2:
	.byte $12,$38,$12,$38,$12,$38
words_palette1:
	.byte $0f,$0f,$0f,$10,$10,$10
words_palette2:
	.byte $0f,$0f,$0f,$30,$30,$30
words_palette3:
	.byte $0f,$0f,$0f,$0f,$0f,$0f

e_speed_offset_table:
	.byte $0a,$14,$1e,$28,$32,$3c,$46,$50,$5a,$64
e_speed_offset_2p:
	.byte $05,$0a,$0f,$14,$19,$1e,$23,$28,$2d,$32

was_hit_table:
	.byte $30,$60,$80,$b0

clik_loop:
	lda scroll_it
	beq @gameplay
		lda scroll_y
		clc
		adc #$01
		sta scroll_y
		cmp #$d4
		bne :+
			lda #$0f
			sta pal_address+14
			sta pal_address+15
:		cmp #$ef
		beq :+
			jmp @nmi
:			lda #$00
			sta scroll_it
			; bring in all sprites here
			lda #$01
			sta start_game
			lda #$3c
			sta one_second
			lda #$04
			sta big_seconds
			jmp @nmi					; Always branch to wait for one more NMI
@gameplay:
	lda start_gameplay
	beq :+
		jmp @now_playing
:	lda start_game
	bne :+
		jmp @nmi
:		ldx #$00						; Pull in bytes for sprites and their
	:	lda clik_sprites, x				; attributes which are stored in the
		sta p1_left_head, x				; 'the_sprites' table. Use X as an index
		inx								; to load and store each byte, which
		cpx #$88						; get stored starting in $200, where
		bne :-							; 'left_cursor' is located at.
		ldx #$00
	:	lda clik_sprite_palette, x
		sta pal_address+21, x
		inx
		cpx #$0b
		bne :-
		ldx #$00						; Pull in the initial bounding boxes
:		lda bounding_init, x			;
		sta p1_left, x					;
		inx								;
		cpx #$18						;
		bne :-							;
		lda #$40
		sta e_anim_count
;		lda #$37
;		sta rand_num
		lda #$01
		sta start_gameplay
		sta e_state
		sta e_state+3
		lda #$02
		jsr music_loadsong
		lda #$00
		sta temp
		lda #$0a
		sta gamename_ticker
		lda number_of_players
		cmp #$01
		beq :+
			jmp @nmi
:			lda #$ff
			sta p2_left_head
			sta p2_right_head
			sta p2_left_bot
			sta p2_right_bot
			sta p2_left
			sta p2_right
			sta p2_top
			sta p2_bottom
			sta virus_p2
			sta p2_score_tens
			sta p2_score_ones
			lda #$d8
			sta energy1
			sta energy2
			sta energy3

@now_playing:
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
	jsr do_random_number
	jsr spark_placement
	jsr p1_hit
	jsr check_p1_spark_collision
	ldx #$00
		jsr check_p1_e_collision
	jsr p1_control
	lda number_of_players
	cmp #$01
	beq :+
		jsr p2_hit
		jsr check_p2_spark_collision
		ldx #$00
			jsr check_p2_e_collision
		jsr p2_control
:	jsr load_e_speed
	ldy #$00
	ldx #$00
		jsr shock_move
	jsr animate_enemies
	ldx #$00
		jsr test_e_state
	jsr animate_clik_palette
	lda number_of_players
	cmp #$02
	beq :+
		jsr p2_start_game
		lda game_over
		beq :+
			lda #$04
			jsr music_loadsong
			lda reg2001_save
			eor #%00010000
			sta reg2001_save
			lda #$10
			sta pal_address+14
			lda #$30
			sta pal_address+15
			jmp test_loop
:	lda number_of_players
	cmp #$02
	beq :++
		lda spark_counter
		cmp #$63
		beq :+
			jmp @nmi
:		lda #$02
		sta beat_game
		lda #$03
		jsr music_loadsong
		lda reg2001_save
		eor #%00010000
		sta reg2001_save
		lda #$10
		sta pal_address+14
		lda #$30
		sta pal_address+15
		lda #$53
		sta slydog+6
		lda #$54
		sta slydog+7
		lda #$55
		sta slydog+8
		lda #$44
		sta slydog+9
		lda #$49
		sta slydog+10
		lda #$4f
		sta slydog+11
		lda #$53
		sta slydog+12
		jmp test_loop
:	lda p1_pickup
	cmp #$32
	bne :++
:		lda #$03
		jsr music_loadsong
		lda reg2001_save
		eor #%00010000
		sta reg2001_save
		lda #$10
		sta pal_address+14
		lda #$30
		sta pal_address+15
		jmp test_loop
:	lda p2_pickup
	cmp #$32
	bne @nmi
		jmp :--
@nmi:
;	jsr nmi_wait
	jmp end_loop	;clik_loop

clik_play_nmi:
	lda beat_game
	beq dont_do_it
		lda beat_game
		cmp #$01
		bne clear_push_start
			ldx #$00
			lda #$29
			sta $2006
			lda #$88
			sta $2006
:			lda beat_clik, x
			sta $2007
			inx
			cpx #$10
			bne :-
			lda #$00
			sta beat_game
			jmp dont_do_it
clear_push_start:
		lda #$2b
		sta $2006
		lda #$52
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		lda #$2b
		sta $2006
		lda #$73
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		lda #$01
		sta beat_game
		jmp all_done
dont_do_it:
	lda game_over
	beq :++
		ldx #$00
		lda #$29
		sta $2006
		lda #$8c
		sta $2006
:		lda its_over, x
		sta $2007
		inx
		cpx #$09
		bne :-
		lda #$2b
		sta $2006
		lda #$52
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		lda #$2b
		sta $2006
		lda #$73
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		lda #$00
		sta game_over
		jmp all_done
:	lda number_of_players
	cmp #$02
	beq :+
		jmp all_done
:	lda p1_pickup
	cmp #$32
	bne :++
		ldx #$00
		lda #$29
		sta $2006
		lda #$8c
		sta $2006
:		lda p1_wins, x
		sta $2007
		inx
		cpx #$08
		bne :-
		lda #$2b
		sta $2006
		lda #$52
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		lda #$2b
		sta $2006
		lda #$73
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		jmp all_done
:	lda p2_pickup
	cmp #$32
	bne :++
		ldx #$00
		lda #$29
		sta $2006
		lda #$8c
		sta $2006
:		lda p2_wins, x
		sta $2007
		inx
		cpx #$08
		bne :-
		lda #$2b
		sta $2006
		lda #$52
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		lda #$2b
		sta $2006
		lda #$73
		sta $2006
		lda #$00
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		sta $2007
		jmp all_done
:
all_done:
	jmp finish_nmi
test_loop:
	lda one_second					; This loop is just a delay to allow
	sec                             ;  the music to play out before setting
	sbc #$01						;  the reset flag (reset_game) to allow
	sta one_second					;  for a reset to happen (snail.asm).
	bne @end						;
		lda #$3c					;
		sta one_second				;
		lda big_seconds				;
		sec							;
		sbc #$01					;
		sta big_seconds				;
		bne @end					;
			jmp @finally			;
@end:
	jsr nmi_wait
	jmp test_loop
@finally:
	ldx #$00
:	lda #$0f
	sta pal_address, x
	inx
	cpx #$20
	bne :-
	jsr nmi_wait
	jmp reset


shock_move:
	lda e_state, x
	beq :+
		lda e1_left+3, y
		sec
		sbc e_speed, x
		sta e1_left+3, y
		iny
		iny
		iny
		iny
		lda e1_left+3, y
		sec
		sbc e_speed, x
		sta e1_left+3, y
		iny
		iny
		iny
		iny
		lda e1_left+3, y
		sec
		sbc e_speed, x
		sta e1_left+3, y
		iny
		iny
		iny
		iny
		lda e_hit_left, x
		sec
		sbc e_speed, x
		sta e_hit_left, x
		lda e_hit_right, x
		sec
		sbc e_speed, x
		sta e_hit_right, x
		jmp @check_end
:	lda e1_left+3, y
	clc
	adc e_speed, x
	sta e1_left+3, y
	iny
	iny
	iny
	iny
	lda e1_left+3, y
	clc
	adc e_speed, x
	sta e1_left+3, y
	iny
	iny
	iny
	iny
	lda e1_left+3, y
	clc
	adc e_speed, x
	sta e1_left+3, y
	iny
	iny
	iny
	iny
	lda e_hit_left, x
	clc
	adc e_speed, x
	sta e_hit_left, x
	lda e_hit_right, x
	clc
	adc e_speed, x
	sta e_hit_right, x
@check_end:
	inx
	cpx #$04
	beq :+
		jmp shock_move
:	rts

check_p1_spark_collision:
	lda spark_left
	cmp p1_right
	bcs @no_spark_collision
	lda spark_right
	cmp p1_left
	bcc @no_spark_collision
	lda spark_top
	cmp p1_bottom
	bcs @no_spark_collision
	lda spark_bottom
	cmp p1_top
	bcc @no_spark_collision
		ldx spark_count
		lda spark_counter
		clc
		adc #$01
		sta spark_counter
		lda p1_pickup
		clc
		adc #$01
		sta p1_pickup
		lda number_of_players
		cmp #$02
		bne :+
			lda spark_counter
			cmp e_speed_offset_2p, x
			bne :++
				lda spark_count
				clc
				adc #$01
				sta spark_count
				jmp :++
:		lda spark_counter
		cmp e_speed_offset_table, x
		bne :+
			lda spark_count
			clc
			adc #$01
			sta spark_count
:		lda #$00
		sta spark_state
		lda #$ff
		sta virus_pickup
		lda p1_score_ones+1
		cmp #$39
		bne :+
			lda #$2f
			sta p1_score_ones+1
			lda p1_score_tens+1
			clc
			adc #$01
			sta p1_score_tens+1
:		lda p1_score_ones+1
		clc
		adc #$01
		sta p1_score_ones+1
		lda #$01
		jsr music_loadsfx
	jmp @done_collision
@no_spark_collision:
	lda #$00
	sta p1_spark_result
@done_collision:
	rts

check_p2_spark_collision:
	lda spark_left
	cmp p2_right
	bcs @no_spark_collision
	lda spark_right
	cmp p2_left
	bcc @no_spark_collision
	lda spark_top
	cmp p2_bottom
	bcs @no_spark_collision
	lda spark_bottom
	cmp p2_top
	bcc @no_spark_collision
		ldx spark_count
		lda spark_counter
		clc
		adc #$01
		sta spark_counter
		lda p2_pickup
		clc
		adc #$01
		sta p2_pickup
		lda number_of_players
		cmp #$02
		bne :+
			lda spark_counter
			cmp e_speed_offset_2p, x
			bne :++
				lda spark_count
				clc
				adc #$01
				sta spark_count
				jmp :++
:		lda spark_counter
		cmp e_speed_offset_table, x
		bne :+
			lda spark_count
			clc
			adc #$01
			sta spark_count
:		lda #$00
		sta spark_state
		lda #$ff
		sta virus_pickup
		lda p2_score_ones+1
		cmp #$39
		bne :+
			lda #$2f
			sta p2_score_ones+1
			lda p2_score_tens+1
			clc
			adc #$01
			sta p2_score_tens+1
:		lda p2_score_ones+1
		clc
		adc #$01
		sta p2_score_ones+1
		lda #$02
		jsr music_loadsfx
	jmp @done_collision
@no_spark_collision:
	lda #$00
	sta p2_spark_result
@done_collision:
	rts


check_p1_e_collision:
	lda e_hit_left, x
	cmp p1_right
	bcs @no_e_collision
	lda e_hit_right, x
	cmp p1_left
	bcc @no_e_collision
	lda e_hit_top, x
	cmp p1_bottom
	bcs @no_e_collision
	lda e_hit_bottom, x
	cmp p1_top
	bcc @no_e_collision
		lda #$3c
		sta p1_coll_result
		lda was_hit_table, x
		sta p1_left_head
		sta p1_right_head
		clc
		adc #$08
		sta p1_left_bot
		sta p1_right_bot
		lda p1_left_head
		clc
		adc #$02
		sta p1_top
		clc
		adc #$0a
		sta p1_bottom
		lda number_of_players
		cmp #$02
		beq :+
			jsr test_p1_death
:		lda #$03
		jsr music_loadsfx
	jmp @check_done
@no_e_collision:
;	lda p1_coll_result
;	bne :+
;	lda #$00
;	sta p1_coll_result
@check_done:
	inx
	cpx #$04
	bne check_p1_e_collision
	rts

	ldx #$00
check_p2_e_collision:
	lda e_hit_left, x
	cmp p2_right
	bcs @no_e_collision
	lda e_hit_right, x
	cmp p2_left
	bcc @no_e_collision
	lda e_hit_top, x
	cmp p2_bottom
	bcs @no_e_collision
	lda e_hit_bottom, x
	cmp p2_top
	bcc @no_e_collision
	lda #$01
	sta p2_coll_result
		lda #$3c
		sta p2_coll_result
		lda was_hit_table, x
		sta p2_left_head
		sta p2_right_head
		clc
		adc #$08
		sta p2_left_bot
		sta p2_right_bot
		lda p2_left_head
		clc
		adc #$02
		sta p2_top
		clc
		adc #$0a
		sta p2_bottom
		lda #$03
		jsr music_loadsfx
	jmp @check_done
@no_e_collision:
;	lda #$00
;	sta p2_coll_result
@check_done:
	inx
	cpx #$04
	bne check_p2_e_collision
	rts

check_players_collision:
	lda p1_left
	cmp p2_right
	bcs @no_players_collision
	lda p1_right
	cmp p2_left
	bcc @no_players_collision
	lda p1_top
	cmp p2_bottom
	bcs @no_players_collision
	lda p1_bottom
	cmp p2_top
	bcc @no_players_collision
	lda #$01
	sta players_result
	jmp @done_collision
@no_players_collision:
	lda #$00
	sta players_result
@done_collision:
	rts

p1_control:
	lda no_control
	beq :+
		jmp @no_right
:	lda p1_left_head
	cmp #$0f
	bcs :+
		jmp @no_up
:	lda control_pad
	and #up_punch
	beq @no_up
		lda #$c8
		sta p1_left_head+1
		lda #$c9
		sta p1_right_head+1
		lda #$b8
		sta p1_left_bot+1
		lda #$b9
		sta p1_right_bot+1
		dec p1_left_head
		dec p1_left_head
		dec p1_right_head
		dec p1_right_head
		dec p1_left_bot
		dec p1_left_bot
		dec p1_right_bot
		dec p1_right_bot
		dec p1_top
		dec p1_top
		dec p1_bottom
		dec p1_bottom
		jmp @no_right
@no_up:
	lda p1_left_bot
	cmp #$b8
	bcc :+
		jmp @no_down
:	lda control_pad
	and #down_punch
	beq @no_down
		lda #$c4
		sta p1_left_head+1
		lda #$c5
		sta p1_right_head+1
		lda #$c6
		sta p1_left_bot+1
		lda #$c7
		sta p1_right_bot+1
		inc p1_left_head
		inc p1_left_head
		inc p1_right_head
		inc p1_right_head
		inc p1_left_bot
		inc p1_left_bot
		inc p1_right_bot
		inc p1_right_bot
		inc p1_top
		inc p1_top
		inc p1_bottom
		inc p1_bottom
		jmp @no_right
@no_down:
	lda p1_left_head+3
	cmp #$29
	bcs :+
		jmp @no_left
:	lda control_pad
	and #left_punch
	beq @no_left
		lda #$ba
		sta p1_left_head+1
		lda #$bb
		sta p1_right_head+1
		lda #$bc
		sta p1_left_bot+1
		lda #$bd
		sta p1_right_bot+1
		dec p1_left_head+3
		dec p1_left_head+3
		dec p1_right_head+3
		dec p1_right_head+3
		dec p1_left_bot+3
		dec p1_left_bot+3
		dec p1_right_bot+3
		dec p1_right_bot+3
		dec p1_left
		dec p1_left
		dec p1_right
		dec p1_right
		jmp @no_right
@no_left:
	lda p1_left_head+3
	cmp #$c8
	bcc :+
		jmp @no_right
:	lda control_pad
	and #right_punch
	beq @no_right
		lda #$be
		sta p1_left_head+1
		lda #$bf
		sta p1_right_head+1
		lda #$b6
		sta p1_left_bot+1
		lda #$b7
		sta p1_right_bot+1
		inc p1_left_head+3
		inc p1_left_head+3
		inc p1_right_head+3
		inc p1_right_head+3
		inc p1_left_bot+3
		inc p1_left_bot+3
		inc p1_right_bot+3
		inc p1_right_bot+3
		inc p1_left
		inc p1_left
		inc p1_right
		inc p1_right
@no_right:
	rts

p2_control:
	lda no_control2
	beq :+
		jmp @no_right
:	lda p2_left_head
	cmp #$0f
	bcs :+
		jmp @no_up
:	lda control_pad2
	and #up_punch
	beq @no_up
		lda #$c8
		sta p2_left_head+1
		lda #$c9
		sta p2_right_head+1
		lda #$b8
		sta p2_left_bot+1
		lda #$b9
		sta p2_right_bot+1
		dec p2_left_head
		dec p2_left_head
		dec p2_right_head
		dec p2_right_head
		dec p2_left_bot
		dec p2_left_bot
		dec p2_right_bot
		dec p2_right_bot
		dec p2_top
		dec p2_top
		dec p2_bottom
		dec p2_bottom
		jmp @no_right
@no_up:
	lda p2_left_bot
	cmp #$b8
	bcc :+
		jmp @no_down
:	lda control_pad2
	and #down_punch
	beq @no_down
		lda #$c4
		sta p2_left_head+1
		lda #$c5
		sta p2_right_head+1
		lda #$c6
		sta p2_left_bot+1
		lda #$c7
		sta p2_right_bot+1
		inc p2_left_head
		inc p2_left_head
		inc p2_right_head
		inc p2_right_head
		inc p2_left_bot
		inc p2_left_bot
		inc p2_right_bot
		inc p2_right_bot
		inc p2_top
		inc p2_top
		inc p2_bottom
		inc p2_bottom
		jmp @no_right
@no_down:
	lda p2_left_head+3
	cmp #$29
	bcs :+
		jmp @no_left
:	lda control_pad2
	and #left_punch
	beq @no_left
		lda #$ba
		sta p2_left_head+1
		lda #$bb
		sta p2_right_head+1
		lda #$bc
		sta p2_left_bot+1
		lda #$bd
		sta p2_right_bot+1
		dec p2_left_head+3
		dec p2_left_head+3
		dec p2_right_head+3
		dec p2_right_head+3
		dec p2_left_bot+3
		dec p2_left_bot+3
		dec p2_right_bot+3
		dec p2_right_bot+3
		dec p2_left
		dec p2_left
		dec p2_right
		dec p2_right
		jmp @no_right
@no_left:
	lda p2_left_head+3
	cmp #$c8
	bcc :+
		jmp @no_right
:	lda control_pad2
	and #right_punch
	beq @no_right
		lda #$be
		sta p2_left_head+1
		lda #$bf
		sta p2_right_head+1
		lda #$b6
		sta p2_left_bot+1
		lda #$b7
		sta p2_right_bot+1
		inc p2_left_head+3
		inc p2_left_head+3
		inc p2_right_head+3
		inc p2_right_head+3
		inc p2_left_bot+3
		inc p2_left_bot+3
		inc p2_right_bot+3
		inc p2_right_bot+3
		inc p2_left
		inc p2_left
		inc p2_right
		inc p2_right
@no_right:
	rts

load_e_speed:
	ldx spark_count
	lda e1_speed, x
	sta e_speed
	lda e2_speed, x
	sta e_speed+1
	lda e3_speed, x
	sta e_speed+2
	lda e4_speed, x
	sta e_speed+3
	rts

test_e_state:
	lda e_hit_left, x
	cmp #$18
	bcc :+
	bcs :++
:		lda #$00
		sta e_state, x
		jmp @next
:	lda e_hit_right, x
	cmp #$e9
	bcc @next
		lda #$01
		sta e_state, x
@next:
	inx
	cpx #$04
	bne test_e_state
	rts

do_random_number:
	lda rand_num
	cmp #105
	bne :+
		lda #$00
		sta rand_num
		jmp @done_rand
:	inc rand_num
@done_rand:
	rts

spark_placement:
	lda spark_state
	beq :+
		jmp @no_change
:	lda rand_num
	cmp p1_prior_cursor
	bne :+
		clc
		adc #4
		sta rand_num
		cmp #106
		bcc :+
			lda #$00
			sta rand_num
:	ldx rand_num
	stx p1_prior_cursor
	lda spark_y, x
	sta virus_pickup
	sta spark_top
	clc
	adc #$08
	sta spark_bottom
	lda spark_x, x
	sta virus_pickup+3
	sta spark_left
	clc
	adc #$08
	sta spark_right
	lda #$01
	sta spark_state
@no_change:
	rts

animate_enemies:
	lda e_anim_count
	cmp #$40
	bne :+
		lda e1_left+2
		eor #$80
		sta e1_left+2
		sta e2_left+2
		sta e3_left+2
		sta e4_left+2
		jmp @done
:	cmp #$30
	bne :+
		lda e1_mid+2
		eor #$80
		sta e1_mid+2
		sta e2_mid+2
		sta e3_mid+2
		sta e4_mid+2
		jmp @done
:	cmp #$20
	bne :+
		lda e1_right+2
		eor #$80
		sta e1_right+2
		sta e2_right+2
		sta e3_right+2
		sta e4_right+2
		jmp @done
:	cmp #$10
	bne @done
		lda e1_mid+2
		eor #$80
		sta e1_mid+2
		sta e2_mid+2
		sta e3_mid+2
		sta e4_mid+2
@done:
	lda e_anim_count
	bne :+
		lda #$41
		sta e_anim_count
:	sec
	sbc #$01
	sta e_anim_count
	rts

animate_clik_palette:							; Here is the animating palette code for the title screen.
	dec gamename_ticker							; This controls the letters in the title of the game
	bne :++										; and also the bouncing cursor. The LUTs for this code
		lda #$0a								; are located right below the subroutine.
		sta gamename_ticker						;
		ldx temp								;
		cpx #$05								;
		bne :+									;
			ldx #$00							;
			stx temp							;
			jmp @next							;
:		inx										;
		stx temp								;
		jmp @next								;
:	ldx temp									;
	lda elec_walls_palette, x					;
	sta pal_address+10							;
	lda virus_pal1, x
	sta pal_address+30
	lda virus_pal2, x
	sta pal_address+31
	lda number_of_players
	cmp #$01
	bne :+
		lda words_palette1, x
		sta pal_address+14
		lda words_palette2, x
		sta pal_address+15
		jmp @next
:	lda words_palette3, x
	sta pal_address+14
	sta pal_address+15
@next:
	rts

p1_hit:
	lda p1_coll_result
	bne :+
		rts
:	lda p1_coll_result
	sec
	sbc #$01
	sta p1_coll_result
	bne :+
		lda #$00
		sta no_control
		lda #$21
		sta pal_address+21
		lda #$c4
		sta p1_left_head+1
		lda #$c5
		sta p1_right_head+1
		lda #$c6
		sta p1_left_bot+1
		lda #$c7
		sta p1_right_bot+1
		lda #$ac
		sta energy1+1
		sta energy2+1
		sta energy3+1
		rts
:	lda #$15
	sta pal_address+21
	lda #$01
	sta no_control
	lda #$b4
	sta p1_left_head+1
	lda #$b5
	sta p1_right_head+1
	lda #$ad
	sta p1_left_bot+1
	lda #$ae
	sta p1_right_bot+1
	lda #$ab
	sta energy1+1
	sta energy2+1
	sta energy3+1
	rts

p2_hit:
	lda p2_coll_result
	bne :+
		rts
:	lda p2_coll_result
	sec
	sbc #$01
	sta p2_coll_result
	bne :+
		lda #$00
		sta no_control2
		lda #$29
		sta pal_address+25
		lda #$c4
		sta p2_left_head+1
		lda #$c5
		sta p2_right_head+1
		lda #$c6
		sta p2_left_bot+1
		lda #$c7
		sta p2_right_bot+1
		rts
:	lda #$15
	sta pal_address+25
	lda #$01
	sta no_control2
	lda #$b4
	sta p2_left_head+1
	lda #$b5
	sta p2_right_head+1
	lda #$ad
	sta p2_left_bot+1
	lda #$ae
	sta p2_right_bot+1
	rts

p2_start_game:
	lda control_pad2
	and #start_punch
	beq @no_push
		lda #$30
		sta p1_score_tens+1
		sta p1_score_ones+1
		lda #$00
		sta spark_count
		sta spark_counter
		sta p1_pickup
		sta p2_pickup
		lda #$ff
		sta energy1
		sta energy2
		sta energy3
		ldx #$00
:		lda clik_sprites, x
		sta p1_left_head, x
		inx
		cpx #$20
		bne :-
		ldx #$00
:		lda bounding_init, x
		sta p1_left, x
		inx
		cpx #$08
		bne :-
		lda #$d8
		sta p2_score_tens
		sta p2_score_ones
		sta virus_p2
		lda #$a0
		sta p2_score_tens+3
		lda #$a8
		sta p2_score_ones+3
		lda #$02
		sta number_of_players
		lda #$b4
		sta virus_p2+3
		lda #$04
		jsr music_loadsfx
@no_push:
	rts

test_p1_death:
	lda energy3
	cmp #$ff
	beq :+
		lda #$ff
		sta energy3
		rts
:	lda energy2
	cmp #$ff
	beq :+
		lda #$ff
		sta energy2
		rts
:	lda #$01
	sta game_over
	rts
	