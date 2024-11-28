.data

.globl equations
equations: .space 64
.globl answers
answers: .space 64
.globl selectedCard
selectedCard: .space 1
.globl shuffledCards
shuffledCards: .space 128  # Array to hold the shuffled cards (32 cards * 4 bytes each)

.text
main:
  jal startArray