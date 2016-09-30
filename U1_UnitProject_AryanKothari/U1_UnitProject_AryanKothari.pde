/*
Lovers of Bob is created by Aryan Kothari. For my second project of this class, 
 Bob has to make his way to the pizza to win! But be careful! If he gets hit by the blocks -Game Over!-
 */

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
int screen = 0;
PImage HeartEmoji;
PImage BobFront;
PImage Door;
PImage Pizza;
PImage Broc;
PImage Brick;
PImage Castle;
PImage Bob;
PImage Level2;
boolean CollisionDetected = false;
int Lives = 3;
float velY = 5;
float velX = 5;
float bobX = 50;
float DoorY = 800;
float DoorX = 1400;
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
  Brick = loadImage("brick.png");
  Brick.resize(width, height);

  Castle = loadImage("Castle.png");
  Castle.resize(width, height);

  Level2 = loadImage("level2.png");
  Level2.resize(width, height);

  fullScreen();
  background(Brick);
  noStroke();

  //Music
  minim = new Minim(this); //Music 
  song = minim.loadFile("MinionSong.mp3");
  song2 = minim.loadFile("TaaDaa.mp3");
  song3 = minim.loadFile("DOH.mp3");
  song.loop();

  //randomsizeNumbers
  for (int i = 0; i < nums.length; i++)
  {
    nums[i] = int(random(70));
  }

  //CooridinatesX for Barrier
  for (int i = 0; i<barrierX.length; i++)
  {
    barrierX[i] = i * 200 + 100;
  }
  //CoordinatesY for barrier
  for (int i = 0; i<barrierY.length; i++)
  {
    barrierY[i] = 0;
  }


  //Images
  HeartEmoji = loadImage("HeartEmoji.png");
  BobFront = loadImage("Bob.png");
  Bob = loadImage ("Bobplayer.png");
  Pizza = loadImage("imgres.png");
  Broc = loadImage("broc.png");
  Brick = loadImage("brick.png");
  Door = loadImage("door.png");

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
  if (screen == 0 & mousePressed & mouseX >= 620 & mouseX <= 800 & 
    mouseY >= 400 & mouseY <= 450) 
  {
    screen = 1;
  }

  if (screen == 1)
  {
    background(Castle);
    noStroke();

    Barriers();
    scoreinfo();
    BarrierRestrictions();
    BasicPlatform();

    CollisonDetection();
    if (CollisionDetected == true)
    {
      Lives = Lives - 1;
      delay(1000);
      for (int i = 0; i < barrierY.length; i++)
      {
        barrierY[i] = velY*-1;
        r = random(255);
        g = random(255);
        b = random(255);

        randomSize[i] = 20 + (i+1)*random(0, 10);
      }

      CollisionDetected = false;
    }


    if (Lives == 0)
    {
      textSize(40);
      text("Quit", 670, 520);
      pause();
    }


    if (bobX > width/1.05)
    {

      screen = 2;
    }
  }

  if (screen == 2)
  {
    bobX = 50;
    DoorY = 780;
    bobY = 780;

    fill(r, g, b);
    background(Level2);
    noStroke();
    Barriers();
    scoreinfo();
    BarrierRestrictions();
    BasicPlatform();
  }

  if (screen == 3)
  {
    background(0);
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
  if (keyCode == RIGHT)
  {
    bobX = bobX + 12;
  }
  if (keyCode == LEFT)
  {
    pushMatrix();
    scale(-2.0, 2.0);
    image(Bob, -Bob.width, 0);
    popMatrix();

    bobX = bobX - 12;
  }
}



//Boundaries for Barriers
void BarrierRestrictions()
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


//Making Barriers
void Barriers()
{
  fill(r, g, b);

  for (int i=0; i < barrierX.length; i++)
  {
    fill(r, g, b);
    rect(barrierX[i], barrierY[i], randomSize[i], randomSize[i]);
    barrierY[i] = barrierY[i] + random(0, 25);
  }
}

//Collision Detection Boolean
boolean CollisonDetection()
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

void scoreinfo()
{

  fill(0, 0, 0);
  textSize(20);
  text("Level:", 50, 50);
  text(screen, 110, 50);
  text("Lives:", 50, 30);
  text(Lives, 110, 30);
}

void VictoryScreen()
{

  background(0, 100, 0);
  song.pause();
  song2.play();
  for (int i = 0; i < 100; i++)
  {
    imageMode(CENTER);
    image(Bob, random(width), random(height), nums[i], nums[i]);
    fill(random(255));
  }
}

void BasicPlatform()
{
  imageMode(CENTER);
  image(Door, DoorX, DoorY, 50, 50);
  image(Bob, bobX, bobY, 50, 50);
}