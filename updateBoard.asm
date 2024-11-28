.data
.extern equations, 64
.extern answers, 64
.extern shuffledCards, 128

.text
.globl shufflePairs
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
   	jal printArray
exitShuffleCards:
    # Exit the function
    jr $ra

