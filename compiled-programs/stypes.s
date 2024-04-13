    .section .data
memory_space:
    .space 20   # Allocate 20 bytes of memory for testing

    .section .text
    .globl _start
_start:
    # Load the base address of the memory space
    la x6, memory_space  # Load address of memory_space into x6

    # Initialize registers with test data
    li x1, 0x12345678  # Arbitrary test value for a word
    li x2, 0x89AB      # Arbitrary test value for a halfword
    li x3, 0xCD        # Arbitrary test value for a byte

    # Store word at address 0
    sw x1, 0(x0)  # Store the entire word from x1 at the start of memory_space

    # Store halfword at address 8 (avoid overlap with the word)
    sh x2, 4(x0)  # Store the lower halfword from x2 at offset 8

    # Store byte at address 12 (avoid overlap with the halfword)
    sb x3, 6(x0)  # Store the lower byte from x3 at offset 12

    lw x20, 0(x0)  # Load the word stored
    lh x21, 4(x0)  # Load the halfword stored
    lb x22, 6(x0)  # Load the byte stored
end:
    # Here you might want to halt the processor or loop indefinitely jump and link using register 0
    j end

