
// BALL THROWER 
int numBalls = 1000; // Number of balls
float[] posX;// array for positon x
float[] posY;// array for position y
float[] velX;// x speed
float[] velY;// y speed
float[] diam;// array for diameter of the balls
int[] colors;// array for colors
int[] opacity;// array for opacity of the balls
boolean mousePressed;

void setup() {
  size(500, 500);
  createArrays();
}

void draw() {
  background(220);
  
  if (mousePressed) {
    generateBall(mouseX, mouseY);
  }
  
  moveBalls();
  displayBalls();
}

// function that holds all the arrauy
void createArrays() {
  posX = new float[numBalls];
  posY = new float[numBalls];
  velX = new float[numBalls];
  velY = new float[numBalls];
  diam = new float[numBalls];
  colors = new int[numBalls];
  opacity = new int[numBalls];
}

// generate ball function
void generateBall(float x, float y) {
  for (int i = 0; i < numBalls; i++) {
    if (diam[i] == 0) {
      posX[i] = x;
      posY[i] = y;
      diam[i] = random(10, 30);
      velX[i] = random(-3, 3);
      velY[i] = random(-3, 3);
      colors[i] = color(random(255), random(255), random(255));
      opacity[i] = 255;
      break;
    }
  }
}
// moveball function
void moveBalls() {
  for (int i = 0; i < numBalls; i++) {
    if (diam[i] != 0) {
      posX[i] += velX[i];
      posY[i] += velY[i];
      
      if (posX[i] <= 0 || posX[i] >= width - diam[i]) {
        velX[i] *= -1;
      }
      if (posY[i] <= 0 || posY[i] >= height - diam[i]) {
        velY[i] *= -1;
      }
      
      opacity[i] -= 2;
      if (opacity[i] <= 0) {
        diam[i] = 0; // Set diameter to 0 to mark the ball as faded away
      }
    }
  }
}


//display function
void displayBalls() {
  for (int i = 0; i < numBalls; i++) {
    if (diam[i] != 0) {
      noStroke();
      fill(red(colors[i]), green(colors[i]), blue(colors[i]), opacity[i]);
      ellipse(posX[i], posY[i], diam[i], diam[i]);
    }
  }
}

void mousePressed() {
  mousePressed = true;
}

void mouseReleased() {
  mousePressed = false;
}
