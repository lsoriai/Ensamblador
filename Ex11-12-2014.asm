.data
	message: .asciiz "\Escribe un número por favor: "
	
.text
	# Le pedimos al usuario que introduzca el primer número
	la $a0, message
	li $v0, 4
	syscall
	li $v0, 5
	syscall		# El valor se almacena en $v0
	
	# Llamamos a la funcion creat(valor, anterior)
	move $a0, $v0
	move $a1, $zero
	jal node_t_creat
	# Ya tenemos el primer nodo, ese es la cima, por lo que:
	add $s0, $v0, $zero	# $s0, indica la cima
	
	LOOP:
		# Leemos el número de pantalla
		la $a0, message
		li $v0, 4
		syscall
		li $v0, 5
		syscall		# El valor se almacena en $v0
		beq $v0, 0, fin
		move $a0, $s0	# Cima de la pila (ANTERIOR)
		move $a1, $v0	# Número entrante
		jal node_t_push
		add $s0, $v0, $zero	# $s0, indica la cima
		b LOOP		
	
		
	fin:
		# Imprimir de forma recursiva
		move $a0, $s0
		jal node_print
		
	exit:
		li $v0, 10
		syscall
		
	node_t_creat:
		move $t0, $a0	# valor
		move $t1, $a1	# Anterior
		# Pedimos memoria al sistema
		la $a0, 8
		li $v0, 9
		syscall
		sw $t0, 0($v0)
		sw $t1, 4($v0)
		# Retornamos el valor
		jr $ra
		
	node_t_push:
		subu $sp, $sp, 32
		sw $ra, 0($sp)
		sw $fp, 4($sp)
		addiu $fp, $sp, 28
		move $t0, $a0	# ANTERIOR
		move $t1, $a1	# VALOR
		move $a0, $t1
		move $a1, $t0
		jal node_t_creat
		# Devolvemos la dirección del nuevo nodo insertado
		lw $ra, 0($sp)
		lw $fp, 4($sp)
		addi $sp, $sp, 32
		jr $ra
		
	node_print:
		lw $t1, 0($s0)	# VALOR
		lw $t2, 4($s0)	# SIGUIENTE
		# Imprimimos el valor de la cima en este momento
		move $a0, $t1
		li $v0, 1
		syscall
		beq $t2, 0, exit
		add $s0, $t2, $zero
		b node_print
		
		
