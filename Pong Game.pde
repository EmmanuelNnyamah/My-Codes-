
// pong game program*/
int leftPaddleX = 10;
int leftPaddleY = 200;
int rightPaddleX = 970;
int rightPaddleY = 200;
int paddleSpeed = 3;
int ballSize = 40;
float ballSpeedX = 6;
float ballSpeedY = 4;
float ballX;
float ballY;
float ballAngle;
int paddleHeight;
int paddleWidth;
final int MIN_SPEED = 2;
final int MAX_SPEED = 5;
int circleSize = 200;

int keyScore = 0;
int mouseScore = 0;
boolean gameOver = false;

void setup() {
  size(1000, 600);
  paddleHeight = height/3;
  paddleWidth = width/50;
  ballX = width/2;
  ballY = height/2;
  ballAngle = random(TWO_PI);
}
void draw() {
  background(#080446);
  drawGame();
}

void drawGame() {
  drawScore();
  drawLeftPaddle();
  drawRightPaddle();
  drawBall();
  moveLeftPaddle();
  moveRightPaddle();
  moveBall();
  ballReset();
  gameOver();
}


void drawScore() {
  textSize(20);
  String toPrint = "Mouse: " + keyScore;
  text(toPrint, width/4-textWidth(toPrint)/2, 50);
  toPrint = "Keyboard: " + mouseScore;
  text(toPrint, width*3/4-textWidth(toPrint)/2, 50);
}

void drawLeftPaddle() {
  if (!gameOver) {

    rect(leftPaddleX, leftPaddleY, paddleWidth, paddleHeight);
  }
}

void drawRightPaddle() {
  if (!gameOver) {

    rect(rightPaddleX, rightPaddleY, paddleWidth, paddleHeight);
  }
}
// question 2, move the paddles
void moveLeftPaddle() {
  if (!gameOver) {
    if (mouseButton == LEFT) {
      leftPaddleY -= paddleSpeed;
    }
    if (mouseButton == RIGHT) {
      leftPaddleY += paddleSpeed;
    }
    if (leftPaddleY + paddleHeight > height) {
      leftPaddleY  += -paddleSpeed ;
    }
    if (leftPaddleY < 0) {
      leftPaddleY += paddleSpeed;
    }
  }
}

void moveRightPaddle() {
  if (!gameOver) {
    if (keyCode == UP) {
      rightPaddleY -= paddleSpeed;
    }
    if (keyCode == DOWN) {
      rightPaddleY += paddleSpeed;
    }
    if (rightPaddleY + paddleHeight > height) {
      rightPaddleY  += -paddleSpeed ;
    }
    if (rightPaddleY < 0) {
      rightPaddleY += paddleSpeed;
    }
  }
}
//question 3 add the ball
void drawBall() {
  ballX +=  cos(ballAngle) * ballSpeedX;
  ballY +=  sin(ballAngle) * ballSpeedY;
  if (!gameOver) {
    circle(ballX, ballY, ballSize);
  }
}
void moveBall() {
  if (!gameOver) {
    if ( ballY + ballSize/2 > height || ballY - ballSize/2 < 0) {
      ballAngle = -ballAngle;
    }
    if (ballX - ballSize/2 <= paddleWidth && ballY >= leftPaddleY && ballY <= leftPaddleY + paddleHeight) {
      ballSpeedX = -ballSpeedX;
      ballSpeedY = random(0, 10);
    } else if (ballX + ballSize/2 >= width - paddleWidth && ballY >= rightPaddleY && ballY <= rightPaddleY + paddleHeight) {
      ballSpeedX = -ballSpeedX;
      ballSpeedY = random(0, 10);
    }
  }
}



//question 5 keep score
void ballReset() {
  if (!gameOver) {
    if (ballX - ballSize/2 < 0) {
      mouseScore += 1;
      ballX = width/2;
      ballY = height/2;
    }
    if (ballX + ballSize/2 > width) {
      keyScore += 1;
      ballX = width/2;
      ballY = height/2;
    }
  }
}

void gameOver() {
  if ( mouseScore == 11 || keyScore == 11) {
    textSize(100);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2);
    gameOver = true;
  }
}
