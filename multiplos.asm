.data
	number1: .word 
	number2: .word
	prompt: .asciiz "Enter a number: "
	espace: .asciiz "\n"
	
.text
	main:	
		# First, we have to do a call system to show prompt. Then, we get de user's numbers and save it.
		la $a0, prompt	# Load prompt's value to $a0.
		li $v0, 4	# syscall order 4 --> print string get the user's number
		syscall	
		lw $t1, number1	# Load in $t0 the memory address of variable number1
		li $v0, 5	# Syscall order 5 --> read integer
		syscall
		move $s1, $v0 	# Change the register.
		
		#Repite again to get the other number
		la $a0, prompt
		li $v0, 4
		syscall
		lw $t2, number2
		li $v0, 5
		syscall
		move $s2, $v0
		
		add $t0, $zero, 0	# number aux. Inicialize 0	
		bgtz, $s2, LOOP		# if (number2 > 0) go to LOOP
			li $v0, 10	# then Syscall to exit 
			syscall

		LOOP:
			bgeu $s2, $t0, MULT	# If (number2 >= aux) go to MULT
				li $v0, 10	# Then Syscall to exit
				syscall
		MULT:
			mult $t0, $s1	# Mult number1 * number_aux
			mflo $a0	# Move the multiply 's result to $a0
				li $v0, 1	# Print the result on screen
				syscall
				
				la $a0, espace	# Print one space on the screen
				li $v0, 4
				syscall
			addi $t0, $t0, 1	# ++number_aux
			j LOOP			# Go back to LOOP
			
			
			 
