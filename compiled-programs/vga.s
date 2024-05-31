_start:
    li t0, 0xFA0     # Load base address of VGA buffer into t0
    li t1, ' '       # Load ASCII code for space character into t1
    li t2, 0xFF      # Set an upper limit for the loop counter

loop:
    sw t1, 0(t0)     # Write the space character into memory at address in t0
    addi t0, t0, 4   # Increment the address by 4 (assuming each entry is 4 bytes)
    addi t2, t2, -1   # Decrement the loop counter
    bnez t2, loop    # If counter is not zero, loop back

    # Once the counter is zero, reset the address and counter and loop again
    li t0, 0xFA0     # Reset address to start of VGA buffer
    li t2, 0xFF      # Reset the loop counter
    j loop           # Jump back to the start of the loop


