// Add this at the very top of your sketch, before any other code
public void settings() {
  System.setProperty("sun.java2d.uiScale", "1.0");
  size(800, 600, P2D);
}

// Global variables
int[] cells;
float[] lightWaves;
PVector[] nodes;
float time = 0;

// Constants
final int CELL_COUNT = 800;
final int NODE_COUNT = 5;
final float MAX_NODE_DISTANCE = 200;
final int CONTRACT_COUNT = 5;

void setup() {
  initializeSimulation();
}

void draw() {
  background(0);
  
  drawPhotonicAutomaton();
  drawCrownConsensus();
  drawPhotonicSmartContracts();
  
  updateSimulation();
}

void initializeSimulation() {
  cells = new int[CELL_COUNT];
  lightWaves = new float[CELL_COUNT];
  nodes = new PVector[NODE_COUNT];
  
  for (int i = 0; i < CELL_COUNT; i++) {
    cells[i] = int(random(2));
    lightWaves[i] = random(TWO_PI);
  }
  
  for (int i = 0; i < NODE_COUNT; i++) {
    nodes[i] = new PVector(random(width), random(height));
  }
}

void drawPhotonicAutomaton() {
  stroke(0, 255, 255, 100);
  for (int i = 0; i < CELL_COUNT; i++) {
    if (cells[i] == 1) {
      float x = map(i, 0, CELL_COUNT, 0, width);
      float y = height/2 + sin(lightWaves[i] + time) * 50;
      line(x, height/2, x, y);
    }
  }
}

void drawCrownConsensus() {
  stroke(255, 255, 0);
  for (int i = 0; i < NODE_COUNT; i++) {
    for (int j = i + 1; j < NODE_COUNT; j++) {
      float d = PVector.dist(nodes[i], nodes[j]);
      if (d < MAX_NODE_DISTANCE) {
        line(nodes[i].x, nodes[i].y, nodes[j].x, nodes[j].y);
      }
    }
  }
  
  fill(255, 0, 255);
  for (PVector node : nodes) {
    ellipse(node.x, node.y, 10, 10);
  }
}

void drawPhotonicSmartContracts() {
  for (int i = 0; i < CONTRACT_COUNT; i++) {
    float x = noise(i * 0.5, time * 0.1) * width;
    float y = noise(i * 0.5 + 1000, time * 0.1) * height;
    float size = noise(i * 0.5 + 2000, time * 0.1) * 30 + 10;
    
    fill(0, 255, 0, 150);
    ellipse(x, y, size, size);
    
    if (frameCount % 60 == 0) {
      fill(255);
      textAlign(CENTER, CENTER);
      text("Contract " + (i+1), x, y);
    }
  }
}

void updateSimulation() {
  time += 0.05;
  
  updateCellularAutomaton();
  updateLightWaves();
  updateNodes();
}

void updateCellularAutomaton() {
  int[] newCells = new int[CELL_COUNT];
  for (int i = 0; i < CELL_COUNT; i++) {
    int left = cells[(i - 1 + CELL_COUNT) % CELL_COUNT];
    int center = cells[i];
    int right = cells[(i + 1) % CELL_COUNT];
    newCells[i] = rules(left, center, right);
  }
  cells = newCells;
}

void updateLightWaves() {
  for (int i = 0; i < CELL_COUNT; i++) {
    lightWaves[i] += 0.1;
  }
}

void updateNodes() {
  for (PVector node : nodes) {
    node.x += random(-1, 1);
    node.y += random(-1, 1);
    node.x = constrain(node.x, 0, width);
    node.y = constrain(node.y, 0, height);
  }
}

int rules(int left, int center, int right) {
  return left ^ (center | right);  // Rule 30
}

void mousePressed() {
  initializeSimulation();
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("iphotonic-ananas-####.png");
  }
}
