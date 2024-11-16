.data
equations: .space 64
answers: .space 32

.text

main:
	la $t0, equations
	li $t1, 0
	la $t2, answers
	
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
	j exit

solutions:
	#loads the current and next values of the array into $t4 and $t5
	lw $t4, 0($t0)
	lw $t5, 4($t0)
	
	#multiply those together and put them into $t3
	mul $t3, $t4, $t5
	#store that value into array at $t2
	sw $t3, 0($t2)
	
	#adjust the indexes for both arrays and the counter
	addi $t0, $t0, 8
	addi $t2, $t2, 4
	addi $t1, $t1, 1
	j loopSolutions
	
exit:
	li $v0, 10
	syscall
