/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;
PFont italicfont;
String speciesname =  "Oscillatoria tenius"; // "Oscillatoria animalis";
Capture cam;
int up=30;
float contrastval = 2;
int brightnessThreshold=200;
boolean upbrightness=true;
int r, g, b;
int counter=0; // num frames
int frameoftimelapse=0;
int frameoftimelapse2=0;
int numberOfFramesToModulus=60; // @ 30 fps this is every 2 sec, @ 60 fps this is every 1 sec, etc
int numberOfFramesToModulus2=60*30; // @ 30 fps this is every 2 sec, @ 60 fps this is every 1 sec, etc
int maxLengthOfTimeLapseArray=260;
//PImage[] TimeLapseArray = new PImage[maxLengthOfTimeLapseArray];
ArrayList<PImage> TimeLapseArray = new ArrayList<PImage>(); // shorter
ArrayList<PImage> TimeLapseArray2 = new ArrayList<PImage>(); // longer

void setup() {
  fullScreen(); // p3+ only

  String[] cameras = Capture.list();

  // don't need to list cameras
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 800, 600);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    // cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "iSight", 30);
  }
  // capture from light microscope with name = MD130, 
  cam = new Capture(this, 1600, 1200, "Andonstar Camera", 30);
  // Start capturing the images from the camera
  cam.start();

  // font/size
  italicfont = createFont("Times New Roman Italic", 24);
} // setup

void draw() {
  if (cam.available() == true) {
    cam.read();
    counter++;
    // shorter array
    if (counter%numberOfFramesToModulus == 0) { // every x frames (frame divided by framerate)
      TimeLapseArray.add(cam.get());
    }

    if (TimeLapseArray.size() > maxLengthOfTimeLapseArray) {
      TimeLapseArray.remove(0); // remove the first element
    }
    // longer array
    if (counter%numberOfFramesToModulus2 == 0) { // every x frames (frame divided by framerate)
      TimeLapseArray2.add(cam.get());
    }

    if (TimeLapseArray2.size() > maxLengthOfTimeLapseArray) {
      TimeLapseArray2.remove(0); // remove the first element
    }
  }

  if (upbrightness) {
    cam.loadPixels();
    for (int i = 0; i<cam.width*cam.height; i++) {
      // increase brightness
      // cam.pixels[i] = color(red(cam.pixels[i])+up, green(cam.pixels[i])+up, blue(cam.pixels[i])+up); //  = max(cam.pixels[i]+50,255); // max 
      if (true) { // brightness(cam.pixels[i])<brightnessThreshold) { // increase contrast?  
        // cam.pixels[i] = color(red(cam.pixels[i])-up, green(cam.pixels[i])-up, blue(cam.pixels[i])-up);
        //cam.pixels[i] = color(max(int((red(cam.pixels[i])+128)/128),0),max(int((green(cam.pixels[i])+128)/128),0),max(int((blue(cam.pixels[i])+128)/128),0));
        r=(cam.pixels[i])>> 16 & 0xFF;
        g=(cam.pixels[i])>> 8 & 0xFF; 
        b=(cam.pixels[i])& 0xFF;
        r=adjustedComponent(r, up, contrastval);
        g=adjustedComponent(g, up, contrastval);
        b=adjustedComponent(b, up, contrastval);
        cam.pixels[i] = color(r, g, b);
      }
    } // for
    cam.updatePixels();
  } // if brightness

  image(cam, 0, 0, width, height);
  // filter(POSTERIZE, 20);
  // filter(DILATE);
  tint(222, 255, 222);


  // write text to corner
  textFont(italicfont);
  text(speciesname, 30, 30);

  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);

  // overlay the timelapsed image
  if (TimeLapseArray.size() > frameoftimelapse) {
    image(TimeLapseArray.get(frameoftimelapse), 0, 0, width/2, height/2);
    frameoftimelapse++;
    if (frameoftimelapse>=TimeLapseArray.size()) { // about to overwrite
      frameoftimelapse=0;
      save("oscillatoria_timelapse" + counter + ".jpg");
    }
  }
  // overlay the timelapsed image
  if (TimeLapseArray2.size() > frameoftimelapse2) {
    image(TimeLapseArray2.get(frameoftimelapse2), width/2, 0, width, height/2);
    frameoftimelapse2++;
    if (frameoftimelapse2>=TimeLapseArray2.size()) {
      frameoftimelapse2=0;
    }
  }

  tint(222, 255, 222);
  text("frame " +frameoftimelapse, 30, 30);
} // draw

private void addFrameToTimeLapse() {
  // take input image and append it to last x images
}

private int adjustedComponent(int component, int brightness, float contrast) {
  component = int((component- 128)*contrast)+128+brightness;
  return component < 0 ? 0 : component > 255 ? 255 : component;
}