     ;===============================================================;
     ;								     ;
     ;			  Mortaza Mak Asaadi			     ;
     ;								     ;
     ;								     ;
     ;===============================================================;
    
;--------------------------------------------------------------------------------configs
LIST 	p=pic18f452,f=inhx32,n=0,st=off,r=hex					;running on 16MHZ
CONFIG 	osc=hs,oscs=off,wdt=off,pwrt=on,bor=off					;external clock
CONFIG 	debug=off,lvp=off,stvr=off
;--------------------------------------------------------------------------------include
#include "/usr/share/gputils/header/p18f452.inc"
;--------------------------------------------------------------------------------definitions&aliases
keypadP	EQU PORTB								
keypadT	EQU TRISB

keypadState EQU 0x25

delayOuter  EQU 0x26
delayOut    EQU 0x27
delayIn	    EQU 0x28
;--------------------------------------------------------------------------------program starts here
main:		ORG 0x00							;writing over intrupt table
										;we don't need it anyway
										;fornow...
										;hell-yeah! more space!!!
										
;--------------------------------------------------------------------------------setting up serial port
		MOVLW 0x20							
		MOVWF TXSTA							;enable send on serial
		MOVLW 0x19
		MOVWF SPBRG							;set serial speed
		BCF TRISC,TX							;enable TX as output 
		BSF RCSTA,SPEN							;enable serial
		
startOver:
;--------------------------------------------------------------------------------reading keypad upper nibble
		MOVLW 0xf0							;iiiixxxx
		MOVWF keypadT
		NOP
		MOVLW 0x0f
		IORWF keypadP
		NOP
		NOP
		MOVF keypadP,W
		ANDLW 0xf0
		MOVWF keypadState

;--------------------------------------------------------------------------------reading keypad lower nibble
		MOVLW 0x0f							;xxxxiiii
		MOVWF keypadT
		NOP
		MOVLW 0xf0
		IORWF keypadP
		NOP
		NOP
		MOVF keypadP,W
		ANDLW 0x0f
		IORWF keypadState

;--------------------------------------------------------------------------------check keyState and send serial
										;Multi key enabled :D
if1:		MOVLW 0x11;00010001						
		ANDWF keypadState,W
		SUBLW 0x11
		BNZ if2	
		MOVLW A'A'
		CALL TRANS

if2:		MOVLW 0x21;00100001
		ANDWF keypadState,W
		SUBLW 0x21
		BNZ if3
		MOVLW A'B'
		CALL TRANS

if3:		MOVLW 0x41;01000001
		ANDWF keypadState,W
		SUBLW 0x41
		BNZ if4
		MOVLW A'C'
		CALL TRANS

if4:		MOVLW 0x81;10000001
		ANDWF keypadState,W
		SUBLW 0x81
		BNZ if5
		MOVLW A'D'
		CALL TRANS

if5:		MOVLW 0x12;00010010
		ANDWF keypadState,W
		SUBLW 0x12
		BNZ if6
		MOVLW A'E'
		CALL TRANS

if6:		MOVLW 0x22;00100010
		ANDWF keypadState,W
		SUBLW 0x22
		BNZ if7
		MOVLW A'F'
		CALL TRANS

if7:	    	MOVLW 0x42;01000010
		ANDWF keypadState,W
		SUBLW 0x42
		BNZ if8
		MOVLW A'G'
		CALL TRANS


if8:		MOVLW 0x82;10000010
		ANDWF keypadState,W
		SUBLW 0x82
		BNZ if9
		MOVLW A'H'
		CALL TRANS


if9:		MOVLW 0x14;00010100
		ANDWF keypadState,W
		SUBLW 0x14
		BNZ if10
		MOVLW A'I'
		CALL TRANS

if10:		MOVLW 0x24;00100100
		ANDWF keypadState,W
		SUBLW 0x24
		BNZ if11
		MOVLW A'J'
		CALL TRANS

if11:	    	MOVLW 0x44;01000100
		ANDWF keypadState,W
		SUBLW 0x44
		BNZ if12
		MOVLW A'K'
		CALL TRANS

if12:	    	MOVLW 0x84;10000100
		ANDWF keypadState,W
		SUBLW 0x84
		BNZ if13
		MOVLW A'L'
		CALL TRANS

if13:		MOVLW 0x18;00011000
		ANDWF keypadState,W
		SUBLW 0x18
		BNZ if14
		MOVLW A'M'
		CALL TRANS

if14:		MOVLW 0x28;00101000
		ANDWF keypadState,W
		SUBLW 0x28
		BNZ if15
		MOVLW A'N'
		CALL TRANS

if15:		MOVLW 0x48;01001000
		ANDWF keypadState,W
		SUBLW 0x48
		BNZ if16
		MOVLW A'O'
		CALL TRANS

if16:		MOVLW 0x88;10001000
		ANDWF keypadState,W
		SUBLW 0x88
		BNZ over
		MOVLW A'P'
		CALL TRANS
	over:	CALL DELAY
		GOTO  startOver
;--------------------------------------------------------------------------------transmit function		
TRANS:										;transmits data to serial
	sendAgain:  BTFSS PIR1,TXIF						;don't care if none connected
		    BRA sendAgain						;bytes cashed...
		    MOVWF TXREG							;problem! :(
		    RETURN
;--------------------------------------------------------------------------------delay function		    
DELAY:		    MOVLW 0x03							;creates roughly 
		    MOVWF delayOuter						;255*255*3*(1/4MHZ)s
	AGAIN:	    MOVLW 0xff							;delay running on 16MHZ
		    MOVWF delayOut
	AGAIN1:	    MOVLW 0xff
		    MOVWF delayIn
	HERE:	    NOP
		    NOP
		    DECF delayIn,F
		    BNZ HERE
		    DECF delayOut,F
		    BNZ AGAIN1
		    DECF delayOuter,F
		    BNZ AGAIN
		    RETURN		    
;--------------------------------------------------------------------------------end of program
END										
		  
