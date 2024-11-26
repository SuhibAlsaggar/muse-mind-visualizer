void drawControl() {
    fill(150);
    rect(50, height - 40, 150, 30); // Prev button
    rect(width - 200, height - 40, 150, 30); // Next button
    
    fill(255);
    noStroke(); // Disable stroke for text
    textSize(20);
    
    text("Prev File", 70, height - 20);
    text("Next File", width - 180, height - 20);

    // Display current file name at the top
    text("File: " + fileNames[currentFileIndex], 16, 32);
    text("Click on screen and drag to rotate surface", 16, height / 2 + 32);

}

void mousePressed() {
    if (mouseX > 50 && mouseX < 200 && mouseY > height - 40 && mouseY < height - 10) {
        // Reset pointer
        dataPointer = 0;

        // Load previous file
        currentFileIndex = (currentFileIndex - 1 + fileNames.length) % fileNames.length;
        loadData(fileNames[currentFileIndex]);

        // Re-map surface grid data
        grid.mapSensorDataToGrid(tp9, af7, af8, tp10);
    } else if (mouseX > width - 200 && mouseX < width - 50 && mouseY > height - 40 && mouseY < height - 10) {
        // Reset pointer
        dataPointer = 0;

        // Load next file
        currentFileIndex = (currentFileIndex + 1) % fileNames.length;
        loadData(fileNames[currentFileIndex]);

        // Re-map surface grid data
        grid.mapSensorDataToGrid(tp9, af7, af8, tp10);
    }
}
