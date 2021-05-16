/*
Ball object
Epsilon
Final Evidence (Chika Shioriko XVI)*
CDMX 11/03/2021
*Personal code name, ignore
*/
class Pelota{
  float[] pos = new float[2]; //{x, y} Position
  float[] vel = new float[2]; //{x, y} Velocity
  float radio; //Radius of the ball
  //Constructor
  //initial position in X, initial position in Y, velocity in x, velocity in y, radius
  Pelota(float posX, float posY, float velX, float velY, float radioT){
    pos[0] = posX;
    pos[1] = posY;
    
    vel[0] = velX;
    vel[1] = velY;
    
    radio = radioT;
  }
  //Sends ball to position
  void reset(float posX, float posY){
    pos[0] = posX;
    pos[1] = posY;
  }
  //Checks if the ball hits a paddle and moves accordingly
  //width of the paddle, y of top side of paddle, y of bottom side of paddle, side boolean of paddle, width of window, height of window
  void checaPaleta(float anchoP, float paletaS, float paletaI, boolean izqDer, float widthT){
    //Variables for evaluation
    float radioCuadrado = radio * radio;
    float extremoPelota;
    boolean enZona = false; //Bollean to check if the ball is in posibility of hitting the paddle
    int valorFor1= 0, valorFor2 = 0; //For values to analyze
    //If it's the right paddle
    if(izqDer){
        //Check the closest x of the ball
        extremoPelota = pos[0] + radio;
        if(extremoPelota>=widthT-anchoP){
           enZona = true;
           valorFor1 = int (widthT-anchoP);
           valorFor2 = int(widthT);
        }
    }
    //if it's the left paddle
    else{
      //Check the closest x of the ball
       extremoPelota = pos[0] - radio;
       if(extremoPelota<=anchoP){
           enZona = true; 
           valorFor1 = 0;
           valorFor2 = int (anchoP);
        }
    }
     //If we're in the zone
   if (enZona){ 
     boolean golpeConfirmado = true; //Stop processing to reduce time complexity
     //Direct strike
     if(pos[1] >= paletaS && pos[1] <= paletaI){
       if(pos[1] - radio <= paletaI){
         //Change x velocity
         vel[0] = - vel[0];
         golpeConfirmado = false;
       }
       else if(pos[1] + radio >= paletaS){
         vel[0] = - vel[0];
         golpeConfirmado = false;
       }
     }
     //Bottom side
     //Check every possible point of this size
     for (int i = valorFor1; i < valorFor2 && golpeConfirmado; i++){
       float dist = (pos[0]-i)*(pos[0]-i) + (pos[1]-paletaI)*(pos[1]-paletaI);
       //Check the distance between points
       if(dist <= radioCuadrado){
         //If we are hitting it from the corner, change x velocity
         if(pos[0]+radio < paletaI){
           vel[0] = - vel[0];
         }
         //If we are hitting the paddle going upwards, change y velocity 
         if (vel[1] < 0){
           vel[1] = - vel[1];
         }
         golpeConfirmado = false;
       }
     }
     //Top side
     //Check every possible point of this size
     for (int i = valorFor1; i < valorFor2 && golpeConfirmado; i++){
       float dist = (pos[0]-i)*(pos[0]-i) + (pos[1]-paletaS)*(pos[1]-paletaS);
       //Check the distance between points
       if(dist <= radioCuadrado){
         //If we are hitting it from the corner, change x velocity
         if(pos[0]+radio > paletaS){
           vel[0] = - vel[0];
         }
         //If we are hitting the paddle going downards, change y velocity
         if (vel[1] > 0){
           vel[1] = - vel[1];
         }
         golpeConfirmado = false;
       }
     }
   
   }
    
  }
  //Checks the interaction of the ball and the walls
  //Width of window, height of window
  //Output: 0->No point scored, 1 -> right score, 2 -> left score
  int checaParedes(float widthT, float heightT){
    boolean salio = false; //Boolean to indicate the ball has hit the vartical walss
    int salida = 0; //Output
    //Horizontal walls
    if(pos[1] >= heightT || pos[1]-radio <= 0){
      vel[1] = - vel[1];//Change y velocity
    }
    //Left wall
    if(pos[0] <= 0){
      salida = 1;
      salio = true;
    }
    //Right wall
    else if(pos[0]+radio >= widthT){
       salida = 2;
       salio = true;
    }
    //If there was a point
    if (salio){
      //Return to center
      pos[0] = widthT / 2;
      pos[1] = heightT / 2;
      if(random(5) < 2.5){
        vel[0] = -vel[0];
      }
    }
    return salida;
  }
  //Paint and move the ball
  void update(boolean actPelota){
    //If the ball doesn't move
    if (actPelota){
      pos[0] += vel[0];
      pos[1] += vel[1];
    }
    stroke(255,200,50);
    fill(255,255,255);
    ellipse(pos[0],pos[1],radio+radio,radio+radio);
  }
  
}
