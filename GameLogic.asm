.data

.extern equations, 64
.extern answers, 64
.extern shuffledCards, 128
.extern selectedCard, 4


.globl startArray
.globl firstCardPrompt
.globl secondCardPrompt
numberPrompt:	.asciiz  "Choose a card 1-16 to flip: "
nextRow:	.asciiz "\n" # new line for next row
matchFound:	.asciiz  "Match Found! "
matchNotFound:	.asciiz  "No Match, Try Again! "
winnerWinnerChickenDinner:	.asciiz  "CONGRATS! You won! "

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
	sw $t3, 0($t2)
	
	#puts a 0 in the next index to indicate that it
	li $t3, 0
	addi $t2, $t2, 4
	sw $t3, 0($t2)
	
	#adjust the indexes for both arrays and the counter
	addi $t0, $t0, 8
	addi $t2, $t2, 4
	addi $t1, $t1, 1
	j loopSolutions
	
firstGameLoop:
	jal start
	secondGameLoop:
		firstCardPrompt:
			la $a0, numberPrompt
			li $v0, 4
			syscall
			li $v0, 5
			syscall
			
			sw $v0, selectedCard
			move $s4, $v0
			
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
			move $s5, $v0	
			bge $v0, 17, secondCardPrompt
			ble $v0, 0, secondCardPrompt
			jal checkCardValue2
			
			#store if it is a valid number
			jal processCardValue
    		move $s7, $v0
    		jal replaceValue
			jal start
			
			#adds a 1 second delay when the second number is inputted and the board is displayed
            li $v0, 32
            li $a0, 1000
            syscall
			
			#prints a new line
			la $a0, nextRow
			li $v0, 4
			syscall
			
		comparingValues:
			beq $s6, $s7, handleMatch
			j resetQuestionMark
		handleMatch:
			#if a match is found, output the needed text
			la $a0, matchFound
    		li $v0, 4
    		syscall
    			
    		#prints a new line
    		la $a0, nextRow
			li $v0, 4
			syscall
    			
    		#increment match counter and check if the game should end
    		addi $s2, $s2, 1
    		jal checkGameStatus
    			
    		#play the sound for getting a match
    		jal correctSound
    			
    		#go to a new line
    		la $a0, nextRow
			li $v0, 4
			syscall
    		j firstGameLoop

		resetQuestionMark:
			#loading each of the user inputted values and jumping to returnToQuestionMark
			sw $s4, selectedCard	
			jal returnToQuestionMark
			sw $s5, selectedCard
			jal returnToQuestionMark
			
			#jumps to matchNotFound
			la $a0, matchNotFound
    		li $v0, 4
    		syscall
    			
    		la $a0, nextRow
			li $v0, 4
			syscall
			
			#outputs the sound for not geetting a match
			jal incorrectSound
			
			la $a0, nextRow
			li $v0, 4
			syscall
			
			j firstGameLoop
		checkGameStatus:
		#if the number of matches required to end the game has been reached, jump to endGame
    		li $t0, 8
    		beq $s2, $t0, endGame
    		jr $ra

endGame:
	la $a0, winnerWinnerChickenDinner
    li $v0, 4
    syscall
    jal winnerSound
    la $a0, nextRow
	li $v0, 4
	syscall
			
	#ends the game
    li $v0, 10
    syscall

			
processCardValue:
    #Load the selected card number and convert to 0-based index
    lw $, selectedCard

    #move the base address of the shuffledCards array
    mul $t9, $t8, 8
    la $t0, shuffledCards
    add $t0, $t0, $t9

    #Load the two integers from the pair
    lw $t1, 0($t0)
    lw $t2, 4($t0)
	
    #Determine if it’s an equation or an answer
    beqz $t2, isAnswer
    
    #Process as equation: calculate product
    mul $v0, $t1, $t2
    
    jr $ra

isAnswer:
    move $v0, $t1
    jr $ra


exit:
	li $v0, 10
	syscall