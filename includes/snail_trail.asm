final_loop:
	lda control_pad					; B button check/routine
	eor control_old
	and control_pad
	and #start_punch
	beq @no_start
		jsr nmi_wait
		jmp snail_start
@no_start:
	lda control_pad					; B button check/routine
	eor control_old
	and control_pad
	and #select_punch
	beq @no_select
		jsr nmi_wait
		jmp reset
@no_select:
	jsr nmi_wait
	jmp final_loop

snail_dead_loop:
	lda snail_winner
	cmp #$01
	bne @try_2
		lda p2_shell
		cmp #$f8
		bne :+
			lda p2_head
			cmp #$f8
			bne :+
				jsr words_setup
				lda #$04
				sta snail_winner
				jmp final_loop
:		lda p2_shell
		cmp #$f8
		beq :+
			inc p2_shell
;			inc p2_shell
:		lda p2_head
		cmp #$f8
		beq :+
			dec p2_head
;			dec p2_head
:		jmp @done
@try_2:
	cmp #$02
	bne @try_3
		lda p1_shell+3
		bne :+
			lda p1_head+3
			bne :+
				jsr words_setup
				lda #$04
				sta snail_winner
				jmp final_loop
:		lda p1_shell+3
		beq :+
			inc p1_shell+3
;			inc p1_shell+3
:		lda p1_head+3
		beq :+
			dec p1_head+3
;			dec p1_head+3
:		jmp @done
@try_3:
		lda p1_shell+3
		bne :+
			lda p1_head+3
			bne :+
				lda p2_shell
				cmp #$f8
				bne :+
					lda p2_head
					cmp #$f8
					bne :+
						jsr words_setup
						lda #$04
						sta snail_winner
						jmp final_loop
:		lda p1_shell+3
		beq :+
			inc p1_shell+3
;			inc p1_shell+3
:		lda p1_head+3
		beq :+
			dec p1_head+3
;			dec p1_head+3
:

		lda p2_shell
		cmp #$f8
		beq :+
			inc p2_shell
;			inc p2_shell
:		lda p2_head
		cmp #$f8
		beq :+
			dec p2_head
;			dec p2_head
:
@done:
	jsr nmi_wait
	jmp snail_dead_loop

snail_loop:
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
	lda p1_shell
	cmp p2_shell
	bne :+
		lda p1_shell+3
		cmp p2_shell+3
		bne :+
			lda #$0a
			jsr music_loadsong
			lda #$03
			sta snail_winner
			jmp snail_dead_loop
:	lda snail_winner
	beq :+
		lda #$0a
		jsr music_loadsong
		jmp snail_dead_loop
:	jsr p1_get_pos
	jsr p2_get_pos
	jsr p1_hit_test
	jsr p2_hit_test
	jsr p1_movement
	jsr p2_movement
	jsr p1_controllers
	jsr p2_controllers
@the_nmi:
	jsr nmi_wait
				lda #<snail_play_nmi
				sta nmi_pointer
				lda #>snail_play_nmi
				sta nmi_pointer+1
	jmp snail_loop

p1_snail_win:
	.byte $00,"P1",$00,"WINS",$5c,$00
p2_snail_win:
	.byte $00,"P2",$00,"WINS",$5c,$00
no_one_wins:
	.byte "BOTH",$00,"LOSE",$5c
title_screen_words:
	.byte "PUSH",$00,"SELECT",$00,"FOR",$00,"TITLE"
replay_words:
	.byte "PUSH",$00,"START",$00,"TO",$00,"REPLAY"
snail_play_nmi:
	lda snail_winner
	cmp #$04
	bne @no_winner
		lda #$20
		sta $2006
		lda #$cb
		sta $2006
		ldx #$00
:		lda $400, x
		sta $2007
		inx
		cpx #$0a
		bne :-
		ldx #$00
		lda #$21
		sta $2006
		lda #$06
		sta $2006
		ldx #$00
:		lda $500, x
		sta $2007
		inx
		cpx #(replay_words - title_screen_words)
		bne :-
		ldx #$00
		lda #$21
		sta $2006
		lda #$46
		sta $2006
		ldx #$00
:		lda $600, x
		sta $2007
		inx
		cpx #(snail_play_nmi - replay_words)
		bne :-
		jmp finish_nmi
@no_winner:
	lda snail_winner
	bne @p2_not_set
	lda p1_set
	beq @p1_not_set
		ldy #$00
		lda (game_pic_addy_lo), y
		sta $2006
		lda (game_pic_pointer2), y
		sta $2006
		lda #$88
		sta $2007
		lda #$01
		sta (e_hit_right), y
		lda #$00
		sta p1_set
@p1_not_set:
	lda p2_set
	beq @p2_not_set
		ldy #$00
		lda (p2_jump_address), y
		sta $2006
		lda (p2_held_address), y
		sta $2006
		lda #$97
		sta $2007
		lda #$01
		sta (e_hit_right+2), y
		lda #$00
		sta p2_set
@p2_not_set:
	jmp finish_nmi

words_setup:
	lda snail_winner
	cmp #$01
	bne :++
		ldx #$00
:		lda p1_snail_win, x
		sta $400, x
		inx
		cpx #$0a
		bne :-
		jmp @do_the_rest
:	cmp #$02
	bne :++
		ldx #$00
:		lda p2_snail_win, x
		sta $400, x
		inx
		cpx #$0a
		bne :-
		jmp @do_the_rest
:	ldx #$00
:	lda no_one_wins, x
	sta $400, x
	inx
	cpx #$0a
	bne :-
@do_the_rest:
	ldx #$00
:	lda title_screen_words, x
	sta $500, x
	inx
	cpx #(replay_words - title_screen_words)
	bne :-
	ldx #$00
:	lda replay_words, x
	sta $600, x
	inx
	cpx #(snail_play_nmi - replay_words)
	bne :-
	lda #$ff
	sta p1_shell
	sta p1_head
	sta p2_shell
	sta p2_head
	rts


p2_move_table:
	.addr p1_no_move-1, p2_move_up-1, p2_move_down-1, p2_move_left-1, p2_move_right-1
	.addr p2_move_up2-1, p2_move_down2-1, p2_move_left2-1, p2_move_right2-1
p1_move_table:
	.addr p1_no_move-1, p1_move_up-1, p1_move_down-1, p1_move_left-1, p1_move_right-1
	.addr p1_move_up2-1, p1_move_down2-1, p1_move_left2-1, p1_move_right2-1
p1_no_move:
	rts
p1_move_up:
	lda #$b3
	sta p1_shell+1
	lda #$a3
	sta p1_head+1
	lda temp
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp
		dec p1_head
		rts
:	lda #$05
	sta e_state+0
	rts
p1_move_down:
	lda #$a2
	sta p1_shell+1
	lda #$b2
	sta p1_head+1
	lda temp
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp
		inc p1_head
		rts
:	lda #$06
	sta e_state+0
	rts
p1_move_left:
	lda #$a1
	sta p1_shell+1
	lda #$a0
	sta p1_head+1
	lda temp
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp
		dec p1_head+3
		rts
:	lda #$07
	sta e_state+0
	rts
p1_move_right:
	lda #$b0
	sta p1_shell+1
	lda #$b1
	sta p1_head+1
	lda temp
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp
		inc p1_head+3
		rts
:	lda #$08
	sta e_state+0
	rts
p1_move_up2:
	lda temp
	beq :+
	sec
	sbc #$01
	sta temp
		dec p1_shell
		rts
:	lda e_state+1
	sta e_state+0
			lda #$10
			sta temp
	lda #$01
	sta p1_set
	dec p1_top
	rts
p1_move_down2:
	lda temp
	beq :+
	sec
	sbc #$01
	sta temp
		inc p1_shell
		rts
:	lda e_state+1
	sta e_state+0
			lda #$10
			sta temp
	lda #$01
	sta p1_set
	inc p1_top
	rts
p1_move_left2:
	lda temp
	beq :+
	sec
	sbc #$01
	sta temp
		dec p1_shell+3
		rts
:	lda e_state+1
	sta e_state+0
			lda #$10
			sta temp
	lda #$01
	sta p1_set
	dec p1_left
	rts
p1_move_right2:
	lda temp
	beq :+
	sec
	sbc #$01
	sta temp
		inc p1_shell+3
		rts
:	lda e_state+1
	sta e_state+0
			lda #$10
			sta temp
	lda #$01
	sta p1_set
	inc p1_left
	rts
p1_movement:
	lda e_state+0
	asl a
	tay
	lda p1_move_table+1, y
	pha
	lda p1_move_table, y
	pha
	rts
p2_movement:
	lda e_state+2
	asl a
	tay
	lda p2_move_table+1, y
	pha
	lda p2_move_table, y
	pha
	rts
p1_controllers:
	lda control_pad
	eor control_old
	and control_pad
	and #up_punch
	beq @no_up
		lda #$01
		sta e_state+1
@no_up:
	lda control_pad
	eor control_old
	and control_pad
	and #down_punch
	beq @no_down
		lda #$02
		sta e_state+1
@no_down:
	lda control_pad
	eor control_old
	and control_pad
	and #left_punch
	beq @no_left
		lda #$03
		sta e_state+1
@no_left:
	lda control_pad
	eor control_old
	and control_pad
	and #right_punch
	beq @no_right
		lda #$04
		sta e_state+1
@no_right:
	rts

p2_controllers:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #up_punch
	beq @no_up
		lda #$01
		sta e_state+3
@no_up:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #down_punch
	beq @no_down
		lda #$02
		sta e_state+3
@no_down:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #left_punch
	beq @no_left
		lda #$03
		sta e_state+3
@no_left:
	lda control_pad2
	eor control_old2
	and control_pad2
	and #right_punch
	beq @no_right
		lda #$04
		sta e_state+3
@no_right:
	rts



snail_sprites:
	.byte $70,$b0,$00,$30
	.byte $70,$b1,$00,$31
	.byte $70,$a1,$01,$c8
	.byte $70,$a0,$01,$c7
	.byte $ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff

p1_get_pos:
	ldx p1_top				; y pos
	lda p1_left				; x pos
	clc
	adc multiply_lo, x		; add low byte of our multiply table to X coord
	sta game_pic_pointer+0		; save it in low byte of address
	lda multiply_hi, x		; get high byte of multiply table
	adc #000h				; add our carry on
	sta game_pic_pointer+1		; save it in high byte of address

	lda #<snail_ram_collision_lo
	adc game_pic_pointer+0
	sta e_hit_left+0
	lda #>snail_ram_collision_lo
	adc game_pic_pointer+1
	sta e_hit_left+1

	lda #<snail_ram_collision_hi
	adc game_pic_pointer+0
	sta e_hit_left+2
	lda #>snail_ram_collision_hi
	adc game_pic_pointer+1
	sta e_hit_left+3

	lda #<snail_ppu_collision_lo
	adc game_pic_pointer+0
	sta game_pic_pointer2+0
	lda #>snail_ppu_collision_lo
	adc game_pic_pointer+1
	sta game_pic_pointer2+1

	lda #<snail_ppu_collision_hi
	adc game_pic_pointer+0
	sta game_pic_addy_lo+0
	lda #>snail_ppu_collision_hi
	adc game_pic_pointer+1
	sta game_pic_addy_lo+1

	ldy #$00
	lda (e_hit_left), y
	sta e_hit_right+0
	lda (e_hit_left+2), y
	sta e_hit_right+1

	rts

p2_get_pos:
	ldx p2_top				; y pos
	lda p2_left				; x pos
	clc
	adc multiply_lo, x		; add low byte of our multiply table to X coord
	sta cpu_pointer+0		; save it in low byte of address
	lda multiply_hi, x		; get high byte of multiply table
	adc #000h				; add our carry on
	sta cpu_pointer+1		; save it in high byte of address

	lda #<snail_ppu_collision_lo
	adc cpu_pointer+0
	sta p2_held_address+0
	lda #>snail_ppu_collision_lo
	adc cpu_pointer+1
	sta p2_held_address+1

	lda #<snail_ppu_collision_hi
	adc cpu_pointer+0
	sta p2_jump_address+0
	lda #>snail_ppu_collision_hi
	adc cpu_pointer+1
	sta p2_jump_address+1

	lda #<snail_ram_collision_lo
	adc cpu_pointer+0
	sta e_hit_top+0
	lda #>snail_ram_collision_lo
	adc cpu_pointer+1
	sta e_hit_top+1

	lda #<snail_ram_collision_hi
	adc cpu_pointer+0
	sta e_hit_top+2
	lda #>snail_ram_collision_hi
	adc cpu_pointer+1
	sta e_hit_top+3

	ldy #$00
	lda (e_hit_top), y
	sta e_hit_right+2
	lda (e_hit_top+2), y
	sta e_hit_right+3

	rts

p1_hit_test:
	lda temp
	cmp #$10
	bne @nope
		lda e_hit_right+1
		cmp #$04
		bne @at5
			ldx e_hit_right
			lda $400, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@at5:
		cmp #$05
		bne @at6
			ldx e_hit_right
			lda $500, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@at6:
		cmp #$06
		bne @at7
			ldx e_hit_right
			lda $600, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@at7:
			ldx e_hit_right
			lda $700, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@nope:
	rts
@zinga_youre_hit:
	lda #$02
	sta snail_winner
	rts

p2_hit_test:
	lda temp2
	cmp #$10
	bne @nope
		lda e_hit_right+3
		cmp #$04
		bne @at5
			ldx e_hit_right+2
			lda $400, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@at5:
		cmp #$05
		bne @at6
			ldx e_hit_right+2
			lda $500, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@at6:
		cmp #$06
		bne @at7
			ldx e_hit_right+2
			lda $600, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@at7:
			ldx e_hit_right+2
			lda $700, x
			cmp #$01
			bne @nope
				jmp @zinga_youre_hit
@nope:
	rts
@zinga_youre_hit:
	lda snail_winner
	beq :+
		lda #$03
		sta snail_winner
		rts
:	lda #$01
	sta snail_winner
	rts


loop_stop:
	jmp loop_stop

.byte "START"
MAP_WIDTH  = 32
MAP_HEIGHT = 30
MAP_BASE   = $0000
 
.macro makeLUT op
  .repeat MAP_HEIGHT, y_
    .byte op ( y_ * MAP_WIDTH + MAP_BASE )
  .endrepeat
.endmacro
 
multiply_lo:	makeLUT <
multiply_hi:	makeLUT >
.byte "END"


snail_ram_collision_lo:
	.byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
	.byte $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
	.byte $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
	.byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
	.byte $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f
	.byte $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
	.byte $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f
	.byte $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f
	.byte $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
	.byte $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f
	.byte $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
	.byte $b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
	.byte $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
	.byte $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df
	.byte $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
	.byte $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff
	.byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
	.byte $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
	.byte $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
	.byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
	.byte $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f
	.byte $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
	.byte $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f
	.byte $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f
	.byte $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
	.byte $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f
	.byte $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
	.byte $b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
	.byte $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
	.byte $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df
;	.byte $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
;	.byte $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff

snail_ram_collision_hi:
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
;	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
;	.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07

snail_ppu_collision_lo:
	.byte   $00,  $01,  $02,  $03,  $04,  $05,  $06,  $07,  $08,  $09,  $0a,  $0b,  $0c,  $0d,  $0e,  $0f,  $10,  $11,  $12,  $13,  $14,  $15,  $16,  $17,  $18,  $19,  $1a,  $1b,  $1c,  $1d,  $1e,  $1f
	.byte   $20,  $21,  $22,  $23,  $24,  $25,  $26,  $27,  $28,  $29,  $2a,  $2b,  $2c,  $2d,  $2e,  $2f,  $30,  $31,  $32,  $33,  $34,  $35,  $36,  $37,  $38,  $39,  $3a,  $3b,  $3c,  $3d,  $3e,  $3f
	.byte   $40,  $41,  $42,  $43,  $44,  $45,  $46,  $47,  $48,  $49,  $4a,  $4b,  $4c,  $4d,  $4e,  $4f,  $50,  $51,  $52,  $53,  $54,  $55,  $56,  $57,  $58,  $59,  $5a,  $5b,  $5c,  $5d,  $5e,  $5f
	.byte   $60,  $61,  $62,  $63,  $64,  $65,  $66,  $67,  $68,  $69,  $6a,  $6b,  $6c,  $6d,  $6e,  $6f,  $70,  $71,  $72,  $73,  $74,  $75,  $76,  $77,  $78,  $79,  $7a,  $7b,  $7c,  $7d,  $7e,  $7f
	.byte   $80,  $81,  $82,  $83,  $84,  $85,  $86,  $87,  $88,  $89,  $8a,  $8b,  $8c,  $8d,  $8e,  $8f,  $90,  $91,  $92,  $93,  $94,  $95,  $96,  $97,  $98,  $99,  $9a,  $9b,  $9c,  $9d,  $9e,  $9f
	.byte   $a0,  $a1,  $a2,  $a3,  $a4,  $a5,  $a6,  $a7,  $a8,  $a9,  $aa,  $ab,  $ac,  $ad,  $ae,  $af,  $b0,  $b1,  $b2,  $b3,  $b4,  $b5,  $b6,  $b7,  $b8,  $b9,  $ba,  $bb,  $bc,  $bd,  $be,  $bf
	.byte   $c0,  $c1,  $c2,  $c3,  $c4,  $c5,  $c6,  $c7,  $c8,  $c9,  $ca,  $cb,  $cc,  $cd,  $ce,  $cf,  $d0,  $d1,  $d2,  $d3,  $d4,  $d5,  $d6,  $d7,  $d8,  $d9,  $da,  $db,  $dc,  $dd,  $de,  $df
	.byte   $e0,  $e1,  $e2,  $e3,  $e4,  $e5,  $e6,  $e7,  $e8,  $e9,  $ea,  $eb,  $ec,  $ed,  $ee,  $ef,  $f0,  $f1,  $f2,  $f3,  $f4,  $f5,  $f6,  $f7,  $f8,  $f9,  $fa,  $fb,  $fc,  $fd,  $fe,  $ff
	.byte   $00,  $01,  $02,  $03,  $04,  $05,  $06,  $07,  $08,  $09,  $0a,  $0b,  $0c,  $0d,  $0e,  $0f,  $10,  $11,  $12,  $13,  $14,  $15,  $16,  $17,  $18,  $19,  $1a,  $1b,  $1c,  $1d,  $1e,  $1f
	.byte   $20,  $21,  $22,  $23,  $24,  $25,  $26,  $27,  $28,  $29,  $2a,  $2b,  $2c,  $2d,  $2e,  $2f,  $30,  $31,  $32,  $33,  $34,  $35,  $36,  $37,  $38,  $39,  $3a,  $3b,  $3c,  $3d,  $3e,  $3f
	.byte   $40,  $41,  $42,  $43,  $44,  $45,  $46,  $47,  $48,  $49,  $4a,  $4b,  $4c,  $4d,  $4e,  $4f,  $50,  $51,  $52,  $53,  $54,  $55,  $56,  $57,  $58,  $59,  $5a,  $5b,  $5c,  $5d,  $5e,  $5f
	.byte   $60,  $61,  $62,  $63,  $64,  $65,  $66,  $67,  $68,  $69,  $6a,  $6b,  $6c,  $6d,  $6e,  $6f,  $70,  $71,  $72,  $73,  $74,  $75,  $76,  $77,  $78,  $79,  $7a,  $7b,  $7c,  $7d,  $7e,  $7f
	.byte   $80,  $81,  $82,  $83,  $84,  $85,  $86,  $87,  $88,  $89,  $8a,  $8b,  $8c,  $8d,  $8e,  $8f,  $90,  $91,  $92,  $93,  $94,  $95,  $96,  $97,  $98,  $99,  $9a,  $9b,  $9c,  $9d,  $9e,  $9f
	.byte   $a0,  $a1,  $a2,  $a3,  $a4,  $a5,  $a6,  $a7,  $a8,  $a9,  $aa,  $ab,  $ac,  $ad,  $ae,  $af,  $b0,  $b1,  $b2,  $b3,  $b4,  $b5,  $b6,  $b7,  $b8,  $b9,  $ba,  $bb,  $bc,  $bd,  $be,  $bf
	.byte   $c0,  $c1,  $c2,  $c3,  $c4,  $c5,  $c6,  $c7,  $c8,  $c9,  $ca,  $cb,  $cc,  $cd,  $ce,  $cf,  $d0,  $d1,  $d2,  $d3,  $d4,  $d5,  $d6,  $d7,  $d8,  $d9,  $da,  $db,  $dc,  $dd,  $de,  $df
	.byte   $e0,  $e1,  $e2,  $e3,  $e4,  $e5,  $e6,  $e7,  $e8,  $e9,  $ea,  $eb,  $ec,  $ed,  $ee,  $ef,  $f0,  $f1,  $f2,  $f3,  $f4,  $f5,  $f6,  $f7,  $f8,  $f9,  $fa,  $fb,  $fc,  $fd,  $fe,  $ff
	.byte   $00,  $01,  $02,  $03,  $04,  $05,  $06,  $07,  $08,  $09,  $0a,  $0b,  $0c,  $0d,  $0e,  $0f,  $10,  $11,  $12,  $13,  $14,  $15,  $16,  $17,  $18,  $19,  $1a,  $1b,  $1c,  $1d,  $1e,  $1f
	.byte   $20,  $21,  $22,  $23,  $24,  $25,  $26,  $27,  $28,  $29,  $2a,  $2b,  $2c,  $2d,  $2e,  $2f,  $30,  $31,  $32,  $33,  $34,  $35,  $36,  $37,  $38,  $39,  $3a,  $3b,  $3c,  $3d,  $3e,  $3f
	.byte   $40,  $41,  $42,  $43,  $44,  $45,  $46,  $47,  $48,  $49,  $4a,  $4b,  $4c,  $4d,  $4e,  $4f,  $50,  $51,  $52,  $53,  $54,  $55,  $56,  $57,  $58,  $59,  $5a,  $5b,  $5c,  $5d,  $5e,  $5f
	.byte   $60,  $61,  $62,  $63,  $64,  $65,  $66,  $67,  $68,  $69,  $6a,  $6b,  $6c,  $6d,  $6e,  $6f,  $70,  $71,  $72,  $73,  $74,  $75,  $76,  $77,  $78,  $79,  $7a,  $7b,  $7c,  $7d,  $7e,  $7f
	.byte   $80,  $81,  $82,  $83,  $84,  $85,  $86,  $87,  $88,  $89,  $8a,  $8b,  $8c,  $8d,  $8e,  $8f,  $90,  $91,  $92,  $93,  $94,  $95,  $96,  $97,  $98,  $99,  $9a,  $9b,  $9c,  $9d,  $9e,  $9f
	.byte   $a0,  $a1,  $a2,  $a3,  $a4,  $a5,  $a6,  $a7,  $a8,  $a9,  $aa,  $ab,  $ac,  $ad,  $ae,  $af,  $b0,  $b1,  $b2,  $b3,  $b4,  $b5,  $b6,  $b7,  $b8,  $b9,  $ba,  $bb,  $bc,  $bd,  $be,  $bf
	.byte   $c0,  $c1,  $c2,  $c3,  $c4,  $c5,  $c6,  $c7,  $c8,  $c9,  $ca,  $cb,  $cc,  $cd,  $ce,  $cf,  $d0,  $d1,  $d2,  $d3,  $d4,  $d5,  $d6,  $d7,  $d8,  $d9,  $da,  $db,  $dc,  $dd,  $de,  $df
	.byte   $e0,  $e1,  $e2,  $e3,  $e4,  $e5,  $e6,  $e7,  $e8,  $e9,  $ea,  $eb,  $ec,  $ed,  $ee,  $ef,  $f0,  $f1,  $f2,  $f3,  $f4,  $f5,  $f6,  $f7,  $f8,  $f9,  $fa,  $fb,  $fc,  $fd,  $fe,  $ff
	.byte   $00,  $01,  $02,  $03,  $04,  $05,  $06,  $07,  $08,  $09,  $0a,  $0b,  $0c,  $0d,  $0e,  $0f,  $10,  $11,  $12,  $13,  $14,  $15,  $16,  $17,  $18,  $19,  $1a,  $1b,  $1c,  $1d,  $1e,  $1f
	.byte   $20,  $21,  $22,  $23,  $24,  $25,  $26,  $27,  $28,  $29,  $2a,  $2b,  $2c,  $2d,  $2e,  $2f,  $30,  $31,  $32,  $33,  $34,  $35,  $36,  $37,  $38,  $39,  $3a,  $3b,  $3c,  $3d,  $3e,  $3f
	.byte   $40,  $41,  $42,  $43,  $44,  $45,  $46,  $47,  $48,  $49,  $4a,  $4b,  $4c,  $4d,  $4e,  $4f,  $50,  $51,  $52,  $53,  $54,  $55,  $56,  $57,  $58,  $59,  $5a,  $5b,  $5c,  $5d,  $5e,  $5f
	.byte   $60,  $61,  $62,  $63,  $64,  $65,  $66,  $67,  $68,  $69,  $6a,  $6b,  $6c,  $6d,  $6e,  $6f,  $70,  $71,  $72,  $73,  $74,  $75,  $76,  $77,  $78,  $79,  $7a,  $7b,  $7c,  $7d,  $7e,  $7f
	.byte   $80,  $81,  $82,  $83,  $84,  $85,  $86,  $87,  $88,  $89,  $8a,  $8b,  $8c,  $8d,  $8e,  $8f,  $90,  $91,  $92,  $93,  $94,  $95,  $96,  $97,  $98,  $99,  $9a,  $9b,  $9c,  $9d,  $9e,  $9f
	.byte   $a0,  $a1,  $a2,  $a3,  $a4,  $a5,  $a6,  $a7,  $a8,  $a9,  $aa,  $ab,  $ac,  $ad,  $ae,  $af,  $b0,  $b1,  $b2,  $b3,  $b4,  $b5,  $b6,  $b7,  $b8,  $b9,  $ba,  $bb,  $bc,  $bd,  $be,  $bf
;	.byte   $c0,  $c1,  $c2,  $c3,  $c4,  $c5,  $c6,  $c7,  $c8,  $c9,  $ca,  $cb,  $cc,  $cd,  $ce,  $cf,  $d0,  $d1,  $d2,  $d3,  $d4,  $d5,  $d6,  $d7,  $d8,  $d9,  $da,  $db,  $dc,  $dd,  $de,  $df
;	.byte   $e0,  $e1,  $e2,  $e3,  $e4,  $e5,  $e6,  $e7,  $e8,  $e9,  $ea,  $eb,  $ec,  $ed,  $ee,  $ef,  $f0,  $f1,  $f2,  $f3,  $f4,  $f5,  $f6,  $f7,  $f8,  $f9,  $fa,  $fb,  $fc,  $fd,  $fe,  $ff

snail_ppu_collision_hi:
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $21,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $22,  $20
	.byte   $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $20
	.byte   $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $20
	.byte   $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $20
	.byte   $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $20
	.byte   $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $20
	.byte   $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $23,  $20

p2_move_up:
	lda #$b3
	sta p2_shell+1
	lda #$a3
	sta p2_head+1
	lda temp2
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp2
		dec p2_head
		rts
:	lda #$05
	sta e_state+2
	rts
p2_move_down:
	lda #$a2
	sta p2_shell+1
	lda #$b2
	sta p2_head+1
	lda temp2
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp2
		inc p2_head
		rts
:	lda #$06
	sta e_state+2
	rts
p2_move_left:
	lda #$a1
	sta p2_shell+1
	lda #$a0
	sta p2_head+1
	lda temp2
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp2
		dec p2_head+3
		rts
:	lda #$07
	sta e_state+2
	rts
p2_move_right:
	lda #$b0
	sta p2_shell+1
	lda #$b1
	sta p2_head+1
	lda temp2
	cmp #$08
	beq :+
	sec
	sbc #$01
	sta temp2
		inc p2_head+3
		rts
:	lda #$08
	sta e_state+2
	rts
p2_move_up2:
	lda temp2
	beq :+
	sec
	sbc #$01
	sta temp2
		dec p2_shell
		rts
:	lda e_state+3
	sta e_state+2
			lda #$10
			sta temp2
	lda #$01
	sta p2_set
	dec p2_top
	rts
p2_move_down2:
	lda temp2
	beq :+
	sec
	sbc #$01
	sta temp2
		inc p2_shell
		rts
:	lda e_state+3
	sta e_state+2
			lda #$10
			sta temp2
	lda #$01
	sta p2_set
	inc p2_top
	rts
p2_move_left2:
	lda temp2
	beq :+
	sec
	sbc #$01
	sta temp2
		dec p2_shell+3
		rts
:	lda e_state+3
	sta e_state+2
			lda #$10
			sta temp2
	lda #$01
	sta p2_set
	dec p2_left
	rts
p2_move_right2:
	lda temp2
	beq :+
	sec
	sbc #$01
	sta temp2
		inc p2_shell+3
		rts
:	lda e_state+3
	sta e_state+2
			lda #$10
			sta temp2
	lda #$01
	sta p2_set
	inc p2_left
	rts