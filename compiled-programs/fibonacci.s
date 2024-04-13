    .section .data
    .align 1
memory_space:
    .space 8   # Allocate 8 bytes of memory for 8 Fibonacci numbers

    .section .text
    .globl _start
_start:
    # Load the base address of the memory space into x4
    la x4, memory_space

    # Initial Fibonacci numbers
    li x5, 0     # Fibonacci(n-2)
    li x6, 1     # Fibonacci(n-1)
    
    # Store initial Fibonacci numbers in memory
    sb x5, 0(x4)  # Store 0 at the base address
    sb x6, 1(x4)  # Store 1 at base address + 1

    # Initial index for storing subsequent Fibonacci numbers, as an offset
    li x7, 2     # Start storing from the third position (offset 2 from the base)

loop:
    # Calculate next Fibonacci number
    add x8, x5, x6    # x8 = Fibonacci(n) = Fibonacci(n-2) + Fibonacci(n-1)

    # Calculate the address to store the next Fibonacci number
    add x10, x4, x7   # Add the offset x7 to base address x4, store in x10

    # Store the result in memory at the calculated address
    sb x8, 0(x10)  # Store Fibonacci(n) at the address stored in x10

    # Prepare for the next iteration
    mv x5, x6         # Move Fibonacci(n-1) to Fibonacci(n-2)
    mv x6, x8         # Move Fibonacci(n) to Fibonacci(n-1)
    
    # Increment the offset for the next number
    addi x7, x7, 1    # Increment the offset for the next storage location

    # Check if we are done
    li x9, 8          # Total numbers to generate
    blt x7, x9, loop  # Continue the loop if we have more numbers to generate

end:
    # Here you might want to halt the processor or loop indefinitely
    j end             # Infinite loop to prevent further execution

