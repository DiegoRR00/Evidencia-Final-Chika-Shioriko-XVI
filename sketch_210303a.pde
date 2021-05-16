/*
Main function of the ping pong game
Epsilon
Final Evidence (Chika Shioriko XVI)*
CDMX 11/03/2021
*Personal code name, ignore
*/
import processing.serial.*;

//Allow for keyboard inputs as controls
void keyPressed(){
  paletaI.tecla(int(key),480);
  paletaD.tecla(int(key),480);
}
Serial jugV; //Serial port entity
PImage fondo; //Background image
//Strings to save the serial inputs
String entrada = "00000";
String entrada1 = "00000";
String entrada2 = "00000";
//Strings that reads serial data sets
int tipoDato = 7;
//Boolean that signals if theres a reset
boolean actPelota = true;
Pelota pelota = new Pelota(320,200,-2,2.5,15); //Ball
//Paddles
Paleta paletaD = new Paleta(620,160,80,20,80,true);
Paleta paletaI = new Paleta(0,160,80,20,160,false);
//Score
Puntaje puntaje = new Puntaje(640);


void setup(){
  size(640,480);
  //Initialize serial port
  String portName = Serial.list()[0];
  jugV = new Serial(this, portName, 9600);
  fondo = loadImage("space.png"); //Load background image
  
}
void draw(){
  background(fondo);
  //Check if there's ball and paddle contact
  pelota.checaPaleta(paletaI.dimension[1],paletaI.pos[1],paletaI.pos[1]+paletaI.dimension[0], paletaI.izqDer,640);
  pelota.checaPaleta(paletaD.dimension[1],paletaD.pos[1],paletaD.pos[1]+paletaD.dimension[0], paletaD.izqDer,640);
  //Check if ther's a score
  int punto = pelota.checaParedes(width, height);
  puntaje.aumentarPuntaje(punto);
  if(punto == 1){
    jugV.write(1);//Send to FPGA
  }
  else if (punto == 2){
    jugV.write(0);//Send to FPGA
  }
  //Read Serial input
  if (jugV.available() > 0){
      entrada = jugV.readStringUntil('\n');
      if(entrada != null && entrada.length() > 1){ //If it's a valid data
        //Input that indicates the end of a set
        if(entrada.charAt(0) == 's'){
          tipoDato = 0;
        }
        //First input, it's binary
        else if(tipoDato == 0){
          entrada1 = entrada;  //BIN
          tipoDato ++;
        }
        //Second input, it's decimal
        else if(tipoDato == 1){
          entrada2 = entrada;  //DEC
          tipoDato ++;
        }
        //If this condition is met, we're receiving null, we stop sending data to the paddles
        else{
           tipoDato ++;
        }
      }
      if (entrada1 != null && entrada2 != null && tipoDato == 2){  //If it's a valid inputs
        if(int(entrada2.substring(0,entrada2.length()-1)) == 170){ //reset input
          pelota.reset(320,200);
          paletaI.reset(620,200);
          paletaD.reset(0,200);
          puntaje.reset();
          actPelota = false;//Stop ball movement until reset is deactivated
        }
        //If we have the accelerometer data type identifier
        else if(entrada1.charAt(entrada1.length()-2) == '0'){
          //If ot's no 0
          if(entrada1.length() >= 3){
            actPelota = true;
            //Send input to paddle
            paletaI.fpga(int(entrada2.substring(0,entrada2.length()-1)),480, entrada1.charAt(entrada1.length()-3));
          }
          //If it's 0
          else if(entrada.charAt(0) == '0'){
            actPelota = true;
            paletaI.fpga(0,480, '0'); //Send the valid input "00000000"
          }
        }
        //If we have the ultrasonic data type identifier
        else if (entrada1.charAt(entrada1.length()-2) == '1'  && entrada1.length() >= 3){
          actPelota = true;
          paletaD.fpga(int(entrada2.substring(0,entrada2.length()-1)),480, '0'); //Send input to paddle
        }
        else{
          actPelota = true;
        }
      }
      
  }
  //Paint objects
  pelota.update(actPelota);
  paletaI.update();
  paletaD.update();
  puntaje.update();
}
