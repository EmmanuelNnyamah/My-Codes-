
//   Doodle Jump Game 


final int BGCOLOR = color(249, 240, 231); // Grid Background Color
final int LINECOLOR = color(240, 216, 193); // Grid Lines Color
final int GREENCOLOR = color(74, 186, 0); // Color Code for Green Color
final int BLUECOLOR = color(60, 191, 211); // Color Code for Blue Color
final int BROWNCOLOR = color(142, 92, 34); // Color Code for Brown Color
final int ORANGECOLOR = color(251, 179, 17); // Color Code for Orange Color
final String[] TYPES = {"Green", "Green", "Green", "Green", "Green", "Blue", "Blue", "Blue", "Brown", "Orange"}; // 50% Green, 30% Blue, 10% Brown, and 10% Orange

final float PLATFORM_WIDTH = 50; // Platform width value
final float PLATFORM_HEIGHT = 10; // Platform height value
final int NUM_PLATFORMS = 1000; // 1000 platforms generate for the game
final float MARGIN = 50; // Margin to draw platforms in range
final float G = 9.8; // The value for gravity that affects the doodle speed
final float DOODLE_HEIGHT = 50;
final float DOODLE_WIDTH = 50;
final int DOODLE_XDIFF = 5; // the change in doodle x when moving left or right

PImage doodleLeft, doodleRight; // Image variable to store the doodle Picture
boolean lookingRight;
float doodleX, doodleY;
float doodleSpeed, scrollSpeed;
float [] platformX;
float [] platformY;
int [] typeColor;
float [] platformSpeedX;
boolean gameOver;

void setup() {
  size(400, 700);
  doodleLeft = loadImage("doodleLeft.png"); // loading the doodle looking left image
  doodleRight = loadImage("doodleRight.png"); // loading the doodle looking right image

  startGame(); // start the game for the first time
}

void draw() {
  background(BGCOLOR);

  // Draw grid lines
  stroke(LINECOLOR);
  for (int x = 0; x <= width; x += width/50) {
    line(x, 0, x, height);
  }
  for (int y = 0; y <= height; y += height/50) {
    line(0, y, width, y);
  }

  // Draw the platforms that exist and are in the range of the screen
  drawPlatform();

  // Change doodle's x and y coordinates in the direction that it needs to move
  moveDoodle();

  // Apply gravity to the doodle
  applyGravity();

  // Check for collision and make the doodle jump
  checkCollision();

  // Draw doodle
  drawDoodle();

  // Move the blue platforms
  moveBluePlatforms();
  
  // Game Over
  displayGameOver();
  
  // Restart game
  restartGame();
}

void drawDoodle() {
  // Draw doodle according to whether it is looking towards left or right
  if (lookingRight)
    image(doodleRight, doodleX, doodleY, DOODLE_WIDTH, DOODLE_HEIGHT);
  else
    image(doodleLeft, doodleX, doodleY, DOODLE_WIDTH, DOODLE_HEIGHT);
}

void startGame() {
  // Initialize the doodle properties and create levels
  lookingRight = true; // Doodle will be looking right initially

  // Set gameover boolean to false at game start
  gameOver = false; // To check if the game is over
  // Random place for doodle starting x position
  doodleX = random(width - DOODLE_WIDTH);
  // Random place for doodle starting y position
  doodleY = random(height/2, height - DOODLE_HEIGHT);
  // Random float value between 5 to 10 for doodle starting speed
  doodleSpeed = random(5, 10);

  // Generate platforms for the whole game
  generatePlatform();

  // Draw background of the game
  background(BGCOLOR);

  // Draw platforms
  drawPlatform();
  
  // apply gravity
  applyGravity();
}


// Function to move doodle 
void moveDoodle() {
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      doodleX -= DOODLE_XDIFF;
      lookingRight = false;
    } else if (key == 'd' || key == 'D') {
      doodleX += DOODLE_XDIFF;
      lookingRight = true;
    }
  }

  // Warp the doodle around the screen
  if (doodleX < 0) {
    doodleX = width;
  } else if (doodleX > width) {
    doodleX = 0;
  }
}

// Apply gravity to the doodle
void applyGravity() {
  doodleY -= doodleSpeed;
  doodleSpeed -= G / 60;
}

// Function to generate platforms
void generatePlatform() {
  platformX = new float[NUM_PLATFORMS];
  platformY = new float[NUM_PLATFORMS];
  typeColor = new int[NUM_PLATFORMS];
  platformSpeedX = new float[NUM_PLATFORMS];

  for (int i = 0; i < NUM_PLATFORMS; i++) {
    platformX [i] = random(0, width - PLATFORM_WIDTH);
    typeColor[i] = int(random(0, TYPES.length));
    platformY[i] = height - MARGIN - 7*i*PLATFORM_HEIGHT;
    platformSpeedX[i] = 0;
    if (TYPES[typeColor[i]].equals("Blue")) {
      if (random(0, 1)> 0.5) {
        platformSpeedX[i] = 1;
      } else {
        platformSpeedX[i] = -1;
      }
    }
  }
}

// Function to draw the platforms
void drawPlatform() {
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    if (platformY[i] < height && platformY[i]+ PLATFORM_HEIGHT > 0) {
      int colour;
      if (TYPES[typeColor[i]].equals("Blue")) {
        colour = BLUECOLOR;
      } else if (TYPES[typeColor[i]].equals("Orange")) {
        colour = ORANGECOLOR;
      } else if (TYPES[typeColor[i]].equals("Brown")) {
        colour = BROWNCOLOR;
      } else {
        colour = GREENCOLOR;
      }
      fill(colour);
      rect(platformX[i], platformY[i], PLATFORM_WIDTH, PLATFORM_HEIGHT, 20);
    }
  }
}

// Function to move the blue platforms
void moveBluePlatforms() {
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    if (platformY[i] < height && platformY[i]+ PLATFORM_HEIGHT > 0) {
      if (TYPES[typeColor[i]].equals("Blue")) {
        if (platformX[i] <= 0 || platformX[i] >= width - PLATFORM_WIDTH) {
          platformSpeedX[i] = - platformSpeedX[i];
        }
        platformX[i]+= platformSpeedX[i];
      }
    }
  }
}

// Function to scroll after collision with a platform
void scrollDown() {
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    platformY[i] += scrollSpeed;
  }
}

// Function to check the collision with platforms
void checkCollision() {
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    if (platformY[i] < height && platformY[i] + PLATFORM_HEIGHT > 0) {
      if (doodleY + DOODLE_HEIGHT >= platformY[i] && doodleY <= platformY[i] + PLATFORM_HEIGHT &&
        doodleX + DOODLE_WIDTH >= platformX[i] && doodleX <= platformX[i] + PLATFORM_WIDTH) {
        if (TYPES[typeColor[i]].equals("Orange")) {
          // Collision with orange platform
          doodleSpeed = 10 + random(0, 3) * (doodleY - height / 2) / (height / 2);
          scrollSpeed = 3 * doodleSpeed;
          scrollDown();
        } else if (TYPES[typeColor[i]].equals("Brown")) {
          // Collision with brown platform
          platformY[i] = -PLATFORM_HEIGHT; // Make the brown platform disappear
        } else {
          // Collision with green or blue platform
          doodleSpeed = 5 + random(0, 3) * (doodleY - height / 2) / (height / 2);
          scrollSpeed = 1.5 * doodleSpeed;
          scrollDown();
        }
      }
    }
  }
}

// Function to display Game Over! and Play Again button
void displayGameOver() {
  if (doodleY > height) {
    gameOver = true;
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(255, 0, 0);
    text("Game Over!", width / 2, height / 2);

    fill(0);
    rect(width / 2 - 60, height / 2 + 40, 120, 40, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Play Again", width / 2, height / 2 + 60);
  }
}

// Function to restrt the game
void restartGame() {
  if (gameOver && mousePressed && mouseX > width / 2 - 60 && mouseX < width / 2 + 60 && mouseY > height / 2 + 40 && mouseY < height / 2 + 80) {
    startGame();
  }
}
