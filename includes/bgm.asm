env_0:
	.byte $b0,$b0,$b0,$b0
env_1:
	.byte $b0,$b0,$b0,$b1
env_2:
	.byte $b0,$b0,$b0,$b2
env_3:
	.byte $b0,$b0,$b0,$b3
env_4:
	.byte $b0,$b0,$b0,$b4
env_5:
	.byte $b0,$b0,$b1,$b4
env_6:
	.byte $b0,$b0,$b2,$b4
env_7:
	.byte $b0,$b0,$b3,$b4
env_8:
	.byte $b0,$b0,$b4,$b4
env_9:
	.byte $b0,$b1,$b4,$b4
env_a:
	.byte $b0,$b2,$b4,$b4
env_b:
	.byte $b0,$b3,$b4,$b4
env_c:
	.byte $b0,$b4,$b4,$b4
env_d:
	.byte $b1,$b4,$b4,$b4
env_e:
	.byte $b2,$b4,$b4,$b4
env_f:
	.byte $b3,$b4,$b4,$b4


env_lo:
	.byte <env_0,<env_1,<env_2,<env_3,<env_4,<env_5,<env_6,<env_7,<env_8
	.byte <env_9,<env_a,<env_b,<env_c,<env_d,<env_e,<env_f
env_hi:
	.byte >env_0,>env_1,>env_2,>env_3,>env_4,>env_5,>env_6,>env_7,>env_8
	.byte >env_9,>env_a,>env_b,>env_c,>env_d,>env_e,>env_f

song_list:
	.byte $01,$05,$0b,$02,$08,$07

juke_control:
	lda control_pad					; A button check/routine
	eor control_old
	and control_pad
	and #left_punch
	beq :+
		lda song_offset
		beq :+
			lda song_offset
			sec
			sbc #$01
			sta song_offset
			clc
			adc #$30
			sta song_added
:
	lda control_pad					; A button check/routine
	eor control_old
	and control_pad
	and #right_punch
	beq :+
		lda song_offset
		cmp #$05
		beq :+
			lda song_offset
			clc
			adc #$01
			sta song_offset
			clc
			adc #$30
			sta song_added
:
	lda control_pad					; A button check/routine
	eor control_old
	and control_pad
	and #a_punch
	beq :+
		ldx song_offset
		stx test_byte
		lda song_list, x
		jsr music_loadsong
:
	lda control_pad					; A button check/routine
	eor control_old
	and control_pad
	and #b_punch
	beq :++
		lda mus_ptrH
		cmp #>silence
		beq :+
			lda #$00
			jsr music_loadsong
			jmp :++
:		lda #$00
		sta switch_controls
		lda prior_cursor_pos
		sta cursor_position
			lda #$20
			sta left_cursor+3
			clc
			adc #$08
			sta right_cursor+3
			lda #$77
			sta left_cursor
			sta right_cursor
				lda #<title_loop
				sta loop_pointer+0
				lda #>title_loop
				sta loop_pointer+1
				lda #<title_nmi
				sta nmi_pointer
				lda #>title_nmi
				sta nmi_pointer+1
				lda #$03
				sta cursor_position
				jmp end_loop
:	lda sq1_envpos
	bne :+
		ldx #$00
		jmp :++++
:
	lda test_byte
	cmp #$04
	bne :+
		lda sq1+12
		clc
		adc #$03
		jmp :++
:
	lda sq1+12
	asl
	asl
:	and #$0f
	tax
:	lda env_lo, x
	sta e_hit_left+0
	lda env_hi, x
	sta e_hit_left+1
	ldy #$00
:	lda (e_hit_left), y
	sta juke_env, y
	iny
	cpy #$04
	bne :-

	lda test_byte
	cmp #$02
	beq :+
		cmp #$04
		bne :++
:		lda sq2+3
		jmp :++
:
	lda sq2+12
:	and #$0f
	tax
	lda env_lo, x
	sta e_hit_left+2
	lda env_hi, x
	sta e_hit_left+3
	ldy #$00
:	lda (e_hit_left+2), y
	sta juke_env2, y
	iny
	cpy #$04
	bne :-

	lda mus_ptrH
	bne :+
		ldx #$00
		jmp :+++
:	lda tri+12
	cmp #$0f
	bcc	:+
		lda #$0f
:
;	and #$0f
	tax
:	lda env_lo, x
	sta e_hit_right+0
	lda env_hi, x
	sta e_hit_right+1
	ldy #$00
:	lda (e_hit_right), y
	sta juke_env3, y
	iny
	cpy #$04
	bne :-

	lda mus_ptrH
	bne :+
		ldx #$00
		jmp :++
:
	lda nse+3;nse+11 ; 
	and #$0f
	tax
:	lda env_lo, x
	sta e_hit_right+2
	lda env_hi, x
	sta e_hit_right+3
	ldy #$00
:	lda (e_hit_right+2), y
	sta juke_env4, y
	iny
	cpy #$04
	bne :-


	jsr animate_gamename_palette

	jmp end_loop	;rts

bgm_nmi:
	lda #%10000100
	sta $2000

	lda #$21
	sta $2006
	lda #$d6
	sta $2006
	lda song_added
	sta $2007

	lda #$21
	sta $2006
	lda #$15
	sta $2006
	lda juke_env+0
	sta $2007
	lda juke_env+1
	sta $2007
	lda juke_env+2
	sta $2007
	lda juke_env+3
	sta $2007

	lda #$21
	sta $2006
	lda #$17
	sta $2006
	lda juke_env+4
	sta $2007
	lda juke_env+5
	sta $2007
	lda juke_env+6
	sta $2007
	lda juke_env+7
	sta $2007

	lda #$21
	sta $2006
	lda #$19
	sta $2006
	lda juke_env+8
	sta $2007
	lda juke_env+9
	sta $2007
	lda juke_env+10
	sta $2007
	lda juke_env+11
	sta $2007

	lda #$21
	sta $2006
	lda #$1b
	sta $2006
	lda juke_env+12
	sta $2007
	lda juke_env+13
	sta $2007
	lda juke_env+14
	sta $2007
	lda juke_env+15
	sta $2007

	lda #%10000000
	sta $2000

	jmp finish_nmi
