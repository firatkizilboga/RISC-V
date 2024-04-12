    .section .text
    .globl  _start

_start:
    # Test LUI
    lui x1, 0x12345      # Load upper immediate into x1
    addi x1, x1, 567     # Add a lower immediate to validate the correct value

    # Test AUIPC
    auipc x2, 0x12345    # x2 = PC + (0x12345 << 12)
    addi x2, x2, 567     # Adjust x2 to validate

    # Validation of LUI using simple comparisons
    # Assuming x3 is a temporary register for storing test result
    addi x3, x0, 0        # x3 = 0 (will use to store results of check)

    # Check x1 for a specific value, for example:
    lui x4, 0x12345
    addi x4, x4, 567
    beq x1, x4, check_x1_correct
    addi x3, x3, 1        # If not equal, set x3 to 1
check_x1_correct:

    # AUIPC check needs to consider the PC at the auipc instruction
    # We calculate expected value directly in assembly by simulating AUIPC:
    la x5, auipc_target  # Load address of label into x5
    beq x2, x5, check_x2_correct
    addi x3, x3, 2        # If not equal, set x3 to 2
check_x2_correct:

    # Final action based on x3 value
    # If x3 is 0, both tests passed

_end:
    # Infinite loop to prevent further execution
    j _end

auipc_target:
    # This label is used to calculate expected PC value for AUIPC

