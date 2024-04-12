    .section .text
    .globl  _start

_start:
    # Test ADD and ADDI
    addi x1, x0, 10       # x1 = 10
    addi x2, x0, 20       # x2 = 20
    add x3, x1, x2        # x3 = x1 + x2 = 30, test ADD

    # Test SLTI (Set if Less Than Immediate)
    slti x4, x1, 15       # x4 = 1 (10 < 15)
    slti x5, x2, 15       # x5 = 0 (20 not < 15)

    # Test SLTIU (Set if Less Than Immediate Unsigned)
    sltiu x6, x1, 25      # x6 = 1 (10 < 25 unsigned)
    sltiu x7, x2, 15      # x7 = 0 (20 not < 15 unsigned)

    # Test SLT (Set if Less Than)
    addi x8, x0, -5       # x8 = -5
    slt x9, x8, x1        # x9 = 1 (-5 < 10)
    slt x10, x1, x8       # x10 = 0 (10 not < -5)

    # Test SLTU (Set if Less Than Unsigned)
    sltu x11, x8, x1      # x11 = 0 (unsigned -5 not < 10)
    sltu x12, x1, x8      # x12 = 1 (unsigned 10 < -5)

    # Using multiple addi to approximate a large value, though not exact
    addi x13, x0, 2047    # x13 = 2047
    addi x13, x13, 2047   # x13 += 2047 (Incrementally adding up to a larger number)
    addi x13, x13, 2047   # x13 += 2047

    # Comparisons for approximate values
    slti x14, x13, 100    # x14 = 0 (approximated large value not < 100)
    sltiu x15, x13, 100   # x15 = 0 (approximated large value not < 100 unsigned)

    # Finalization and exit
    # Normally, here you would handle an exit. This depends on your environment.
    # Example for an infinite loop to halt the CPU:
    j _start             # Jump back to start - creates an infinite loop

