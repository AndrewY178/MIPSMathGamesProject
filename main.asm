.data

.globl equations
equations: .space 64
.globl answers
answers: .space 32
.globl selectedCard
selectedCard: .space 1

.text

main:
  jal startArray
  