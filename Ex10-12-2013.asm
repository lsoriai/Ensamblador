.data
	TorreOrigen: .asciiz "A"
	TorreExtra: .asciiz "B"
	TorreDestino: .asciiz "C"
	message: .asciiz "\nPor favor, introduzca el numero de discos: "
	negativo: .asciiz "\nEl número de discos no puede ser 0"
	mover_origen: .asciiz "\nMover del disco de la torre "
	mover_destino: .asciiz "\n a la torre "
	fin: .asciiz "\nEL PROGRAMA HA FINALIZADO"
.text
	main:
	# Imprimimo el mensaje y conseguimos el número de discos del juego
	la $a0, message
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a0, $v0	# $a0, tiene almacenado el número de discos
	beq $a0, 0, no
	la $a1, TorreOrigen
	la $a2, TorreExtra
	la $a3, TorreDestino
	jal HANOI
	la $a0, fin
	li $v0, 4
	syscall
	exit:
		li $v0, 10
		syscall
	
	HANOI:
		beq $a0, 0, final
		subu $sp, $sp, 32
		sw $ra, 0($sp)
		sw $fp, 4($sp)
		addiu $fp, $sp, 28
		sw $a0, 0($fp)		# Esta almacenado el valor del número de discos inicial
		sw $a1, -4($fp)		# Origen
		sw $a2, -8($fp)		# Extra
		sw $a3, -12($fp)	# Destino
		LOOP:
			subu $a0, $a0, 1
			bne $a0, 0, LOOP
			
		lw $t0, -4($fp)		# Origen
		lw $t2, -12($fp)	# Destino
		
			imprimir:
			la $a0, mover_origen
			li $v0, 4
			syscall
			move $a0, $t0
			li $v0, 4
			syscall
			la $a0, mover_destino
			li $v0, 4
			syscall
			move $a0, $t2
			li $v0, 4
			syscall
		
		lw $a0, 0($fp)
		subu $a0, $a0, 1
		lw $a1, -4($fp)
		lw $a2, -12($fp)
		lw $a3, -8($fp)
		jal HANOI
		b final
	no:
		la $a0, negativo
		li $v0, 4
		syscall
		b main

	final:
		lw $ra, 0($sp)
		lw $fp, 4($sp)
		addi $sp, $sp, 32
		jr $ra