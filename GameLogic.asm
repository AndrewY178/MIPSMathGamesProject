.data

.extern equations, 64
.extern answers, 64
.extern shuffledCards, 128

.extern selectedCard, 4
.globl startArray
.globl firstCardPrompt
.globl secondCardPrompt
numberPrompt:    .asciiz  "Choose a card 1-16 to flip: "
nextRow: .asciiz "\n" # new line for next row
.text


startArray:
	la $t0, equations
	li $t1, 0
	la $t2, answers
	li $s2, 0
	
loopRandInt:
	#loops through randInt while $t1 is less that 16
	blt $t1, 16, randInt
	#when $t1 is 16, reset the adress of $t0, the value of $t1, and jump to loopSolutions
	la $t0, equations
	li $t1, 0
	j loopSolutions
randInt:
	#generates random int
	li $a1, 8
	li $v0, 42
	syscall
	
	#changes the range from 0-8 to 1-9
	addi $a0, $a0, 1
	
	#puts random int into array
	sw $a0, 0($t0)
	addi $t0, $t0, 4
	addi $t1, $t1, 1
	j loopRandInt
	
loopSolutions:
	#loops through randInt while $t1 is less that 8
	blt $t1, 8, solutions
	#when $t1 is 8, reset the adress of $t0, the address of $t2, and exit 
	la $t0, equations
	la $t2, answers
	jal shufflePairs
	j firstGameLoop

solutions:
	#loads the current and next values of the array into $t4 and $t5
	lw $t4, 0($t0)
	lw $t5, 4($t0)
	
	#multiply those together and put them into $t3
	mul $t3, $t4, $t5
	#store that value into array at $t2
	sw $t3, 0($t2)
	li $t3, 0			#put a 0 marker to indicate that it is a answer 
	addi $t2, $t2, 4	#adjust array
	sw $t3, 0($t2)		#insert 0 to array
	
	#adjust the indexes for both arrays and the counter
	addi $t0, $t0, 8
	addi $t2, $t2, 4
	addi $t1, $t1, 1
	j loopSolutions
	
firstGameLoop:
	#print board
	jal start
	secondGameLoop:
	#request the first card from user
		firstCardPrompt:
			la $a0, numberPrompt
			li $v0, 4
			syscall
			li $v0, 5
			syscall
			
			#error where the first card disappears happens here
			sw $v0, selectedCard
			move $s3, $v0		#assign the first number that the user put as s3
			
			#check if the card is a valid choice	
			bge $v0, 17, firstCardPrompt
			ble $v0, 0, firstCardPrompt
			
			jal checkCardValue
			#store if it is a valid number
			jal processCardValue
    		move $s6, $v0
    		
			jal replaceValue
			
			jal start
	#request the second card from user
		secondCardPrompt:
			la $a0, numberPrompt
			li $v0, 4
			syscall
			li $v0, 5
			syscall
			
			#check if the card is a valid choice
			sw $v0, selectedCard
			move $s4, $v0	
			bge $v0, 17, secondCardPrompt
			ble $v0, 0, secondCardPrompt
			jal checkCardValue2
			#store if it is a valid number
			
			jal processCardValue
    		move $s7, $v0
    		
    		jal replaceValue
			jal start
			
			la $a0, nextRow
			li $v0, 4
			syscall
			syscall
			
		#checks if the values are equal
		comparingValues:
			beq $s6, $s7, handleMatch
			j resetQuestionMark
		handleMatch:
    		addi $s2, $s2, 1            # Increment match counter
    		jal checkGameStatus         # Check if the game should end
    		j secondGameLoop            # Continue to the next game loop

		resetQuestionMark:
			sw $s3, selectedCard
			jal returnToQuestionMark
			sw $s4, selectedCard
			jal returnToQuestionMark
			j firstGameLoop
		checkGameStatus:
    		li $t0, 8                  # Load the number of matches needed to end the game into $t0
    		beq $s2, $t0, endGame      # If $s2 equals 8, branch to endGame
    		jr $ra                     # Return to the calling function if the game is not over

		endGame:
    		# Insert logic to end the game
    		li $v0, 10                # Load the syscall code for program termination
    		syscall                   # End the program

			
processCardValue:
    # Load the selected card number and convert to 0-based index
    lw $, selectedCard
    subi $t8, $t8, 1        # Convert to 0-based index

    # Calculate offset in shuffledCards array (each card has two integers)
    mul $t9, $t8, 8         # Each card pair is 8 bytes (2 words)
    la $t0, shuffledCards   # Base address of shuffledCards
    add $t0, $t0, $t9       # Address of the first value of the pair

    # Load the two integers from the pair
    lw $t1, 0($t0)          # First value of the pair
    lw $t2, 4($t0)          # Second value of the pair
	
    # Determine if it’s an equation or an answer
    beqz $t2, isAnswer      # If second value is 0, it’s an answer
    # Process as equation: calculate product
    mul $v0, $t1, $t2       # $v0 = product
    
    jr $ra

isAnswer:
    move $v0, $t1           # For an answer, return the first value
    jr $ra

exit:
	li $v0, 10
	syscall
