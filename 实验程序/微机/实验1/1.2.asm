ORG 	0000H
LJMP 	MAIN
		ORG 	0100H
MAIN:	MOV 	R0, #30H
		MOV 	R7, #09H
LP1: 	MOV 	A, R7
		MOV 	R6, A
		MOV 	A, R0
		MOV 	R1, A
		INC 	R1
LP2:		MOV 	A, @R0	
		CLR 	C
		SUBB 	A, @R1
		JC 		LP3	
MOV 	A, @R0	
		XCH 	A, @R1
MOV 	@R0, A
LP3:		INC 	R1
DJNZ 	R6, LP2
		INC 	R0
		DJNZ 	R7, LP1
SJMP 	$
		END
