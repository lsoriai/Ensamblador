.data
	UserInput1: .space 1024	# Como máximo van a meter 1024 caracteres
	UserInput2: .space 1024	# Como máximo van a meter 1024 caracteres
	message: .asciiz "\nPor favor, introduzca una cadena de caracteres: "
	
.text
	la $a0, UserInput1
	la $a1, 1024
	jal read_string
	move $t6, $v0		# Guardamos el primer string --> UserInput1
	la $a0, UserInput2
	la $a1, 1024
	jal read_string		# Llamamos otra vez a la subrutina
	move $t7, $v0		# Guardamos el segundo string --> UserInput2
	# Preparamos las dos cadenas para pasarselo a la funcion copiar
	move $a0, $t6
	move $a1, $t7
	jal strcpy
	b exit
	
	exit:
		li $v0, 10
		syscall
	

	read_string:
		move $t0, $a0	# Cadena de caracteres
		move $t1, $a1	# Tamaño máximo permitido
		# Imprimimos message
		la $a0, message
		li $v0, 4
		syscall
		# Recogemos el mensaje, como máximo 1024 caracteres
		move $a0, $t0
		move $a1, $t1
		li $v0, 8
		syscall
		move $v0, $a0
		jr $ra
		
	strcpy:
		subu $sp, $sp, 32
		sw $ra, 0($sp)
		sw $fp, 4($sp)
		addiu $fp, $sp, 28
		move $t4, $a0	# Primera lista
		move $t3, $a1	# Segunda lista
		
		# Llamamos a la función strlen para que nos cuente el numero de caracteres de la cadena $a0
		move $a0, $t3		# Palabra que queremos copiar
		jal strlen
		COPY:
			move $t1, $t3
			move $t2, $t4
			lb $t5, 0($t3)	# Se copia lo que estamos leyendo
			sb $t5, 0($t4)	# Se copia aquí
			subu $v0, $v0, 1
			addi $t3, $t3, 1
			addi $t4, $t4, 1
			bne $v0, 0, COPY
		move $v0, $t2
		lw $ra, 0($sp)
		lw $fp, 4($sp)
		addi $sp, $sp, 32
		jr $ra
	strlen:
		# Nos declaramos un contador
		add $t1, $zero, $zero
		add $t0, $a0, $zero
		LOOP:
			lb $t2, 0($t0)
			addi $t0, $t0, 1
			addi, $t1, $t1, 1
			bne $t2, 10, LOOP
		# Imprimirmos el numero de caracteres
		move $v0, $t1
		jr $ra
		
