import processing.serial.*;
import oscP5.*;
import netP5.*;

// Global variables
OscP5 oscP5;
Table table;
float[] timestamps, tp9, af7, af8, tp10; // Sensor data arrays
float[] tp9MinMax, af7MinMax, af8MinMax, tp10MinMax;
color[] Colors = {
    color(255, 69, 0), // Vibrant Red
    color(0, 191, 255), // Electric Blue
    color(57, 255, 20), // Neon Green
    color(255, 215, 0) // Bright Yellow
};
String[] fileNames = {
    "eeg_data_suhib_coding_test.csv",
    "eeg_data_suhib_chess.csv",
    "eeg_data_abd_coding_test.csv",
    "eeg_data_suhib_chess_false_data.csv",
    "eeg_data_abd_math_test_false_data.csv"
};
int currentFileIndex = 0; // To track which file is loaded

int dataPointer = 0; // To scroll through the data
PFont font;

SurfaceGrid grid;

void setup() {
    oscP5 = new OscP5(this, 5000); // Listening on port 5000

    size(1600, 900, P3D); // Canvas size
    font = createFont("Arial", 12, true);
    textFont(font);
    loadData(fileNames[currentFileIndex]); // Load the first file

    // Set the camera to look at the center of the scene
    camera(width / 2.0, height / 2.0, (height / 2.0) / tan(PI * 30.0 / 180.0), // Eye position
        width / 2.0, height / 2.0, 0, // Look-at position
        0, 1, 0);

    // Create the grid
    grid = new SurfaceGrid(800, 800, 15);

    // Map sensor data to the grid
    grid.mapSensorDataToGrid(tp9, af7, af8, tp10);
}

void oscEvent(OscMessage msg) {
    // Parse incoming EEG data and update the visualization
}

void draw() {
    background(0); // Black background
    lights();

    // Draw white borders to split the screen into four quadrants
    stroke(255);
    strokeWeight(2);
    line(width / 2, 0, width / 2, height);
    line(0, height / 2, width, height / 2);

    // Top-left: Line graph
    pushMatrix();
    translate(0, height / -7);
    scale(0.5); // Scale to fit the quadrant
    drawLineGraph(tp9, tp9MinMax, Colors[0], height / 3.5); // Red for TP9
    drawLineGraph(af7, af7MinMax, Colors[1], height / 2.4); // Blue for AF7
    drawLineGraph(af8, af8MinMax, Colors[2], height / 1.9); // Green for AF8
    drawLineGraph(tp10, tp10MinMax, Colors[3], height / 1.3); // Yellow for TP10
    popMatrix();

    // Top-right: Flow graph
    pushMatrix();
    addSquares();
    drawSquares();
    drawActiveLines();
    translate(width / 2, 0); // Move to the top-right quadrant
    scale(0.5);
    // Draw a vertical line
    stroke(145, 0, 255); // Purple line
    strokeWeight(2); // Line thickness
    line(width / 2, 0, width / 2, height);
    popMatrix();

    // Bottom-left: Surface visualization
    pushMatrix();
    translate(0, height / 2); // Move to the bottom-right quadrant
    scale(0.5);
    if (frameCount % 2 == 0) {
        grid.shiftRows(true); // Shift upward
        // grid.shiftRows(false); // Uncomment for downward shift
    }
    grid.drawGrid();
    grid.handleMouseInteraction();
    popMatrix();

    // Bottom-right: Sphere visualization
    pushMatrix();
    translate(width / 3, height / 3.5); // Move to the bottom-right quadrant
    drawScatterVisualization();
    popMatrix();

    // Draw text and navigation buttons at the bottom of the screen
    drawControl();

    // Scroll through data
    dataPointer = (dataPointer + 1) % timestamps.length;
}
