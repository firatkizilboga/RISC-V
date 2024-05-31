#define VGA_ADDRESS 0xB8000
#define VGA_COLS 80
#define VGA_ROWS 25

// Create a pointer to the VGA memory
volatile unsigned char* vga = (volatile unsigned char*)VGA_ADDRESS;

int main() {
    while(1){
    for (unsigned char color = 0; color < 16; color++) {
        // Calculate the attribute byte (background color in the high nibble, black foreground)
        unsigned char attribute = (color << 4);

        // Write spaces with the current background color to the entire screen
        for (int row = 0; row < VGA_ROWS; row++) {
            for (int col = 0; col < VGA_COLS; col++) {
                int position = 2 * (row * VGA_COLS + col);
                vga[position] = ' ';        // Character to display - space
                vga[position + 1] = attribute;  // Attribute byte
            }
        }

        // Delay to observe the color change (implementation depends on your system)
        // You might need to implement a timer or a simple busy loop here
    }
    }
    return 0;
}

