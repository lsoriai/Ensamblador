.data
	number1: .word # We have to save one number who range is 0-2^32 
	number2: .word
	prompt: .asciiz "Enter a number: "
	message: .asciiz "The highest number is: "
		
.text
	main:
		# First, we have to do a call system to show prompt. Then, we get de user's numbers and save it.
		la $a0, prompt	# Load prompt's value to $a0.
		li $v0, 4	# syscall order 4 --> print string get the user's number
		syscall	
		lw $t1, number1	# Load in $t0 the memory address of variable number1
		li $v0, 5	# Syscall order 5 --> read integer
		syscall
		move $t1, $v0 	# Change the register.
		
		#Repite again to get the other number
		la $a0, prompt
		li $v0, 4
		syscall
		lw $t2, number2
		li $v0, 5
		syscall
		move $t2, $v0
		
		#Show the message by then the program calculates the highest number bewteen number1 and number2
		la $a0, message
		li $v0, 4
		syscall
	
		# Calculate the highest number
		bgt $t1, $t2, IsHighest	#This command compares t1 y t2. If t1 is highest than t2 call function IsHighest
		move $a0, $t2
		li $v0, 1
		syscall
		li $v0, 10	# Syscall to exit 
		syscall
	
	IsHighest:
		move $a0, $t1
		li $v0, 1
		syscall
		li $v0, 10
		syscall
