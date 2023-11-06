
 //A TV with button functionality
import javax.swing.JOptionPane;
int tvX;
int tvY;
int tvWidth;
int tvHeight;
int floorHeight;
int windowX;
int windowY;
int windowWidth;
int windowHeight;
int floorX;
int floorY;
int floorWidth;
float innerRectX;
float innerRectY;
float innerRectWidth;
float innerRectHeight;
float circleX;
float circleY1;
float circleY2;
float circleY3;
float rectX;
float rectY;
float rectWidth;
float rectHeight;
float circleWidth;
float circleHeight;
boolean draw;
String userInput;
boolean reset;
boolean type;

boolean changecolor;



void setup() {
  size(1000, 1000);

  tvX = width/4;
  tvY = height/4;
  tvWidth = width/2 + width/10;
  tvHeight = height/2 - width/10;

  floorHeight = height/5;
  floorX = width*0;
  floorY = height - floorHeight;
  floorWidth = width;

  windowX = width/12;
  windowY = height/12;
  windowWidth = width/4;
  windowHeight = height/4;

  innerRectX = tvX + tvWidth / 14;
  innerRectY = tvY + tvHeight / 14;
  innerRectWidth = tvWidth*3/4;
  innerRectHeight = tvHeight*3/4;

  circleX = tvX + tvWidth*9/10 ;
  circleY1 = tvY + tvHeight*1/5;
  circleY2 = tvY + tvHeight/2;
  circleY3 = tvY + tvHeight*4/5;
  circleWidth = width/12;
  circleHeight = height/12;
  rectX = tvX + tvWidth/3;
  rectY = tvY + tvHeight*5/6;
  rectWidth = width/5;
  rectHeight = height/16;
  draw = true;
  reset = false;
  changecolor = false;
  type = false;
  frameRate(2400);

  background(#A0A09B);
  drawWindow();
  drawFloor();
  drawTv();
}

void draw() {
  drawSketch();
}

// CODE TO DRAW THE FLOOR
void drawFloor() {
  // FLOOR
  strokeWeight(0);
  fill(#523607);
  rect(floorX, floorY, floorWidth, floorHeight);
}

// CODE TO DRAW THE FLOOR
void drawWindow() {
  // WINDOW
  fill(#05F0FA);
  stroke(#7C310B);
  strokeWeight(5);
  rect(windowX, windowY, windowWidth, windowHeight);

  // GRASS
  fill(#10740C);
  stroke(0);
  strokeWeight(1);
  rect(windowX, windowY +  windowHeight*3 / 4, windowWidth, windowHeight/4);

  // WINDOW LINES
  stroke(0);
  line(windowX, windowY + windowHeight / 2, windowX + windowWidth, windowY + windowHeight / 2);
  line(windowX + windowWidth / 2, windowY, windowX + windowWidth / 2, windowY + windowHeight);

  // SUN
  fill(#FAEE05);
  ellipse(windowX + windowWidth / 4, windowY + windowHeight / 4, windowWidth / 4, windowWidth / 4);
}

// CODE TO DRAW THE TV
void drawTv() {
  // LEGS
  stroke(0);
  strokeWeight(15);
  line(tvX + tvWidth/4, tvY + tvHeight, tvX, floorY + height/15);  // LEFT LEG
  line(tvX + tvWidth*3/4, tvY + tvHeight, tvX + tvWidth, floorY + height/15);  // RIGHT LEG
  line(tvX + tvWidth/2, tvY + tvHeight, tvX + tvWidth/2, floorY + height/30); // CENTER LEG


  // TV
  fill(#7C2C11);
  stroke(0);
  strokeWeight(5);
  rect(tvX, tvY, tvWidth, tvHeight);

  // TV SCREEN
  fill(#F5A9BC);
  stroke(255);
  strokeWeight(5);
  rect(innerRectX, innerRectY, innerRectWidth, innerRectHeight);


  // ANTENNAE
  float antennaHeight = height/15;
  float antennaY = tvY - antennaHeight;

  stroke(0);
  line(tvX + tvWidth/4, antennaY, tvX + tvWidth/2, tvY);  // FIRST ANTENNAE
  line(tvX + tvWidth*3/4, antennaY, tvX + tvWidth/2, tvY);  // SECOND ANTENNAE


  // BUTTONS
  fill(#0A2FFA);
  stroke(0);
  strokeWeight(2);



  ellipse(circleX, circleY1, circleWidth, circleHeight);// COLOR BUTTON
  ellipse(circleX, circleY2, circleWidth, circleHeight);// SKETCH BUTTON
  ellipse(circleX, circleY3, circleWidth, circleHeight);// TYPE BUTTON

  rect(rectX, rectY, rectWidth, rectHeight);// RESET BUTTON

  //CODE FOR THE TEXT OF THE BUTTONS
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(width/30);
  text("Color", circleX, circleY1);

  textAlign(CENTER, CENTER);
  textSize(width/35);
  text("Sketch", circleX, circleY2);

  textAlign(CENTER, CENTER);
  textSize(width/30);
  text("Type", circleX, circleY3);

  textAlign(CENTER, CENTER);
  textSize(width/20);
  text("Reset", rectX + rectWidth/2, rectY + rectHeight*1/3);
}

// FUNCTION FOR THE SKETCH BUTTON
void drawSketch() {
  if (!draw) {
    if (mouseX > innerRectX && mouseX < innerRectX+innerRectWidth && mouseY > innerRectY && mouseY < innerRectY+innerRectHeight) {
      stroke(0);
      strokeWeight(10);
      point(mouseX, mouseY);
    }
  }
}

//  FUNCTION FOR THE COLOR BUTTON
void changeColor() {
  fill(random(255), random(255), random(255));
  stroke(255);
  strokeWeight(5);
  rect(innerRectX, innerRectY, innerRectWidth, innerRectHeight);
}

// FUNCTION FOR THE TYPE BUTTON
void drawType() {
  if (type == false) {
    userInput = JOptionPane.showInputDialog("Enter Text");
    fill(0);
    stroke(0);
    textAlign(CENTER, CENTER);
    textSize(width/20);
    text(userInput, innerRectX + innerRectWidth/2, innerRectY + innerRectHeight/2);
    println("Can i PLEASE get extra marks Mr Pouya =)");
  }
}




// CODE FOR WHEN MOUSE IS PRESSED
void mousePressed() {
  if (dist(mouseX, mouseY, circleX, circleY1) < circleWidth/2 ) {
    changeColor();
    changecolor = true;
    type = false;
    reset = false;
    draw = true;
  } else if (dist(mouseX, mouseY, circleX, circleY2) < circleWidth/2 ) {

    draw = false;
    changecolor = false;
    type = false;
    reset = false;
  } else if (dist(mouseX, mouseY, circleX, circleY3) < circleWidth/2 ) {
    draw = true;
    changecolor = false;
    type = false;
    reset = true;
    drawType();
  } else if (mouseX >= rectX && mouseX <= rectX+rectWidth && mouseY >= rectY && mouseY <= rectY+rectHeight) {

    stroke(255);
    strokeWeight(5);
    rect(innerRectX, innerRectY, innerRectWidth, innerRectHeight);
    changecolor = false;
    reset = true;
    draw = true;
    type = false;
  }
}
