
;ball_dir constants
no_move1			=	$00
down_left1			=	$01
up_left1			=	$02
down_right1			=	$03
up_right1			=	$04

; Sprite ram
pong1_1			=	$200
pong1_2			=	$204		
pong1_3			=	$208
pong1_4			=	$20c
pong1_5			=	$210
pong1_6			=	$214
pong1_7			=	$218
pong1_8			=	$21c
pong1_9			=	$220
pong1_10			=	$224
pong1_11			=	$228
pong1_12			=	$22c
pong1_13			=	$230
pong1_14			=	$234
pong1_15			=	$238

pong2_1			=	$23c
pong2_2			=	$240
pong2_3			=	$244
pong2_4			=	$248
pong2_5			=	$24c
pong2_6			=	$250
pong2_7			=	$254
pong2_8			=	$258
pong2_9			=	$25c
pong2_10			=	$260
pong2_11			=	$264
pong2_12			=	$268
pong2_13			=	$26c
pong2_14			=	$270
pong2_15			=	$274

p1_pad1			=	$278
p1_pad2			=	$27c
p1_pad3			=	$280
p1_pad4			=	$284

p2_pad1			=	$288
p2_pad2			=	$28c
p2_pad3			=	$290
p2_pad4			=	$294

ball			=	$298

s_0				=	$33	;$400	;:			.res 15
s_1				=	$42	;$40f	;:			.res 15
s_2				=	$51	;$41e	;:			.res 15
s_3				=	$60	;$42d	;:			.res 15
s_4				=	$6f	;$43c	;:			.res 15
s_5				=	$7e	;$44b	;:			.res 15
s_6				=	$8d	;$45a	;:			.res 15
s_7				=	$9c	;$469	;:			.res 15
s_8				=	$ab	;$478	;:			.res 15
s_9				=	$ba	;$487	;:			.res 15

ball_left		=	$500	;:		.res 1
ball_right		=	$501	;:		.res 1
ball_top		=	$502	;:		.res 1
ball_bottom		=	$503	;:	.res 1
player			=	$504	;:			.res 1
pong1_left			=	$505	;:		.res 1
pong2_left			=	$506	;:		.res 1
pong1_right		=	$507	;:		.res 1
pong2_right		=	$508	;:		.res 1
pong1_top			=	$509	;:			.res 1
pong2_top			=	$50a	;:			.res 1
pong1_bottom		=	$50b	;:		.res 1
pong2_bottom		=	$50c	;:		.res 1
p1_s_offset		=	$50d	;:	.res 1
p2_s_offset		=	$50e	;:	.res 1
ball_dir		=	$50f	;:		.res 1
pong_set		=	$510
code2_offset	=	$511
code2_count		=	$512


;nmi_num:		.res 1
;addy_lo:		.res 1
;addy_hi:		.res 1
;control_pad:	.res 1
;control_pad2:	.res 1
;control_old:	.res 1
;control_old2:	.res 1
;ball_left:		.res 1
;ball_right:		.res 1
;ball_top:		.res 1
;ball_bottom:	.res 1
;player:			.res 1
;p1_left:		.res 1
;p2_left:		.res 1
;p1_right:		.res 1
;p2_right:		.res 1
;p1_top:			.res 1
;p2_top:			.res 1
;p1_bottom:		.res 1
;p2_bottom:		.res 1
;p1_s_offset:	.res 1
;p2_s_offset:	.res 1
;ball_dir:		.res 1


reset_pong:

			ldx #$00
			lda #$20						;
			sta $2006						;
			lda #$00						;
			sta $2006						;
:			sta $2007						;
			sta $2007
			sta $2007
			sta $2007
			dex								;
			bne :-
	lda #$3f						; Set the values for the palette
	sta $2006						;
	lda #$00						;
	sta $2006						;
	lda #$0f						;
	sta $2007						;
	sta pal_address+0
	lda #$00
	sta pal_address+1
	lda #$3f						; Set the values for the palette
	sta $2006						;
	lda #$10						;
	sta $2006						;
	lda #$0f						;
	sta $2007						;
	sta pal_address+16
	lda #$00						;
	sta $2007						;
	sta pal_address+17

	ldx #0
	lda #$21						; 
	sta $2006						; 
	lda #$00						; 
	sta $2006						; 
:	lda #$ac						; 
	sta $2007						;
	inx
	cpx #32
	bne :-
	ldx #0
	lda #$23						; 
	sta $2006						; 
	lda #$80						; 
	sta $2006						; 
:	lda #$ac						; 
	sta $2007						;
	inx
	cpx #32
	bne :-

	ldx #$00						; Pull in bytes for sprites and their
:	lda pong_sprites, x				;  attributes which are stored in the
	sta pong1_1, x						;  'pong_sprites' table. Use X as an index
	lda scores, x
	sta s_0, x
	inx								;  to load and store each byte, which
	cpx #156						;  get stored starting in $200, where
	bne :-							;  'score_ones' is located at.

	lda #1
	sta ball_dir

:	bit $2002
	bpl :-

	lda #%10000000
	sta $2000
	sta reg2000_save
	lda #%00011010
	sta $2001
	sta reg2001_save
wait:
	lda control_pad
	and #start_punch
	beq @no_start
		lda nmi_num					; Wait for an NMI to happen before running
:		cmp nmi_num					;  the main loop again
		beq :-
			bne loop_pong				; CHANGED FROM JMP TO BNE SAVE A BYTE
@no_start:
	beq wait						; CHANGED FROM JMP TO BEQ TO SAVE A BYTE


loop_pong:
	ldy p1_s_offset
	ldx score_table, y
	ldy #0
:	lda $00, x
	sta pong1_1+1, y
	inx
	iny
	iny
	iny
	iny
	cpy #60
	bne :-
	lda p1_s_offset
	cmp #9
	bne :+
		jmp game_over_pong
:	ldy p2_s_offset
	ldx score_table, y
	ldy #0
:	lda $00, x
	sta pong2_1+1, y
	inx
	iny
	iny
	iny
	iny
	cpy #60
	bne :-
	lda p2_s_offset
	cmp #9
	bne :+
		jmp game_over_pong
:
	lda ball_left
	cmp #$08
	bne :+
		inc p2_s_offset
		jsr set_ball
:

	lda ball_right
	cmp #$f8
	bne :+
		inc p1_s_offset
		jsr set_ball
:
	ldx #$00
	stx player
@do_controls:
	lda control_pad, x
	and #up_punch
	beq @no_up
		cpx #$00
		beq :+
			lda p2_pad1
			cmp #$47
			beq @no_up
				dec p2_pad1
				dec p2_pad2
				dec p2_pad3
				dec p2_pad4
				bne @no_up
:			lda p1_pad1
			cmp #$47
			beq @no_up
			dec p1_pad1
			dec p1_pad2
			dec p1_pad3
			dec p1_pad4
			bne @no_down
@no_up:
	lda control_pad, x
	and #down_punch
	beq @no_down
		cpx #$00
		beq :+
			lda p2_pad4
			cmp #$d7
			beq @no_down
				inc p2_pad1
				inc p2_pad2
				inc p2_pad3
				inc p2_pad4
				bne @no_down
:		lda p1_pad4
		cmp #$d7
		beq @no_down
			inc p1_pad1
			inc p1_pad2
			inc p1_pad3
			inc p1_pad4
@no_down:
	inx
	inx
	cpx #$04
	bne @do_controls

	ldx #$00
@pong_hit:
	lda ball_left
	cmp pong1_right, x
	bcs @no_coll1
	lda ball_right
	cmp pong1_left, x
	bcc @no_coll1
	lda ball_top
	cmp pong1_bottom, x
	bcs @no_coll1
	lda ball_bottom
	cmp pong1_top, x
	bcc @no_coll1

		ldx player
		beq :++
			lda ball_dir
			cmp #down_right1
			bne :+
				lda #down_left1
				sta ball_dir
				bne @no_coll1
:			lda #up_left1
			sta ball_dir
			bne @no_coll1

:		lda ball_dir
		cmp #down_left1
		bne :+
			lda #down_right1
			sta ball_dir
			bne @no_coll1
:		lda #up_right1
		sta ball_dir
@no_coll1:

	inx
	stx player
	cpx #$01
	bne :+
		jmp @pong_hit
:



	lda ball
	cmp #$d7
	bne :++
		lda ball_dir
		cmp #down_left1
		bne :+
			lda #up_left1
			sta ball_dir
			bne :++	
:		lda #up_right1
		sta ball_dir
		bne :+
:	cmp #$47
	bne :++
		lda ball_dir
		cmp #up_left1
		bne :+
			lda #down_left1
			sta ball_dir
			bne :++
:		lda #down_right1
		sta ball_dir
:	jsr ball_movement


	lda p1_pad1						; p1 bounding box
	sta pong1_top						;
	clc								;
	adc #32							;
	sta pong1_bottom					;
	lda p1_pad1+3					;
	sta pong1_left						;
	clc								;
	adc #$08						;
	sta pong1_right					;

	lda p2_pad1						; p2 bounding box
	sta pong2_top						;
	clc								;
	adc #32							;
	sta pong2_bottom					;
	lda p2_pad1+3					;
	sta pong2_left						;
	clc								;
	adc #$08						;
	sta pong2_right					;

	lda ball						; ball bounding box
	sta ball_top					;
	clc								;
	adc #8							;
	sta ball_bottom					;
	lda ball+3						;
	sta ball_left					;
	clc								;
	adc #8							;
	sta ball_right					;

	lda nmi_num						; Wait for an NMI to happen before running
:	cmp nmi_num						; the main loop again
	beq :-							;
	jmp loop_pong


ball_movement:
	lda ball_dir
	asl a
	tay
	lda ball_move_table+1,y
	pha
	lda ball_move_table,y
	pha
	rts
done_loop:
	jmp done_loop

nmi_pong:
	jmp finish_nmi

ball_move_table:
	.addr no_move-1, down_left-1, up_left-1, down_right-1, up_right-1

set_ball:
	lda #$80
	sta ball
	sta ball+3
	rts
no_move:
	rts
down_left:
	inc ball
	dec ball+3
	rts
up_left:
	dec ball
	dec ball+3
	rts
down_right:
	inc ball
	inc ball+3
	rts
up_right:
	dec ball
	inc ball+3
	rts

game_over_pong:
	jmp game_over_pong

scores:
;score_zero:
	.byte $ac,$ac,$ac
	.byte $ac,$00,$ac
	.byte $ac,$00,$ac
	.byte $ac,$00,$ac
	.byte $ac,$ac,$ac
;score_one:
	.byte $ac,$ac,$00
	.byte $00,$ac,$00
	.byte $00,$ac,$00
	.byte $00,$ac,$00
	.byte $ac,$ac,$ac
;score_two:
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $ac,$ac,$ac
	.byte $ac,$00,$00
	.byte $ac,$ac,$ac
;score_three:
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $ac,$ac,$ac
;score_four:
	.byte $ac,$00,$ac
	.byte $ac,$00,$ac
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $00,$00,$ac
;score_five:
	.byte $ac,$ac,$ac
	.byte $ac,$00,$00
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $ac,$ac,$ac
;score_six:
	.byte $ac,$ac,$ac
	.byte $ac,$00,$00
	.byte $ac,$ac,$ac
	.byte $ac,$00,$ac
	.byte $ac,$ac,$ac
;score_seven:
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $00,$00,$ac
	.byte $00,$00,$ac
	.byte $00,$00,$ac
;score_eight:
	.byte $ac,$ac,$ac
	.byte $ac,$00,$ac
	.byte $ac,$ac,$ac
	.byte $ac,$00,$ac
	.byte $ac,$ac,$ac
;score_nine:
	.byte $ac,$ac,$ac
	.byte $ac,$00,$ac
	.byte $ac,$ac,$ac
	.byte $00,$00,$ac
	.byte $ac,$ac,$ac
score_table:
	.byte <s_0,<s_1,<s_2,<s_3,<s_4,<s_5,<s_6,<s_7,<s_8,<s_9

; Sprite definitions
pong_sprites:
	.byte $10,$00,$00,$20			; p1 score
	.byte $10,$00,$00,$28			; 
	.byte $10,$00,$00,$30			; 
	.byte $18,$00,$00,$20			; 
	.byte $18,$00,$00,$28			; 
	.byte $18,$00,$00,$30			; 
	.byte $20,$00,$00,$20			; 
	.byte $20,$00,$00,$28			; 
	.byte $20,$00,$00,$30			; 
	.byte $28,$00,$00,$20			; 
	.byte $28,$00,$00,$28			; 
	.byte $28,$00,$00,$30			; 
	.byte $30,$00,$00,$20			; 
	.byte $30,$00,$00,$28			; 
	.byte $30,$00,$00,$30			; 

	.byte $10,$00,$00,$c8			; p2 score
	.byte $10,$00,$00,$d0			; 
	.byte $10,$00,$00,$d8			; 
	.byte $18,$00,$00,$c8			; 
	.byte $18,$00,$00,$d0			; 
	.byte $18,$00,$00,$d8			; 
	.byte $20,$00,$00,$c8			; 
	.byte $20,$00,$00,$d0			; 
	.byte $20,$00,$00,$d8			; 
	.byte $28,$00,$00,$c8			; 
	.byte $28,$00,$00,$d0			; 
	.byte $28,$00,$00,$d8			; 
	.byte $30,$00,$00,$c8			; 
	.byte $30,$00,$00,$d0			; 
	.byte $30,$00,$00,$d8			; 

	.byte $78,$ac,$00,$18			; p1 paddle
	.byte $80,$ac,$00,$18			; 
	.byte $88,$ac,$00,$18			; 
	.byte $90,$ac,$00,$18			; 
;	.byte $98,$ac,$00,$18			; 

	.byte $78,$ac,$00,$e0			; p2 paddle
	.byte $80,$ac,$00,$e0			; 
	.byte $88,$ac,$00,$e0			; 
	.byte $90,$ac,$00,$e0			; 
;	.byte $98,$ac,$00,$e0			; 

	.byte $80,$ac,$00,$80			; ball
