.data

# DISPLAY BOARD (each cell is 3 bytes:  ? )
board:  .byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '
	.byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '
	.byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '
	.byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '

size:   .word 4 # Specify dimension of the grid for further traversal
nextRow: .asciiz "\n" # new line for next row 

.text
.globl main
main:
    la $a0, board # Load board for printing
    lw $a1, size # Load the size for printing

    li $t1, 0 # Row counter
    j rowLoop # enter the outer loop

# Outer loop (row loop)
rowLoop:
    bge $t1, $a1, exit # If all rows are printed, exit the program
    # Inner loop (column loop)
    li $t2, 0 # Column counter
colLoop:
    bge $t2, $a1, nextRowInLoop # If all columns in the row are printed, go to the next row

    # Print left border (~)
    li $a0, 126 # ASCII for ~
    li $v0, 11
    syscall

    mul $t3, $t1, 12 # row * 12 (for row offest)
    mul $t4, $t2, 3  # column * 3 (for column offset)
    add $t3, $t3, $t4 # offset of both row and column combined

    # Print the first character of the cell
    lb $t5, board($t3) # needed to print out ? 
    move $a0, $t5 
    li $v0, 11
    syscall

    # Print the second character of the cell
    addi $t3, $t3, 1 # needed to print out ? 
    lb $t5, board($t3)
    move $a0, $t5
    li $v0, 11
    syscall

    # Print the third character of the cell
    addi $t3 $t3, 1 # needed to print out ? 
    lb $t5, board($t3)
    move $a0, $t5
    li $v0, 11
    syscall

    # Print right border for the cell (~)
    li $a0, 126 # ASCII for ~
    li $v0, 11
    syscall
    
    # Prints a space between cells
    li $a0, 32 # ASCII for space
    li $v0, 11
    syscall

    addi $t2, $t2, 1 # Increment column counter
    j colLoop # Go back to print the next column

# Once a full row is printed, proceed to the next row
nextRowInLoop:
    la $a0, nextRow # Printing out the \n
    li $v0, 4
    syscall 
    
    addi $t1, $t1, 1  # Increment row counter
    j rowLoop # Go back to print the next row

exit:
    li $v0, 10 # Exit the program
    syscall
