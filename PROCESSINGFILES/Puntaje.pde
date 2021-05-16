/*
Score object
Epsilon
Final Evidence (Chika Shioriko XVI)*
CDMX 11/03/2021
*Personal code name, ignore
*/
class Puntaje{
  int ultra, accel;  //Scores
  float[] pos = new float[2]; //Position of print
  int showFor = 0; //Show win mesagge for this number of frames
  
  //Constructor
  //width of the window
  Puntaje(float widthT){
    ultra = 0;
    accel = 0;
    pos[0] = widthT / 2;
    pos[1] = 30;
  }
  //Reset Score
  void reset (){
    ultra = 0;
    accel = 0;
  }
  //Update the score
  //number returned from the checarParedes funtion of wall
  void aumentarPuntaje(int puntaje){
    //If the left player has scored
    if (puntaje == 2){
      accel += 1;
      //If the player has won
      if(accel == 5){
        showFor = 120; //Set number of iterations
      }
    }
    //If the right player has scored
    else if (puntaje == 1){
      ultra += 1;
      //If the player has won
      if(ultra == 5){
        showFor = 120; //Set number of iterations
      }
    }
  }
  //Print the winning message
  void win(String text){
    textAlign(CENTER);
    textSize(25);
    text(text, 320,240);
    showFor --;
  }
  //Draw the score
  void update(){
    String impresion;
    impresion = "Points";
    textAlign(CENTER);
    textSize(25);
    text(impresion, pos[0], pos[1]);
    impresion = "Accel : " + str(accel) + "   Ultra : " + str(ultra);
    text(impresion, pos[0], pos[1] + 40);
    //If we need to show a win
    if(showFor != 0){
      if(accel >= 5){
       win("Accel has reached 5 points"); 
      }
      else if(ultra >= 5){
        win("Ultra has reached 5 points");
      }
      if(showFor == 0){
        accel = 0;
        ultra = 0;
      }
    }
  }
  
}
