


DISPTIME1
	LDD TIMELEFT
	STD DVDADPER
	LDA #16
	STA COUNAD
	CLRA
	CLRB
DISPTIME2
	ASL DVDADPER+1
	ROL DVDADPER
	ROLB
	ROLA
	CMPD #60
	BLO DISPTIME3
	SUBD #60
	INC DVDADPER+1
DISPTIME3
	DEC COUNAD
	BNE DISPTIME2

* B contient secondes
* DVDAPPER+1 contient minutes
