
// A Simple fireworks show

float fireworkX, fireworkY, fireworkYSpeed, fireworkTargetX, fireworkTargetY, ExplodeTimer;
int fireworkNumLines, fireworkDuration;
boolean fireworkLaunched, fireworkExploded, fireworkHidden;
color[] fireworkLineColors;
color fireworkExplodeColor;

void setup() {
  size(1000, 600);
  launchFirework();
}

void draw() {
  background(0);

  if ((fireworkLaunched) && (!fireworkExploded) && (!fireworkHidden)) {
    launchFireworkMaths();
    drawFireWork();
  }

  if ((!fireworkLaunched) && (fireworkExploded) && (!fireworkHidden)) {
    explodeFireworkMaths();
    drawExplosion();
  }
  if ((!fireworkLaunched) && (!fireworkExploded) && (fireworkHidden)) {
    launchFirework();
  }
}

// CODE FOR WHEN THE FIREWORK IS HIDDEN
void hideFirework() {
  fireworkLaunched = false;
  fireworkExploded = false;
  fireworkHidden = true;
}


// CODE TO DRAW FIREWORK
void drawFireWork(){
  strokeWeight(1);
    stroke(255);

    fill(random(255), random(255), random(255));
    ellipse(fireworkX, fireworkY, 10, 10);
    line(fireworkX, fireworkY, fireworkX, fireworkY + 15);
}

// CODE TO LAUNCH FIREWORK
void launchFirework() {
  fireworkX  = random(width);
  fireworkY = height * 1.1;
  fireworkTargetX = random(width);
  fireworkTargetY = random(height / 2);
  fireworkYSpeed = random(8) + 2;
  fireworkNumLines = int(random(5, 20));
  fireworkDuration = int(random(width/20, width / 5));
  fireworkLineColors = new color[fireworkNumLines];
  for (int i = 0; i < fireworkNumLines; i++) {
    fireworkLineColors[i] = color(random(255), random(255), random(255));
  }
  fireworkLaunched = true;
  fireworkExploded = false;
  fireworkHidden = false;
}
// ADDITIONAL LAUNCH FIREWORK CALCULATIONS
void launchFireworkMaths() {
  if (fireworkY > fireworkTargetY) {
    fireworkX += (fireworkTargetX - fireworkX) / 2;
    fireworkY -= fireworkYSpeed;
  } else {
    explodeFirework();
  }
}

//CODE TO EXPLODE FIREWORK
void explodeFirework() {
  ExplodeTimer = 0;
  fireworkLaunched = false;
  fireworkExploded = true;
  fireworkHidden = false;
  fireworkExplodeColor = fireworkLineColors[0]; // COLOR OF THE LINES
}
// ADDITIONAL EXPLODE FIREWORK CALCULATIONS
void explodeFireworkMaths() {
  if (ExplodeTimer < fireworkDuration) {
    ExplodeTimer += 1;
  } else {
    hideFirework();
  }
}

// CODE TO DRAW EXPLOSIONS
void drawExplosion(){
   strokeWeight(2);
    stroke(fireworkExplodeColor);
    for (int i = 0; i < fireworkNumLines; i++) {
      float angle = i * TWO_PI / fireworkNumLines;
      float lineX2 = fireworkX + cos(angle) * ExplodeTimer;
      float lineY2 = fireworkY + sin(angle) * ExplodeTimer;
      float lineX = fireworkX + cos(angle) * ExplodeTimer*1/2;
      float lineY = fireworkY + sin(angle) * ExplodeTimer*1/2;
      line(lineX, lineY, lineX2, lineY2);
    }
}
