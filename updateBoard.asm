.data
.extern equations, 64
.extern answers, 64
.extern shuffledCards, 128
.globl shufflePairs

.text
shufflePairs: 
	la $t0, equations
    li $t1, 7
    
shuffleEquations:
	li $v0, 42
    syscall
    andi $t2, $a0, 7

    #calculate the addresses of the current pair and random pair
    mul $t3, $t1, 8
    add $t3, $t0, $t3

    mul $t4, $t2, 8
    add $t4, $t0, $t4

    #load current pair and random pair elements
    lw $t5, 0($t3)
    lw $t6, 4($t3)
    lw $t7, 0($t4)
    lw $t8, 4($t4)

    # Swap the pairs
    sw $t7, 0($t3)
    sw $t8, 4($t3)
    sw $t5, 0($t4)
    sw $t6, 4($t4)

    #decrease counter and continue the loop until t1 is less than 0
    sub $t1, $t1, 1
    bgez $t1, shuffleEquations
   	
reset:
	#assign the values and counters for each array
    la $t0, equations
    li $t1, 0
    la $t2, answers
    li $t3, 0
    la $t4, shuffledCards
    li $t5, 0

LoopForBig:
	#if the shuffledCards counter is greater than 16, it is shuffled
	bge $t5, 16, exitShuffleCards
	
	#assign t6 a random variable between 0 or 1
	li $v0, 42
    syscall
    andi $t6, $a0, 1
	
	#if t6 = 0, put equation in next slot of shuffledCards array
 	beqz $t6, pullEquation
 	#if t6 = 1, check if all answers have been pulled, if so, put equation
 	bgt $t3, 7, pullEquation
 	#put answer into next answer
    j pullAnswer
    
pullEquation:
	#if t1 is > 7, go to the big loop
	bgt $t1, 7, LoopForBig
	
	#calculate index
    mul $t7, $t1, 8
    add $t7, $t0, $t7
	
	#put equation into the shuffledCards array
    lw $t8, 0($t7)
    sw $t8, 0($t4)
    lw $t9, 4($t7)
    sw $t9, 4($t4)
	
	#adjust counters
    addi $t1, $t1, 1
    addi $t4, $t4, 8
    addi $t5, $t5, 1
    j LoopForBig
    
pullAnswer:
	#calculate index
    mul $t7, $t3, 8
    add $t7, $t2, $t7

    #put answers into the shuffledCards array
    lw $t8, 0($t7)
    sw $t8, 0($t4)
    lw $t9, 4($t7)
    sw $t9, 4($t4)

    #adjust counters
    addi $t3, $t3, 1
    addi $t4, $t4, 8
    addi $t5, $t5, 1
    j LoopForBig
	
exitShuffleCards:
    jr $ra
