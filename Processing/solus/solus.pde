/*
 * Solus - Interactive Installation
 * v1.0 01-02-2012
 *
 * author: |Ds|
 * site: http://binaryunit.com/works/view/10
 * github:https://github.com/7Ds7/Solus
 *
 * 
 * Keyboard:
 * - 'd' toggle debug mode
 * - 'S' save settings
 * - 'L' load settings
 * - '>' select next quad in debug mode
 * - '<' select prev quad in debug mode
 * - '1', '2', '3', '4' select one of selected quad's corners 
 * - Arrow keys (left, right, up, down) move selected corner's position (you can also use mouse for that) 
 */

/* 
 * Copyright (c) 2012 |Ds| http://binaryunit.com
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
import processing.video.*;

Movie faceMovie;
Movie earMovie;
Movie hairMovie;
Movie muteMovie;

String state;
Timer _timer_; //Not in use right now
SerialRead _serial_;
PApplet ROOT = this;

void setup() {
  size(1280, 1024, P3D);
  state = "F"; //Current proximity check F is far C is close
  //_serial_ = new SerialRead();
  setupSound();
  
  faceMovie = new Movie(this, "PIA_face.mov");
  faceMovie.loop();
  earMovie = new Movie(this, "PIA_ear_r.mov");
  earMovie.loop();
  hairMovie = new Movie(this, "PIA_head.mov");
  hairMovie.loop();
  muteMovie = new Movie(this, "PIA_quiet.mov");
  muteMovie.loop();

  _timer_ = new Timer(5); // Wait x seconds before checking proximity
  _timer_.start();

  projectedQuads = new ProjectedQuads();  
  projectedQuads.load(configFile);  
  projectedQuads.setNumQuads(9);
  
  //we want to display 3 quads so if there was no config file
  //or less than 3 were defined we increase number to 3
  if (projectedQuads.getNumQuads() < 3) {
    projectedQuads.setNumQuads(3);
  }  

  //quadImage = loadImage("checker.png");
  quadGraphics = createGraphics(256, 256, P2D);
  
  //Face 1
  projectedQuads.getQuad(0).setTexture(faceMovie);
  projectedQuads.getQuad(1).setTexture(earMovie);
  projectedQuads.getQuad(2).setTexture(hairMovie); 

  //Face 2
  projectedQuads.getQuad(3).setTexture(faceMovie);  
  projectedQuads.getQuad(4).setTexture(earMovie);  
  projectedQuads.getQuad(5).setTexture(hairMovie);   

  //Face 3
  projectedQuads.getQuad(6).setTexture(faceMovie);  
  projectedQuads.getQuad(7).setTexture(earMovie);  
  projectedQuads.getQuad(8).setTexture(hairMovie);

  //If mirrored image is needed use this
  projectedQuads.getQuad(7).setMirrored(true);
}


/*public static void main( String args[] ) {
 PApplet.main( new String[] { "--present", "Faces" } );
 }*/

void draw() {
  background(0);
  drawGraphics();
  checkProximity();
  projectedQuads.draw();
}

void drawGraphics () {
  //animation code is here
  quadGraphics.beginDraw();
  quadGraphics.background(0, 00255);
  quadGraphics.stroke(255);
  quadGraphics.strokeWeight(10);
  quadGraphics.noFill();
  quadGraphics.rect(0, 0, quadGraphics.width, quadGraphics.height);
  quadGraphics.noStroke();
  quadGraphics.strokeWeight(3);
  quadGraphics.fill(255);
  float[] speeds = {
    1, 1.25, 1.5, 2.0, 2.5, 3
  };
  for (int i=0; i<speeds.length; i++) {
    float x = quadGraphics.width * (0.5 + 0.5*sin(frameCount/100.0*speeds[i]));
    quadGraphics.rect(x, 0, 10*speeds[i], quadGraphics.height);
  }
  quadGraphics.endDraw();
}

void checkProximity() {
  //Check proximity based on serial response
  if ( _serial_.serial_port.available () > 0 ) {
    String sread = _serial_.checkState();
    if ( !sread.equals( state ) && sread.equals("C") ) {
      player.shiftGain(1, -80.0, 5000);
      projectedQuads.getQuad(0).setTexture(muteMovie);
      projectedQuads.getQuad(3).setTexture(muteMovie);
      projectedQuads.getQuad(6).setTexture(muteMovie);
      println ("#### SOUND OFF ####");
      state = "C";
    }
    else if ( !sread.equals( state ) && sread.equals("F") ) {
      player.shiftGain(-80.0, 1, 1000);
      projectedQuads.getQuad(0).setTexture(faceMovie);
      projectedQuads.getQuad(3).setTexture(faceMovie);
      projectedQuads.getQuad(6).setTexture(faceMovie);
      println ("#### SOUND ON ####");
      state = "F";
    }
  }
}


// Needed for Processing 2.0
void movieEvent(Movie m) {
  m.read();
}

