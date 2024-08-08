
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Trafic light system.c,33 :: 		void interrupt()
;Trafic light system.c,35 :: 		if(INTF_BIT){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;Trafic light system.c,36 :: 		INTF_BIT = 0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;Trafic light system.c,37 :: 		if(Phase == 3)Phase = 0;
	MOVF       _Phase+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
	CLRF       _Phase+0
	GOTO       L_interrupt2
L_interrupt1:
;Trafic light system.c,38 :: 		else ++Phase;
	INCF       _Phase+0, 1
L_interrupt2:
;Trafic light system.c,39 :: 		Manual();
	CALL       _Manual+0
;Trafic light system.c,40 :: 		}
L_interrupt0:
;Trafic light system.c,41 :: 		if(RBIF_BIT){
	BTFSS      RBIF_bit+0, BitPos(RBIF_bit+0)
	GOTO       L_interrupt3
;Trafic light system.c,42 :: 		RBIF_BIT = 0;
	BCF        RBIF_bit+0, BitPos(RBIF_bit+0)
;Trafic light system.c,43 :: 		if(Manual_Auto)Manual();
	BTFSS      PORTB+0, 4
	GOTO       L_interrupt4
	CALL       _Manual+0
	GOTO       L_interrupt5
L_interrupt4:
;Trafic light system.c,44 :: 		else Automatic();
	CALL       _Automatic+0
L_interrupt5:
;Trafic light system.c,45 :: 		}
L_interrupt3:
;Trafic light system.c,46 :: 		}
L_end_interrupt:
L__interrupt53:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Trafic light system.c,52 :: 		void main() {
;Trafic light system.c,53 :: 		TRISC = TRISD = INTEDG_BIT = Phase = 0;
	CLRF       _Phase+0
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
	MOVLW      0
	BTFSC      INTEDG_bit+0, BitPos(INTEDG_bit+0)
	MOVLW      1
	MOVWF      TRISD+0
	MOVF       TRISD+0, 0
	MOVWF      TRISC+0
;Trafic light system.c,54 :: 		TRISB.B0 = TRISB.B4 = GIE_BIT = INTE_BIT = RBIE_BIT = RBIF_BIT = 1;
	BSF        RBIF_bit+0, BitPos(RBIF_bit+0)
	BTFSC      RBIF_bit+0, BitPos(RBIF_bit+0)
	GOTO       L__main55
	BCF        RBIE_bit+0, BitPos(RBIE_bit+0)
	GOTO       L__main56
L__main55:
	BSF        RBIE_bit+0, BitPos(RBIE_bit+0)
L__main56:
	BTFSC      RBIE_bit+0, BitPos(RBIE_bit+0)
	GOTO       L__main57
	BCF        INTE_bit+0, BitPos(INTE_bit+0)
	GOTO       L__main58
L__main57:
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
L__main58:
	BTFSC      INTE_bit+0, BitPos(INTE_bit+0)
	GOTO       L__main59
	BCF        GIE_bit+0, BitPos(GIE_bit+0)
	GOTO       L__main60
L__main59:
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
L__main60:
	BTFSC      GIE_bit+0, BitPos(GIE_bit+0)
	GOTO       L__main61
	BCF        TRISB+0, 4
	GOTO       L__main62
L__main61:
	BSF        TRISB+0, 4
L__main62:
	BTFSC      TRISB+0, 4
	GOTO       L__main63
	BCF        TRISB+0, 0
	GOTO       L__main64
L__main63:
	BSF        TRISB+0, 0
L__main64:
;Trafic light system.c,55 :: 		Decoder = 0xF0;
	MOVLW      240
	MOVWF      PORTC+0
;Trafic light system.c,56 :: 		while(1){
L_main6:
;Trafic light system.c,57 :: 		asm sleep;
	SLEEP
;Trafic light system.c,58 :: 		}
	GOTO       L_main6
;Trafic light system.c,59 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_Multiplex_4:

;Trafic light system.c,65 :: 		void Multiplex_4(char N1, char N2){
;Trafic light system.c,67 :: 		Trafic_light = Phases[phase];
	MOVF       _Phase+0, 0
	ADDLW      _phases+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Trafic light system.c,68 :: 		for(i = 0 ; i < 50; ++i){
	CLRF       Multiplex_4_i_L0+0
L_Multiplex_48:
	MOVLW      50
	SUBWF      Multiplex_4_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Multiplex_49
;Trafic light system.c,69 :: 		Decoder = (N1 /10) | ((N1 /10)== 0? 0xf0 : 0b11100000);
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_Multiplex_4_N1+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Multiplex_411
	MOVLW      240
	MOVWF      ?FLOC___Multiplex_4T17+0
	GOTO       L_Multiplex_412
L_Multiplex_411:
	MOVLW      224
	MOVWF      ?FLOC___Multiplex_4T17+0
L_Multiplex_412:
	MOVF       ?FLOC___Multiplex_4T17+0, 0
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;Trafic light system.c,70 :: 		Delay_ms(WAIT);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Multiplex_413:
	DECFSZ     R13+0, 1
	GOTO       L_Multiplex_413
	DECFSZ     R12+0, 1
	GOTO       L_Multiplex_413
	NOP
	NOP
;Trafic light system.c,71 :: 		Decoder = (N1 %10) |  0b11010000;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_Multiplex_4_N1+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      208
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;Trafic light system.c,72 :: 		Delay_ms(WAIT);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Multiplex_414:
	DECFSZ     R13+0, 1
	GOTO       L_Multiplex_414
	DECFSZ     R12+0, 1
	GOTO       L_Multiplex_414
	NOP
	NOP
;Trafic light system.c,73 :: 		Decoder = (N2 /10) | ((N2 /10)== 0 ? 0xf0 : 0b10110000);
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_Multiplex_4_N2+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Multiplex_415
	MOVLW      240
	MOVWF      ?FLOC___Multiplex_4T24+0
	GOTO       L_Multiplex_416
L_Multiplex_415:
	MOVLW      176
	MOVWF      ?FLOC___Multiplex_4T24+0
L_Multiplex_416:
	MOVF       ?FLOC___Multiplex_4T24+0, 0
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;Trafic light system.c,74 :: 		Delay_ms(WAIT);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Multiplex_417:
	DECFSZ     R13+0, 1
	GOTO       L_Multiplex_417
	DECFSZ     R12+0, 1
	GOTO       L_Multiplex_417
	NOP
	NOP
;Trafic light system.c,75 :: 		Decoder = (N2 %10) |  0b01110000;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_Multiplex_4_N2+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      112
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;Trafic light system.c,76 :: 		Delay_ms(WAIT);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Multiplex_418:
	DECFSZ     R13+0, 1
	GOTO       L_Multiplex_418
	DECFSZ     R12+0, 1
	GOTO       L_Multiplex_418
	NOP
	NOP
;Trafic light system.c,68 :: 		for(i = 0 ; i < 50; ++i){
	INCF       Multiplex_4_i_L0+0, 1
;Trafic light system.c,77 :: 		}
	GOTO       L_Multiplex_48
L_Multiplex_49:
;Trafic light system.c,78 :: 		Decoder = 0xF0;
	MOVLW      240
	MOVWF      PORTC+0
;Trafic light system.c,79 :: 		}
L_end_Multiplex_4:
	RETURN
; end of _Multiplex_4

_Automatic:

;Trafic light system.c,84 :: 		void Automatic(){
;Trafic light system.c,85 :: 		Auto_counter = Auto_counter ? Auto_counter : 38;
	MOVF       _Auto_counter+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Automatic19
	MOVF       _Auto_counter+0, 0
	MOVWF      ?FLOC___AutomaticT28+0
	GOTO       L_Automatic20
L_Automatic19:
	MOVLW      38
	MOVWF      ?FLOC___AutomaticT28+0
L_Automatic20:
	MOVF       ?FLOC___AutomaticT28+0, 0
	MOVWF      _Auto_counter+0
;Trafic light system.c,86 :: 		while( Auto_counter && !Manual_Auto){
L_Automatic21:
	MOVF       _Auto_counter+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Automatic22
	BTFSC      PORTB+0, 4
	GOTO       L_Automatic22
L__Automatic51:
;Trafic light system.c,87 :: 		if (Auto_counter > 18) {
	MOVF       _Auto_counter+0, 0
	SUBLW      18
	BTFSC      STATUS+0, 0
	GOTO       L_Automatic25
;Trafic light system.c,88 :: 		Phase = 0;
	CLRF       _Phase+0
;Trafic light system.c,89 :: 		Multiplex_4(Auto_counter - 15, Auto_counter - 18);
	MOVLW      15
	SUBWF      _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N1+0
	MOVLW      18
	SUBWF      _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N2+0
	CALL       _Multiplex_4+0
;Trafic light system.c,90 :: 		}
	GOTO       L_Automatic26
L_Automatic25:
;Trafic light system.c,91 :: 		else if (Auto_counter <= 18 && Auto_counter > 15) {
	MOVF       _Auto_counter+0, 0
	SUBLW      18
	BTFSS      STATUS+0, 0
	GOTO       L_Automatic29
	MOVF       _Auto_counter+0, 0
	SUBLW      15
	BTFSC      STATUS+0, 0
	GOTO       L_Automatic29
L__Automatic50:
;Trafic light system.c,92 :: 		Phase = 1;
	MOVLW      1
	MOVWF      _Phase+0
;Trafic light system.c,93 :: 		Multiplex_4(Auto_counter - 15, Auto_counter - 15);
	MOVLW      15
	SUBWF      _Auto_counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_Multiplex_4_N1+0
	MOVF       R0+0, 0
	MOVWF      FARG_Multiplex_4_N2+0
	CALL       _Multiplex_4+0
;Trafic light system.c,94 :: 		} else if (Auto_counter <= 15 && Auto_counter > 3) {
	GOTO       L_Automatic30
L_Automatic29:
	MOVF       _Auto_counter+0, 0
	SUBLW      15
	BTFSS      STATUS+0, 0
	GOTO       L_Automatic33
	MOVF       _Auto_counter+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_Automatic33
L__Automatic49:
;Trafic light system.c,95 :: 		Phase =  2;
	MOVLW      2
	MOVWF      _Phase+0
;Trafic light system.c,96 :: 		Multiplex_4(Auto_counter - 3, Auto_counter);
	MOVLW      3
	SUBWF      _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N1+0
	MOVF       _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N2+0
	CALL       _Multiplex_4+0
;Trafic light system.c,97 :: 		} else {
	GOTO       L_Automatic34
L_Automatic33:
;Trafic light system.c,98 :: 		Phase =  3;
	MOVLW      3
	MOVWF      _Phase+0
;Trafic light system.c,99 :: 		Multiplex_4(Auto_counter, Auto_counter);
	MOVF       _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N1+0
	MOVF       _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N2+0
	CALL       _Multiplex_4+0
;Trafic light system.c,100 :: 		}
L_Automatic34:
L_Automatic30:
L_Automatic26:
;Trafic light system.c,101 :: 		if(Auto_counter == 1) Auto_counter = 38;
	MOVF       _Auto_counter+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Automatic35
	MOVLW      38
	MOVWF      _Auto_counter+0
	GOTO       L_Automatic36
L_Automatic35:
;Trafic light system.c,102 :: 		else Auto_counter--;
	DECF       _Auto_counter+0, 1
L_Automatic36:
;Trafic light system.c,103 :: 		}
	GOTO       L_Automatic21
L_Automatic22:
;Trafic light system.c,104 :: 		}
L_end_Automatic:
	RETURN
; end of _Automatic

_Manual:

;Trafic light system.c,110 :: 		void Manual (){
;Trafic light system.c,111 :: 		Decoder = 0xf0;
	MOVLW      240
	MOVWF      PORTC+0
;Trafic light system.c,112 :: 		Trafic_light = Phases[phase];
	MOVF       _Phase+0, 0
	ADDLW      _phases+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Trafic light system.c,113 :: 		switch(Phase){
	GOTO       L_Manual37
;Trafic light system.c,114 :: 		case 0:
L_Manual39:
;Trafic light system.c,115 :: 		Auto_counter = 38;
	MOVLW      38
	MOVWF      _Auto_counter+0
;Trafic light system.c,116 :: 		break;
	GOTO       L_Manual38
;Trafic light system.c,117 :: 		case 1:
L_Manual40:
;Trafic light system.c,118 :: 		Auto_counter = 18;
	MOVLW      18
	MOVWF      _Auto_counter+0
;Trafic light system.c,119 :: 		for(; Auto_counter > 15 ; --Auto_counter)
L_Manual41:
	MOVF       _Auto_counter+0, 0
	SUBLW      15
	BTFSC      STATUS+0, 0
	GOTO       L_Manual42
;Trafic light system.c,120 :: 		Multiplex_4(Auto_counter - 15, Auto_counter - 15);
	MOVLW      15
	SUBWF      _Auto_counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_Multiplex_4_N1+0
	MOVF       R0+0, 0
	MOVWF      FARG_Multiplex_4_N2+0
	CALL       _Multiplex_4+0
;Trafic light system.c,119 :: 		for(; Auto_counter > 15 ; --Auto_counter)
	DECF       _Auto_counter+0, 1
;Trafic light system.c,120 :: 		Multiplex_4(Auto_counter - 15, Auto_counter - 15);
	GOTO       L_Manual41
L_Manual42:
;Trafic light system.c,121 :: 		Phase = 2;
	MOVLW      2
	MOVWF      _Phase+0
;Trafic light system.c,122 :: 		break;
	GOTO       L_Manual38
;Trafic light system.c,123 :: 		case 2:
L_Manual44:
;Trafic light system.c,124 :: 		Auto_counter = 15;
	MOVLW      15
	MOVWF      _Auto_counter+0
;Trafic light system.c,125 :: 		break;
	GOTO       L_Manual38
;Trafic light system.c,126 :: 		case 3:
L_Manual45:
;Trafic light system.c,127 :: 		Auto_counter = 3;
	MOVLW      3
	MOVWF      _Auto_counter+0
;Trafic light system.c,128 :: 		for(; Auto_counter ; --Auto_counter)
L_Manual46:
	MOVF       _Auto_counter+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Manual47
;Trafic light system.c,129 :: 		Multiplex_4(Auto_counter, Auto_counter);
	MOVF       _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N1+0
	MOVF       _Auto_counter+0, 0
	MOVWF      FARG_Multiplex_4_N2+0
	CALL       _Multiplex_4+0
;Trafic light system.c,128 :: 		for(; Auto_counter ; --Auto_counter)
	DECF       _Auto_counter+0, 1
;Trafic light system.c,129 :: 		Multiplex_4(Auto_counter, Auto_counter);
	GOTO       L_Manual46
L_Manual47:
;Trafic light system.c,130 :: 		Phase = 0;
	CLRF       _Phase+0
;Trafic light system.c,131 :: 		}
	GOTO       L_Manual38
L_Manual37:
	MOVF       _Phase+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Manual39
	MOVF       _Phase+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Manual40
	MOVF       _Phase+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Manual44
	MOVF       _Phase+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Manual45
L_Manual38:
;Trafic light system.c,132 :: 		Trafic_light = Phases[phase];
	MOVF       _Phase+0, 0
	ADDLW      _phases+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Trafic light system.c,133 :: 		}
L_end_Manual:
	RETURN
; end of _Manual
