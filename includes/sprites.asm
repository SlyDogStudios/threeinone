; *********************************************************
; Sprite original data                                    *
; *********************************************************
the_sprites:
	.byte $47,$2e,$00,$20	; Player left head
	.byte $47,$2f,$00,$28	; Player right head
	.byte $c7,$d7,$01,$28	; middle of tooth gleam
	.byte $c7,$d8,$01,$20	; left tooth gleam
	.byte $bf,$d9,$01,$28	; top tooth gleam
	.byte $c7,$da,$01,$30	; right tooth gleam
	.byte $cf,$db,$01,$28	; bottom tooth gleam
	.byte $ff,$c4,$02,$ff	; ttt left cursor
	.byte $ff,$c5,$02,$ff	; ttt right cursor
	.byte $ff,$9e,$03,$0e	; p1_strike1
	.byte $ff,$9e,$03,$12	; p1_strike2
	.byte $ff,$9e,$03,$16	; p1_strike3
	.byte $ff,$9f,$03,$de	; p2_strike1
	.byte $ff,$9f,$03,$e2	; p2_strike2
	.byte $ff,$9f,$03,$e6	; p2_strike3


	.byte $98,$2e,$00,$3c ; Player left head        THIS WORKS FOR CURSOR POSITION
	.byte $98,$2f,$00,$44 ; Player right head		DURING PLAYER 1 OR 2 SELECTION
