  int g = 10;
  int ex = 400;
  int ey = 100;
  int max = 100;   //maximale höhe
  int r = 0;       // Richtung 0 runter, 1 hoch
  int gk = 0;      //Gravitationskonstante
  int counter = 0;

void setup(){
  frameRate(30);
  
  size(800, 615);
  background(0, 255, 0);
  
  ellipseMode(CENTER);
  
  ellipse(200, 550, 100, 100); // unten
  ellipse(200, 100, 100, 100);  //oben
}

void draw(){

  ellipseMode(CENTER);
  background(0, 255, 0);
  ellipse(ex, ey, 100, 100);
  if (ey>=550){
    r = 1;
    println(counter);
    max=max+10;
    println(max);
  }
  
  if (ey<=max){
    r = 0;
    println(counter);
  }
    
  if (r==0){
    gk++;
    ey= ey + (gk);
    counter++;
  }
  
  if (r==1){
    ey= ey - gk;
    gk--;
    counter--;
  }
  
  
}
//background(0, 255, 0);
