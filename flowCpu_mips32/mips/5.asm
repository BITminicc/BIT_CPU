#test simple add
ori $1, $0, 0x8000
sll $1, $1, 16
ori $1, $1, 0x0010

ori $2, $0, 0x8000
sll $2, $2, 16
ori $2, $2, 0x0001

ori $3, $0, 0x0000
addu $3, $2, $1
ori $3, $0, 0x0000
add $3, $2, $1

sub $3, $1, $3
subu $3, $3, $2

addi $3, $3, 2
ori $3, $0, 0x0000
addiu $3, $3, 0x8000