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
.extern shuffledCards, 128
.extern selectedCard, 4
.globl start
.globl replaceValue
.globl checkCardValue
.globl checkCardValue2
.globl returnToQuestionMark

.text
#checks if the card value is valid and jumps back to prompt if not
checkCardValue:
	lw $t8, selectedCard   # Load selected card number (1�16)
    subi $t8, $t8, 1       # Convert to 0-based index (0�15)
    
    lw $t7, shuffledCards

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
	lw $t8, selectedCard   # Load selected card number
    subi $t8, $t8, 1       # Convert to 0-based index

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
    lw $t8, selectedCard   # Load selected card number (1�16)
    subi $t8, $t8, 1       # Convert to 0-based index (0�15)

    # Calculate row and column
    li $t9, 4              # Number of columns
    div $t0, $t8, $t9      # $t0 = row number
    mflo $t0
    rem $t1, $t8, $t9      # $t1 = column number

    # Calculate offset in the board array
    mul $t0, $t0, 12       # row_offset = row * 12
    mul $t1, $t1, 3        # col_offset = col * 3
    add $t3, $t0, $t1      # index = row_offset + col_offset

	#gets the correct index for the array
    mul $t8, $t8, 2
    sll $t8, $t8, 2 
    
    #loads shuffledCards into $t7
    la $t7, shuffledCards
    
    #sets the base adress of $t7 to the current index     
    add $t7, $t7, $t8
    
    #gets the next value in the array to determine weather the current index is an equation or solution
    lw $t6, 4($t7)         
    bne $t6, 0, equationOutput
    
    #if it is a solution, checks to see if it is 2 digits long
    lw $t6, 0($t7)
    div $t6, $t6, 10
    mflo $t6
    mfhi $s1
    
    #if it is 2 digits long, branch to solutionOutput
    bne $t6, 0, solutionOutput
    
    #if this point is reached, the value is a solution with 1 digit.
    lw $s1, 0($t7)
    
    #outputs the value to the board
    addi $t3, $t3, 1
    addi $s1, $s1, '0'
    sb $s1, board($t3)
    subi $t3, $t3, 1

    jr $ra
    
solutionOutput:
	#splits and converts the values to ascii character so it can be put onto the board
	addi $s0, $t6, '0'
	addi $s1, $s1, '0'
	
	#puts everything onto the board
	sb $s0, board($t3)
	addi $t3, $t3, 1
	sb $s1, board($t3)
	subi $t3, $t3, 1
	jr $ra
	

equationOutput:
    # Load the values shuffledArray
    lw $s0, 0($t7)
    lw $s1, 4($t7)

    # Convert to ASCII
    addi $s0, $s0, '0'
    addi $s1, $s1, '0'     

    # Load 'x' into $s3
    li $s3, 'x'
	
	#puts everything onto the board
    sb $s0, board($t3)     

    addi $t3, $t3, 1       
    sb $s3, board($t3)     

    addi $t3, $t3, 1       
    sb $s1, board($t3)     
    subi $t3, $t3, 2

    jr $ra
	
returnToQuestionMark:
	lw $t8, selectedCard   # Load selected card number (1�16)
    subi $t8, $t8, 1       # Convert to 0-based index (0�15)

    # Calculate row and column
    li $t9, 4              # Number of columns
    div $t0, $t8, $t9      # $t0 = row number
    mflo $t0
    rem $t1, $t8, $t9      # $t1 = column number

    # Calculate offset in the board array
    mul $t0, $t0, 12       # row_offset = row * 12
    mul $t1, $t1, 3        # col_offset = col * 3
    add $t3, $t0, $t1      # index = row_offset + col_offset

    # Replace the mismatched card value with a '?'
    li $t4, '?'
    addi $t3, $t3, 1
    sb $t4, board($t3)
    li $t4, ' '
    addi $t3, $t3, 1
    sb $t4, board($t3)
    subi $t3, $t3, 2
    sb $t4, board($t3)

    jr $ra
start:
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
	
	# Prints a space between cells
    #li $a0, 32 # ASCII for space
    #li $v0, 11
    #syscall
    
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
    
    # Prints a space between cells
    #li $a0, 32 # ASCII for space
    #li $v0, 11
    #syscall

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
