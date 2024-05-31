    .section .text
    .globl main

main:
    # Allocate stack space
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      s0, 8(sp)
    addi    s0, sp, 16

    # Initialize pointers
    li      t0, 0x00000000      # t0 holds the address of a
    li      t1, 0x0000000A      # t1 holds the address of b
    li      t2, 0x00000010      # t2 holds the address of c

    # *a = 12;
    li      t3, 12              # t3 = 12
    sh      t3, 0(t0)           # Store 12 at address t0 (a)

    # *b = 24;
    li      t3, 24              # t3 = 24
    sh      t3, 0(t1)           # Store 24 at address t1 (b)

    # *c = 0;
    li      t3, 0               # t3 = 0
    sh      t3, 0(t2)           # Store 0 at address t2 (c)

    # *c = *a + *b;
    lh      t4, 0(t0)           # Load half-word from address t0 (a) into t4
    lh      t5, 0(t1)           # Load half-word from address t1 (b) into t5
    add     t6, t4, t5          # t6 = t4 + t5 (result of *a + *b)
    sh      t6, 0(t2)           # Store the result at address t2 (c)

    # Return 0;
    li      a0, 0               # Return value 0 in a0

    # Restore stack and return
    lw      ra, 12(sp)
    lw      s0, 8(sp)
    addi    sp, sp, 16

end:
    j end
