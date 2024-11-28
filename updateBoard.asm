.data
.extern equations, 64
.extern answers, 64
.extern shuffledCards, 128
.globl shufflePairs

.text
shufflePairs: 
	la $t0, equations     # Load address of equations array
    li $t1, 7
    
shuffleEquations:
	li $v0, 42                 # Syscall for random number
    syscall
    andi $t2, $a0, 7          # Random index (0 to $t1)

    # Calculate the addresses of the current pair and random pair
    mul $t3, $t1, 8            # Multiply the current pair index by 8 (2 words per pair)
    add $t3, $t0, $t3          # Address of the current pair

    mul $t4, $t2, 8            # Multiply random index by 8 (2 words per pair)
    add $t4, $t0, $t4          # Address of the random pair

    # Load current pair and random pair
    lw $t5, 0($t3)		# Load first element of current pair into $t5
    lw $t6, 4($t3)		# Load second element of current pair into $t6
    lw $t7, 0($t4)		# Load first element of random pair into $t7
    lw $t8, 4($t4)		# Load second element of random pair into $t8

    # Swap the pairs
    sw $t7, 0($t3)			# Store the first element of the random pair at current position
    sw $t8, 4($t3)			# Store the second element of the random pair at current position
    sw $t5, 0($t4)			# Store the first element of the current pair at random position
    sw $t6, 4($t4)			# Store the second element of the current pair at random position

    # Decrease counter and continue the loop if $t1 >= 0
    sub $t1, $t1, 1				# Decrease counter
    bgez $t1, shuffleEquations	# Loop until counter reaches 0
   	
reset:
    la $t0, equations           # Base address of equations array
    li $t1, 0                   # Counter for equations (pairs pulled)
    la $t2, answers             # Base address of answers array
    li $t3, 0                   # Counter for answers (pairs pulled)
    la $t4, shuffledCards       # Base address of shuffledCards array
    li $t5, 0                   # Counter for shuffledCards (pairs written)

LoopForBig:
	bge $t5, 16, exitShuffleCards
	
	li $v0, 42                  # Syscall for random number
    syscall
    andi $t6, $a0, 1            # Mask to get random number (0 or 1)

 	beqz $t6, pullEquation
 	
 	bgt $t3, 7, pullEquation  # Skip if answers are exhausted
 	
    j pullAnswer
    
pullEquation:
	bgt $t1, 7, LoopForBig
	# Calculate the address of the current equation pair (t1 * 8)
    mul $t7, $t1, 8             # t7 = t1 * 8 (2 words per pair, 4 bytes per word)
    add $t7, $t0, $t7           # Address of the current equation pair

    lw $t8, 0($t7)              # Load first word of equation pair
    sw $t8, 0($t4)              # Store first word in shuffledCards
    lw $t9, 4($t7)              # Load second word of equation pair
    sw $t9, 4($t4)              # Store second word in shuffledCards

    # Increment counters
    addi $t1, $t1, 1            # Increment equations counter
    addi $t4, $t4, 8            # Move to next pair slot in shuffledCards
    addi $t5, $t5, 1            # Increment shuffledCards counter (pair added)
    j LoopForBig              # Continue loop
    
pullAnswer:
	# Calculate the address of the current answer pair (t3 * 8)
    mul $t7, $t3, 8             # t7 = t3 * 8 (2 words per pair, 4 bytes per word)
    add $t7, $t2, $t7           # Address of the current answer pair

    # Load the pair and store in shuffledCards
    lw $t8, 0($t7)              # Load first word of answer pair
    sw $t8, 0($t4)              # Store first word in shuffledCards
    lw $t9, 4($t7)              # Load second word of answer pair
    sw $t9, 4($t4)              # Store second word in shuffledCards

    # Increment counters
    addi $t3, $t3, 1            # Increment answers counter
    addi $t4, $t4, 8            # Move to next pair slot in shuffledCards
    addi $t5, $t5, 1            # Increment shuffledCards counter (pair added)
    j LoopForBig              # Continue loop
	
exitShuffleCards:
    # Exit the function
    jr $ra

