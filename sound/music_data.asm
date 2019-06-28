; This relies on the ability of the assembler to read labels and put data bytes
; and all that other good stuff. No actual assembly is used here, just data.

;;;;;;;;;;;;;;;;;
;;  envelopes  ;;
;;;;;;;;;;;;;;;;;
;; 10 - Jump to position XX
;; FF - Stop envelope

; Each byte is just simply written to register 0 of whatever channel is using the
; envelope, after one of the useless bits being masked out so commands (yep, all
; two of them) could exist. Triangle channel completely ignores envelopes.
; It's *highly* recommended that the first envelope is a silent one.

envelopes:
	.addr env_blank
	.addr env_lead1, env_nse_hat, env_nse_hat2, env_nse_snare, env_lead2
	.addr bass_drum1, testit, ttt_sq2_intro, blah, peg_env
	.addr sq4sound
env_blank:
 .byte	$00,$FF
env_lead1:
 .byte	$0F,$0D,$0B,$09,$07,$05,$04,$04,$04,$04,$05,$05,$06,$06,$06,$06,$05,$05,$10,$06
env_nse_hat:
 .byte	$0F,$0C,$00,$FF
env_nse_hat2:
 .byte	$0F,$0B,$07,$03,$FF
env_nse_snare:
 .byte	$0F,$08,$0C,$06,$04,$03,$02,$02,$01,$01,$00,$FF
env_lead2:
 .byte	$8C,$8E,$8F,$8E,$8C,$8A,$89,$88,$87,$86,$85,$84,$FF
bass_drum1:
	.byte $0f,$10,$12,$16,$19,$1e,$22,$27,$30,$21,$20,$1a,$19,$16,$14,$10,$0f,$ff
testit:
	.byte $84,$85,$86,$86,$86,$86,$85,$84,$ff
ttt_sq2_intro:
	.byte $01,$01,$01,$01,$02,$01,$02,$01,$02,$01,$03,$02,$03,$02,$03,$02
	.byte $04,$03,$04,$03,$05,$04,$05,$06,$05,$06,$05,$07,$06,$07,$06,$07
	.byte $08,$07,$08,$07,$09,$08,$09,$0a,$09,$0a,$09,$0b,$0a,$0b,$0a,$0b
	.byte $0c,$0b,$0c,$0b,$0c,$0b,$0c,$0b,$0c,$0b,$0c,$0b,$0c,$0b,$0c,$0b,$ff
could_be_evil:
	.byte $c8,$c9,$ca,$cf,$ce,$cf,$ce,$cf,$ce,$cd,$ff
blah:
	.byte $01,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
	.byte $0f,$0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01,$01,$10,$00
	.byte $41,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f
	.byte $81,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
;	.byte $c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
peg_env:
	.byte $03,$05,$06,$03,$07,$08,$08,$09,$08,$07,$06,$05,$ff
sq4sound:
	.byte $41,$4a,$4d,$4d,$4d,$4a,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$ff

;;;;;;;;;;;;;;;;;;
;;  song table  ;;
;;;;;;;;;;;;;;;;;;
; This determines what song is assigned to what value when loading songs
songs:
	.addr silence
	.addr title, clik_song, clear, dying, ttt_song
	.addr ttt_win_song, snail_song, peg_song, all_song, pppt_song
	.addr peg1_song

;;;;;;;;;;;;;
;;  songs  ;;
;;;;;;;;;;;;;
;; C8 XX - silent rest for XX cycles
;; C0 XX - do nothing (just extend the note for another XX cycles)
;; C1 XX - precut (cut the note XX cycles before it ends)
;; C2 XX - set envelope to XX
;; C3 YY XX ZZ - jump to YYXX, ZZ times
;; C4 YY XX - jump to YYXX
;; C5 XX - set detune to XX (01-7F up, 80-FF down, 00 none)
;; C6 XX - decrease envelope volume by XX
;; C7 XX - set pitch bend to XX (01-7F down, 80-FE up, 00 none)
;; C9 XX - set tempo-independent pitch bend (functions the same as C7)
;; FF - Track end (the track stops playing here)

; The first 4 words in the list are the pointer for square 1, square 2, tri, noise
; in that order, followed by a byte that defines the tempo. Lower values are
; slower, higher are faster, 00 is infinitely slow, making the song stop.
; If you don't use a particular channel for a song, just put $0000 as the pointer.
; All four channels can be used at once. It's *highly* recommended that you reserve
; one song in your playlist to be a silent song.

silence:
 .word $0000, $0000, $0000, $0000
 .byte $00
title:
	.addr title_sq1, title_sq2, title_tri, title_nse
	.byte $f0
clik_song:
	.addr clik_sq1, clik_sq2, clik_tri, clik_nse
	.byte $a0
clear:
	.addr clear_sq1, clear_sq2, clear_tri, clear_nse
	.byte $90
dying:
	.addr dying_sq1, dying_sq2, dying_tri, dying_nse
	.byte $90
ttt_song:
	.addr ttt_song_sq1, ttt_song_sq2, ttt_song_tri, ttt_song_nse
	.byte $c0
ttt_win_song:
	.addr ttt_win_sq1, ttt_win_sq2, ttt_win_tri, ttt_win_nse
	.byte $c0
snail_song:
	.addr snail_sq1, snail_sq2, snail_tri, snail_nse
	.byte $d8
peg_song:
	.addr peg_sq1_0, peg_sq2_0, peg_tri0, peg_nse0
	.byte $b0
all_song:
	.addr all_song_sq1, all_song_sq2, all_song_tri, all_song_nse
	.byte $c0
pppt_song:
	.addr pppt_song_sq1, pppt_song_sq2, pppt_song_tri, pppt_song_nse
	.byte $c0
peg1_song:
	.addr peg1_sq1, peg1_sq2, peg1_tri, peg1_nse
	.byte $d8
; Song data is just <note> <duration> for each note, or <command> <data>... for
; commands (see table above). For <note>, the higher nybble is the actual note
; (the scale begins with A, so 0x is A, 1x is A#, 2x is B, etc), and the lower
; nybble is the octave. The tracks are state machines, so whatever commands you
; apply (like envelope, detune, pitch bend, etc) will stick until you change them,
; or until a new song is loaded.


peg1_sq1:
	.byte $c2,$01
	.byte $02,$08,$02,$08, $c8,$20, $02,$08,$02,$08, $c8,$40
	.byte $02,$08,$02,$08, $c8,$20, $02,$08,$02,$08, $c8,$10, $03,$08,$43,$08,$73,$08,$a2,$08,$73,$08,$43,$08
	.byte $52,$08,$52,$08, $c8,$20, $52,$08,$52,$08, $c8,$10, $52,$08,$92,$08,$03,$08,$53,$08,$03,$08,$92,$08
	.byte $02,$08,$02,$08, $c8,$20, $02,$08,$02,$08, $c8,$40
	.byte $72,$08,$72,$08, $c8,$20, $b2,$08,$b2,$08, $c8,$40
	.byte $03,$08,$03,$08, $c8,$20, $72,$08,$72,$08, $53,$04,$c8,$04, $a3,$08,$b3,$08, $03,$28
	.byte $c4,<peg1_sq1,>peg1_sq1
	.byte $ff
peg1_sq2:
	.byte $c2,$01
	.byte $72,$0a,$72,$08, $c8,$20, $72,$08,$72,$08, $c8,$40
	.byte $42,$08,$42,$08, $c8,$20, $72,$08,$42,$08, $c8,$40
	.byte $03,$08,$03,$08, $c8,$20, $03,$08,$03,$08, $c8,$40
	.byte $42,$08,$42,$08, $c8,$20, $42,$08,$72,$08, $c8,$40
	.byte $23,$08,$23,$08, $c8,$20, $33,$08,$33,$08, $c8,$40
	.byte $73,$08,$73,$08, $c8,$20, $23,$08,$23,$08, $03,$04,$c8,$04, $a3,$08,$b3,$08, $73,$26;$c8,$3e
	.byte $c4,<peg1_sq2,>peg1_sq2
	.byte $ff
peg1_tri:
	.byte $c1,$01
	.byte $02,$10, $42,$10, $72,$10, $92,$10, $03,$10, $92,$10, $72,$10, $42,$10
	.byte $02,$10, $42,$10, $72,$10, $92,$10, $a2,$10, $92,$10, $72,$10, $42,$10
	.byte $52,$10, $92,$10, $03,$10, $23,$10, $53,$10, $23,$10, $03,$10, $92,$10
	.byte $02,$10, $42,$10, $72,$10, $92,$10, $a2,$10, $92,$10, $72,$10, $42,$10
	.byte $72,$10, $b2,$10, $23,$10, $b2,$10, $52,$10, $92,$10, $a2,$10, $b2,$10
	.byte $03,$10, $a2,$10, $92,$10, $72,$10, $52,$04, $c8,$04, $a2,$08, $b2,$08, $03,$18, $71,$04,$a1,$0c
	.byte $c4,<peg1_tri,>peg1_tri
	.byte $ff
peg1_nse:
	.byte $c2,$04
	.byte $02,$0e,$00,$02, $00,$0e,$00,$02
	.byte $c4,<peg1_nse,>peg1_nse
	.byte $ff




pppt_song_sq1:
	.byte $c2,$07
	.byte $c7,$03,$01,$20
	.byte $ff
pppt_song_sq2:
	.byte $c2,$07
	.byte $71,$08
	.byte $ff
pppt_song_tri:
	.byte $01,$08
	.byte $ff
pppt_song_nse:
	.byte $c2,$05
	.byte $c7,$01,$0a,$40
	.byte $ff

all_song_sq1:
;	.byte $c8,$30
	.byte $c2,$0b
	.byte $50,$10, $30,$10, $00,$20
	.byte $ff
all_song_sq2:
;	.byte $c8,$30
	.byte $c2,$0b
	.byte $80,$10, $60,$10, $30,$20
	.byte $ff
all_song_tri:
;	.byte $c8,$30
	.byte $52,$10, $32,$10, $02,$20
	.byte $ff
all_song_nse:
;	.byte $c8,$30
	.byte $c2,$04
	.byte $00,$10,$00,$10,$00,$10
	.byte $ff

; *******************************************************
; Pegboard                                              *
; *******************************************************

peg_sq1_0:
	.byte $c8,$30
peg_sq1:
	.byte $c2,$01
	.byte $01,$20, $51,$10, $02,$40
	.byte $01,$20, $51,$10, $02,$40
	.byte $01,$20, $51,$10, $02,$40
	.byte $41,$20, $51,$10, $22,$40
	.byte $c3,<peg_sq1,>peg_sq1,$03
peg_sq1_1:
	.byte $51,$20, $a1,$20, $21,$20, $71,$20
	.byte $51,$20, $a1,$20, $21,$20, $71,$20
	.byte $51,$20, $a1,$20, $21,$20, $71,$20
	.byte $51,$20, $a1,$20, $21,$10, $71,$10, $51,$20

	.byte $01,$20, $51,$10, $02,$40
	.byte $01,$20, $51,$10, $02,$40
	.byte $01,$20, $51,$10, $02,$40
	.byte $41,$20, $51,$10, $22,$40

	.byte $51,$20, $a1,$20, $21,$20, $71,$20
	.byte $51,$20, $a1,$20, $21,$20, $71,$20
	.byte $51,$20, $a1,$20, $21,$20, $71,$20
	.byte $52,$08,$03,$08,$92,$08,$52,$08, $a3,$08,$54,$08,$24,$08,$a3,$08
	.byte $22,$08,$92,$08,$72,$08,$22,$08, $02,$20
	.byte $c4,<peg_sq1,>peg_sq1
	.byte $ff

peg_sq2_0:
	.byte $c8,$30
peg_sq2:
	.byte $c2,$01
	.byte $71,$20, $02,$10, $71,$40
	.byte $71,$20, $02,$10, $71,$40
	.byte $71,$20, $02,$10, $71,$40
	.byte $b1,$20, $02,$10, $92,$40
	.byte $c3,<peg_sq2,>peg_sq2,$03
peg_sq2_1:
	.byte $91,$20, $22,$20, $52,$20, $a1,$20
	.byte $02,$20, $52,$20, $92,$20, $22,$20
	.byte $91,$20, $22,$20, $52,$20, $a1,$20
	.byte $52,$20, $a2,$20, $22,$10, $72,$10, $52,$20
peg_sq2_2:
	.byte $41,$10,$41,$10,$91,$10, $41,$08,$21,$08,$01,$08,$21,$08,$41,$08,$21,$08,$01,$08,$21,$08
	.byte $02,$10,$22,$10,$71,$10, $72,$08,$21,$10,$22,$10,$21,$08,$02,$08,$21,$08
	.byte $41,$10,$41,$10,$91,$10, $41,$08,$21,$08,$01,$08,$21,$08,$41,$08,$21,$08,$01,$08,$21,$08
	.byte $02,$10,$22,$10,$71,$10, $72,$08,$21,$10,$22,$10,$21,$08,$02,$08,$21,$08
peg_sq2_3:
	.byte $53,$08,$04,$08,$93,$08,$53,$08, $a4,$08,$55,$08,$25,$08,$a4,$08
	.byte $23,$08,$93,$08,$53,$08,$23,$08, $73,$08,$24,$08,$b3,$08,$73,$08
	.byte $c3,<peg_sq2_3,>peg_sq2_3,$02
	.byte $53,$08,$04,$08,$93,$08,$53,$08, $a4,$08,$55,$08,$25,$08,$a4,$08
	.byte $23,$08,$93,$08,$73,$08,$23,$08, $53,$20
	.byte $c4,<peg_sq2,>peg_sq2
	.byte $ff

peg_tri0:
	.byte $c8,$30
peg_tri:
	.byte $c1,$04
	.byte $02,$10, $03,$10, $c8,$08, $c1,$01,$52,$04,$52,$04,$52,$08, $72,$10, $a2,$10, $72,$08, $52,$08, $42,$08
	.byte $c1,$04
	.byte $02,$10, $03,$10, $c8,$10, $c1,$01,$72,$08,$a2,$08, $92,$08, $72,$10, $72,$08, $42,$08, $22,$08
	.byte $c1,$04
	.byte $02,$10, $03,$10, $c8,$08, $c1,$01,$52,$04,$52,$04,$52,$08, $72,$10, $a2,$10, $72,$08, $52,$08, $42,$08
	.byte $c1,$04
	.byte $42,$10, $02,$10, $c8,$10, $c1,$01,$42,$08,$52,$08, $42,$08, $22,$10, $71,$08, $a1,$08, $b1,$08
;	.byte $02,$20, $32,$08,$02,$08,$22,$08,$32,$08
	.byte $c3,<peg_tri,>peg_tri,$03
peg_tri1:
	.byte $c1,$01
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$22,$08,$72,$10,        $71,$08,$72,$08,$71,$08
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$22,$08,$72,$10,        $71,$08,$72,$08,$71,$08
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$22,$08,$72,$10,        $71,$08,$72,$08,$71,$08
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$72,$08,$73,$08,$02,$20

	.byte $c1,$04
	.byte $02,$10, $03,$10, $c8,$08, $c1,$01,$52,$04,$52,$04,$52,$08, $72,$10, $a2,$10, $72,$08, $52,$08, $42,$08
	.byte $c1,$04
	.byte $02,$10, $03,$10, $c8,$10, $c1,$01,$72,$08,$a2,$08, $92,$08, $72,$10, $72,$08, $42,$08, $22,$08
	.byte $c1,$04
	.byte $02,$10, $03,$10, $c8,$08, $c1,$01,$52,$04,$52,$04,$52,$08, $72,$10, $a2,$10, $72,$08, $52,$08, $42,$08
	.byte $c1,$04
	.byte $42,$10, $02,$10, $c8,$10, $c1,$01,$42,$08,$52,$08, $42,$08, $22,$10, $71,$08, $a1,$08, $b1,$08

	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$22,$08,$72,$10,        $71,$08,$72,$08,$71,$08
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$22,$08,$72,$10,        $71,$08,$72,$08,$71,$08
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$22,$08,$72,$10,        $71,$08,$72,$08,$71,$08
	.byte $52,$08,$53,$08,$52,$08,$53,$08,$a2,$08,$a3,$08,$a2,$08,$a3,$08
	.byte $22,$08,$23,$08,$72,$08,$73,$08,$02,$20
	.byte $c4,<peg_tri,>peg_tri
	.byte $ff
peg_nse0:
	.byte $c2,$01
	.byte $02,$10,$02,$10,$02,$10
peg_nse:
	.byte $c2,$01
	.byte $0e,$08,$00,$08, $0d,$10, $00,$08,$0e,$04,$0e,$04, $0d,$08,$00,$08, $00,$08,$00,$08, $00,$08,$0d,$10,$00,$08
	.byte $0e,$08,$00,$08, $0d,$10, $00,$08,$0e,$04,$0e,$04, $0d,$08,$00,$08, $02,$10, $00,$08,$0d,$10,$02,$08
	.byte $c3,<peg_nse,>peg_nse,$07
peg_nse1:
	.byte $04,$10,$0d,$08,$02,$08,$0e,$08,$02,$08,$0d,$08,$02,$04,$02,$04,$0e,$08,$02,$08,$0d,$08,$02,$08,$0e,$08,$02,$08,$0d,$08,$02,$04,$02,$04
	.byte $c3,<peg_nse1,>peg_nse1,$03
peg_nse2:
	.byte $0e,$08,$00,$08, $0d,$10, $00,$08,$0e,$04,$0e,$04, $0d,$08,$00,$08, $00,$08,$00,$08, $00,$08,$0d,$10,$00,$08
	.byte $0e,$08,$00,$08, $0d,$10, $00,$08,$0e,$04,$0e,$04, $0d,$08,$00,$08, $02,$10, $00,$08,$0d,$10,$02,$08
	.byte $c3,<peg_nse2,>peg_nse2,$01
peg_nse3:
	.byte $04,$10,$0d,$08,$02,$08,$0e,$08,$02,$08,$0d,$08,$02,$04,$02,$04,$0e,$08,$02,$08,$0d,$08,$02,$08,$0e,$08,$02,$08,$0d,$08,$02,$04,$02,$04
	.byte $c3,<peg_nse3,>peg_nse3,$03
	.byte $c4,<peg_nse,>peg_nse
	.byte $ff



; *******************************************************
; Title Screen                                          *
; *******************************************************

title_sq1:
	.byte $c2,$01
	.byte $70,$10, $21,$10, $70,$20, $01,$10, $71,$10, $01,$20
	.byte $31,$20, $11,$10, $01,$20, $31,$08, $41,$08, $51,$20, $51,$10, $ff
title_sq2:
	.byte $c2,$01
	.byte $20,$10, $91,$10, $20,$20, $70,$10, $01,$10, $70,$20
	.byte $a1,$20, $91,$10, $70,$20, $a0,$08, $b0,$08, $01,$20, $01,$10, $ff
title_tri:
	.byte $c1,$01
	.byte $72,$08, $72,$08, $22,$08, $72,$08, $72,$08, $72,$08, $a2,$08, $b2,$08
	.byte $03,$08, $03,$08, $73,$08, $03,$08, $03,$08, $03,$08, $13,$08, $23,$08
	.byte $33,$08, $33,$08, $33,$08, $33,$08, $13,$08, $14,$08, $03,$08, $03,$08
	.byte $03,$08, $03,$08, $33,$08, $43,$08, $53,$08, $04,$08, $54,$08, $04,$08, $53,$10
	.byte $ff
title_nse:
	.byte $c2,$04
	.byte $0e,$08, $00,$08, $0d,$08, $0e,$08, $0e,$08, $0e,$08, $0d,$08, $00,$08
	.byte $0e,$08, $00,$08, $0d,$08, $0e,$08, $0e,$08, $0e,$08, $0d,$08, $00,$08
	.byte $0e,$08, $00,$08, $0d,$08, $0e,$08, $0e,$08, $0e,$08, $0d,$08, $00,$08
	.byte $0e,$08, $00,$08, $0d,$08, $0e,$08, $0e,$08, $0e,$08, $0d,$08, $00,$08, $0d,$10, $ff


;*******************************************
; CLIK
;*******************************************
clik_sq1:
	.byte $c2,$01
	.byte $30,$08, $30,$08, $c8,$08, $50,$08, $50,$08, $60,$08, $c8,$08, $20,$08
	.byte $c3,<clik_sq1,>clik_sq1,$03
clik_sq1_1:
	.byte $30,$08, $30,$08, $c8,$08, $50,$08, $50,$08, $60,$08, $c8,$08, $20,$08
	.byte $c3,<clik_sq1_1,>clik_sq1_1,$03
clik_sq1_2:
	.byte $30,$04,$31,$04, $30,$04,$31,$04, $a0,$04,$a1,$04, $50,$04,$51,$04
	.byte $50,$04,$51,$04, $60,$04,$61,$04, $30,$04,$31,$04, $60,$08
	.byte $c3,<clik_sq1_2,>clik_sq1_2,$0b
clik_sq1_3:
	.byte $a1,$10, $c8,$08, $01,$08, $02,$08, $11,$08, $c8,$08, $21,$08
	.byte $c3,<clik_sq1_3,>clik_sq1_3,$03
	.byte $c4,<clik_sq1,>clik_sq1
	.byte $ff
clik_sq2:
	.byte $c2,$01
	.byte $a0,$08, $a0,$08, $c8,$08, $00,$08, $00,$08, $10,$08, $c8,$08, $20,$08
	.byte $c3,<clik_sq2,>clik_sq2,$03
clik_sq2_1:
	.byte $a0,$08, $a0,$08, $c8,$08, $00,$08, $00,$08, $10,$08, $c8,$08, $20,$08
	.byte $c3,<clik_sq2_1,>clik_sq2_1,$07
clik_sq2_2:
	.byte $c2,$05
	.byte $a1,$10, $c8,$08, $01,$08, $02,$08, $11,$08, $c8,$08, $21,$08
	.byte $c3,<clik_sq2_2,>clik_sq2_2,$0b
	.byte $c4,<clik_sq2,>clik_sq2
	.byte $ff
clik_tri:
	.byte $c1,$00
	.byte $32,$02, $c8,$0e, $a2,$02, $c8,$06, $32,$02, $c8,$16, $a2,$02, $c8,$0e
	.byte $c3,<clik_tri,>clik_tri,$03
clik_tri_1:
	.byte $32,$02, $31,$06, $a1,$08, $a2,$02, $51,$06, $32,$02, $51,$06, $61,$10, $a2,$02, $c8,$0e
	.byte $c3,<clik_tri_1,>clik_tri_1,$0f
clik_tri_2:
	.byte $c1,$01
	.byte $a3,$08,$a3,$08, $c8,$08, $03,$08, $03,$08, $13,$08, $c8,$08, $23,$08
	.byte $c3,<clik_tri_2,>clik_tri_2,$03
	.byte $c4,<clik_tri,>clik_tri
	.byte $ff
clik_nse:
	.byte $c2,$04
	.byte $0e,$08, $00,$08, $0d,$08, $0e,$08, $00,$08, $00,$08, $0d,$08, $00,$08
	.byte $c4,<clik_nse,>clik_nse

;*******************************************
; TTT SONG
;*******************************************
ttt_song_sq1:
	.byte $c8,$80, $c0,$80
ttt_song_sq1_2:
	.byte $c2,$07
	.byte $50,$08, $c8,$08, $51,$08, $50,$08, $c8,$08, $51,$08, $50,$08, $51,$08
	.byte $50,$08, $c8,$08, $51,$08, $50,$08, $c8,$08, $51,$08, $50,$08, $51,$08
	.byte $30,$08, $c8,$08, $31,$08, $30,$08, $c8,$08, $31,$08, $30,$08, $31,$08
	.byte $60,$08, $c8,$08, $61,$08, $60,$08, $c8,$08, $61,$08, $60,$08, $61,$08
	.byte $c3,<ttt_song_sq1_2,>ttt_song_sq1_2,$02
ttt_song_sq1_3:
	.byte $92,$18, $82,$10, $52,$38, $c8,$08, $52,$08, $82,$08, $92,$08
	.byte $a2,$40, $92,$18, $62,$08, $c8,$08, $61,$08, $60,$08, $61,$08
	.byte $50,$08, $c8,$08, $51,$08, $50,$08, $c8,$08, $51,$08, $50,$08, $51,$08
	.byte $50,$08, $c8,$08, $51,$08, $50,$08, $c8,$08, $51,$08, $50,$08, $51,$08
	.byte $a2,$18, $92,$10, $62,$10, $c8,$08, $92,$18, $62,$08, $c8,$08,$31,$08, $a1,$08, $31,$08
	.byte $c4,<ttt_song_sq1_2,>ttt_song_sq1_2
	.byte $ff
ttt_song_sq2:
	.byte $c8,$80, $c0,$80, $c0,$80, $c0,$40
	.byte $c2,$08
	.byte $10,$40
ttt_song_sq2_2:
	.byte $c2,$01
	.byte $00,$08, $c8,$08, $01,$08, $00,$08, $c8,$08, $01,$08, $00,$08, $01,$08
	.byte $00,$08, $c8,$08, $01,$08, $00,$08, $c8,$08, $01,$08, $00,$08, $01,$08
	.byte $30,$08, $c8,$08, $31,$08, $30,$08, $c8,$08, $31,$08, $30,$08, $31,$08
	.byte $10,$08, $c8,$08, $11,$08, $10,$08, $c8,$08, $11,$08, $10,$08, $11,$08
	.byte $c4,<ttt_song_sq2_2,>ttt_song_sq2_2
	.byte $ff
ttt_song_tri:
;	.byte $c1,$01
	.byte $52,$08, $c8,$08, $53,$08, $52,$08, $c8,$08, $53,$08, $52,$08, $53,$08
	.byte $52,$08, $c8,$08, $53,$08, $52,$08, $c8,$08, $53,$08, $52,$08, $53,$08
	.byte $32,$08, $c8,$08, $33,$08, $32,$08, $c8,$08, $33,$08, $32,$08, $33,$08
	.byte $62,$08, $c8,$08, $63,$08, $62,$08, $c8,$08, $63,$08, $62,$08, $63,$08
	.byte $c4,<ttt_song_tri,>ttt_song_tri
	.byte $ff
ttt_song_nse:
	.byte $c2,$04
	.byte $0e,$08, $00,$08, $0d,$08, $0e,$08, $00,$08, $0d,$08, $0e,$08, $0d,$08
	.byte $c4,<ttt_song_nse,>ttt_song_nse
	.byte $ff

;*******************************************
; SNAIL TRAIL
;*******************************************
; cheat sheet:
; A=0 #=1 B=2 C=3 #=4 D=5 #=6 E=7 F=8 #=9 G=a #=b
snail_sq1:
	.byte $c2,$07
	.byte $30,$08, $40,$08, $50,$08, $60,$08, $90,$08, $90,$08, $20,$08, $30,$08
	.byte $30,$08, $40,$08, $50,$08, $60,$08, $90,$08, $90,$08, $90,$08, $90,$08
	.byte $c3,<snail_sq1,>snail_sq1,$07
snail_sq1_1:
	.byte $c2,$07
	.byte $30,$08, $40,$08, $50,$08, $60,$08, $90,$08, $90,$08, $20,$08, $30,$08
	.byte $c8,$40
	.byte $c3,<snail_sq1_1,>snail_sq1_1,$07
	.byte $c2,$06
	.byte $91,$20,$b1,$20,$51,$20,$61,$20
	.byte $81,$10,$11,$10,$71,$10,$51,$10
	.byte $61,$08,$21,$08,$51,$08,$b1,$08,$21,$08,$61,$08,$11,$08,$81,$08
	.byte $c4,<snail_sq1,>snail_sq1
snail_sq2:
	.byte $c8,$80,$c8,$80
snail_sq2_1:
	.byte $c2,$07
	.byte $a0,$08, $b0,$08, $01,$08, $11,$08, $41,$08, $41,$08, $90,$08, $a0,$08
	.byte $a0,$08, $b0,$08, $01,$08, $11,$08, $41,$08, $41,$08, $41,$08, $41,$08
	.byte $c3,<snail_sq2_1,>snail_sq2_1,$05
snail_sq2_2:
	.byte $c2,$07
	.byte $a0,$08, $b0,$08, $01,$08, $11,$08, $41,$08, $41,$08, $90,$08, $a0,$08
	.byte $c8,$40
	.byte $c3,<snail_sq2_2,>snail_sq2_2,$07
	.byte $c2,$05
	.byte $90,$20,$b0,$20,$50,$20,$60,$20
	.byte $80,$10,$10,$10,$70,$10,$50,$10
	.byte $60,$08,$20,$08,$50,$08,$b0,$08,$20,$08,$60,$08,$10,$08,$80,$08
	.byte $c4,<snail_sq2,>snail_sq2
snail_tri:
	.byte $c8,$60, $c1,$01
	.byte $91,$08, $91,$08, $91,$08, $91,$08
snail_tri_1:
	.byte $c1,$01
	.byte $31,$08, $41,$08, $51,$08, $61,$08, $91,$08, $91,$08, $21,$08, $31,$08
	.byte $31,$08, $41,$08, $51,$08, $61,$08, $91,$08, $91,$08, $91,$08, $91,$08
	.byte $c3,<snail_tri_1,>snail_tri_1,$02
snail_tri_2:
	.byte $c1,$01
	.byte $32,04,$32,$04, $41,$08, $51,$08, $61,$08, $92,$04, $91,$04, $91,$08, $21,$08, $31,$08
	.byte $32,$04, $31,$04, $41,$08, $51,$08, $62,$04, $61,$04, $92,$04, $91,$04, $91,$08, $91,$08, $92,$04, $c8,$04
	.byte $c3,<snail_tri_2,>snail_tri_2,$03
snail_tri_3:
	.byte $32,04,$32,$04, $41,$08, $51,$08, $61,$08, $92,$04, $91,$04, $91,$08, $21,$08, $31,$08
	.byte $32,$04, $c8,$14, $61,$04, $c8,$04, $91,$04, $c8,$14, $92,$04, $c8,$04
	.byte $c3,<snail_tri_3,>snail_tri_3,$07
	.byte $91,$20,$b1,$20,$51,$20,$61,$20
	.byte $81,$10,$11,$10,$71,$10,$51,$10
	.byte $61,$08,$21,$08,$51,$08,$b1,$08,$21,$08,$61,$08,$11,$08,$81,$08
	.byte $c4,<snail_tri,>snail_tri
snail_nse:
	.byte $c8,$80,$c8,$80,$c8,$80,$c8,$80
snail_nse_1:
	.byte $c2,$04
	.byte $0e,04,$0e,$04, $00,$08,$00,$08,$00,$08, $0d,$08, $00,$08,$00,$08, $0e,$08
	.byte $0e,$08, $00,$08,$00,$08, $0e,$08, $0d,$08,$00,$08,$00,$08, $0e,$08
	.byte $c4,<snail_nse_1,>snail_nse_1

;*****************************************
; CLEAR
;*****************************************
clear_sq1:
	.byte $c2,$01
	.byte $00,$01,$10,$01,$20,$01,$30,$01,$40,$01,$50,$01,$60,$01,$70,$01
	.byte $80,$08, $50,$08, $80,$08, $b0,$18, $ff
clear_sq2:
	.byte $c2,$01
	.byte $71,$01,$81,$01,$91,$01,$a1,$01,$b1,$01,$02,$01,$12,$01,$22,$01
	.byte $32,$08, $02,$08, $32,$08, $62,$18, $ff
clear_tri:
	.byte $02,$01,$12,$01,$22,$01,$32,$01,$42,$01,$52,$01,$62,$01,$72,$01
	.byte $83,$08, $53,$08, $83,$08, $b3,$18, $ff
clear_nse:
	.byte $c2,$04
	.byte $00,$08, $00,$08, $00,$08, $00,$08, $00,$18, $ff

;***************************************
; dying
;***************************************
dying_sq1:
	.byte $c2,$01
	.byte $c8,$30, $30,$08, $60,$08, $90,$08, $01,$08, $31,$20, $ff
dying_sq2:
	.byte $c2,$01
	.byte $c8,$30, $a0,$08, $11,$08, $41,$08, $72,$08, $a2,$20, $ff
dying_tri:
	.byte $c8,$30, $33,$08, $63,$08, $93,$08, $04,$08, $34,$20, $ff
dying_nse:
	.byte $ff


ttt_win_sq1:
	.byte $c2,$01
	.byte $62,$01, $72,$01, $82,$01, $92,$01, $a2,$10, $52,$0c, $32,$08, $52,$0c, $72,$18, $a3,$20
	.byte $ff
ttt_win_sq2:
	.byte $c2,$05
	.byte $12,$01, $22,$01, $32,$01, $42,$01, $52,$10, $02,$0c, $a1,$08, $02,$0c, $22,$18, $53,$20
	.byte $ff
ttt_win_tri:
	.byte $62,$01,$72,$01,$82,$01,$92,$01,$a2,$10,$52,$0c,$32,$08,$52,$0c,$72,$18,$a3,$20
	.byte $ff
ttt_win_nse:
	.byte $ff

; Sound effects - Absolutely everything that applies for the music and songs
; applies here too, except sound effects have their own playlist and their
; own envelope table. Also, all sound effects play at tempo $100, which is
; impossible for music, since music tempo only goes up to $FF. When a sound
; effect is playing, it'll interrupt the corresponding channels of the music,
; and then when the sound effect is finished, the music channels it hogged will
; be audible again.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sound effect envelopes  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sfxenvelopes:
 .addr	sfxenv1
sfxenv1:
 .byte	$8F,$8D,$88,$8F,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86,$85,$84,$83,$82,$81,$80,$FF

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sound effect table  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
sounds:
	.addr sfx_silence, got_virus, got_virus2, player_hit, lay_teleport, lay_an_x
	.addr lay_an_o, ttt_init_win, pause_jingle, end_level_score, targeting
	.addr target_explosion, time_expire, teleport_sound, cant_teleport, title_start
	.addr time_tick, take_teleport
;;;;;;;;;;;;;;;;;;;;;
;;  sound effects  ;;
;;;;;;;;;;;;;;;;;;;;;
sfx_silence:
 .word	$0000, $0000, $0000, $0000


got_virus:
	.addr $0000, got_virus_sq2, $0000, $0000
got_virus_sq2:
	.byte $24,$01, $43,$01,$53,$01,$63,$01,$73,$01,$83,$01,$93,$01,$a3,$01, $ff

got_virus2:
	.addr got_virus2_sq1, $0000, $0000, $0000
got_virus2_sq1:
	.byte $a3,$01,$93,$01,$83,$01,$73,$01,$63,$01,$53,$01,$43,$01,$24,$01, $ff

player_hit:
	.addr $0000, player_hit_sq2, player_hit_tri, $0000
player_hit_sq2:
	.byte $30,$01,$45,$04,$35,$01,$25,$01,$15,$01,$05,$01,$b4,$01,$a4,$01,$94,$01
	.byte $84,$01,$74,$01,$64,$01,$54,$01,$44,$01,$34,$01,$24,$01,$14,$01,$04,$01
	.byte $03,$04,$02,$08,$01,$10, $ff
player_hit_tri:
	.byte $31,$01,$45,$04,$35,$01,$25,$01,$15,$01,$05,$01,$b4,$01,$a4,$01,$94,$01
	.byte $84,$01,$74,$01,$64,$01,$54,$01,$44,$01,$34,$01,$24,$01,$14,$01,$04,$01
	.byte $03,$04,$02,$08,$01,$10, $ff

lay_an_x:
	.addr $0000, $0000, lay_an_x_tri, lay_an_x_nse
lay_an_x_tri:
	.byte $53,$02,$63,$02,$73,$02,$83,$02,$ff
lay_an_x_nse:
	.byte $0f,$08,$ff

lay_an_o:
	.addr $0000, $0000, lay_an_o_tri, lay_an_o_nse
lay_an_o_tri:
	.byte $13,$02,$23,$02,$33,$02,$43,$02,$ff
lay_an_o_nse:
	.byte $0f,$08,$ff

ttt_init_win:
	.addr ttt_init_win_sq1, ttt_init_win_sq2, ttt_init_win_tri, $0000
ttt_init_win_sq1:
	.byte $60,$08, $50,$08, $40,$08, $30,$08, $20,$04, $ff
ttt_init_win_sq2:
	.byte $01,$08, $11,$08, $21,$08, $31,$08, $41,$04, $ff
ttt_init_win_tri:
	.byte $63,$08, $53,$08, $43,$08, $33,$08, $42,$04, $ff

pause_jingle:
	.addr pause_sq1, $0000, $0000, $0000
pause_sq1:
	.byte $33,$08, $03,$08, $33,$08, $63,$08, $ff

end_level_score:
	.addr end_level_score_sq1, $0000, $0000, $0000
end_level_score_sq1:
	.byte $64,$08, $ff

targeting:
	.addr targeting_sq1, $0000, $0000, $0000, $0000
targeting_sq1:
	.byte $35,$01,$ff

target_explosion:
	.addr $0000,$0000,$0000,target_ex_nse
target_ex_nse:
	.byte $0f,$10, $ff ; $0f,$10, $ff

time_expire:
	.addr time_expire_sq1, $0000, $0000, $0000
time_expire_sq1:
	.byte $b4,$04, $63,$04, $ff

time_tick:
	.addr time_tick_sq1, $0000, $0000, $0000
time_tick_sq1:
	.byte $b5,$04, $64,$04, $ff

teleport_sound:
	.addr teleport_sound_sq1, teleport_sound_sq2,$0000,$0000
teleport_sound_sq1:
	.byte $30,$01,$70,$01,$31,$01,$71,$01,$32,$01,$72,$01,$ff
teleport_sound_sq2:
	.byte $24,$01,$34,$01,$44,$01,$54,$01,$64,$01,$74,$01,$ff

cant_teleport:
	.addr cant_teleport_sq1,$0000,$0000,$0000
cant_teleport_sq1:
	.byte $30,$08,$30,$08,$ff

take_teleport:
	.addr take_teleport_sq1, $0000, take_teleport_tri, $0000
take_teleport_sq1:
take_teleport_tri:
	.byte $72,$01,$71,$01,$70,$01,$52,$01,$51,$01,$50,$01,$32,$01,$31,$01,$30,$01, $ff

lay_teleport:
	.addr lay_teleport_sq1, $0000, lay_teleport_tri, $0000
lay_teleport_sq1:
lay_teleport_tri:
	.byte $30,$01,$31,$01,$32,$01,$50,$01,$51,$01,$52,$01,$70,$01,$71,$01,$72,$01, $ff

title_start:
	.addr title_start_sq1,title_start_sq2,title_start_tri,title_start_nse
title_start_sq1:
	.byte $c8,$18, $a4,$08, $ff
title_start_sq2:
	.byte $31,$01,$41,$01,$51,$01,$61,$01,$71,$01, $81,$01,$91,$01,$a1,$01,$b1,$01,$32,$01
	.byte $c8,$08, $34,$08, $ff
title_start_tri:
	.byte $31,$10, $ff
title_start_nse:
	.byte $0f,$10, $ff ; $0f,$10, $ff
