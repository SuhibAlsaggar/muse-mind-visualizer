class SurfaceGrid {
    int cols, rows; // Number of columns and rows in the grid
    float[][] af8; // Z-values (height)
    float[][] tp10; // Color intensity
    int gridSize; // Size of each grid cell
    int surfaceWidth, surfaceHeight; // Dimensions of the grid
    float angleX = -2; // Rotation angle for X-axis
    float angleY = -0.1; // Rotation angle for Y-axis
    float limit = 200;

    // Constructor
    SurfaceGrid(int surfaceWidth, int surfaceHeight, int gridSize) {
        this.surfaceWidth = surfaceWidth;
        this.surfaceHeight = surfaceHeight;
        this.gridSize = gridSize;

        // Calculate grid dimensions
        cols = surfaceWidth / gridSize;
        rows = surfaceHeight / gridSize;

        // Initialize height and color arrays
        af8 = new float[cols][rows];
        tp10 = new float[cols][rows];
    }

    void shiftRows(boolean upward) {
        if (upward) {
            // Save the first row
            float[] firstRowHeight = af8[0];
            float[] firstRowColor = tp10[0];

            // Move all rows up
            for (int x = 0; x < cols - 1; x++) {
                af8[x] = af8[x + 1];
                tp10[x] = tp10[x + 1];
            }

            // Wrap the first row to the last
            af8[cols - 1] = firstRowHeight;
            tp10[cols - 1] = firstRowColor;

        } else {
            // Save the last row
            float[] lastRowHeight = af8[cols - 1];
            float[] lastRowColor = tp10[cols - 1];

            // Move all rows down
            for (int x = cols - 1; x > 0; x--) {
                af8[x] = af8[x - 1];
                tp10[x] = tp10[x - 1];
            }

            // Wrap the last row to the first
            af8[0] = lastRowHeight;
            tp10[0] = lastRowColor;
        }
    }


    // Map sensor data to the grid
    void mapSensorDataToGrid(float[] tp9, float[] af7, float[] af8Data, float[] tp10Data) {

        float yOffset = millis() * 0.0001; // Time-based filler data
        for (int x = 0; x < cols; x++) {
            float xOffset = millis() * 0.0001;
            for (int y = 0; y < rows; y++) {
                af8[x][y] = safeMap(noise(xOffset, yOffset), 0, 1, -limit * 0.65, limit * 0.65); // Update height values
                tp10[x][y] = 0; // Update color values
                xOffset += 0.1; // Move along x-axis in noise space
            }
            yOffset += 0.1; // Move along y-axis in noise space
        }

        // Map each sensor data point to the grid
        for (int i = 0; i < tp9.length; i++) {
          
            // Normalize tp9 and af7 to grid dimensions
            int col = int(safeMap(tp9[i], tp9MinMax[0], tp9MinMax[1], 0, cols - 1)); // tp9 -> column
            int row = int(safeMap(af7[i], af7MinMax[0], af7MinMax[1], 0, rows - 1)); // af7 -> row

            // Avoid out-of-bounds indexing
            col = constrain(col, 0, cols - 1);
            row = constrain(row, 0, rows - 1);

            // Map af8 and tp10 to grid cell
            af8[col][row] += safeMap(af8Data[i], af8MinMax[0], af8MinMax[1], -limit, limit); // Normalize af8 data for height
            tp10[col][row] += safeMap(tp10Data[i], tp10MinMax[0], tp10MinMax[1], 0, 255); // Normalize tp10 for color
        }
    }

    // Draw the grid
    void drawGrid() {
        translate(width / 2, height / 2, -400); // Move to the center
        rotateX(angleX); // Rotate around X-axis
        rotateY(angleY); // Rotate around Y-axis
        noStroke();

        float[] dataMinMax = findMinMax(af8);
        for (int x = 0; x < cols - 1; x++) {
            for (int y = 0; y < rows - 1; y++) {
                beginShape(QUADS); // Draw quadrilateral for each grid cell

                // Map TP10 to color intensity
                float colorValue = tp10[x][y];
                fill(colorValue, 255 - colorValue, 255 - colorValue); // Use gradient based on colorValue

                float cellHeight1 = safeMap(af8[x][y], dataMinMax[0], dataMinMax[1], -limit, limit);
                float cellHeight2 = safeMap(af8[x + 1][y], dataMinMax[0], dataMinMax[1], -limit, limit);
                float cellHeight3 = safeMap(af8[x + 1][y + 1], dataMinMax[0], dataMinMax[1], -limit, limit);
                float cellHeight4 = safeMap(af8[x][y + 1], dataMinMax[0], dataMinMax[1], -limit, limit);


                // Draw the four corners of the quad
                vertex(x * gridSize - surfaceWidth / 2, y * gridSize - surfaceHeight / 2, cellHeight1); // Top-left
                vertex((x + 1) * gridSize - surfaceWidth / 2, y * gridSize - surfaceHeight / 2, cellHeight2); // Top-right
                vertex((x + 1) * gridSize - surfaceWidth / 2, (y + 1) * gridSize - surfaceHeight / 2, cellHeight3); // Bottom-right
                vertex(x * gridSize - surfaceWidth / 2, (y + 1) * gridSize - surfaceHeight / 2, cellHeight4); // Bottom-left

                endShape();
            }
        }
    }

    // Handle mouse interaction
    void handleMouseInteraction() {
        if (mousePressed) {
            angleX += (mouseY - pmouseY) * 0.01;
            angleY += (mouseX - pmouseX) * 0.01;
        }
    }
}
