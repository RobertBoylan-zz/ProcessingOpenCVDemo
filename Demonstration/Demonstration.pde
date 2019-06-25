import gab.opencv.*;

enum demos {
  hueSelection, erodeDilate, blur, threshold, adaptiveThreshold, contours, edges, brightestPoint, colourChannels
}

demos demo = demos.hueSelection;

PImage src, dst, dilated, eroded, both, gray, thresh, blur, adaptive, canny, scharr, sobel, r, g, b, h, s, v;

OpenCV openCV;
Histogram histogram;

boolean initialize = true;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

String[] imageFileNames = {"SampleImage1.jpg", "SampleImage2.jpg", "SampleImage3.jpg"};

int imageIndex = 0;

int lowerHue = 0;
int upperHue = 10;

int lowerThresh = 0;
int upperThresh = 50;

int blurAmount = 1;
int thresholdAmount = 1;
int adaptiveThresholdAmount = 1;

int numPixels;

void setup() {
  size(1024, 768);

  src = loadImage(imageFileNames[imageIndex]);
  src.resize(width, height);

  openCV = new OpenCV(this, src);
}

void draw() {
  openCV.loadImage(src);

  switch(demo) {
  case hueSelection:
    hueSelectionDemo();
    break;
  case erodeDilate:
    erodeDilate();
    break;
  case blur:
    blur();
    break;
  case threshold:
    threshold();
    break;
  case adaptiveThreshold:
    adaptiveThreshold();
    break;
  case contours:
    contours();
    break;
  case edges:
    edges();
    break;
  case brightestPoint:
    brightestPoint();
    break;
  case colourChannels:
    colourChannels();
    break;
  default:
    hueSelectionDemo();
    break;
  }
}

void hueSelectionDemo() {
  if (initialize) {
    background(255);
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    openCV.useColor(HSB);

    numPixels = openCV.getOutput().pixels.length;

    lowerHue = 0;
    upperHue = 10;

    initialize = false;
  }

  background(255);

  openCV.setGray(openCV.getH().clone());
  openCV.inRange(lowerHue, upperHue);
  histogram = openCV.findHistogram(openCV.getH(), 255);

  dst = openCV.getOutput();

  for (int i = 0; i < numPixels; i++) {
    if (dst.pixels[i] == color(255)) {
      dst.pixels[i] = src.pixels[i];
    }
  }
  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(dst, src.width, 0);
  popMatrix();

  noStroke(); 
  fill(0);
  histogram.draw(10, height - 230, 400, 200);
  noFill(); 
  stroke(0);
  line(10, height-30, 410, height-30);

  fill(255, 0, 0);
  text("Hue", 10, height - (textAscent() + textDescent()));

  float lowHueDot = map(lowerHue, 0, 255, 0, 400);
  float highHueDot = map(upperHue, 0, 255, 0, 400);

  stroke(255, 0, 0); 
  fill(255, 0, 0);
  strokeWeight(2);
  line(lowHueDot + 10, height-30, highHueDot +10, height-30);
  ellipse(lowHueDot+10, height-30, 3, 3 );
  text(lowerHue, lowHueDot-10, height-15);
  ellipse(highHueDot+10, height-30, 3, 3 );
  text(upperHue, highHueDot+10, height-15);
}

void erodeDilate() {
  if (initialize) {
    background(0);
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width/2, height/2);

    openCV = new OpenCV(this, src);

    openCV.gray();
    openCV.threshold(100);

    openCV.invert();

    src = openCV.getSnapshot();

    openCV.erode();
    eroded = openCV.getSnapshot();

    openCV.loadImage(src);
    openCV.dilate();

    dilated = openCV.getSnapshot();

    openCV.erode();
    both = openCV.getSnapshot();

    initialize = false;
  }
  image(src, 0, 0);
  image(eroded, src.width, 0);
  image(dilated, 0, src.height);  
  image(both, src.width, src.height);  

  fill(255, 0, 0);
  text("original", 20, 20);
  text("erode", src.width + 20, 20);
  text("dilate", 20, src.height+20);
  text("dilate then erode\n(close holes)", src.width+20, src.height+20);
}

void blur() {
  if (initialize) {
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    initialize = false;
  }

  background(0);

  gray = openCV.getSnapshot();

  openCV.loadImage(gray);
  openCV.blur(blurAmount);  
  blur = openCV.getSnapshot();

  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(blur, src.width, 0);
  popMatrix();

  fill(255, 0, 0);
  text("source", src.width/2 - 100, 20 );
  text("blur", src.width - 100, 20 );

  stroke(255);
  line(10, height-30, 410, height-30);

  fill(255, 0, 0);
  text("Blur", 10, height - (textAscent() + textDescent()));

  float blurDot = map(blurAmount, 1, 200, 0, 400);

  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(blurDot+10, height-30, 3, 3 );
  text(blurAmount, blurDot-10, height-15);
}

void threshold() {
  if (initialize) {
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    initialize = false;
  }
  background(0);

  openCV.threshold(thresholdAmount);
  thresh = openCV.getSnapshot();

  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(thresh, src.width, 0);
  popMatrix();

  fill(255, 0, 0);
  text("source", src.width/2 - 100, 20 );
  text("threshold", src.width - 100, 20 );

  stroke(255);
  line(10, height-30, 410, height-30);

  fill(255, 0, 0);
  text("Threshold", 10, height - (textAscent() + textDescent()));

  float thresholdDot = map(thresholdAmount, 0, 255, 0, 400);

  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(thresholdDot+10, height-30, 3, 3 );
  text(thresholdAmount, thresholdDot-10, height-15);
}

void adaptiveThreshold() {
  if (initialize) {
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    initialize = false;
  }
  background(0);

  gray = openCV.getSnapshot();

  openCV.loadImage(gray);
  openCV.adaptiveThreshold(adaptiveThresholdAmount, 1);
  adaptive = openCV.getSnapshot();

  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(adaptive, src.width, 0);
  popMatrix();

  fill(255, 0, 0);
  text("source", src.width/2 - 100, 20 );
  text("adaptive threshold", src.width - 100, 20 );

  stroke(255);
  line(10, height-30, 410, height-30);

  fill(255, 0, 0);
  text("AdaptiveThreshold", 10, height - (textAscent() + textDescent()));

  float adaptiveThresholdDot = map(adaptiveThresholdAmount, 0, 255, 0, 400);

  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(adaptiveThresholdDot+10, height-30, 3, 3 );
  text(adaptiveThresholdAmount, adaptiveThresholdDot-10, height-15);
}

void contours() {
  if (initialize) {
    src = loadImage(imageFileNames[imageIndex]); 
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    initialize = false;
  }

  background(0);

  openCV.gray();
  openCV.threshold(thresholdAmount);
  dst = openCV.getOutput();

  contours = openCV.findContours();
  println("found " + contours.size() + " contours");

  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(dst, src.width, 0);

  noFill();
  strokeWeight(3);

  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.draw();
  }
  popMatrix();

  stroke(255);
  line(10, height-30, 410, height-30);


  fill(255, 0, 0);
  text("Threshold", 10, height - (textAscent() + textDescent()));

  float thresholdDot = map(thresholdAmount, 0, 255, 0, 400);

  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(thresholdDot+10, height-30, 3, 3 );
  text(thresholdAmount, thresholdDot-10, height-15);
}

void edges() {
  if (initialize) {
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    lowerThresh = 0;
    upperThresh = 50;

    initialize = false;
  }

  background(0);

  openCV.findCannyEdges(lowerThresh, upperThresh);
  canny = openCV.getSnapshot();

  openCV.loadImage(src);
  openCV.findScharrEdges(OpenCV.HORIZONTAL);
  scharr = openCV.getSnapshot();

  openCV.loadImage(src);
  openCV.findSobelEdges(1, 0);
  sobel = openCV.getSnapshot();

  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(canny, src.width, 0);
  image(scharr, 0, src.height);
  image(sobel, src.width, src.height);
  popMatrix();

  fill(255, 0, 0);
  text("Source", 10, 25); 
  text("Canny", src.width/2 + 10, 25); 
  text("Scharr", 10, src.height/2 + 25); 
  text("Sobel", src.width/2 + 10, src.height/2 + 25);

  stroke(0);
  line(10, height-30, 410, height-30);

  fill(255, 0, 0);
  text("Threshold", 10, height - (textAscent() + textDescent()));

  float lowThreshDot = map(lowerThresh, 0, 255, 0, 400);
  float highThreshDot = map(upperThresh, 0, 255, 0, 400);

  stroke(255, 0, 0); 
  fill(255, 0, 0);
  strokeWeight(2);
  line(lowThreshDot + 10, height-30, highThreshDot +10, height-30);
  ellipse(lowThreshDot+10, height-30, 3, 3 );
  text(lowerHue, lowThreshDot-10, height-15);
  ellipse(highThreshDot+10, height-30, 3, 3 );
  text(upperHue, highThreshDot+10, height-15);
}

void brightestPoint() {
  if (initialize) {
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width, height);

    openCV = new OpenCV(this, src);

    initialize = false;
  }

  image(openCV.getOutput(), 0, 0); 

  PVector loc = openCV.max();

  stroke(255, 0, 0);
  strokeWeight(4);
  noFill();
  ellipse(loc.x, loc.y, 10, 10);
}

void colourChannels() {
  if (initialize) {
    background(0);
    src = loadImage(imageFileNames[imageIndex]);
    src.resize(width/3,height/3);

    openCV = new OpenCV(this, src);

    r = openCV.getSnapshot(openCV.getR());
    g = openCV.getSnapshot(openCV.getG());
    b = openCV.getSnapshot(openCV.getB());  

    openCV.useColor(HSB);

    h = openCV.getSnapshot(openCV.getH());
    s = openCV.getSnapshot(openCV.getS());  
    v = openCV.getSnapshot(openCV.getV());

    initialize = false;
  }

  noTint();
  image(src, src.width,0, src.width, src.height);
  
  tint(255,0,0);
  image(r, 0, src.height, src.width, src.height);
  
  tint(0,255,0);
  image(g, src.width, src.height, src.width, src.height);
  
  tint(0,0,255);
  image(b, 2*src.width, src.height, src.width, src.height);
  
  noTint();
  image(h, 0, 2*src.height, src.width, src.height);
  image(s, src.width, 2*src.height, src.width, src.height);
  image(v, 2*src.width, 2*src.height, src.width, src.height);
}

void keyReleased() {
  if (key == '1' && demo != demos.hueSelection) {
    demo = demos.hueSelection;
    initialize = true;
  } else if (key == '2' && demo != demos.erodeDilate) {
    demo = demos.erodeDilate;
    initialize = true;
  } else if (key == '3' && demo != demos.blur) {
    demo = demos.blur;
    initialize = true;
  } else if (key == '4' && demo != demos.threshold) {
    demo = demos.threshold;
    initialize = true;
  } else if (key == '5' && demo != demos.adaptiveThreshold) {
    demo = demos.adaptiveThreshold;
    initialize = true;
  } else if (key == '6' && demo != demos.contours) {
    demo = demos.contours;
    initialize = true;
  } else if (key == '7' && demo != demos.edges) {
    demo = demos.edges;
    initialize = true;
  } else if (key == '8' && demo != demos.brightestPoint) {
    demo = demos.brightestPoint;
    initialize = true;
  } else if (key == '9' && demo != demos.colourChannels) {
    demo = demos.colourChannels;
    initialize = true;
  }
  else if (keyCode == RIGHT) {
    imageIndex++;

    if (imageIndex > imageFileNames.length-1) {
      imageIndex = 0;
    }
    initialize = true;
  } else if (keyCode == LEFT) {
    imageIndex--;

    if (imageIndex < 0) {
      imageIndex = imageFileNames.length-1;
    }
    initialize = true;
  }
}

void mouseMoved() {
  if (demo == demos.hueSelection) {
    if (keyPressed && key == ' ') {
      upperHue += mouseX - pmouseX;
    } else {
      if (upperHue < 255 || (mouseX - pmouseX) < 0) {
        lowerHue += mouseX - pmouseX;
      }

      if (lowerHue > 0 || (mouseX - pmouseX) > 0) {
        upperHue += mouseX - pmouseX;
      }
    }

    upperHue = constrain(upperHue, lowerHue, 255);
    lowerHue = constrain(lowerHue, 0, upperHue-1);
  } else if (demo == demos.blur) {
    if (mouseX - pmouseX < 0) {
      blurAmount -= 1;
    }

    if (mouseX - pmouseX > 0) {
      blurAmount += 1;
    }

    blurAmount = constrain(blurAmount, 1, 200);
  } else if (demo == demos.threshold || demo == demos.contours) {
    if (mouseX - pmouseX < 0) {
      thresholdAmount -= 1;
    }

    if (mouseX - pmouseX > 0) {
      thresholdAmount += 1;
    }

    thresholdAmount = constrain(thresholdAmount, 0, 255);
  } else if (demo == demos.adaptiveThreshold) {
    if (mouseX - pmouseX < 0) {
      adaptiveThresholdAmount -= 2;
    }

    if (mouseX - pmouseX > 0) {
      adaptiveThresholdAmount += 2;
    }

    adaptiveThresholdAmount = constrain(adaptiveThresholdAmount, 1, 255);
  } else if (demo == demos.edges) {
    if (keyPressed && key == ' ') {
      upperThresh += mouseX - pmouseX;
    } else {
      if (upperThresh < 255 || (mouseX - pmouseX) < 0) {
        lowerThresh += mouseX - pmouseX;
      }

      if (lowerThresh > 0 || (mouseX - pmouseX) > 0) {
        upperThresh += mouseX - pmouseX;
      }
    }

    upperThresh = constrain(upperThresh, lowerThresh, 255);
    lowerThresh = constrain(lowerThresh, 0, upperThresh-1);
  }
}