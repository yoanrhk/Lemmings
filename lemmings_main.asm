
	ORG $7300

DEBUT

	JSR PALZERO

	LDB $E7E6
	PSHS B,CC
	ORCC #$50

	JSR INIECR

	LDB $6081
	ORB #$10
	STB $6081
	CLR $616D

	JSR SCRC
	JSR EFFSCR
	JSR SCRC
	JSR EFFSCR
	JSR SCRC



CREATELEVEL

*
* PREPARATION
* DU NIVEAU
*

	JSR PALZERO

	LDX #LEVTAB
	LDB CURLEVEL
	LSLB
	ABX
	LDD ,X
	LDX #LEVEL
	STD 5,X
	LDX #LAND
	STD 4,X


	LDA #04
	STA $E7E5
	LDX #LEVEL
	JSR READFILE

	LDX #$A000
	LDY #LEVELCARAC
* CNT
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++
* EXIT
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++

* DOOR
	LDD ,X++
	STD ,Y++
	LDD ,X++
	STD ,Y++

* SAVE
	LDD ,X++
	STD ,Y++
	LDA ,X+
	STA ,Y+

	CLR NBOUT
	CLR TOGO

	LDD ,X++
	STD VARX

	LDD #$0100
	LBSR AFFMAP
	JSR COPSCR
	JSR COPSCBANK

	LDA #04
	STA $E7E5

	LDU #$A000+8000
	JSR CLRSCR
	LDU #$C000+8000
	JSR CLRSCR


	LDX #LAND
	JSR READFILE


	LDA #0
	STA $E7DB
	LDD #0
	STB $E7DA
	STA $E7DA
	LDD VARX
	STB $E7DA
	STA $E7DA
	LDD #48
	STB $E7DA
	STA $E7DA
	LDD #3551
	STB $E7DA
	STA $E7DA


	LDA #$05
	STA $E7E5


	LDA NBLEM
	STA PATCH+1

	LDX #LEM

CREELEM

	PSHS A

	LDY DOORX
	STY ,X
	STY 10,X
	LDD DOORY
	STB 2,X
	STB 12,X


	CLR 3,X
	CLR 13,X
	LDA #34
	STA 4,X
	STA 14,X
	CLR 5,X
	CLR 6,X
	CLR 15,X
	CLR 16,X

	CLR 7,X
	CLR 17,X

	CLR 8,X
	CLR 18,X
	CLR 9,X
	CLR 19,X

	PULS A
	LEAX 20,X

	DECA
	BNE CREELEM


	LDX #LEM
	INC 7,X
	INC 17,X

PATCH

	LDA #50
	STA LOOPRESTMOD+1
	STA LOOPSAUVMOD+1
	STA LOOPDISPRMOD+1
	STA LOOPANIMMOD+1
	STA TOGOOUT3+1
	STA NUKE0+1
	STA CALCPER2+3
	STA CALCPER3+2

	CLR NUKETHEMALL

	LDD #300
	STD TIMELEFT
	LDA #20
	STA TIMECHANGE


BOUCLE

	JSR VBLANK
* JSR VBLANK


	JSR SCRC

	LDU #MOUSESTATUS
	CLR 3,U
	JSR RESTMOUSE

	LDA #04
	STA $E7E5


	LDX #LEM

LOOPRESTMOD

	LDA #2
	STA VARA
	CLR SAUVEALL

LOOPREST

*******************
*---- RESTAURE FOND
*******************

RESTBG

	LDA #$05
	STA $E7E5

	LDU #CARAC
	LDB 4+10,X
	LSLB
	LSLB
	CLRA
	LEAU D,U

	LDB 5,U
	STB VARB

	LDD 10,X
	ASRA
	RORB
	ASRA
	RORB
	ASRA
	RORB

	STB RESTBG0+2

	LDB 2+10,X
	LDA #40
	MUL

RESTBG0

	ADDD #$0000
	TFR D,Y

	STY RESTBOMB1+2
	LDA 18,X
	STA RESTBOMB+1

	LDD ,X
	STD 10,X
	LDD 2,X
	STD 12,X
	LDD 4,X
	STD 14,X
	LDD 6,X
	STD 16,X
	LDD 8,X
	STD 18,X

	INC VARB
	LSR VARB

RESTBG2

	LDD $C000,Y
	STD ,Y
	LDU $A000,Y
	STU $2000,Y

	LDD $C000+40,Y
	STD 40,Y
	LDU $A000+40,Y
	STU $2000+40,Y

	LEAY 80,Y

	DEC VARB
	BNE RESTBG2


RESTBOMB

	LDA #$00
	BEQ RESTBOMB2

RESTBOMB1

	LDY #$0000
	LEAY -8*40,Y

	LDD $C000,Y
	STD ,Y
	LDD $A000,Y
	STD $2000,Y

	LDD $C000+40,Y
	STD 40,Y
	LDD $A000+40,Y
	STD $2000+40,Y

	LDD $C000+80,Y
	STD 80,Y
	LDD $A000+80,Y
	STD $2000+80,Y

	LDD $C000+120,Y
	STD 120,Y
	LDD $A000+120,Y
	STD $2000+120,Y

	LDD $C000+160,Y
	STD 160,Y
	LDD $A000+160,Y
	STD $2000+160,Y

RESTBOMB2

	LEAX 20,X
	DEC VARA
	LBNE LOOPREST


LOOPANIMMOD
	LDA #50
	STA VARA
	LDX #LEM

LOOPANIM

	LDA #$04
	STA $E7E5

	LDA 4,X
	LDU #TABANIM
	JSR [A,U]

	LDU #EX1
	LDD ,X
	CMPD ,U
	BLT LOOPANIM1
	CMPD 2,U
	BGT LOOPANIM1
	CLRA
	LDB 2,X
	CMPD 4,U
	BLT LOOPANIM1
	CMPD 6,U
	BGT LOOPANIM1

THEEXIT

	LDA 4,X
	BEQ LOOPANIM1
	CMPA #32
	BEQ LOOPANIM1

	LDA 5,U
	STA 2,X
	LDD ,U
	ADDD #4
	STD ,X
	LDA #32
	STA 4,X
	CLR 3,X


LOOPANIM1

* TOMBE EN DEHORS

	LDA 2,X
	CMPA #155
	BLO LOOPANIM2

* MORT
	CLR 4,X
	CLR 3,X
	CLR 2,X
	DEC NBLEM


LOOPANIM2

*** LEMMING UNDER MOUSE ?

	LDA 4,X
	BEQ NOSELEC
	CMPA #34
	BEQ NOSELEC


	LDU #MOUSESTATUS

	LDD ,U
	SUBD #2
	CMPD ,X
	BGT NOSELEC
	ADDD #16-2
	CMPD ,X
	BLT NOSELEC

	LDA 2,U
	ADDA #8
	CMPA 2,X
	BMI NOSELEC

	SUBA #8
	CMPA 2,X
	BHI NOSELEC

	LDA #1
	STA 3,U
	STX MOUSELEM





NOSELEC


	LEAX 20,X
	DEC VARA
	LBNE LOOPANIM


***
* DISPLAY LEMTEXT
***

	LDY #LEMTEXT
	LDU #MOUSESTATUS
	LDA 3,U
	BEQ DISLEMDOIT

	LDX MOUSELEM

	LDD 5,X
	BEQ DISLEMT3

	LDA 5,X
	BEQ DISLEMT1

	LDA 6,X
	BEQ DISLEMT2

* ATHLETE
	LEAY 9*7,Y
	JMP DISLEMDOIT
* FLOATER
DISLEMT1
	LEAY 3*7,Y
	JMP DISLEMDOIT
* CLIMBER
DISLEMT2
	LEAY 2*7,Y
	JMP DISLEMDOIT
* OTHER
DISLEMT3
	LDA 4,X
	CMPA #2
	BEQ DISLEMT4
	CMPA #4
	BEQ DISLEMT4
	CMPA #18
	BEQ DISLEMT5
	CMPA #22
	BEQ DISLEMT5
	CMPA #26
	BEQ DISLEMT6
	CMPA #28
	BEQ DISLEMT7
	CMPA #38
	BEQ DISLEMT8
	CMPA #40
	BEQ DISLEMT8
	CMPA #42
	BEQ DISLEMT9
	CMPA #44
	BEQ DISLEMT9

	JMP DISLEMDOIT

* WALKER
DISLEMT4
	LEAY 1*7,Y
	JMP DISLEMDOIT
* BUILDER
DISLEMT5
	LEAY 8*7,Y
	JMP DISLEMDOIT
* DIGGER
DISLEMT6
	LEAY 4*7,Y
	JMP DISLEMDOIT
* BLOCKER
DISLEMT7
	LEAY 5*7,Y
	JMP DISLEMDOIT
* MINER
DISLEMT8
	LEAY 6*7,Y
	JMP DISLEMDOIT
* BASHER
DISLEMT9
	LEAY 7*7,Y


DISLEMDOIT
	LDA #7
	LDX #160*40

DISLEMDOIT1
	LDB ,Y+
	JSR AFFFONT
	LEAX 1,X
	DECA
	BNE DISLEMDOIT1


**
* DISPLAY NBOUT & PERCENT
**

DISLEMOUT


	LDX #160*40+18
	LDB TOGO
	JSR AFFNUM

	LDX #160*40+26
	JSR CALCPERCENT
	LEAX 1,X
	LDB #55
	JSR AFFFONT

***
* DISPLAY TIME
***

	DEC TIMECHANGE
	BNE DISPTIME1

	LDA #17
	STA TIMECHANGE

	LDD TIMELEFT
	SUBD #1
	STD TIMELEFT

	LDD TIMELEFT
	LBEQ NOMORELEM

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

	LDX #160*40+36

	PSHS B

	LDB DVDADPER+1
	ADDB #59
	JSR AFFFONT
	LEAX 1,X
	LDB #57
	JSR AFFFONT
	LEAX 1,X
	PULS B
	CMPB #9
	BGT DISPTIME4
	PSHS B
	LDB #59
	JSR AFFFONT
	LEAX 1,X
	PULS B
DISPTIME4
	JSR AFFNUM



NOSAUVALL


*** CRAYON OPTION APPUYE


	JSR $E81B
	BCC NOPRESSED

	LDA PRESSED
	BNE NOPRESSEDFIN

	LDA #1
	STA PRESSED

	LDU #MOUSESTATUS
	LDA 3,U
	BEQ MENU

	LDB SELECTEDOP
	LDU #OPTION
	JSR [B,U]
	JMP NOPRESSEDFIN

MENU
	LDU #MOUSESTATUS
	CLRA
	LDB 2,U
	ADDD #8
	CMPD #176
	BLT NOPRESSEDFIN
	LDD ,U
	ADDD #8
	CMPD #188
	BGT NOPRESSEDFIN
	CMPD #4
	BLT NOPRESSEDFIN


	SUBD #4

	LSRB
	LSRB
	LSRB
	LSRB
	LSLB

	STB SELECTEDOP

	JSR SELECTOPTION


* OPTION 0,1

	LDB SELECTEDOP
	BNE NOLEMAS1

* Option 0
	JSR DECEXIT
	JMP NOLEMASEND
NOLEMAS1
	CMPB #2
	BNE NOLEMAS2

* Option 1
	JSR INCEXIT
	JMP NOLEMASEND
NOLEMAS2
	CMPB #22
	BNE NOLEMAS3

* Nuke Them All

	LDB #1
	STB NUKETHEMALL
	JMP NOLEMASEND

NOLEMAS3

NOLEMASEND
	JMP NOPRESSEDFIN

NOPRESSED

	CLR PRESSED

NOPRESSEDFIN

	JSR MOVEMOUSE

LOOPSAUVMOD
	LDA #2
	STA VARA
	LDU #LEM

LOOPSAUV


***
* NUKE
***

	LDB NUKETHEMALL
	BEQ NUKE4
	LDX #LEM

NUKE0
	LDB #0

NUKE1

	LDA 4,X
	CMPA #0
	BEQ NUKE2
	CMPA #34
	BEQ NUKE3
	CMPA #10
	BEQ NUKE2
	CMPA #12
	BEQ NUKE2
	CMPA #14
	BEQ NUKE2
	CMPA #16
	BEQ NUKE2
	CMPA #36
	BEQ NUKE2
	LDA 8,X
	BNE NUKE2

	LDA #16*5
	STA 8,X
	JMP NUKE4

NUKE2
	DECB
	BEQ NUKE4

	LEAX 20,X
	JMP NUKE1

NUKE3

	CLR 4,X
	CLR 3,X
	DEC NBLEM

NUKE4





LOOPDISPRMOD
	LDA #2
	STA VARA
	LDU #LEM

LOOPDISPR

********************
*---- AFFICHE SPRITE
********************


DISPR
	LDX #CARAC

	LDB 4,U
	LBEQ NEXTANIM
	CMPB #34
	LBEQ NEXTANIM
	LSLB
	LSLB
	ABX

	LDB 2,X
	BNE DISPRDEB1

	LDY #DISPR000
	STY DISPR000-2
	LDY #DISPR030
	STY DISPR030-2

	JMP DISPRDEB2

DISPRDEB1

	LDY #DISPR001
	STY DISPR000-2
	LDY #DISPR1
	STY DISPR030-2

DISPRDEB2


	LDA 5,X
	STA VARB
	LDB #6
	MUL
	STB DISPR02+1
	LDA 7,X
	STA $E7E5

	LDB 2,U
	LDA #40
	MUL
	TFR D,Y

	LDD ,U
	ASRA
	RORB
	ASRA
	RORB
	ASRA
	RORB
	LEAY B,Y
	STY BOMBCNT1+2
DISPR00
	LDB 1,U
	ANDB #7
	STB BOMBCNT2+1
	JMP DISPR000
DISPR000
	ANDB #4
	LSRB
	LSRB
DISPR001
	LDA 3,X
	MUL
	ADDB 3,U
DISPR02
	LDA #5
	MUL
DISPR03
	ADDD ,X
	TFR D,X

	STS PILES
	LEAS $2000,Y

	JMP DISPR030

DISPR030

	STX DISX
	LDB 1,U
	COMB
	ANDB #3
	ASLB

	LDX #DISSFTRA2
	ABX
	STX DISSFTRA2-2
	LDX #DISSFTRB2
	ABX
	STX DISSFTRB2-2

	ASLB
	LDX #DISSFTM2
	ABX
	STX DISSFTM2-2


	LDX DISX

DISSFTM1
	LDD ,X
	JMP DISSFTM2
DISSFTM2
	LSRA
	RORB
	ORA #128
	LSRA
	RORB
	ORA #128
	LSRA
	RORB
	ORA #128
	STD DISMASK

DISSFTRA1
	LDD 2,X
	JMP DISSFTRA2
DISSFTRA2
	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB
	STD DISRAMA

DISSFTRB1
	LDD 4,X
	JMP DISSFTRB2

DISSFTRB2

	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB
	STD DISRAMB

	LDD ,Y
	ANDA DISMASK
	ANDB DISMASK+1
	ORA DISRAMA
	ORB DISRAMA+1
	STD ,Y
	LDD ,S
	ANDA DISMASK
	ANDB DISMASK+1
	ORA DISRAMB
	ORB DISRAMB+1
	STD ,S

	LEAY 40,Y
	LEAS 40,S
	LEAX 6,X
	DEC VARB
	BEQ DISPR3
DISPR2
	JMP DISSFTM1

DISPR1
	LDD ,Y
	ANDA ,X
	ANDB 1,X
	ORA 2,X
	ORB 3,X
	STD ,Y
	LDD ,S
	ANDA ,X
	ANDB 1,X
	ORA 4,X
	ORB 5,X
	STD ,S

	LEAY 40,Y
	LEAS 40,S
	LEAX 6,X

	DEC VARB
	BNE DISPR1





DISPR3

	LDS PILES

BOMBCNT

	LDA 8,U
	LBEQ NEXTANIM

	DEC 8,U
	LDA 8,U
	BNE BOMBCNT1

	CLR 3,U
	LDA #36
	STA 4,U
	JMP NEXTANIM


BOMBCNT1

	LDY #$0000
	LEAY -8*40,Y

	LDX #TINYFONTE
	LDA 2,X
	STA $E7E5
	LDX ,X
BOMBCNT2
	LDA #$00
	LDB #10
	MUL
	LEAX D,X

	LDA 8,U
	ASRA
	ASRA
	ASRA
	ASRA
	LDB #80
	MUL
	LEAX D,X

	LDD ,X
	ORA ,Y
	ORB 1,Y
	STD ,Y
	LDD 2,X
	ORA 40,Y
	ORB 41,Y
	STD 40,Y
	LDD 4,X
	ORA 80,Y
	ORB 81,Y
	STD 80,Y
	LDD 6,X
	ORA 120,Y
	ORB 121,Y
	STD 120,Y
	LDD 8,X
	ORA 160,Y
	ORB 161,Y
	STD 160,Y

	LEAY $2000,Y

	LDD ,X
	ORA ,Y
	ORB 1,Y
	STD ,Y
	LDD 2,X
	ORA 40,Y
	ORB 41,Y
	STD 40,Y
	LDD 4,X
	ORA 80,Y
	ORB 81,Y
	STD 80,Y
	LDD 6,X
	ORA 120,Y
	ORB 121,Y
	STD 120,Y
	LDD 8,X
	ORA 160,Y
	ORB 161,Y
	STD 160,Y

NEXTANIM

	INC 3,U
	LDD 3,U
	LSLB
	LSLB
	LDX #CARAC
	ABX
	CMPA 3,X
	BNE B5

	LDA 4,U
	CMPA #12
	BNE B1


* FLOAT RIGHT

	LDA #4
	STA 3,U
	JMP B5

B1
	CMPA #10
	BNE B2

* FLOAT LEFT

	LDA #4
	STA 3,U
	JMP B5


B2
	CMPA #32
	BNE B3


* EXIT

	LDA 3,U
	CMPA #8
	BNE B5
	CLR 4,U
	DEC NBLEM
	INC NBOUT
	CLR 3,U
	JMP B5
B3
	CMPA #30
	BNE B4

* DROP DEAD

	CLR 4,U
	CLR 3,U
	DEC NBLEM
	JMP B5
B4
	CLR 3,U



B5

	LEAU 20,U
	DEC VARA
	LBNE LOOPDISPR

	JSR DISPCOUNTERS
	JSR DISPMOUSE

* JSR CLAV

	LDA NBLEM
	LBNE BOUCLE


NOMORELEM

***
* NO MORE LEMMINGS
***


	LDA TOSAVE
	LDX #NBOUT
	CMPA ,X

	BLS NEXTLEVEL

* NOT ENOUGH

	JMP CREATELEVEL


* ENOUGH DONE

NEXTLEVEL


	INC CURLEVEL
	JMP CREATELEVEL



THEEND
	CLR $E7DD
	PULS CC,B
	STB $E7E6
	RTS















AFFCOUNTER

	LDU #SMALLFONTE
	LDB 2,U
	STB $E7E5
	LDU ,U

	LDB #8
	MUL

	LEAU D,U
	LEAU 8,U

	LDA ,U+
	STA ,Y
	STA $2000,Y
	LDA ,U+
	STA 40,Y
	STA $2000+40,Y
	LDA ,U+
	STA 80,Y
	STA $2000+80,Y
	LDA ,U+
	STA 120,Y
	STA $2000+120,Y
	LDA ,U+
	STA 160,Y
	STA $2000+160,Y
	LDA ,U+
	STA 200,Y
	STA $2000+200,Y
	LDA ,U+
	STA 240,Y
	STA $2000+240,Y
	LDA ,U
	STA 280,Y
	STA $2000+280,Y


	RTS

*****************
*---- DISPLAY COUNTERS
*****************

DISPCOUNTERS

	LDX #LEVCNT
	LDA #10
	LDY #7081

DISPCOUNTERS1

	PSHS A

	LDA ,X+
	JSR AFFCOUNTER
	LEAY 2,Y
	PULS A
	DECA
	BNE DISPCOUNTERS1

	RTS



*****************
*---- RESTORE MOUSE
*****************

RESTMOUSE

	LDX #MOUSESTATUS
	LDD 4,X
	ASRA
	RORB
	ASRA
	RORB
	ASRA
	RORB

	STB RESTMOUS0+2

	LDB 6,X
	LDA #40
	MUL

RESTMOUS0

	ADDD #$0000
	TFR D,Y

	LDD ,X
	STD 4,X
	LDD 2,X
	STD 6,X

	LDB SCRC0+1
	ANDB #128
	LDX #MOUSEBG
	ABX

	LDB #8
	STB VARB


	LDA #$05
	STA $E7E5

RESTMOUS1

	LDD $C000,Y
	STD ,Y
	LDD $A000,Y
	STD $2000,Y

	LDA $C000+2,Y
	LDB $A000+2,Y
	STA 2,Y
	STB $2000+2,Y

	LDD $C000+40,Y
	STD 40,Y
	LDD $A000+40,Y
	STD $2000+40,Y

	LDA $C000+42,Y
	LDB $A000+42,Y
	STA 42,Y
	STB $2000+42,Y

	LEAY 80,Y

	DEC VARB
	BNE RESTMOUS1


	RTS


*****************
*---- MOVE MOUSE
*****************

MOVEMOUSE

	JSR $E818
	LDU #MOUSESTATUS
	TFR X,D
	SUBD #8
	BPL MOVEMOUS0
	LDD #0
	JMP MOVEMOUS1
MOVEMOUS0
	CMPD #304
	BLT MOVEMOUS1
	LDD #304
MOVEMOUS1
	STD ,U

	TFR Y,D
	SUBD #8
	BMI MOVEMOUS2
	CMPD #184
	BLT MOVEMOUS3
	LDB #184
	JMP MOVEMOUS3
MOVEMOUS2
	CLRB
	STB 2,U
	RTS
MOVEMOUS3
	STB 2,U
	RTS



*****************
*---- DISPLAY MOUSE
*****************

DISPMOUSE

	LDY #MOUSE
	LDX #MOUSESTATUS

	LDB 3,X
	ASLB
	ASLB
	LEAY B,Y
	LDU ,Y

	LDB 1,X
	ANDB #7
	LDA #144
	MUL

	LEAU D,U

	LDD ,X
	ASRA
	RORB
	ASRA
	RORB
	ASRA
	RORB
	STB DISPMOUS0+2

	LDB 2,X
	LDA #40
	MUL

DISPMOUS0

	ADDD #$0000

	TFR D,X

	LDA 3,Y
	STA $E7E5

	LEAY $2000,X

	LDA #8
	STA VARA

DISPMOUS1

	LDD ,X
	ANDA ,U
	ANDB 1,U
	ORA 3,U
	ORB 4,U
	STD ,X
	LDA 2,X
	ANDA 2,U
	ORA 5,U
	STA 2,X

	LDD ,Y
	ANDA ,U
	ANDB 1,U
	ORA 6,U
	ORB 7,U
	STD ,Y
	LDA 2,Y
	ANDA 2,U
	ORA 8,U
	STA 2,Y

	LDD 40,X
	ANDA 9,U
	ANDB 10,U
	ORA 12,U
	ORB 13,U
	STD 40,X
	LDA 42,X
	ANDA 11,U
	ORA 14,U
	STA 42,X

	LDD 40,Y
	ANDA 9,U
	ANDB 10,U
	ORA 15,U
	ORB 16,U
	STD 40,Y
	LDA 42,Y
	ANDA 11,U
	ORA 17,U
	STA 42,Y



	LEAX 80,X
	LEAY 80,Y
	LEAU 18,U

	DEC VARA
	BNE DISPMOUS1

	RTS






*---- AFFICHE MAP

AFFMAP
	STD $61D6
	STX $616B
	LDB #$FF
	STB $6249
	LDB #69
	JMP $EC0C

*---- COPIE DANS ECRAN VIDEO


COPSCR LDD #$0260
	STD $E7E5
	LDX #$0000
	LDU #$C000
	BSR COPSC0
	LDU #$A000
	LDX #$2000
COPSC0 LDY #8000/2
COPSC1 SET *
	LDD ,X++
	STD ,U++
	LEAY -1,Y
	BNE COPSC1

	RTS

*---- COPIE VIDEO DANS BANK

COPSCBANK

	LDD #$0560
	STD $E7E5
	LDX #$0000
	LDU #$C000
	BSR COPSC2
	LDU #$A000
	LDX #$2000
COPSC2 LDY #8000/2
COPSC3 SET *
	LDD ,X++
	STD ,U++
	LEAY -1,Y
	BNE COPSC3

	RTS




*---- SWITCH ECRAN (ZONE CARTOUCHE)

SCRC
	LDB SCRC0+1
	ANDB #$80
	STB $E7DD
	COM SCRC0+1
SCRC0
	LDB #$00
	ANDB #$02
	ORB #$60
	STB $E7E6

	CLR $E7CF

	RTS


*---- SWITCH ECRAN POUR RAM SEULE

SCRCRAM

	COM SCRC0+1
	LDB SCRC0+1
	ANDB #$02
	ORB #$60
	STB $E7E6

	RTS



EFFSCR PSHS A,B,X,Y,U
	LDU #$2000+8000
	LBSR CLRSCR
	LDU #$0000+8000
	LBSR CLRSCR
	PULS U,Y,X,B,A
	RTS


*---- EFFACEMENT ECRAN

CLRSCR PSHS CC,DP
	STS PILEU
	ORCC #$50
	TFR U,S
	CLRA
	CLRB
	TFR D,X
	TFR D,Y
	TFR D,U
	TFR B,DP
	LDA #50
	STA DECMP
	CLRA
CLRSC0 PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS A,B,X,Y,U,DP
	PSHS X,Y,U,DP
	DEC DECMP
	BNE CLRSC0
	LDS PILEU
	PULS CC,DP,PC


*---- PALETTE A ZERO

PALZERO
	CLRA
	STA $E7DB
	STA $E7DA
	STA $E7DA
	STA $E7DA
	STA $E7DA
	STA $E7DA
	STA $E7DA
	STA $E7DA
	STA $E7DA
	RTS



*---- ATTENTE VBL

VBLANK TST $E7E7
	BPL VBLANK
VBLAN0 TST $E7E7
	BMI VBLAN0
	RTS

*---- CLAVIER

CLAV JSR $E809
	BHS CLAV0
	LEAS 2,S
	JMP THEEND
CLAV0 RTS


*---- INITIALISATION DE L'ECRAN

INIECR
	LDB #$1B
	JSR $E803
	LDB #$59
	JSR $E803

	LDB $6081
	ORB #$10
	STB $6081
	STB $E7E7

	RTS



*---- VARIABLES

DISMASK	FDB 0
DISRAMA	FDB 0
DISRAMB	FDB 0
DISX FDB 0

DECMP FCB 0
PILEU FDB 0
PILES FDB 0
COUNT FCB 0
VARX FDB 0
VARA FCB 0
VARB FCB 0

MOUSE FDB $BAD8,8
	FDB $BF58,8

BOMBMASK
	FDB $CB58,8

DIGMASK
	FCB $AC,$CC,8
	FCB $BA,$38,8

LEMTEXT
	FCB 0,0,0,0,0,0,0
	FCB 23,1,12,11,5,18,0
	FCB 3,12,9,13,2,5,18
	FCB 6,12,15,1,20,5,18
	FCB 4,9,7,7,5,18,0
	FCB 2,12,15,3,11,5,18
	FCB 13,9,14,5,18,0,0
	FCB 2,1,19,8,5,18,0
	FCB 2,21,9,12,4,5,18
	FCB 1,20,8,12,5,20,5



CARAC * INACTIVE
	FDB 0,0,10,6
	* WALK LEFT
	FDB $AF00,$0108,10,6
	* WALK RIGHT
	FDB $A000,$0108,10,6
	* CLIMB LEFT
	FDB $C770,8,11,6
	* CLIMB RIGHT
	FDB $C1C0,8,11,6
	* FLOAT LEFT
	FDB $D998,8,16,6
	* FLOAT RIGHT
	FDB $CB90,8,16,6
	* FALL LEFT
	FDB $BFE0,4,10,6
	* FALL RIGHT
	FDB $BE00,4,10,6
	* BRIDGE RIGHT
	FDB $A900,16,13,7
	* WAIT RIGHT
	FDB $B2C0,12,10,7
	* BRIDGE LEFT
	FDB $B860,16,13,7
	* WAIT LEFT
	FDB $C220,12,10,7
	* DIGGER
	FDB $A000,16,12,7
	* STOPPER
	FDB $C7C0,16,10,7
	* DROP DEAD
	FDB $CF40,16,10,7
	* GOING IN
	FDB $D4B8,8,13,6
	* TO GO OUT
	FDB 0,0,10,6
	* BOMBER
	FDB $C3D8,16,10,8
	* DIG RIGHT
	FDB $A000,21,13,8
	* DIG LEFT
	FDB $AD6C,21,13,8
	* BASHER RIGHT
	FDB $A000,32,9,9
	* BASHER LEFT
	FDB $AD80,32,9,9


	INCLUD ANIMLEM
	INCLUD OPTION
	INCLUD FILE
	INCLUD SPRITE


MOUSESTATUS FDB 160,$4700
	FDB 160,$4700
MOUSELEM FDB 0
SAUVEALL FCB 0
SELECTEDOP FCB 0
PRESSED	FCB 0
SMALLFONTE FDB $D190,$0600
TINYFONTE FDB $C5E0,$0600
BIGFONT	FDB $BB00,$0900
MOUSEBG	RMB 256


LEVEL FCB 76,69,86,69,76
	FCB 50,32,32
	FCB 66,73,78

LAND FCB 76,65,78,68,50
	FCB 32,32,32
	FCB 66,73,78

LEVTAB FCB 49,32
	FCB 50,32
	FCB 51,32
	FCB 52,32
	FCB 53,32
	FCB 54,32

CURLEVEL FCB 0

NUKETHEMALL FCB 0

TIMELEFT FDB 300
TIMECHANGE FCB 15



LEVELCARAC
LEVCNT
OP0 FCB 50
OP1 FCB 50
OP2 FCB 0
OP3 FCB 0
OP4 FCB 0
OP5 FCB 0
OP6 FCB 0
OP7 FCB 0
OP8 FCB 0
OP9 FCB 10
EX1 FDB 242
EX2 FDB 255
EY1 FDB 119
EY2 FDB 132
DOORX FDB 0
DOORY FDB 0
NBLEM FCB 10
TOSAVE FCB 1
SAVDIS FCB 10
NBOUT FCB 0
TOGO FCB 0

LEM RMB 100*20

FIN
