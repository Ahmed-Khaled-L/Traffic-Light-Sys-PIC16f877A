#line 1 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
#line 21 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
void Multiplex_4(char N1, char N2);
void Automatic();
void Manual();


char Auto_counter = 38;
char Phase ;
char phases[] = { 0b100001  ,  0b010001  ,  0b001100  , 0b001010 };
#line 33 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
void interrupt()
{
 if(INTF_BIT){
 INTF_BIT = 0;
 if(Phase == 3)Phase = 0;
 else ++Phase;
 Manual();
 }
 if(RBIF_BIT){
 RBIF_BIT = 0;
 if( PORTB.B4 )Manual();
 else Automatic();
 }
}
#line 52 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
void main() {
 TRISC = TRISD = INTEDG_BIT = Phase = 0;
 TRISB.B0 = TRISB.B4 = GIE_BIT = INTE_BIT = RBIE_BIT = RBIF_BIT = 1;
  PORTC  = 0xF0;
 while(1){
 asm sleep;
 }
}
#line 65 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
void Multiplex_4(char N1, char N2){
 char i;
  PORTD  = Phases[phase];
 for(i = 0 ; i < 50; ++i){
  PORTC  = (N1 /10) | ((N1 /10)== 0? 0xf0 : 0b11100000);
 Delay_ms( 5 );
  PORTC  = (N1 %10) | 0b11010000;
 Delay_ms( 5 );
  PORTC  = (N2 /10) | ((N2 /10)== 0 ? 0xf0 : 0b10110000);
 Delay_ms( 5 );
  PORTC  = (N2 %10) | 0b01110000;
 Delay_ms( 5 );
 }
  PORTC  = 0xF0;
}
#line 84 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
void Automatic(){
 Auto_counter = Auto_counter ? Auto_counter : 38;
 while( Auto_counter && ! PORTB.B4 ){
 if (Auto_counter > 18) {
 Phase = 0;
 Multiplex_4(Auto_counter - 15, Auto_counter - 18);
 }
 else if (Auto_counter <= 18 && Auto_counter > 15) {
 Phase = 1;
 Multiplex_4(Auto_counter - 15, Auto_counter - 15);
 } else if (Auto_counter <= 15 && Auto_counter > 3) {
 Phase = 2;
 Multiplex_4(Auto_counter - 3, Auto_counter);
 } else {
 Phase = 3;
 Multiplex_4(Auto_counter, Auto_counter);
 }
 if(Auto_counter == 1) Auto_counter = 38;
 else Auto_counter--;
 }
}
#line 110 "C:/Users/ahmed/Desktop/Embeded Project/Code/Trafic light system.c"
void Manual (){
  PORTC  = 0xf0;
  PORTD  = Phases[phase];
 switch(Phase){
 case 0:
 Auto_counter = 38;
 break;
 case 1:
 Auto_counter = 18;
 for(; Auto_counter > 15 ; --Auto_counter)
 Multiplex_4(Auto_counter - 15, Auto_counter - 15);
 Phase = 2;
 break;
 case 2:
 Auto_counter = 15;
 break;
 case 3:
 Auto_counter = 3;
 for(; Auto_counter ; --Auto_counter)
 Multiplex_4(Auto_counter, Auto_counter);
 Phase = 0;
 }
  PORTD  = Phases[phase];
}
