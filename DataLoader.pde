void loadData(String fileName) {
    table = loadTable(fileName, "header"); // Load file
    int rowCount = table.getRowCount();
    timestamps = new float[rowCount];
    tp9 = new float[rowCount];
    af7 = new float[rowCount];
    af8 = new float[rowCount];
    tp10 = new float[rowCount];

    for (int i = 1; i < rowCount; i++) {
        timestamps[i] = table.getFloat(i, "Timestamp");
        tp9[i] = table.getFloat(i, "TP9");
        af7[i] = table.getFloat(i, "AF7");
        af8[i] = table.getFloat(i, "AF8");
        tp10[i] = table.getFloat(i, "TP10");
    }

    tp9MinMax = findMinMax(tp9);
    af7MinMax = findMinMax(af7);
    af8MinMax = findMinMax(af8);
    tp10MinMax = findMinMax(tp10);
}

float safeMap(float value, float start1, float stop1, float start2, float stop2) {
    if (Float.isNaN(value) || Float.isInfinite(value)) {
        return (start2 + stop2) / 2; // Default to the midpoint of the output range
    }
    return map(value, start1, stop1, start2, stop2); 
}

float[] findMinMax(float[] array) {
    if (array.length == 0) {
        println("Array is empty!");
        return new float[] {
            Float.NaN, Float.NaN
        }; // Return NaN if array is empty
    }

    float min = Float.POSITIVE_INFINITY;
    float max = Float.NEGATIVE_INFINITY;

    for (int i = 0; i < array.length; i++) {
        if (Float.isNaN(array[i])) {
            println("NaN found in array at index: " + i);
            continue; // Skip NaN values
        }
        if (array[i] < min) min = array[i];
        if (array[i] > max) max = array[i];
    }

    return new float[] {
        min,
        max
    };
}

float[] findMinMax(float[][] array) {
    if (array.length == 0) {
        println("Array is empty!");
        return new float[] {
            Float.NaN, Float.NaN
        }; // Return NaN if the array is empty
    }

    float min = Float.POSITIVE_INFINITY;
    float max = Float.NEGATIVE_INFINITY;

    for (int row = 0; row < array.length; row++) {
        if (array[row] == null || array[row].length == 0) {
            println("Row " + row + " is empty!");
            continue; // Skip empty rows
        }

        for (int col = 0; col < array[row].length; col++) {
            if (Float.isNaN(array[row][col])) {
                println("NaN found at row " + row + ", column " + col);
                continue; // Skip NaN values
            }
            if (array[row][col] < min) min = array[row][col];
            if (array[row][col] > max) max = array[row][col];
        }
    }

    if (min == Float.POSITIVE_INFINITY || max == Float.NEGATIVE_INFINITY) {
        return new float[] {
            Float.NaN, Float.NaN
        };
    }

    return new float[] {
        min,
        max
    };
}
