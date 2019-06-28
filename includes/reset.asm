reset:
	sei
	ldx #$00
	stx $4015
	ldx #$40
	stx $4017
	ldx #$ff
	txs
	inx
	stx $2000
	stx reg2000_save
	stx $2001
	stx reg2001_save
	txa
	tay
@clrmem:
	lda #$00
	sta $00, x
	sta $100, x
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x
;	sta $700, x
	lda #$ff
	sta $200, x
	inx
	bne @clrmem

	jsr vblank_wait

	lda #$00
:	sta $700, x
	inx
	cpx #$f0
	bne :-

	ldx #$00
:	lda slydog, x
	cmp sly_words, x
	bne :+
		inx
		cpx #(sly_end - sly_words)
		bne :-
			jsr win_screen
			lda #<blank_nmi
			sta nmi_pointer
			lda #>blank_nmi
			sta nmi_pointer+1
			jsr vblank_wait
			lda #$00
			sta $2006
			sta $2006
			sta $2005
			sta $2005
			jsr PPU_with_sprites
			jmp win_screen_going_on
:
		
	ldy #$00						; Load the title screen
	ldx #$04						;
	lda #<title_screen_nametable	;
	sta screen_pointer				;
	lda #>title_screen_nametable	;
	sta screen_pointer+1			;
	lda #$20						;
	sta $2006						;
	lda #$00						;
	sta $2006						;
:	lda (screen_pointer),y			;
	sta $2007						;
	iny								;
	bne :-							;
	inc screen_pointer+1			;
	dex								;
	bne :-							;

	ldx #$00						; Pull in bytes for sprites and their
:	lda the_sprites,x				; attributes which are stored in the
	sta left_cursor,x				; 'the_sprites' table. Use X as an index
	inx								; to load and store each byte, which
	cpx #$44						; get stored starting in $200, where
	bne :-							; 'left_cursor' is located at.

	ldx #$00
:	lda palette, x
	sta pal_address, x
	inx
	cpx #$20
	bne :-

	lda #$30
	sta song_added

		lda #$00
		jsr music_loadsong

	lda #$0a
	sta gamename_ticker
	
	lda #$28
	sta hi_ppu_addy
	lda #$00
	sta lo_ppu_addy
	
	lda #$01
	sta number_of_players
	sta which_player

	lda #<title_loop
	sta loop_pointer+0
	lda #>title_loop
	sta loop_pointer+1
	lda #<title_nmi
	sta nmi_pointer+0
	lda #>title_nmi
	sta nmi_pointer+1

	jsr vblank_wait
	lda #$00
	sta $2006
	sta $2006
	sta $2005
	sta $2005
	jsr PPU_with_sprites

	ldx #$00
	stx temp

	jsr nmi_wait
loop_main:
	jmp (loop_pointer)
end_loop:
	jsr nmi_wait
	jmp loop_main

title_loop:
	jsr do_random_number
	jsr test_secret_controller_code
	jsr test_secret_controller_code2
	jsr title_menu
	jsr animate_gamename_palette

	lda p1_set
	beq :+
		jsr black_it_out
		jmp snail_wait_loop
:	lda pong_set
	beq :+
		lda #<nmi_pong
		sta nmi_pointer+0
		lda #>nmi_pong
		sta nmi_pointer+1
		jsr black_it
		jsr nmi_wait
		jsr PPU_off
		jmp reset_pong
:
	jmp end_loop

win_screen_going_on:
	lda control_pad
	eor control_old
	and control_pad
	and #start_punch
	beq @no_start
		lda #$00
		tax
:		sta slydog, x
		inx
		cpx #(sly_end - sly_words)
		bne :-
		jmp reset
@no_start:
	jmp win_screen_going_on


win_screen:
	ldy #$00						; Load the title screen
	ldx #$04						;
	lda #<win_screen_nt				;
	sta screen_pointer				;
	lda #>win_screen_nt				;
	sta screen_pointer+1			;
	lda #$20						;
	sta $2006						;
	lda #$00						;
	sta $2006						;
:	lda (screen_pointer),y			;
	sta $2007						;
	iny								;
	bne :-							;
	inc screen_pointer+1			;
	dex								;
	bne :-							;

	ldx #$00
:	lda palette,x
	sta pal_address,x
	inx
	cpx #$20
	bne :-

		lda #$08
		jsr music_loadsong

	rts

blank_nmi:
	jmp finish_nmi

sly_words:
	.byte "SLYDOGSTUDIOS"
sly_end:
