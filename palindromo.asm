.data
	Prompt: .asciiz "Write the sentence: "
	UserInput: .space 1024
	Palindromo: .asciiz "Es palindromo"
	NoPalindromo: .asciiz "No es palindromo"
	
.text
	# Print message on the screen
	la $a0, Prompt
	li $v0, 4 
	syscall
	
	# Read string (palimdromo)
	la $a0, UserInput
	la $a1, 1024
	li $v0, 8
	syscall
	
	# Look \n
	la $t2, UserInput		# Absolute Value
	la $t1, UserInput		# Absolute Value
	LOOP:
		addi $t2, $t2, 1	# Aumentamos la direcion de memoria del punteo t2
		lb $t3, 0($t2)		# Analizamos el contenido d ela direcion de memoria de t2
		beq $t3, 10, END	# Comparamos para saber si es un fin de linea. Si lo es, saltamos a END
		b LOOP			# Si no es salto de linea ejecutamos de nuevo las 3 sentencias anteriores
	END:
		addi $t2, $t2, -1	# Como se ha encontrado \n en la direccion de memoria t2 accedemos a la anterior
		lb $t3, 0($t2)		# Obtenemos el contenido de la direccion de memoria que esta almacenada en t2
		b COMPARE		# Saltamos a COMPARE
				
	COMPARE:
		lb $t3, 0($t1)		# Obtenemos el contenido almacenado en la direccion de memoria de t1
		lb $t4, 0($t2)		# Obtenemos el contenido almacenado en la direccion de memoria de t2
		beq $t3, $t4, REPITE	# Si ambos contenidos son iguales, saltamos a REPITE 
		la $a0, NoPalindromo	# Si el resultado no es el mismo es que ya no es palindromo y se imprime
		li $v0, 4
		syscall
		li $v0, 10
		syscall
	REPITE:
		addi $t1, $t1, 1	# Aumentamos la direccion de memoria de t1
		addi $t2, $t2, -1	# Disminuimos la direccion de memoria de t2
		bgt $t2, $t1, EXIT	# Si la direccion de memoria de t2 es menor que t1 salimos e imprimios que es palindromo
		b COMPARE		# Si la direccion de memoria de t2 es menor que t1 saltamos a COMPARE 
	EXIT:
		la $a0, Palindromo
		li $v0, 4
		syscall
		li $v0, 10
		syscall

	
	
	
