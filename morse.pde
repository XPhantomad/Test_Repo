/***
* @Author: Florian Minnecker
***/

import java.lang.Math;

int MAX_COMAND_CODE_LENGTH = 12; // max length of command code
Character MAGIC_KEY = '$'; // Magic key for translating commands

String input = ""; //a rowling string for inputs
String output = ""; // a rowling string for outputs/drawing

int helpTextSize = 20;
String helpText = "Hallo, bitte starte das Tippen.";
int helpTextPositionY = 60;

int morseTextSize = 20;
int morseTextPadding = 20;

int datatextsize=20;
String Entropytext="";
String MeanLengthtext="";
String Redundancytext="";
String inputsave="";

float entropy=0;
float meanlength=0;

Boolean buttonHover = false;
color buttonHoverStrokeColor = color(0);

int buttonHeight = 100;
int buttonWidth = 200;
int buttonPositionY = helpTextPositionY + 20;
String buttonText = "Translate";

int displayablechars = (800-morseTextPadding*2)/morseTextSize;

HashMap<Character, String> codesAlphabet = new HashMap<Character, String>() {{
  put('A', "·−");
  put('B', "−···");
  put('C', "−·−·");
  put('D', "−··");
  put('E', "·");
  put('F', "··−·");
  put('G', "−−·");
  put('H', "····");
  put('I', "··");
  put('J', "·−−−");
  put('K', "−·−");
  put('L', "·−··");
  put('M', "−−");
  put('N', "−·");
  put('O', "−−−");
  put('P', "·−−·");
  put('Q', "−−·−");
  put('R', "·−·");
  put('S', "···");
  put('T', "−");
  put('U', "··−");
  put('V', "···−");
  put('W', "·−−");
  put('X', "−··−");
  put('Y', "−·−−");
  put('Z', "−−··");
  put('1', "·−−−−");
  put('2', "··−−−");
  put('3', "···−−");
  put('4', "····−");
  put('5', "·····");
  put('6', "−····");
  put('7', "−−···");
  put('8', "−−−··");
  put('9', "−−−−·");
  put('0', "−−−−−");
  put('À', "·−−·−");
  put('Å', "·−−·−");
  put('Ä', "·−·−");
  put('È', "·−··−");
  put('É', "··−··");
  put('Ö', "−−−·");
  put('Ü', "··−−");
  put('ß', "···−−··");
  put('Ñ', "−−·−−");
  put('.', "·−·−·−");
  put(',', "−−··−−");
  put(':', "−−−···");
  put(';', "−·−·−·");
  put('?', "··−−··");
  put('!', "−·−·−−");
  put('-', "−····−");
  put('_', "··−−·−");
  put('(', "−·−−·");
  put(')', "−·−−·−");
  put('\'', "·−−−−·");
  put('"', "·−··−·");
  put('=', "−···−");
  put('+', "·−·−·");
  put('/', "−··−·");
  put('@', "·−−·−·"); 
}};

HashMap<String, String> codesControl = new HashMap<String, String>() {{
  put("SPRUCHANFANG", "−·−·−");
  put("PAUSE", "−···−");
  put("SPRUCHENDE", "·−·−·");
  put("VERSTANDEN", "···−·");
  put("VERKEHRSENDE", "···−·−");
  put("SOS", "···−−−···");
  put("FEHLER", "········");
  put("IRRUNG", "········");
  put("WIEDERHOLUNG", "········");
}};

void setup() {
  size(800, 600); // canvasWidth and canvasHeigth
  background(100);
  frameRate(60);
}

void draw() {
  textAlign(CENTER, BOTTOM);
  background(100);
  strokeWeight(4);
  fill(255);
  
  // Draw Helptext
  textSize(helpTextSize);
  text(input.isEmpty() ? helpText : input, 800/2, helpTextPositionY);
    
  // Draw Output
  textAlign(RIGHT, BOTTOM);
  textSize(morseTextSize);
  text(output, morseTextPadding, 
      height/2, width-(morseTextPadding*2), morseTextSize+4);
  textSize(datatextsize);    
  textAlign(CENTER);
  text(Entropytext,width/2,400);    
  text(MeanLengthtext,width/2,420);
  text(Redundancytext,width/2,440);

  // Draw Button
  if (isHover((800/2)-(buttonWidth/2), buttonPositionY, buttonWidth, buttonHeight)) {
    stroke(buttonHoverStrokeColor);
  } else {
    stroke(255);
  }
  rect((800/2)-(buttonWidth/2), buttonPositionY, buttonWidth, buttonHeight);
  // buttontext
  textAlign(CENTER);
  textSize(helpTextSize);
  fill(0);
  text(buttonText, 800/2, buttonPositionY+buttonHeight/2);
}

boolean isHover(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void keyPressed() {
  Character in = Character.toUpperCase(key);
  
  // we only allow translatable characters
  if(in == MAGIC_KEY || codesAlphabet.containsKey(in)) {
    input += in;
  } 
  
  if (keyCode == ENTER) {
    translate();
    getdata();
  }
}

void mousePressed() {
  if (isHover((800/2)-(buttonWidth/2), buttonPositionY, buttonWidth, buttonHeight)) {
    translate();
    getdata();
  }
}

void translate() {
  output = "";
  inputsave=input; //store input for getdata()
  while(!input.isEmpty()) {
    if(input.startsWith(MAGIC_KEY.toString())) {
      println("input starts with substring");
      Boolean found = false;
      int searchlength = MAX_COMAND_CODE_LENGTH > input.length() ? input.length() : MAX_COMAND_CODE_LENGTH; 
      for(int i = 1; i <= searchlength; i++) {
        String cmd = input.substring(1,i);
        
        if(codesControl.containsKey(cmd)) {
          // Key was found
          output += codesControl.get(cmd);
          output += " ";
          input = input.substring(i-1); // Magic key will be removed later
          found=true;
          break;
        }
      }
      
      if(!found) {
        // error handling, okay for now i guess
        output="!UNKNOWNCOMMAND!";
      }
      
      input = input.substring(1); // remove the magic key
     }
     else if(codesAlphabet.containsKey(input.charAt(0))) {
       // Key was found
       output += codesAlphabet.get(input.charAt(0));
       // we need to make a pause
       output += " ";
       input = input.substring(1);
     }
     else {
        output = "!UNKNOWNCHAR!";
        input = input.substring(1);
     }
  }
  
  int of = displayablechars-output.length();
  if(of < 0)
    output = output.substring(of*-1);
}
void getdata(){  
  if ((!output.isEmpty()) && !(output=="!UNKNOWNCOMMAND!") && !(output=="!UNKNOWNCHAR!")){
    entropy=0;
    meanlength=0;
    HashMap<Character,Integer> map =new HashMap<Character,Integer>();
    for (int i=0; i<inputsave.length();i++){
      char c = inputsave.charAt(i);
      Integer val=map.get(c);
      if (val!= null){
        map.put(c,new Integer(val +1));
      }
      else {
        map.put(c,1);
      }
    }    
    for (char i : map.keySet()){
      float probability=float(map.get(i))/inputsave.length();
      entropy+=(probability)*(Math.log(probability)/Math.log(2));
      meanlength+=probability*((codesAlphabet.get(i)).length()+1);
    }
    
    if (entropy!=0) entropy=-1*entropy;
    Entropytext="H="+ str(entropy)+" bit"; 
    MeanLengthtext="L="+ str(meanlength)+" bit";
    Redundancytext="R="+ str(meanlength-entropy)+" bit";
  }
}  
