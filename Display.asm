.data

# DISPLAY BOARD (each cell is 3 bytes:  ? )
board:
	 .byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '
	 .byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '
	 .byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '
	 .byte ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' ', ' ', '?', ' '

size:   .word 4 # Specify dimension of the grid for further traversal
nextRow: .asciiz "\n" # new line for next row

.extern equations, 64
.extern answers, 32
.extern selectedCard, 1
.globl start
.globl replaceValue
.globl checkCardValue
.globl checkCardValue2
.text

#checks if the card value is valid and jumps back to prompt if not
checkCardValue:
	lw $t8, selectedCard   # Load selected card number (1ñ16)
    subi $t8, $t8, 1       # Convert to 0-based index (0ñ15)

    # Calculate row and column
    li $t9, 4              # Number of columns
    div $t0, $t8, $t9      # $t0 = row number
    mflo $t0
    rem $t1, $t8, $t9      # $t1 = column number

    # Calculate offset in the board array
    mul $t0, $t0, 12       # row_offset = row * 12
    mul $t1, $t1, 3        # col_offset = col * 3
    add $t3, $t0, $t1      # index = row_offset + col_offset

    # Compares the selected card with '?' to see if it is a valid value
    li $t2, '?'
    addi $t3, $t3, 1
    lb $t4, board($t3)
    
    bne $t2, $t4, firstCardPrompt
    jr $ra
    
#checks if the card value is valid and jumps back to prompt if not
checkCardValue2:
	lw $t8, selectedCard   # Load selected card number (1ñ16)
    subi $t8, $t8, 1       # Convert to 0-based index (0ñ15)

    # Calculate row and column
    li $t9, 4              # Number of columns
    div $t0, $t8, $t9      # $t0 = row number
    mflo $t0
    rem $t1, $t8, $t9      # $t1 = column number

    # Calculate offset in the board array
    mul $t0, $t0, 12       # row_offset = row * 12
    mul $t1, $t1, 3        # col_offset = col * 3
    add $t3, $t0, $t1      # index = row_offset + col_offset

    # Compares the selected card with '?' to see if it is a valid value
    li $t2, '?'
    addi $t3, $t3, 1
    lb $t4, board($t3)
    
    bne $t2, $t4, secondCardPrompt
    jr $ra

replaceValue:
    lw $t8, selectedCard   # Load selected card number (1ñ16)
    subi $t8, $t8, 1       # Convert to 0-based index (0ñ15)

    # Calculate row and column
    li $t9, 4              # Number of columns
    div $t0, $t8, $t9      # $t0 = row number
    mflo $t0
    rem $t1, $t8, $t9      # $t1 = column number

    # Calculate offset in the board array
    mul $t0, $t0, 12       # row_offset = row * 12
    mul $t1, $t1, 3        # col_offset = col * 3
    add $t3, $t0, $t1      # index = row_offset + col_offset

    # Replace the '?' with a card value (for now, hardcoded '3')
    li $t4, '3'
    addi $t3, $t3, 1
    sb $t4, board($t3)
    subi $t3, $t3, 1

    jr $ra

start:
    la $a0, board # Load board for printing
    lw $a1, size # Load the size for printing
    
    #loads adresses of the equations array and answer array into $t6 and $t7
    la $t6, equations
    la $t7, answers
  

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
    jr $ra
    li $v0, 10 # Exit the program
    syscall