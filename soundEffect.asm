.data
.globl incorrectSound
.globl correctSound
.globl winnerSound
.text
incorrectSound:
    #E
    li $v0, 33
    li $a0, 64
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall
	
	#D
    li $v0, 33
    li $a0, 62
    li $a1, 500
    li $a2, 0
    li $a3, 100
    syscall
    
    #B
    li $v0, 33
    li $a0, 59
    li $a1, 500
    li $a2, 0
    li $a3, 100
    syscall

    jr $ra

correctSound:
	#C
	li $v0, 33
    li $a0, 60
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall
    
    #E
    li $v0, 33
    li $a0, 64
    li $a1, 400
    li $a2, 0
    li $a3, 100
    syscall
    
    #G
    li $v0, 33
    li $a0, 67
    li $a1, 400
    li $a2, 0
    li $a3, 100
    syscall
    
    jr $ra

winnerSound:
	#C
    li $v0, 33
    li $a0, 60
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall
	
	#E
    li $v0, 33
    li $a0, 64
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall

	#G
    li $v0, 33
    li $a0, 67
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall

	#C
    li $v0, 33
    li $a0, 72
    li $a1, 400
    li $a2, 0
    li $a3, 110
    syscall

	#G
    li $v0, 33
    li $a0, 67
    li $a1, 500
    li $a2, 0
    li $a3, 100
    syscall

    jr $ra

	
