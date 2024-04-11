    .section .text
    .globl  _start

_start:
    # Initialize registers with positive and negative values
    addi x1, x0, 7        # x1 = 7
    addi x2, x0, -3       # x2 = -3 (in two's complement)

    # First test: x1 is greater than x2, should not branch
    blt x1, x2, branch_taken

    # Instruction to identify if the branch was not taken
    addi x3, x0, 1        # x3 = 1

    j end_test

branch_taken:
    # Instruction to identify if the branch was taken
    addi x3, x0, 2        # x3 = 2

end_test:
    # Rest of your program or exit
    nop
    nop
    nop
    nop
    nop
