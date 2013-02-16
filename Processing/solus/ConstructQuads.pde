String configFile = "data/quadsconfig.txt";

ProjectedQuads projectedQuads;
PImage    quadImage;  
PGraphics quadGraphics;

void keyPressed() {
  //let projectedQuads handle keys by itself
  projectedQuads.keyPressed();
}

void mousePressed() {
  //let projectedQuads handle mousePressed by itself
  projectedQuads.mousePressed();
}

void mouseDragged() {
  //let projectedQuads handle mouseDragged by itself
  projectedQuads.mouseDragged();
}

