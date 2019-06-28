.include "includes\constants.asm"
.include "sound\music_declarations.asm"

.segment "ZEROPAGE"
.include "includes\zp.asm"

.segment "CODE"
.include "includes\reset.asm"

nmi:
	pha
	txa
	pha
	tya
	pha
	inc nmi_num
	lda reg2000_save
	sta $2000
	lda reg2001_save
	sta $2001
	lda #$00
	sta $2003
	lda #$02
	sta $4014

	lda #$3f
	sta $2006
	lda #$00
	sta $2006
	lda pal_address+0
	sta $2007
	lda pal_address+1
	sta $2007
	lda pal_address+2
	sta $2007
	lda pal_address+3
	sta $2007
	lda pal_address+4
	sta $2007
	lda pal_address+5
	sta $2007
	lda pal_address+6
	sta $2007
	lda pal_address+7
	sta $2007
	lda pal_address+8
	sta $2007
	lda pal_address+9
	sta $2007
	lda pal_address+10
	sta $2007
	lda pal_address+11
	sta $2007
	lda pal_address+12
	sta $2007
	lda pal_address+13
	sta $2007
	lda pal_address+14
	sta $2007
	lda pal_address+15
	sta $2007
	lda pal_address+16
	sta $2007
	lda pal_address+17
	sta $2007
	lda pal_address+18
	sta $2007
	lda pal_address+19
	sta $2007
	lda pal_address+20
	sta $2007
	lda pal_address+21
	sta $2007
	lda pal_address+22
	sta $2007
	lda pal_address+23
	sta $2007
	lda pal_address+24
	sta $2007
	lda pal_address+25
	sta $2007
	lda pal_address+26
	sta $2007
	lda pal_address+27
	sta $2007
	lda pal_address+28
	sta $2007
	lda pal_address+29
	sta $2007
	lda pal_address+30
	sta $2007
	lda pal_address+31
	sta $2007
		jmp (nmi_pointer)
finish_nmi:
	lda #$00
	sta $2006
	sta $2006
	lda #$00
	sta $2005
	lda scroll_y
	sta $2005
	jsr music_play
	jsr controller
end_nmi:
	pla
	tay
	pla
	tax
	pla
irq:
	rti


palette:
.incbin "graphics\title.pal"
.byte $0f,$26,$16,$27, $0f,$30,$0f,$10, $0f,$00,$00,$00, $0f,$11,$05,$00

.include "includes\title.asm"
.include "includes\load_screens.asm"
.include "includes\common.asm"
.include "includes\sprites.asm"
.include "includes\ttt1.asm"
.include "includes\pegboard.asm"
.include "includes\clik.asm"
.include "includes\snail_trail.asm"
.include "includes\bgm.asm"
.include "sound\music_data.asm"
.include "sound\music_engine.asm"
win_screen_nt:
	.incbin "graphics\won_it.nam"
title_screen_nametable:
	.incbin "graphics\title.nam"
snail_nt:
	.incbin "graphics\trail.nam"
.incbin "graphics\snail.pal"
.byte $0f,$23,$37,$12, $0f,$26,$37,$16, $0f,$0f,$0f,$0f, $0f,$0f,$0f,$0f
.include "includes\pong1k_hidden.asm"

.segment "VECTORS"
	.addr nmi
	.addr reset
	.addr irq
