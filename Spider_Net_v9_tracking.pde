// Hi Jackson, welcome to our code! Feel free to step inside and look around :-)

import ddf.minim.*;

Minim minim;
AudioPlayer player;

import processing.video.*;
Capture video;

//SPIDER
import gifAnimation.*; //gif library
Gif spiderGif;        //gif variable
Gif clock6Gif;
Gif clock7Gif;
int clock6A = 255;
int clock7A = 0;

//EMAIL
import com.temboo.core.*;                   //hook up to temboo
import com.temboo.Library.Google.Gmail.*;  //and to email client
// Create a session using your Temboo account application details
TembooSession session = new TembooSession("jerog1", "myFirstApp", "42f3a5f470b542b49b7d11e281e15ec7");

color trackColor; 

PImage snooze; //conjures snooze button

float moveX;             // moves the snooze button
float moveY;             // moves the snooze button
float locX;              // coordinates of snooze button
float locY;              // coordinates of snooze button

int backA = 0;

int spiders;          //amount of spiders
float [] spidersize;     // size of spider gifs
float snoozeSize = 100;  // size of snooze button      

float [] x;              // location of spiders in the array
float [] y;              // location of spiders in the array
float [] velocityX;      // spider movement
float [] velocityY;      // spider movement

void setup()
{
  //EMAIL
  // Run the InboxFeed Choreo function
  runInboxFeedChoreo();                  // start seeing email

  minim = new Minim(this);

  player = minim.loadFile("Creepy.aiff");

  // play the file from start to finish.
  // if you want to play the file again, 
  // you need to call rewind() first.


  x = new float[spiders];                // declaring index
  y = new float[spiders];
  velocityX = new float[spiders];
  velocityY = new float[spiders];
  spidersize = new float[spiders];

  size(1152, 720);                                    // window size

  snooze = loadImage("snooze.png");                   // load snooze image

  spiderGif  = new Gif(this, "spidercrawl3.gif");    //declare gif
  clock6Gif = new Gif(this, "Clock6.gif");
  clock7Gif = new Gif(this, "Clock7.gif");

  for (int i=0 ; i<spiders; i++) {          // setting values for array index
    x[i] = random(width);                // set initial X coordinate of each spider
    y[i] = random(height);               // set initial Y coordinate of each spider
    velocityX[i] = (random(-4, 4));      //sets X speed of spiders
    velocityY[i] = (random(-4, 4));      //sets Y speed of spiders
    spidersize[i] = random(60, 100);     //sets size of spiders
  }

  locX = 1;      //sets initial x coordinate for snooze button
  locY = 1;      //sets initial y coordinate for snooze button
  moveX = 3.9;    //sets x speed of snooze button
  moveY = 2.6;    //sets y speed of snooze button

  //-------------------------------------------------------------------
  video = new Capture(this, width, height, 15);
  // Start off tracking for red
  trackColor = color(255, 0, 0);
  smooth();
  video.start();
  //-------------------------------------------------------------------
}

void draw() {

  //background(0); 


  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  image(video, width/2, height/2);

  if (keyPressed) {
    if (key == 'b' || key == 'B') {
      backA = 0;
    }
  }
  else {
    backA = 255;
  }

  fill(0, 0, 0, backA);
  rect(0, 0, width, height);
  
//  tint(255,clock6A);
//  image(clock6Gif, width/2, height/2, 150, 150);
//  clock6Gif.play();
//  tint(255,clock7A);
//  image(clock7Gif, width/2, height/2, 150, 150);
  //clock7Gif.play();
  
   if (keyPressed) {
    if (key == 'm' || key == 'M') {
      player.play();
      clock6A = 0;
      clock7A = 255;
    }
  }

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 10) { 
    // Draw a circle at the tracked pixel

    fill(255);
    noStroke();
    ellipse(closestX, closestY, 20, 20);
  }


  imageMode(CENTER);       
  image(snooze, locX, locY, snoozeSize, snoozeSize);
  smooth();

  locX += moveX;
  locY += moveY;

  if ((locX<0)||(locX>width)) {
    moveX = -moveX;
  }

  if ((locY<0)||(locY>height)) {
    moveY = -moveY;
  }

  println(mouseX);

  if (closestX >= (locX - (snoozeSize/2)) && closestX <= (locX + (snoozeSize/2)) && closestY >= (locY - (snoozeSize/2)) && closestY <= (locY + (snoozeSize/2))) {
    //if (mousePressed == true) {
    spiders--;
    locX = random(width);
    locY = random(height);
    //}
  }

  for (int i=0 ; i<spiders; i++) {
    x[i] += velocityX[i];
    y[i] += velocityY[i];

    //SPIDER
    image (spiderGif, x[i], y[i], spidersize[i], spidersize[i]);
    spiderGif.play();

    //ellipse(x[i],y[i],9,9);-

    if ((x[i]<0)||(x[i]>(width-70))) {
      velocityX[i] = -velocityX[i];
    }

    if ((y[i]<0)||(y[i]>height-70)) {
      velocityY[i] = -velocityY[i];
    }
  }

  //  if (keyPressed) {
  //    if (key == 'b' || key == 'B') {
  //      backA = 255;
  //    }
  //  }
}

void runInboxFeedChoreo() {
  // Create the Choreo object using your Temboo session
  InboxFeed inboxFeedChoreo = new InboxFeed(session);

  // Set inputs
  inboxFeedChoreo.setUsername("jeremynir@gmail.com");
  inboxFeedChoreo.setPassword("nosrafrtfvuczxyw");

  // Run the Choreo and store the results
  InboxFeedResultSet inboxFeedResults = inboxFeedChoreo.run();

  // Print results
  //println(inboxFeedResults.getResponse());
  println(inboxFeedResults.getFullCount());
  spiders = int(inboxFeedResults.getFullCount());
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  //println(trackColor);
}

