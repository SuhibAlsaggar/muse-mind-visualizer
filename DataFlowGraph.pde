ArrayList < Square > tp9Squares = new ArrayList < Square > ();
ArrayList < Square > af7Squares = new ArrayList < Square > ();
ArrayList < Square > af8Squares = new ArrayList < Square > ();
ArrayList < Square > tp10Squares = new ArrayList < Square > ();
ArrayList < Line > activeLines = new ArrayList < Line > ();

float squareSpeed = 5; // Speed at which squares move left
float squareSize = 5; // Size of each square

class Line {
    float x1, y1; // Starting point
    float x2, y2; // Endpoint
    float cx1, cy1; // First control point
    float cx2, cy2; // Second control point
    int Color;
    int createdTime;

    Line(float x1, float y1, float x2, float y2, int Color) {
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;

        float midpointY = height / 8 - 2.5; // Calculate midpoint threshold
        float controlPoint = 10;

        // Define control points for the curve
        if (y1 > midpointY) {
            // Curve downwards
            this.cx1 = x1 + (x2 - x1) * 0.3; // Control point 1
            this.cy1 = y1 + controlPoint; // Push curve downwards
            this.cx2 = x1 + (x2 - x1) * 0.7; // Control point 2
            this.cy2 = y2 + controlPoint; // Push curve downwards
        } else {
            // Curve upwards (default)
            this.cx1 = x1 + (x2 - x1) * 0.3;
            this.cy1 = y1 - controlPoint; // Push curve upwards
            this.cx2 = x1 + (x2 - x1) * 0.7;
            this.cy2 = y2 - controlPoint; // Push curve upwards
        } // Adjust for curvature

        this.Color = Color;
        this.createdTime = millis(); // Store creation time
    }

    // Draw the Bezier curve
    void display() {
        stroke(Color);
        strokeWeight(1);
        noFill();
        bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
    }

    // Check if the line should be removed after 1 second
    boolean isExpired() {
        return millis() - createdTime > 1000; // 1000 milliseconds
    }
}




class Square {
    float x, y; // Position
    float speed; // Horizontal speed
    int Color; // Color of the square

    Square(float x, float y, float speed, int Color) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.Color = Color;
    }

    void update() {
        x -= speed; // Move square left
    }

    void display() {
        fill(Color);
        noStroke();
        rect(x, y, squareSize, squareSize);
    }

    boolean isOffScreen() {
        return x < width * 0.75; // Disappear when it reaches the middle
    }
}

void drawDataArray(ArrayList < Square > data, color Color) {
    for (int i = data.size() - 1; i >= 0; i--) {
        Square s = data.get(i);
        s.update();
        s.display();
        if (s.isOffScreen()) {
            // Add a new Bezier curve to the activeLines list
            activeLines.add(new Line(s.x, s.y, width / 2, height / 4, Color));
            data.remove(i); // Remove square if off screen
        }
    }
}

void drawSquares() {
    // Update and display squares
    drawDataArray(tp9Squares, Colors[0]);
    drawDataArray(af7Squares, Colors[1]);
    drawDataArray(af8Squares, Colors[2]);
    drawDataArray(tp10Squares, Colors[3]);
}

void drawActiveLines() {
    for (int i = activeLines.size() - 1; i >= 0; i--) {
        Line l = activeLines.get(i);
        l.display(); // Draw the line

        if (l.isExpired()) {
            activeLines.remove(i); // Remove the line after 1 seconds
        }
    }
}


float getMappedValue(float value, float[] valueMinMax) {
    return safeMap(value, valueMinMax[0], valueMinMax[1], height / 2 - 5, 0);
}

void addSquares() {
    // Add TP9 square 
    float y = getMappedValue(tp9[dataPointer], tp9MinMax);
    tp9Squares.add(new Square(width, y, squareSpeed, Colors[0]));

    // Add AF7 square 
    y = getMappedValue(af7[dataPointer], af7MinMax);
    af7Squares.add(new Square(width, y, squareSpeed, Colors[1]));

    // Add AF8 square 
    y = getMappedValue(af8[dataPointer], af8MinMax);
    af8Squares.add(new Square(width, y, squareSpeed, Colors[2]));

    // Add TP10 square 
    y = getMappedValue(tp10[dataPointer], tp10MinMax);
    tp10Squares.add(new Square(width, y, squareSpeed, Colors[3]));
}

void drawCurvedLine(float x1, float y1, float x2, float y2, color Color) {
    // Define control points for the Bezier curve
    float cx1 = x1 + (x2 - x1) * 0.3; // First control point (near start)
    float cy1 = y1 - 50; // Add some vertical curvature
    float cx2 = x1 + (x2 - x1) * 0.7; // Second control point (near end)
    float cy2 = y2 + 50; // Add some vertical curvature

    // Draw the Bezier curve
    stroke(Color);
    strokeWeight(2);
    noFill();
    bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
}
