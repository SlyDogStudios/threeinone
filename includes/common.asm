nmi_wait:
	lda nmi_num
:	cmp nmi_num
	beq :-
	rts

PPU_off:
	lda #$00						; turn off PPU
	sta $2000
	sta reg2000_save
	sta $2001
	sta reg2001_save
	rts

PPU_with_sprites:
	lda #%10000000
	sta $2000
	sta reg2000_save
	lda #%00011010
	sta $2001
	sta reg2001_save
	rts

PPU_other_chr_with_sprites:
	lda #%10011000
	sta $2000
	sta reg2000_save
	lda #%00011010
	sta $2001
	sta reg2001_save
	rts

vblank_wait:						; I think we all know what this is!
:	bit $2002
	bpl :-
	rts

; *********************************************************
; The control routine called in NMI                       *
; *********************************************************
controller:
	lda #$01
	sta $4016
	lda #$00
	sta $4016
	lda control_pad
	sta control_old
	ldx #$08
:	lda $4016
	lsr A
	ror control_pad
	dex
	bne :-
    lda control_pad2 
    sta control_old2 
    ldx #$08 
:   lda $4017 
    lsr A 
    ror control_pad2 
    dex 
    bne :-  
	rts
