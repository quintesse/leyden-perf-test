
public final class Bar {

    private static final String BLOCK_FULL = "\u2588";
    private static final char FOO = '\u2589';
    // Unicode fractional blocks ascend; offset points at 1/8 block
    private static final char BLOCK_7_8 = (char) (BLOCK_FULL.codePointAt(0) + 1);
    private static final char BLOCK_1_8 = (char) (BLOCK_FULL.codePointAt(0) + 7);

    private Bar() {}

    public static String bar(Number value, Number minValue, Number maxValue) {
        return bar(value, minValue, maxValue, 40); // default width 40
    }

    /**
     * Draw a bar whose width is proportional to (x - min) and equal to width
     * when x equals max. Unicode block element characters are used to draw
     * fractional blocks. A 1/8 block is always added at the start of the bar.
     *
     * @param value The value to represent
     * @param minValue The minimum value that can be represented
     * @param maxValue The maximum value that can be represented
     * @param width The maximum width of the bar in characters
     * @return A string containing the rendered bar
     */
    public static String bar(Number value, Number minValue, Number maxValue, int width) {
        double dx = value.doubleValue();
        double dmin = minValue.doubleValue();
        double dmax = maxValue.doubleValue();

        if (!(dmin < dmax && dx >= dmin && dx <= dmax)) {
            throw new IllegalArgumentException("Values out of range");
        }

        int fracWidth = width * 8;
        double interval = dmax - dmin;
        int barWidth = (int) (((dx - dmin) / interval) * fracWidth);
        int fullChunks = barWidth / 8;
        int remainder = barWidth % 8;

        StringBuilder sb = new StringBuilder(width + 1);
        for (int i = 0; i < fullChunks; i++) {
            sb.append(BLOCK_7_8);
        }
        // Always append a fractional block
        sb.append((char) (BLOCK_1_8 - remainder));

        return sb.toString();
    }
}