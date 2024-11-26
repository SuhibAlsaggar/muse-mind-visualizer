void drawLineGraph(float[] data, float[] dataMinMax, int lineColor, float yOffset) {
    stroke(lineColor);
    noFill();

    // Draw the signal as a scrolling line
    beginShape();
    for (int i = 0; i < width; i++) {
        int dataIndex = (dataPointer + i) % data.length; // Wrap around data
        float x = i; // X-axis position
        float y = safeMap(data[dataIndex], dataMinMax[0], dataMinMax[1], height / 2, 100) + yOffset; // Map value to canvas height
        vertex(x, y);
    }
    endShape();
}


void drawScatterVisualization() {
    int tempDataPoints = min(tp9.length, af7.length, af8.length);
    int numDataPoints = min(tempDataPoints, tp10.length);
    float scatterSize = 250; // Base size of the scatter

    pushMatrix();
    translate(width / 2, height / 2, -scatterSize); // Center the scatter and move it back a bit
    rotateY(frameCount * 0.01); // Rotate the scatter dynamically
    noFill();

    for (int i = 0; i < numDataPoints; i++) {
        float theta = safeMap(i, 0, numDataPoints, 0, TWO_PI); // Azimuthal angle
        float phi = safeMap(i, 0, numDataPoints, 0, PI); // Polar angle

        // TP9 layer
        float r = scatterSize + safeMap(tp9[i], tp9MinMax[0], tp9MinMax[1], -50, 50);
        float x = r * sin(phi) * cos(theta);
        float y = r * sin(phi) * sin(theta);
        float z = r * cos(phi);
        stroke(Colors[0]);
        point(x, y, z);

        // AF7 layer
        r = scatterSize + safeMap(af7[i], af7MinMax[0], af7MinMax[1], -50, 50);
        x = r * sin(phi) * cos(theta);
        y = r * sin(phi) * sin(theta);
        z = r * cos(phi);
        stroke(Colors[1]);
        point(x, y, z);

        // AF8 layer
        r = scatterSize + safeMap(af8[i], af8MinMax[0], af8MinMax[1], -50, 50);
        x = r * sin(phi) * cos(theta);
        y = r * sin(phi) * sin(theta);
        z = r * cos(phi);
        stroke(Colors[2]);
        point(x, y, z);

        // TP10 layer
        r = scatterSize + safeMap(tp10[i], tp10MinMax[0], tp10MinMax[1], -50, 50);
        x = r * sin(phi) * cos(theta);
        y = r * sin(phi) * sin(theta);
        z = r * cos(phi);
        stroke(Colors[3]);
        point(x, y, z);
    }

    popMatrix();
}
