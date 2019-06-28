loop_screen_load:
	ldx prior_cursor_pos
	lda game_buffer_lo, x
	sta screen_pointer+0
	lda game_buffer_hi, x
	sta screen_pointer+1
	ldy #$00
:	lda (screen_pointer), y
	sta bg_buffer, y
	iny
	bne :-
	lda attribs_lo, x
	sta attribs_pointer+0
	lda attribs_hi, x
	sta attribs_pointer+1
	lda ppu_2000_offset, x
	sta reg2000_save
	lda #<loop_nothing
	sta loop_pointer+0
	lda #>loop_nothing
	sta loop_pointer+1
	lda #<do_the_screen_loading_nmi
	sta nmi_pointer+0
	lda #>do_the_screen_loading_nmi
	sta nmi_pointer+1
	jmp end_loop

loop_nothing:
	jmp end_loop
nmi_nothing:
	jmp finish_nmi
; 16x16 metatiles
; START TIC-TAC-TOE TILES
; 00-blank, 01-topleft corner of top, 02-topright corner of top, 03-up/down left side, 04-up/down right side
; 05-left joint, 06-right joint, 07-left end, 08-left/right block, 09-right end, 0a-bottomleft corner
; 0b-bottomright corner
; START CLIK TILES
; 0c-block, 0d-elec_left, 0e-elec_right, 0f-slope_on_left, 10-slope_on_right
; 11-top_slope_left, 12-bot_slope_left, 13-top_slope_right, 14-bot_slope_right
; START PEGBOARD 2 PLAYER TILES
; 15-bottom1, 16-bottom2, 17-bottom3, 18-bottom4, 19-middle1, 1a-middle2
; 1b-middle3, 1c-middle4, 1d-top1, 1e-top2, 1f-divider_left, 20-divider_mid
; 21-divider_right, 22-PL, 23-AY, 24-ER, 25- 1, 26- 2
; CLIK 'PUSH START'
; 27-PU-S, 28-SH-TA, 29--RT
; TIC TAC TOE FIRST TO 3
; 2a-FI, 2b-RS, 2c-T-, 2d-TO, 2e--3, 2f--W, 30-IN, 31-S!, 32-P1, 33-P2
; 34 - top left of snail trail
; 35 - player 1 ttt

tile_a:
;	.byte $00, $00, $24, $00, $28, $2a, $2c, $00, $2a, $24, $00, $28
	.byte $00, $00, $b9, $00, $bd, $bf, $c1, $00, $bf, $b9, $00, $bd, $ca, $ce, $00, $d0
	.byte $00, $d0, $d1, $00, $00, $70, $72, $74, $76, $00, $66, $68, $00, $00, $61, $2a
	.byte $2b, $2b, $50, $41, $45, $00, $00, $50, $53, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $50, $50, $29, $50, $41, $45, $00
tile_b:
;	.byte $00, $23, $00, $27, $00, $2b, $2a, $23, $2a, $00, $27, $00
	.byte $00, $b8, $00, $bc, $00, $c0, $bf, $b8, $bf, $00, $bc, $00, $cb, $00, $ce, $00
	.byte $d6, $00, $00, $d6, $d5, $71, $73, $75, $77, $00, $67, $69, $00, $60, $00, $2b
	.byte $2b, $28, $4c, $59, $52, $31, $32, $55, $48, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $31, $32, $2a, $4c, $59, $52, $31
tile_c:
;	.byte $00, $00, $28, $00, $28, $29, $2e, $00, $29, $26, $00, $26
	.byte $00, $00, $bd, $00, $bd, $be, $c3, $00, $be, $bb, $00, $bb, $cc, $cf, $00, $d2
	.byte $00, $d1, $d2, $00, $00, $78, $7a, $7c, $7e, $00, $6b, $6d, $6f, $62, $64, $2a
	.byte $2b, $2b, $00, $00, $00, $00, $00, $00, $54, $52, $46, $52, $54, $54, $00, $00
	.byte $49, $53, $00, $00, $00, $00, $00, $00, $00
tile_d:
;	.byte $00, $27, $00, $27, $00, $2d, $29, $25, $29, $00, $25, $00
	.byte $00, $bc, $00, $bc, $00, $c2, $be, $ba, $be, $00, $ba, $00, $cd, $00, $cf, $00
	.byte $d4, $00, $00, $d5, $d4, $79, $7b, $7d, $7f, $6a, $6c, $6e, $00, $63, $65, $2b
	.byte $2b, $28, $00, $00, $00, $00, $00, $53, $41, $54, $49, $53, $00, $4f, $33, $57
	.byte $4e, $5c, $00, $00, $00, $00, $00, $00, $00


do_the_screen_loading_nmi:
	lda switch_to_attributes
	beq :+
		jmp @attribute_laying
:	ldx metatile_index
	lda bg_buffer, x
	tay
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
	lda tile_a, y
	sta $2007
	lda lo_ppu_addy
	clc
	adc #$01
	sta lo_ppu_addy
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
	lda tile_b, y
	sta $2007
	lda lo_ppu_addy
	clc
	adc #31
	sta lo_ppu_addy
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
	lda tile_c, y
	sta $2007
	lda lo_ppu_addy
	clc
	adc #$01
	sta lo_ppu_addy
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
	lda tile_d, y
	sta $2007
	lda lo_ppu_addy
	cmp #$ff
	bne :+
		lda hi_ppu_addy
		clc
		adc #$01
		sta hi_ppu_addy
:	lda lo_ppu_addy
	sec
	sbc #31
	sta lo_ppu_addy

	lda unpack_count
	clc
	adc #$01
	sta unpack_count
	cmp #$10
	bne :+
		lda lo_ppu_addy
		clc
		adc #32
		sta lo_ppu_addy
		lda #$00
		sta unpack_count
:
	inx
	stx metatile_index
	cpx #$00
	bne :+
		lda #$01
		sta switch_to_attributes
		lda #$2b
		sta hi_ppu_addy
		lda #$c0
		sta lo_ppu_addy
:
	jmp finish_nmi
@attribute_laying:
	ldy metatile_index
	lda hi_ppu_addy
	sta $2006
	lda lo_ppu_addy
	sta $2006
	lda (attribs_pointer), y
	sta $2007
	lda lo_ppu_addy
	clc
	adc #$01
	sta lo_ppu_addy
	iny
	sty metatile_index
	cpy #$40
	bne @done_nmi
		lda prior_cursor_pos
		bne :+
				lda #$21
				sta pal_address+25
				lda #$11
				sta pal_address+26
			lda #<ttt_setup
			sta loop_pointer+0
			lda #>ttt_setup
			sta loop_pointer+1
			lda #<ttt_nada
			sta nmi_pointer
			lda #>ttt_nada
			sta nmi_pointer+1
			jmp @start_the_scroll
:		cmp #$01
		bne :+
			lda #<pegboard_loop
			sta loop_pointer+0
			lda #>pegboard_loop
			sta loop_pointer+1
			lda #<pegboard_play_nmi
			sta nmi_pointer
			lda #>pegboard_play_nmi
			sta nmi_pointer+1
			jmp @start_the_scroll
:		cmp #$02
		bne :+
			lda #$17
			sta pal_address+5
			lda #$05
			sta pal_address+7
			lda #$00
			sta pal_address+9
			lda #$14
			sta pal_address+10
			lda #$10
			sta pal_address+11
			lda #<clik_loop
			sta loop_pointer+0
			lda #>clik_loop
			sta loop_pointer+1
			lda #<clik_play_nmi
			sta nmi_pointer
			lda #>clik_play_nmi
			sta nmi_pointer+1
			jmp @start_the_scroll
:	lda #<snail_play_nmi
	sta nmi_pointer
	lda #>snail_play_nmi
	sta nmi_pointer+1
@start_the_scroll:
	lda #$01
	sta scroll_it
@done_nmi:
	jmp finish_nmi
