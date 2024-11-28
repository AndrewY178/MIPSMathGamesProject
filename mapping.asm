.data
.extern equations 64
.extern answers 64
.extern shuffledCards 128
newline: .asciiz "\n"
.text
.globl printArray
printArray:
la $t0, equations  # Load base address of equations
    li $t1, 0          # Counter for array
    li $t2, 16         # Number of elements in the equations array

printEquations:
    bge $t1, $t2, printAnswers  # If all elements are printed, move to answers array
    lw $a0, 0($t0)  # Load current value
    li $v0, 1       # Syscall to print integer
    syscall

    # Print a space between numbers
    li $a0, 32      # ASCII for space
    li $v0, 11      # Syscall to print char
    syscall

    addi $t0, $t0, 4  # Move to the next element
    addi $t1, $t1, 1  # Increment counter
    j printEquations

printAnswers:
	la $a0, newline # Printing out the \n
    li $v0, 4
    syscall 
    # Print contents of answers array
    la $t0, answers  # Load base address of answers
    li $t1, 0        # Counter for array
    li $t2, 16        # Number of elements in the answers array

printAnswersLoop:
    bge $t1, $t2, exit  # If all elements are printed, exit
    lw $a0, 0($t0)  # Load current value
    li $v0, 1       # Syscall to print integer
    syscall

    # Print a space between numbers
    li $a0, 32      # ASCII for space
    li $v0, 11      # Syscall to print char
    syscall

    addi $t0, $t0, 4  # Move to the next element
    addi $t1, $t1, 1  # Increment counter
    j printAnswersLoop

exit:
	la $a0, newline # Printing out the \n
    li $v0, 4
    syscall 
    jr $ra