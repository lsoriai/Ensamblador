.data
	message: .asciiz "\nIntroduzca un número por favor: "
	minimo: .asciiz "\nEl número mínimo de números es 3"
	final: .asciiz "\nEL PROGRAMA HA TERMINADO"
	tab: .asciiz "\n"
.text
	main:
		# Imprimimos el mensaje
		la $a0, message
		li $v0, 4
		syscall
		
		# Obtenemos el mensaje 
		li $v0, 5
		syscall
		
		# Introducimos el número en un nuevo nodo. Llamamos a la subrutina node_t_creat
		move $t0, $v0	# Valor del nodo
		
		# Hacemos una llamada al sistema para conseguir memoria
		la $a0, 8
		li $v0, 9
		syscall
		
		# Preparamos los argumentos
		move $a0, $t0
		move $a1, $v0
		jal node_t_creat
		add $s0, $v0, $zero	# Apunta a la cima
		add $s1, $v0, $zero	# Apunta a la base
		
		# Contador para saber cuantos nodos hay. Mínimo + de 3
		addi $t7, $zero, 1
		
		LOOP:
			# Imprimimos el mensaje
			la $a0, message
			li $v0, 4
			syscall
			# Obtenemos el numero 
			li $v0, 5
			syscall
			
			beq $v0, 0, comprobar
			addi $t7, $t7, 1
			# Preparamos los argumentos para llamar a la 'funcion'
			move $a0, $s0		# Anterior
			move $a1, $v0
			jal node_t_insert
			add $s0, $v0, $zero
			b LOOP	
		
	exit:
		li $v0, 10
		syscall

	comprobar:
		bge $t7, 3, print_node
		# Imprimimos el mensaje de que no puede introducir menos de 3 numeros
		la $a0, minimo
		li $v0, 4
		syscall
		b LOOP
		
	fin:
		la $a0, final
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall
		
	node_t_creat:
		move $t0, $a0	# VALOR
		move $t1, $a1	# SIGUIENTE
		
		# Hacemos una llamada al sistema para almacenar los datos en un mismo nodo
		la $a0, 8
		li $v0, 9
		syscall
		
		# Ponemos al NULL
		sw $zero, 0($v0)
		
		# Guardamos los datos en memoria
		sw $t0, 0($t1)
		sw $v0, 4($t1)
		move $v0, $t1
		# Devolvemos el nodo
		jr $ra
		
	node_t_insert:
		move $t6, $a0	# Anterior
		move $t1, $a1	# Valor
		
		# Como vamos a llamar a otra subrutina, creamos un marco de pila
		subu $sp, $sp, 32
		sw $ra, 0($sp)
		sw $fp, 4($sp)
		addiu $fp, $sp, 28
		
		# Hacemos una llamada al sistema para almacenar los datos en un mismo nodo
		la $a0, 8
		li $v0, 9
		syscall
		
		# Llamamos a la funcion creat pasandole $a1 y $a0
		move $a0, $t1	# Valor
		move $a1, $v0	# Siguiente
		jal node_t_creat
		
		# Insertamos el nodo en los anteroriores
		sw $v0, 4($t6)
		lw $ra, 0($sp)
		lw $fp, 4($fp)
		addiu $sp, $sp, 32
		jr $ra
		
	print_node:
		# Imprime desde el principio --> desde $s1
		lw $t0, 0($s1)
		beq $t0, 0, fin
		move $a0, $t0
		li $v0, 1
		syscall
		la $a0, tab
		li $v0, 4
		syscall
		lw $s1, 4($s1)
		b print_node