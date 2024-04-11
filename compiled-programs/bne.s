    .section .text
    .globl  _start

_start:
    # Initialize registers
    addi x1, x0, 5     # x1 = 5
    addi x2, x0, 10    # x2 = 10

    # Perform an ADD operation
    add x3, x1, x2     # x3 = x1 + x2, should be 15

    # Use BNE
    addi x4, x0, 14    # x4 = 15, for comparison
    bne x3, x4, branch_taken # If x3 != x4, branch to branch_taken

    # If no branch, place a distinct operation
    addi x5, x0, 1     # This instruction is executed if branch is not taken

    # NOOPs
    nop
    nop
    nop
    nop

branch_taken:
    addi x5, x0, 2
