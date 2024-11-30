.data

.globl equations
equations: .space 64
.globl answers
answers: .space 64
.globl shuffledCards
shuffledCards: .space 128 
.globl selectedCard
selectedCard: .space 4

.text
main:
  jal startArray
