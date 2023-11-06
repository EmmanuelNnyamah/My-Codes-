
  // Snake Game
   
final int ROWS=20, COLS=15; //The number of rows and columns of squares
final int SQ_SIZE=40;       //The size of each square in pixels
final int[] X_DIRECTIONS = {0, -1, 0, +1}; //X change for down, left, up, right
final int[] Y_DIRECTIONS = {+1, 0, -1, 0}; //Y change for down, left, up, right
int[] X = new int [COLS];
int[] Y = new int [ROWS];
int startingLength = 4;
int startingApples =0;
int[] appleX = new int[startingApples];
int[] appleY = new int [startingApples];
int currentLength;
int currentApples;
int frameCounter = 0;
int snakeVel = 30;
int snakeDirection = 0;
int snakeGrowth = 1;
int tailPos;
int currentLevel = 1;
boolean grow = false;
boolean gameOver = false;
boolean newLevel = false;

void setup() {
  size(600, 800); // Size of the Canvas
  resetSnake();
  resetApples();
}

void draw() {
  background(#1EA516);
  if (!gameOver) {
    if (frameCounter % snakeVel == 0) {
      moveSnake(X_DIRECTIONS[snakeDirection], Y_DIRECTIONS[snakeDirection]);
      checkCollisions();
    }
    frameCounter++;
    printGameOver();

    if (currentApples == 0) {
      newLevel();
    }
  }
  drawCircles(X, Y, currentLength, #6A05FA);// to draw snake
  drawCircles(appleX, appleY, currentApples, #FA1A05);// to draw apples
}

//Function to draw both the snake and the apples
void drawCircles(int[] x, int[] y, int n, int colour) {
  for (int i=0; i<n; i++) {
    if (i < x.length && i < y.length) {
      int pixelX = x[i] * SQ_SIZE + SQ_SIZE / 2; // Convert grid coordinates to pixels
      int pixelY = y[i] * SQ_SIZE + SQ_SIZE / 2;
      fill(colour);
      circle(pixelX, pixelY, SQ_SIZE);
    }
  }
}


void fillArray (int[]a, int n, int start, int delta) {
  for (int i=0; i<=n; i++) {
    a[i] = start + i*delta;
  }
}

// Function to reset snake
void resetSnake() {
  currentLength = startingLength + currentLevel;
  fillArray(X, currentLength, COLS/2, 0);
  fillArray(Y, currentLength, -1, -1);

  if (newLevel) {
   snakeDirection = Y_DIRECTIONS[1];
  }
  moveSnake(0, 1);
  tailPos = startingLength - 1;
}

// Function to move snake
void moveSnake(int addX, int addY) {
  for (int i = currentLength - 1; i > 0; i--) {
    X[i] = X[i - 1];
    Y[i] = Y[i - 1];
  }
  X[0] += addX; //To change the x-coordinate of the snake 
  Y[0] += addY; //To change the x-coordinate of the snake 

  if (grow) { 
    currentLength++;
    tailPos++;
    grow = false;
  }
  if (currentLength >= X.length) {
    expandSnake();
  }
}



void expandSnake() {
  int newSize = X.length + snakeGrowth;
  int[] newX = new int[newSize];
  int[] newY = new int[newSize];
  X = newX;
  Y = newY;
}

// Function for the buttons to move the snake
void keyPressed() {
  if (key == 'L' || key == 'l'|| key =='D'|| key == 'd') {
    snakeDirection = (snakeDirection + 1) % 4; // Turn the snake clockwise
  } else if (key == 'A' || key == 'a' || key == 'j' || key == 'J') {
    snakeDirection = (snakeDirection + 3) % 4; // Turn the snake counter-clockwise
  }
}

int [] randomArray(int n, int max) {
  int[] values = new int [n];
  for (int i=0; i<n; i++) {
    values[i] = (int) random(max+1);
  }
  return values;
}

//Function to reset apples
void resetApples() {
  currentApples = startingApples + currentLevel;
  appleX = new int[currentApples];
  appleY = new int[currentApples];
  int[] randomX = randomArray(currentApples, COLS-1) ;
  int[] randomY = randomArray(currentApples, ROWS - 1) ;

  for (int i = 0; i<currentApples; i++) {
    appleX[i] = randomX[i];
    appleY[i] = randomY[i];
  }
}



int searchArrays(int[] x, int[]y, int n, int start, int keyX, int keyY) {
  for (int i = start; i<n; i++) {
    if (x[i] == keyX && y[i] == keyY) {
      return i;
    }
  }
  return -1;
}

// Function to delete apple
void deleteApple(int eatenApple) {
  for (int i = eatenApple; i < currentApples - 1; i++) {
    appleX[i] = appleX[i + 1];
    appleY[i] = appleY[i + 1];
  }
  currentApples--;
}

//Function to check collisions
void checkCollisions() {
  int index = searchArrays(appleX, appleY, currentApples, 0, X[0], Y[0]);
  if (index != -1) {
    deleteApple(index); // Delete the apple when it collides with snake
    currentLength++;
  }

  if (currentApples == 0 && !newLevel) {
    newLevel();
  }
}

// Boolean function to detect crash
boolean detectCrash() {

  int headX = X[0]; // X coordinate of the snake
  int headY = Y[0]; // Y coordinate of the snake

  // Check if the snake is outside the canvas
  if (headX < 0 || headX >= COLS || headY < 0 || headY >= ROWS) {
    return true; // Snake has left the canvas
  }

  // Check if the snake collides with itself
  for (int i = 1; i < currentLength; i++) {
    if (headX == X[i] && headY == Y[i]) {
      return true; // Snake has bitten itself
    }
  }

  return false; // There is no crash
}

// // Function to print Game Over
void printGameOver() {
  if (detectCrash()) {
    gameOver = true;
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(50);
    text("GAME OVER", width/2, height/2);
    noLoop();
  }
}

// Function to check for a new level
void newLevel() {

  if (!newLevel) {
    newLevel = true;
    currentLevel++;
    resetSnake();
    resetApples();
    for(int i = 0; i<= snakeVel; i++){
    frameRate(60+i);
    }
  }
  newLevel = false;
}
