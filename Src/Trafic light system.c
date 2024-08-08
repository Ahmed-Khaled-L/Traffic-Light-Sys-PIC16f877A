/* Trafic light lamps */
#define Trafic_light PORTD

/* Switches */
#define Manual_Auto PORTB.B4
#define Man_CTRL PORTB.B0

/* Seven segments */
#define Decoder PORTC

/* Phases */
#define PHASE1 0b100001
#define PHASE2 0b010001
#define PHASE3 0b001100
#define PHASE4 0b001010

/* Delay */
#define WAIT 5

/*  Functions Prototypes */
void Multiplex_4(char N1, char N2);
void Automatic();
void Manual();

/* Global Variables */
char Auto_counter = 38;
char Phase ;
char  phases[] = {PHASE1 , PHASE2 , PHASE3 ,PHASE4};
/*
* RB0 is used to increment the Phase counter to switch between pre-defined phases in the Manual mode
* RB4 is used to switch between the system modes  
*/
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
      if(Manual_Auto)Manual();
      else Automatic();
    }
}
/*
* The main just sets the pins directions and goes to sleep until an interrupt occurs
* before that it raises the RB4 flag to force activate the interrupt func. just only one time (useful for the RESET Case )

*/
void main() {
    TRISC = TRISD = INTEDG_BIT = Phase = 0;
    TRISB.B0 = TRISB.B4 = GIE_BIT = INTE_BIT = RBIE_BIT = RBIF_BIT = 1;
    Decoder = 0xF0;
    while(1){
    asm sleep;
    }
}
/*
* used to Multiplex the 4 seven-segments to reduce the number of pins used
* depends on displaying digit by digit and switching between them quickly using the MCU high speed
* Turn off any left-sided seven-segment that contain a Zero value
*/
void Multiplex_4(char N1, char N2){
    char i;
    Trafic_light = Phases[phase];
    for(i = 0 ; i < 50; ++i){
        Decoder = (N1 /10) | ((N1 /10)== 0? 0xf0 : 0b11100000);
        Delay_ms(WAIT);
        Decoder = (N1 %10) |  0b11010000;
        Delay_ms(WAIT);
        Decoder = (N2 /10) | ((N2 /10)== 0 ? 0xf0 : 0b10110000);
        Delay_ms(WAIT);
        Decoder = (N2 %10) |  0b01110000;
        Delay_ms(WAIT);
    }
    Decoder = 0xF0;
}
/*
* Activate a countdown suitable for each Phase depending on the value of the Auto_counter
* Update The Phase depending on the value of the Auto_counter in case of switching to Manual Mode in diff Phase of standard one
*/
void Automatic(){
                Auto_counter = Auto_counter ? Auto_counter : 38;
                while( Auto_counter && !Manual_Auto){
                if (Auto_counter > 18) {
                Phase = 0;
                Multiplex_4(Auto_counter - 15, Auto_counter - 18);
                }
                else if (Auto_counter <= 18 && Auto_counter > 15) {
                Phase = 1;
                Multiplex_4(Auto_counter - 15, Auto_counter - 15);
                } else if (Auto_counter <= 15 && Auto_counter > 3) {
                Phase =  2;
                Multiplex_4(Auto_counter - 3, Auto_counter);
                } else {
                Phase =  3;
                Multiplex_4(Auto_counter, Auto_counter);
                }
                if(Auto_counter == 1) Auto_counter = 38;
                else Auto_counter--;
                }
}
/*
* Switch between Trafic_light Phases depending on the value of the Phase counter
* sets the value of the Auto_counter var in case of switching in diff Phase of standard one
* Activate a countdown for 3 second in any Phase that contain a ready case
*/
void Manual (){
    Decoder = 0xf0;
    Trafic_light = Phases[phase];
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
    Trafic_light = Phases[phase];
}