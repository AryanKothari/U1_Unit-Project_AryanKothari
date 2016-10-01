/*
This unit project is my development of what I did for project 2. In this game, Bob's mission is to get to his pizza, 
 while blocking the objects falling from the sky. Since the creater of the game, ME, is generous, You are provided with three lives before losing. Good luck, 
 and may the odds be ever in your favor! 
 */

//Music libary for song 
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim;
AudioPlayer song;
AudioPlayer song2;
AudioPlayer input;
AudioPlayer song3;
AudioPlayer crying;
int screen = 0; //Levels
PImage HeartEmoji; //Images that I will be using in my game
PImage BobFront;
PImage Door;
PImage Pizza;
PImage Broc;
PImage Brick;
PImage Castle;
PImage Bob;
PImage Level2;
PImage Defense;
PImage Heaven;
PImage Hell;
PImage SadMinion;
boolean CollisionDetected = false;
boolean Playing = true; //movement controls 
int Lives = 3;
float velY = 5;
float velX = 5;
float bobX = 50;
float DoorY = 800;
float DoorX = 1400;
int LastTime = millis();
float r = random(255);
float g = random(255);
float b = random(255);
int time;
float bobY = 800;
float barrierY[] = new float [10];
float barrierX[] = new float [6];
float randomSize[] = new float [10];
int nums[] = new int[500];
void setup ()
{
  //backgrounds for my game (different levels)
  Brick = loadImage("brick.png");
  Brick.resize(width, height);

  Castle = loadImage("Castle.png");
  Castle.resize(width, height);

  Level2 = loadImage("level2.png");
  Level2.resize(width, height);

  Heaven = loadImage("heaven.png");
  Heaven.resize(width, height);
  
  Hell = loadImage("Hell.png");
  Hell.resize(width, height);

  fullScreen();
  background(Brick);
  noStroke();

  //Music
  minim = new Minim(this); //Music 
  song = minim.loadFile("MinionSong.mp3");
  song2 = minim.loadFile("TaaDaa.mp3");
  song3 = minim.loadFile("DOH.mp3");
  crying = minim.loadFile("Crying.mp3");
  song.loop();

  for (int i = 0; i < nums.length; i++) //generate random numbers between 0, 70)
  {
    nums[i] = int(random(70));
  }

  //CooridinatesX for Barrier
  for (int i = 0; i<barrierX.length; i++) //x values for my falling objects
  {
    barrierX[i] = i * 200 + 100;
  }
  //CoordinatesY for barrier
  for (int i = 0; i<barrierY.length; i++) //y values for my falling objects
  {
    barrierY[i] = 0;
  }


  //Loading Images
  HeartEmoji = loadImage("HeartEmoji.png");
  BobFront = loadImage("Bob.png");
  Bob = loadImage ("Bobplayer.png");
  Pizza = loadImage("imgres.png");
  Broc = loadImage("broc.png");
  Brick = loadImage("brick.png");
  Door = loadImage("door.png");
  Defense = loadImage("objects.png");
  SadMinion = loadImage("SadMinion.png");


  imageMode(CENTER);
  image(BobFront, width/1.3, height/1.75, 665, 594);

  imageMode(CENTER);
  image(Pizza, width/5.7, height/1.9, 500, 500);

  fill (0, 0, 100);
  textSize(100);
  text("Bob's Mission", 350, 200);

  fill (0, 0, 0);
  textSize(30);
  text("Created by Aryan Kothari", 1050, 860);

  fill(0, 255, 0);
  rect(620, 400, 180, 50);

  fill(0, 255, 0);
  rect(620, 480, 180, 50);

  fill(0, 0, 255);
  textSize(35);
  text("Play now!", 635, 440);

  fill(0, 0, 255);
  textSize(40);
  text("Quit", 670, 520);
}


void draw()
{
  if (Lives == 0) //go to game over screen
  {
    screen = 5;
  }

  if (screen == 5) //Game Over Screen
  {
   LosingScreen();
  }



  if (screen == 0 & mousePressed & mouseX >= 620 & mouseX <= 800 & 
    mouseY >= 400 & mouseY <= 450) //Play button/Go to game
  {
    screen = 1;
  }


  if (screen == 1) //Level 1 
  {
    background(Castle);
    Level1Barriers();
    Gameplay();

    if (bobX > width/1.05) //If bob reaches door 
    {
      screen = 2;
      Playing = true;
      bobX = 50;
      DoorY = 780;
      bobY = 780;
    }
  }

  if (screen == 2) //Level 2 
  {
    Defense = loadImage("images.png"); //New falling object
    background(Level2);
    Level1Barriers();
    Gameplay();

    if (bobX > width/1.05) //if bob reaches pizza 
    {
      screen = 3;
      Playing = true;
      bobX = 50;
      bobY = 780;
    }
  }

  if (screen == 3) //Final Level, get to the pizza!
  {
    background(Heaven);
    image(Bob, bobX, bobY, 50, 50);
    for (int i = 0; i<2; i++)
    {
      fill(0, 0, 0);
      textSize(int(random(5, 20)));
      text("SO CLOSE", int(random(width)), int(random(height)));
    }
    if (bobX > width/1.05)
    {
      screen = 4;
    }
  }

  if (screen == 4)
  {
    VictoryScreen();
  }


  if (screen == 0 & mousePressed & mouseX >= 620 & mouseX <= 800 & 
    mouseY >= 480 & mouseY <= 520) //Exit Game 
  {
    exit();
  }
}



//Moving Bob
void keyPressed()
{
  if (keyPressed)
  {
    if (Playing)
    {
      if (keyCode == RIGHT)
      {
        bobX = bobX + 12;
      }
      if (keyCode == LEFT)
      {
        /* pushMatrix();
         scale(-2.0, 2.0);
         image(Bob, -Bob.width, 0);
         popMatrix(); */

        bobX = bobX - 12;
      }
    }
  }
}



//below are custom functions I will be using in my levels 

void Gameplay() //this contains all the other functions, and is the basis platform for my game
{
  fill(r, g, b);
  noStroke();
  scoreinfo();
  BarrierRestrictions();
  BasicPlatform();
  CollisonDetection();


  if (CollisionDetected == true)
  {
    if (millis() - LastTime > 2000)
    {
      LastTime = millis();
      Lives = Lives - 1;
      CollisionDetected = false;
      song3.play();
    }
    song3.pause();
  }
}

void BarrierRestrictions() //Flying objects reset back to top
{
  for (int i = 0; i < barrierY.length; i++)
  {
    if (barrierY[i] > height)
    {
      barrierY[i] = velY*-1;
      r = random(255);
      g = random(255);
      b = random(255);

      randomSize[i] = 20 + (i+1)*random(0, 10);
    }
  }
}




void Level1Barriers() //Making Barriers/The shards that fall from sky
{
  fill(r, g, b);

  for (int i=0; i < barrierX.length; i++)
  {
    fill(r, g, b);
    image(Defense, barrierX[i], barrierY[i], randomSize[i], randomSize[i]);
    barrierY[i] = barrierY[i] + random(0, 25);
  }
}

//Collision Detection Boolean
boolean CollisonDetection() //Boolean for detecting collision of Bob
{

  for (int i = 0; i<barrierX.length; i++)
  {
    if (bobX < barrierX[i] + randomSize[i] &&
      bobX + 50 - 20 > barrierX[i] &&
      bobY < barrierY[i] + randomSize[i] &&
      50 + bobY - 20 > barrierY[i])
    {
      CollisionDetected = true;
    }
  }
  return CollisionDetected;
}

void scoreinfo() //Levels and Lives 
{

  fill(r, g, b);
  textSize(40);
  text("Level:", 550, 50);
  text(screen, 670, 50);
  text("Lives:", 700, 50);
  text(Lives, 820, 50);
}

void LosingScreen() //Losing screen forloop
{
  background(Hell);
  fill(0,0,0);
  textSize(80);
  text("YOU HAVE FAILED!", width/5, height/2);
  song.pause();
  crying.play();
  for (int i = 0; i < 100; i++)
  {
    imageMode(CENTER);
    image(SadMinion, random(width), random(height), nums[i], nums[i]);
    fill(random(255));
  }
}

void VictoryScreen() //Victory screen for loop 
{

  background(Heaven);
  fill(0,0,0);
  textSize(80);
  text("MISSION ACCOMPLISHED!", width/5, height/2);
  song.pause();
  song2.play();
  for (int i = 0; i < 100; i++)
  {
    imageMode(CENTER);
    image(BobFront, random(width), random(height), nums[i], nums[i]);
    fill(random(255));
  }
}

void BasicPlatform() //Door and bob
{
  imageMode(CENTER);
  image(Door, DoorX, DoorY, 50, 50);
  image(Bob, bobX, bobY, 50, 50);
}