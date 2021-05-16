/*
Paddle object
Epsilon
Final Evidence (Chika Shioriko XVI)*
CDMX 11/03/2021
*Personal code name, ignore
*/
class Paleta{ 
  float[] pos = new float[2]; // {x, y} position of left-top corner
  float[] dimension = new float[2];  // {height, width} dimensions of the paddle
  float vel; //Change of position per input
  boolean izqDer;  //Boolean to signify side 1 -> Left 0 -> Right
  //Save last input
  int entradaAnt = 0;
  //Constructor
  //initial position in X, initial position in Y, height, width, velocity, side
  Paleta(float posX, float posY, float altura, float ancho, float velY, boolean lado){
    pos[0] = posX;
    pos[1] = posY;
    dimension[0] = altura;
    dimension[1] = ancho;
    vel = velY;
    izqDer = lado;
  }
  //reset, send to position
  void reset(float posX, float posY){
      pos[0] = posX;
      pos[1] = posY;
  }
  //Analyze ketboard input
  void tecla(int tecla, int heightT){
    //if its left
    if(izqDer){
      //If it's W or w
      if(tecla == 111 || tecla == 79){
        //Move upwards if it's a valid movement
        if (pos[1]>=0){
          if(pos[1]-vel<0){
            if(pos[1] != 0){
              pos[1] = vel;
            }
          }
          else{
            pos[1] -= vel;
          }
        }
      }
      //If it's S or s
      else if(tecla == 108 || tecla == 76 ){
        //Move downwards if it's a valid movement
        if(pos[1] + dimension[0] < heightT){
          if(pos[1] + dimension[0] + vel > heightT){
            pos[1] =heightT - dimension[0] - vel;
          }
          else{
            pos[1] += vel;
          }
        }
      }
     
    }
    //If it's right
    else{
      //If o or O
      if(tecla == 119 || tecla == 87){
        //Move upwards if possible
        if (pos[1]>=0){
          if(pos[1]-vel<0){
            if(pos[1] != 0){
              pos[1] = vel;
            }
          }
          else{
            pos[1] -= vel;
          }
        }
      }
      //If it's l or L
      else if(tecla == 115 || tecla == 83){
        //Move downwards if possible
        if(pos[1] + dimension[0] < heightT){
          if(pos[1] + dimension[0] + vel > heightT){
            pos[1] =heightT - dimension[0] - vel;
          }
          else{
            pos[1] += vel;
          }
        }
      }
    }
  }
  //If it's an fpga input
  //FPGA data, height of window, show if it's an up or down movement
  void fpga(int entrada, int heightT, char arrAba){
      //If it's right -> Accelerometer
      if(!izqDer){
        //If it's a solid movement
        if(entrada > 25){
          float velTemp = (float(entrada) / 1000 * vel); //Determine velocity dependending on entrada
          entradaAnt = entrada;//Save last input
          //If we go up
          if(arrAba == '1'){
            //Move up if possible
            if (pos[1]>=0){
              if(pos[1]-velTemp<0){
                if(pos[1] != 0){
                  pos[1] = velTemp;
                }
              }
              else{
                pos[1] -= velTemp;
              }
            }
          }
          //If we go down
          else{
            //Move down if possible
            if(pos[1] + dimension[0] < heightT){
              if(pos[1] + dimension[0] + velTemp > heightT){
                pos[1] = heightT - dimension[0] - velTemp;
              }
              else{
                pos[1] += velTemp;
              }
            }
          }
        }
      }
      //If it's left -> Ultrasonic sensor
      else{
        //If the diference it's no noise
        if(entrada > entradaAnt + 10){
          //Move up if possible
          if (pos[1]>=0){
               if(pos[1]-vel<0){
                if(pos[1] != 0){
                  pos[1] = vel;
                }
              }
              else{
                pos[1] -= vel;
              }
          }
        }
        //If it's no noise
        else if(entrada < entradaAnt - 10){
          //Move down if possible
          if(pos[1] + dimension[0] < heightT){
            if(pos[1] + dimension[0] + vel > heightT){
              pos[1] =heightT - dimension[0] - vel;
            }
            else{
              pos[1] += vel;
            }
          }
        }
        entradaAnt = entrada;
      }
       
  }
  //Paint the paddle
  void update(){
    stroke(255,255,255);
    fill(255,200, 50);
    rect(pos[0], pos[1], dimension[1], dimension[0]);
  }
}
