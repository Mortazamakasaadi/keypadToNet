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

keypadState EQU 0x20

delayOuter  EQU 0x21
delayOut    EQU 0x22
delayIn	    EQU 0x23

sixteenHandler EQU 0x24
outerLoopControll EQU 0x25
innerLoopControll EQU 0x26
 
numL EQU 0x27
numH EQU 0x28
numComplete EQU 0x29

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
		MOVLW 0x00
		MOVWF sixteenHandler
		MOVLW 0x04
		MOVWF outerLoopControll
		MOVLW 0x80
		MOVWF numL
		MOVLW 0x08
		MOVWF numH
		  
    outerLoop:	
		RLNCF numL
		MOVLW 0x04
		MOVWF innerLoopControll
    innerLoop:	
		RLNCF numH
		MOVF numH,W
		IORWF numL,W
		MOVWF numComplete
		ANDWF keypadState,W
		SUBWF numComplete,W
		BNZ noTrasmit
		CALL TRANS
    noTrasmit:	INCF sixteenHandler
		MOVF numH,W
		SUBLW 0x80
		BNZ numHNot
		MOVLW 0x08
		MOVWF numH
    numHNot:	DECF innerLoopControll
		BNZ innerLoop
		DECF outerLoopControll
		BNZ outerLoop
		   
		CALL DELAY
		BRA  startOver

;--------------------------------------------------------------------------------transmit function		
TRANS:		    
		    MOVLW A'A'
		    ADDWF sixteenHandler,W					;transmits data to serial
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
		  
