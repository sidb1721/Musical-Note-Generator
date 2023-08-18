; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
LJMP MAIN

ORG 000BH
	
LJMP T0ISR

;ORG 001Bh
;LJMP T1SR

ORG 0030H
	
MAIN:
ACALL LCD_SUBR
ACALL DELAY
MOV A, #80H
ACALL LCD_COMMAND
ACALL DELAY
MOV DPTR, #ROLL
ACALL LCD_SENDSTRING
ACALL DELAY

SOUND:
;TIMER 1 TO COUNT DURATION
; TIMER 0 TO GENERATE FREQUENCY
SETB IE.1; ENABLE TIMER 0 INTERRUPT
SETB IE.7; ENABLE ALL

NOTE1_N1:
MOV R0, #1H
MOV R1,#30
MOV TMOD, #11H
MOV TL0,#03FH
MOV TH0,#0EEH
SETB TR0 ; START FREQ GENERATE
L1:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
H1: JNB TF1, H1
	CLR TR1
	CLR TF1
	DJNZ R1, L1 ;30 TIMES


NOTE2_N2:
MOV R0, #2H
MOV R1, #30
MOV TMOD, #11H
MOV TL0,#02FH
MOV TH0,#0F0H
SETB TR0 ; START FREQ GENERATE
L2:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
	H2: JNB TF1, H2
	CLR TR1
	CLR TF1
	DJNZ R1, L2 ;30 TIMES
	
NOTE3_N3:
MOV R0, #3H
MOV R1, #30
MOV TMOD,#11H
MOV TL0,#0B7H
MOV TH0,#0F2H
SETB TR0 ; START FREQ GENERATE
L3:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
H3: JNB TF1, H3
	CLR TR1
	CLR TF1
	DJNZ R1, L3 ;30 TIMES
	
NOTE4_N2:
MOV R0, #4H
MOV R1, #30
MOV TMOD,#11H
MOV TL0,#02FH
MOV TH0,#0F0H
SETB TR0 ; START FREQ GENERATE
L4:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
H4: JNB TF1, H4
	CLR TR1
	CLR TF1
	DJNZ R1, L4 ;30 TIMES
	
NOTE5_N4:
MOV R0, #5H
MOV R1, #40
MOV TMOD, #11H
MOV TL0,#071H
MOV TH0,#0F5H
SETB TR0 ; START FREQ GENERATE
L5:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
H5: JNB TF1, H5
	CLR TR1
	CLR TF1
	DJNZ R1, L5 ;30 TIMES
	
NOTE6_SILENCE:
CLR P0.7
MOV R0, #6H
MOV R1, #20
MOV TMOD, #11H
CLR TR0
L6:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
H6: JNB TF1, H6
	CLR TR1
	CLR TF1
	DJNZ R1, L6 ;30 TIMES
	
NOTE7_N4:
SETB P0.7
MOV TMOD, #11H
MOV TL0,#071H
MOV TH0,#0F5H
SETB TR0 ; START FREQ GENERATE
MOV R0, #7H
MOV R1, #40
L7:
MOV TL1,#0B0H
MOV TH1,#3CH ; 25MS DURATION
SETB TR1
H7: JNB TF1, H7
	CLR TR1
	CLR TF1
	DJNZ R1, L7 ;30 TIMES
	
NOTE8_N5:
MOV R0, #8H
MOV R1, #40
MOV TMOD, #11H
MOV TL0,#02AH
MOV TH0,#0F4H
SETB TR0 ; START FREQ GENERATE
L8:
MOV TL1,#0B0H
MOV TH1,#03CH ; 25MS DURATION
SETB TR1
H8: JNB TF1, H8
	CLR TR1
	CLR TF1
	DJNZ R1, L8 ;30 TIMES



LJMP SOUND



T0ISR:

ONE:
CJNE R0,#01H, TWO
CPL P0.7
CLR TR0
MOV TL0,#03FH
MOV TH0,#0EEH
SETB TR0  ; RESTART FREQ GEN
RETI

TWO:
CJNE R0,#02H, THREE
CPL P0.7
CLR TR0
MOV TL0, #02FH
MOV TH0, #0F0H
SETB TR0

RETI

THREE:
CJNE R0,#03H, FOUR
CPL P0.7
CLR TR0
MOV TL0, #0B7H
MOV TH0, #0F2H
SETB TR0

RETI

FOUR:
CJNE R0,#04H, FIVE
CPL P0.7
CLR TR0
MOV TL0, #02FH
MOV TH0, #0F0H
SETB TR0

RETI

FIVE:
CJNE R0,#05H, SEVEN
CPL P0.7
CLR TR0
MOV TL0, #071H
MOV TH0, #0F5H
SETB TR0

RETI


SEVEN:
CJNE R0,#07H, EIGHT
CPL P0.7
CLR TR0
MOV TL0, #071H
MOV TH0, #0F5H
SETB TR0

RETI

EIGHT:
CPL P0.7
CLR TR0
MOV TL0, #02AH
MOV TH0, #0F4H
SETB TR0

RETI




lcd_subr:
      mov P2,#00h
      mov P1,#00h ;initial delay for lcd power up
	;here1:setb p1.0
	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1

	  acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  acall delay
	  ret
	  
hex2ascii:
mov a,30h ; mov 8 bit no to acc
anl a,#0f0h ; get only msb nibble
mov r1,#4 ;
loop: 
rr a
djnz r1, loop ;makes msb nibble become lsb nible and now msb nibble is 0000
clr c
cjne a,#10 ,go
go:
jc nb ;carry generated if 9 or less

na: ;9 above
add a, #37h
mov 60h, a
sjmp skip

nb:;9 below
add a,#30h
mov 60h,a
skip:

mov a ,30h
anl a, #0fh; lsb nibble
clr c
cjne a, #10, go1
go1:
jc nb1 ;carry generated if 9 or less

na1: ;9 above
add a, #37h
mov 61h, a
sjmp skip1

nb1:;9 below
add a,#30h
mov 61h,a
skip1:
ret


org 300h

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret
	 

;------------- ROM text strings---------------------------------------------------------------
org 600h
ROLL:
		 DB "  ROLLING TIME  ",00H

end

	
