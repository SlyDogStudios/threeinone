ca65 threeinone.asm
ld65 -C threeinone.cfg -o threeinone.prg threeinone.o
copy /b threeinone.hdr+threeinone.prg+graphics\title.chr+graphics\threeinone.chr "3-in-1 2p Pak.nes"
pause
