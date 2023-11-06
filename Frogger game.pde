
// FROGGER GAME 

int level = 1; // Game level
int bandHeight; // Height of each band
float frogX, frogY, frogDiam, hazardSize; // Position of the frog, size of the frog, and size of the hazards
String m; // string for the message
boolean gameOver; // Game Over variable
boolean restartGame = false; // Variable to restart the game
float offset = 0; // Global variable for controlling hazard movement
float offsetChange = 0.75; // Rate of change of offset per frame

void setup() {
  fullScreen();
  bandHeight = height / (level + 4);
  frogX = width / 2;
  frogY = height - bandHeight / 2;
  frogDiam = bandHeight * 0.5;
  hazardSize = bandHeight * 0.5;
  m = "Level " + level;
  gameOver = false; 
}

void draw() {

  if (restartGame) {
    level = 1;
    bandHeight = height / (level + 4);
    frogX = width / 2;
    frogY = height - bandHeight / 2;
    frogDiam = bandHeight * 0.5;
    hazardSize = bandHeight * 0.5;
    m = "Level " + level;
    gameOver = false; // Set the game state to true initially
    offset = 0;
    restartGame = false;
  }

  background(255);
  drawWorld();
  drawFrog(frogX, frogY, frogDiam);

  if (!gameOver) { 
    boolean hazardOverlap = drawHazards(); // Check if any hazard overlaps with the frog

    if (detectWin()) {
      increaseLevel();
      m = "Level " + level;
      resetFrog();
    }

    if (hazardOverlap) {
      m = "Game Over! Press R to restart game";
      gameOver = true; // Game over if there is an overlap
    }
  }
  drawHazards();
  displayMessage(m);
}

// code to draw the world
void drawWorld() {
  for (int i = 0; i < level + 4; i++) {
    int y = i * bandHeight;
    if (i == 0 || i == level + 3) {
      fill(#6F6868); // Grey color for top and bottom bands
    } else {
      fill(10); // Black color for middle bands
    }
    rect(0, y, width, bandHeight);
  }
}
// code to draw the frog
void drawFrog(float x, float y, float diam) {
  fill(0, 255, 0); // Green color for the frog
  ellipse(x, y, diam, diam);
}

// code to move the frog
void moveFrog(float xChange, float yChange) {
  if (!gameOver) { // Only move the frog if the game is running
    float newX = frogX + xChange*0.5;
    float newY = frogY + yChange;

    if (objectInCanvas(newX, newY, bandHeight * 0.5)) {
      frogX = newX;
      frogY = newY;
    }
  }
}

// code to check if the frog is in the canvas
boolean objectInCanvas(float x, float y, float diam) {
  if (x - diam/2 > width || x + diam/2 < 0 || y - diam/2 > height || y + diam/2 < 0) {
    return false;
  } else {
    return true;
  }
}

// code for the buttons to move the frog
void keyPressed() {
  if (!gameOver) { // Only accept key presses if the game is running
    if (keyCode == UP || key == 'W' || key == 'w' || key == 'I' || key == 'i') {
      moveFrog(0, -bandHeight);
    } else if (keyCode == DOWN || key == 'S' || key == 's' || key == 'K' || key == 'k') {
      moveFrog(0, bandHeight);
    } else if (keyCode == LEFT || key == 'A' || key == 'a' || key == 'J' || key == 'j') {
      moveFrog(-bandHeight, 0);
    } else if (keyCode == RIGHT || key == 'D' || key == 'd' || key == 'L' || key == 'l') {
      moveFrog(bandHeight, 0);
    }
  }

  // code for the button to restart the game
  if (gameOver && (key == 'R' || key == 'r')) {
    restartGame = true;
  }
}

// code to draw the hazards

boolean drawHazards() {
  boolean overlap = false; // Variable to track if any hazard overlaps with the frog
  int numLines = level + 2; // Number of lines of hazards

  for (int i = 0; i < numLines; i++) {
    int bandNumber = i + 1;
    int y = bandNumber * bandHeight + bandHeight / 2; // y-coordinate of the line (middle of the band)
    int hazardType = i % 3; // Determine the type of hazard

    int spacing = bandHeight * (numLines - i + 1); // Spacing between hazards in each line

    float netOffset = offset * (numLines - i + 1); // Adjust offset based on line number

    for (int x = -bandHeight * 3; x < width + bandHeight * 3; x += spacing) {
      if (objectInCanvas(x * 0, y, bandHeight)) {
        if (hazardType == 0) {
          // Draw red circles for hazard type 0
          fill(255, 0, 0);
          ellipse(x + netOffset, y, hazardSize, hazardSize);
        } else if (hazardType == 1) {
          // Draw blue squares for hazard type 1
          fill(0, 0, 255);
          rect(x - bandHeight * 0.25 + netOffset, y - bandHeight * 0.25, hazardSize, hazardSize);
        } else if (hazardType == 2) {
          // Draw white circles for hazard type 2
          fill(255);
          ellipse(x + netOffset, y, hazardSize, hazardSize);
        }

        // Check for overlap with frog
        if (objectsOverlap(x + netOffset, y, frogX, frogY, hazardSize, frogDiam)) {
          overlap = true;
        }
      }
    }
  }

  if (!gameOver) {
    offset += offsetChange; // Update offset for hazard movement
    if (offset >= bandHeight) {
      offset = offset % bandHeight;
    }
  }

  return overlap; // Return the overlap result
}

// code to display the message at the top of the screen
void displayMessage(String m) {
  int textSize = bandHeight / 2; // Determine the text size based on the bandHeight
  textSize(textSize);
  textAlign(CENTER, TOP);
  fill(255);
  text(m, width / 2, 0);
}

// code to detect if the frog has passed a level
boolean detectWin() {
  if (frogY <= bandHeight) {
    return true;
  } else {
    return false;
  }
}

// code to reset the frog after passing a level
void resetFrog() {
  frogX = width / 2;
  frogY = height - bandHeight / 2;
}

// code to increase the levels
void increaseLevel() {
  level++;
  bandHeight = height / (level + 4);
  frogDiam = bandHeight / 2;
  hazardSize = bandHeight * 0.5;
  offset = bandHeight;
}

// code to check if there is a collision between the frog and the hazards
boolean objectsOverlap(float x1, float y1, float x2, float y2, float size1, float size2) {
  float distance = dist(x1, y1, x2, y2);
  float radiusSum = size1 / 2 + size2 / 2;

  return distance < radiusSum;
}
