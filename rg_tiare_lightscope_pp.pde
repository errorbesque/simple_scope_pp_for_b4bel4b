/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;
PFont italicfont;
String speciesname =  ""; // "Oscillatoria animalis";
Capture cam;

void setup() {
  size(1280, 1024);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 1280, 1024);
  } if (cameras.length == 0) {
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
    
    // capture from light microscope with name = MD130, 
    cam = new Capture(this, 1280,1024,"MD130",30);
   
    
    // Start capturing the images from the camera
    cam.start();
  }
  // font/size
  italicfont = createFont("Times New Roman Italic",24);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0, width, height);
  // write text to corner
  textFont(italicfont);
  text(speciesname,30,30);
  
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}