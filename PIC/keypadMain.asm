     ;===============================================================;
     ;								     ;
     ;			  Mortaza Mak Asaadi			     ;
     ;								     ;
     ;								     ;
     ;===============================================================;
    
;--------------------------------------------------------------------------------configs
LIST 	p=pic18f452,f=inhx32,n=0,st=off,r=hex
CONFIG 	osc=hs,oscs=off,wdt=off,pwrt=on,bor=off
CONFIG 	debug=off,lvp=off,stvr=off
;--------------------------------------------------------------------------------include
#include "/usr/share/gputils/header/p18f452.inc"
;--------------------------------------------------------------------------------definitions&aliases
keypadP	EQU PORTB								
keypadT	EQU TRISB

keypadState EQU 0x25

delayOuter EQU 0x26
delayOut EQU 0x27
delayIn EQU 0x28
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
										;only if one key pressed
if1:		MOVLW 0x11							;for now ofcourse
		CPFSEQ keypadState						;next improvement:
		BRA if2								;enable multikey press
		MOVLW A'A'
		CALL TRANS

if2:		MOVLW 0x21
		CPFSEQ keypadState
		BRA if3
		MOVLW A'B'
		CALL TRANS

if3:		MOVLW 0x41
		CPFSEQ keypadState
		BRA if4
		MOVLW A'C'
		CALL TRANS

if4:		MOVLW 0x81
		CPFSEQ keypadState
		BRA if5
		MOVLW A'D'
		CALL TRANS

if5:		MOVLW 0x12
		CPFSEQ keypadState
		BRA if6
		MOVLW A'E'
		CALL TRANS

if6:		MOVLW 0x22
		CPFSEQ keypadState
		BRA if7
		MOVLW A'F'
		CALL TRANS

if7:	    	MOVLW 0x42
		CPFSEQ keypadState
		BRA if8
		MOVLW A'G'
		CALL TRANS

if8:		MOVLW 0x82
		CPFSEQ keypadState
		BRA if9
		MOVLW A'H'	
		CALL TRANS

if9:		MOVLW 0x14
		CPFSEQ keypadState
		BRA if10
		MOVLW A'I'	
		CALL TRANS

if10:		MOVLW 0x24
		CPFSEQ keypadState
		BRA if11
		MOVLW A'J'
		CALL TRANS

if11:	    	MOVLW 0x44
		CPFSEQ keypadState
		BRA if12
		MOVLW A'K'
		CALL TRANS

if12:	    	MOVLW 0x84
		CPFSEQ keypadState
		BRA if13
		MOVLW A'L'
		CALL TRANS

if13:		MOVLW 0x18
		CPFSEQ keypadState
		BRA if14
		MOVLW A'M'
		CALL TRANS

if14:		MOVLW 0x28
		CPFSEQ keypadState
		BRA if15
		MOVLW A'N'
		CALL TRANS

if15:		MOVLW 0x48
		CPFSEQ keypadState
		BRA if16
		MOVLW A'O'
		CALL TRANS

if16:		MOVLW 0x88
		CPFSEQ keypadState
		BRA over
		MOVLW A'P'
		CALL TRANS
	over:	CALL DELAY
		GOTO  startOver
;--------------------------------------------------------------------------------transmit function		
TRANS:										;transmits data to serial
	sendAgain:  BTFSS PIR1,TXIF
		    BRA sendAgain
		    MOVWF TXREG
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
END										;Bye-Bye ;D
		  
