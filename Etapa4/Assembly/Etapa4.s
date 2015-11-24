		KEY: .ASCIZ "OCEUAZUL"
		CIPHERTEXT: .ASCIZ "         "
		CLEARTEXT: .ASCIZ "         "
		DECRYPTED: .ASCIZ "         "
		WARN1: .ASCIZ "INITIAL MESSAGE GIVEN AS INPUT, BEFORE PROCESSING: \n"
		WARN2: .ASCIZ "PROCESSED MESSAGE, AFTER ENCRYPTION AND DECRYPTION: \n"
		.align

@=====================================SPOILER SECTION=====================================
		@CLEARTEXT WILL BE TESTED WITH MONTREAL, THAT IS THE INITIAL MESSAGE TYPED
		@THE EXPECTED CLEARTEXT CONTENT IS 4D 4F 4E 54 52 45 41 4C (8 HEX CHARACTERS)
		@THE KEY IS "OCEUAZUL"
		@THE EXPECTED CIPHERTEXT CONTENT IS 02 0C 0B 01 13 1F 14 00 (8 HEX CHARACTERS)
		@THE EXPECTED DECRYPTED CONTENT IS 4D 4F 4E 54 52 45 41 4C (SAME AS CLEARTEXT)
@=====================================END OF SPOILER=====================================		
		


@=====================================ASCII CONVERTING SECTION=====================================

@THE GENERIC CONVERTER (FINITE CHARACTER SEQUENCE)


@PRINTS THE CORRESPONDING INPUT DECIMAL ON THE GREEN SCREEN,
@AND STORE ITS VALUE AS A DECIMAL ON MEMORY


   	 @VALUES SET
	 
   	 MOV R8, #0   		 	@HOLDS LAST X POSITION TO DISPLAY ON SCREEN (MAX = 39, WITH 3 BY 3 INCREASE)
   	 MOV R9, #0   		 	@HOLDS LAST Y POSITION TO DISPLAY ON SCREEN    (MAX = 14)
   	 MOV R7, #0x41   	 	@HOLDS THE FIRST CHARACTER TO BE CONVERTED (A EQUALS 0x41)
   	 MOV R6, #1   		 	@CONSTANT FOR COMPARISON
   	 MOV R3, #0x21   		@HOLDS THE OFFSET TO THE REACH THE SPACE CHARACTER
   	 MOV R4, #0x10   		@HOLDS THE OFFSET TO THE REACH THE Q CHARACTER
	 MOV R10, #8		 	@SETS THE NUMBER OF CHARACTERS TO BE PROCESSED
	 LDR R11, =CLEARTEXT	@R11 KEEPS THE ADDRES OF THE CLEAR MESSAGE
	 LDR R12, =CIPHERTEXT	@R12 KEEPS THE ADDRES OF THE ENCRYPTED MESSAGE
   	 

L1:  CMP R10, #0   		 @CHECKS NUMBER OF CHARACTERS TO CONVERT THE REMAINING ONES
   	 BEQ TERMINATE_STRING
	 
   	 @ADJUST DISPLAY POSITION ON SCREEN
   	 CMP R8, #40   		 @[0 T0 39] = RANGE OF POSSIBLE COLS. TO WRITE, THE 40th COL. IS A COL. OVERFLOW
   	 MOVEQ R8, #0   	 @CARRIAGE RETURN :-D
   	 ADDEQ R9, R9, #1    @NEXT LINE
   	 
   	 CMP R9, #15   		 @[0 T0 14] = RANGE OF POSSIBLE LINES TO WRITE, THE 15th LINE IS A LINE OVERFLOW
   	 MOVEQ R9, #0   	 @RESTART LINE FROM BEGINNING IF DISPLAY BOX IS FULL


   	 @ENCODING BEGINS HERE
	 MOV R5, #1   		 @OFFSET RESET OF BLUE BUTTON POS. CALCULATED AT POS-1,2
   	 SWI 0x202   		 @ALWAYS CHECKS THE RIGHT BLACK BUTTON
   	 CMP R0, #1
   	 BEQ QtoZ   		 @IF R0 == 1 THE RIGHT BUTTON WAS PRESSED, if R0 != 1 THEN AtoP   	 
   	 
AtoP:
     SWI 0x203   		 @CHECKS THE BLUE BUTTONS
   	 
   	 MOV R2, R7   	 @R2 := THE "A" LETTER STARTING POSITION, LATER R2 := R2 + OFFSET
   	 
   	 @SEARCHES FOR "A" CHAR
   	 CMP R0, #1   		 @CHECKS FIRST CHAR
   	 MOVEQ R0, R8   	 @X POSITION
   	 MOVEQ R1, R9   	 @Y POSITION
   	 SWIEQ 0x205   		 @PRINTS THE INTEGER (0X41, OR 65D)
	 STREQB R2, [R11], #1@STORES THE CHAR
	 SUBEQ R10, R10, R6	 @IFORMS THAT A CHARACTER HAVE BEEN PROCESSED
   	 ADDEQ R8, R8, #2    @UPDATES THE DISPLAY SCREEN PRINTING POSITION
   	 BEQ L1   			 @"A" IS FOUND, THEN GOES FOR THE NEXT CHARACTER
    

   		 @HERE IF "A" IS NOT THE PRESSED KEY THEN SEARCHES THE NEXT CHARACTER
    POS2:
		 CMP R6, R0, LSR R5    @SHIFTS R0 BY R5 BITS TO THE RIGHT THEN COMPARES TO 1 (R6 = 1)
   		 ADDEQ R2, R2, R5
   		 MOVEQ R0, R8   	 @X POSITION
   		 MOVEQ R1, R9   	 @Y POSITION
   		 SWIEQ 0x205   		 @PRINTS THE INTEGER
		 STREQB R2, [R11], #1@STORES THE CHAR
		 SUBEQ R10, R10, R6	 @IFORMS THAT A CHARACTER HAVE BEEN PROCESSED
   		 ADDEQ R8, R8, #2    @UPDATES THE DISPLAY SCREEN PRINTING POSITION
   		 BEQ L1
   		 
   		 ADD R5, R5, #1   	 @ADJUSTS OFFSET FOR THE NEXT CHAR TO BE TESTED
   		
		 @FOR SAFETY CHECKS 16th POSITION 		
   		 CMP R5, #16   		 @IF REACHED 16 POSITIONS OF OFFSET THEN CHAR NOT FOUND
   		 @BHS END_err 		 @IF CHAR NOT FOUND THEN GO TO ERROR ROUTINE
		 BHS L1
   		 
   		 B POS2   			 @GO FOR NEXT

QtoZ:
     SWI 0x203   		 @CHECKS THE BLUE BUTTONS
   	 
   	 @SEARCHES FOR SPACE CHAR
   	 CMP R0, #1024
   	 SUBEQ R2, R7, R3    @CHANGE "A" CHAR TO "SPACE" CHAR
   	 MOVEQ R0, R8   	 @X POSITION
   	 MOVEQ R1, R9   	 @Y POSITION
   	 SWIEQ 0x205   		 @PRINTS THE INTEGER
	 STREQB R2, [R11], #1@STORES THE CHAR
	 SUBEQ R10, R10, R6	 @IFORMS THAT A CHARACTER HAVE BEEN PROCESSED
   	 ADDEQ R8, R8, #2    @UPDATES THE DISPLAY SCREEN PRINTING POSITION
   	 BEQ L1
   	 
   	 ADD R2, R4, R7   	 @R2 := THE "Q" LETTER STARTING POSITION, LATER R2 := R2 + OFFSET
   	 
   	 @SEARCHES FOR "Q" CHAR
   	 CMP R0, #1   		 @IF IS NOT SPACE, SO AFTER SWI(203) R0 IS SET
   	 MOVEQ R0, R8   	 @X POSITION
   	 MOVEQ R1, R9   	 @Y POSITION
   	 SWIEQ 0x205   		 @PRINTS THE INTEGER
	 STREQB R2, [R11], #1@STORES THE CHAR
	 SUBEQ R10, R10, R6	 @IFORMS THAT A CHARACTER HAVE BEEN PROCESSED
   	 ADDEQ R8, R8, #2    @UPDATES THE DISPLAY SCREEN PRINTING POSITION
   	 BEQ L1   			 @"Q" IS FOUND, THEN GOES FOR THE NEXT CHARACTER
    

   		 @HERE IF NEITHER "Q" OR "SPACE" IS THE PRESSED KEY THEN SEARCHES THE NEXT CHARACTER
    POS1:
		 CMP R6, R0, LSR R5    @SHIFTS R0 BY R5 BITS TO THE RIGHT THEN COMPARES TO 1 (R6 = 1)
   		 ADDEQ R2, R2, R5
   		 MOVEQ R0, R8   	 @X POSITION
   		 MOVEQ R1, R9   	 @Y POSITION
   		 SWIEQ 0x205   		 @PRINTS THE INTEGER
		 STREQB R2, [R11], #1@STORES THE CHAR
		 SUBEQ R10, R10, R6	 @IFORMS THAT A CHARACTER HAVE BEEN PROCESSED
   		 ADDEQ R8, R8, #2    @UPDATES THE DISPLAY SCREEN PRINTING POSITION
   		 BEQ L1
		 
   		 ADD R5, R5, #1   	 @ADJUSTS OFFSET FOR THE NEXT CHAR TO BE TESTED
   		 
   		 CMP R5, #10   		 @CHECK IF REACHED "SPACE" CHAR POSITION ("SPACE" CHAR WAS TESTED ALREADY)
   		 BEQ L1   	 		 @THEN JUMPS BACK TO L1
   		 B POS1   			 @GO FOR NEXT
   	 
	 
	 
	 
TERMINATE_STRING:				@ROUTINE TO FINISH THE STRING, ADDING A "\0" CHAR
		 MOV R5, #0
		 STRB R5, [R11]			@ADDS THE ZERO AT THE END OF THE STRING
   		 B CIPHER
@=====================================END OF ASCII CONVERTING SECTION=====================================	 
	 
	 
@=====================================CIPHER SECTION=====================================

CIPHER:
		@PREPARE THE CONSTANTS	@(ENCRYPTION)
		
		@IF THE CODE FOLLOWS THE ARM EABI, THEN THE CLEARTEXT LENGHT...
		@...PARAMETER WOULD BE ON {R1 - R3}
				
		
		MOV R10, #1 			@INDICATES THAT DECRYPTION WILL BE PERFORMED

		
		MOV R9, #1				@THE AUXILIARY FOR ADD AND SUBTRACT
		MOV R8, #8				@AMOUNT OF CHARS TO ENCRYPT
		LDR R0, =CIPHERTEXT		@POINTER TO THE ADDRESS OF THE CIPHERTEXT
		LDR R1, =CLEARTEXT		@POINTER TO CLEARTEXT ADDRESS
		LDR R2, =KEY			@POINTER TO THE ADDRESS OF THE KEY

ENC:	LDRB R3, [R1], #1		@ENC = LABEL FOR THE ENCRYPTION/DECRYPTION LOOP
		LDRB R4, [R2], #1
		EOR R5, R3, R4
		STRB R5, [R0], #1
		SUB R8, R8, R9			@DECREASE THE COUNTER
		CMP R8, #0
		MOVEQ R6, #0
		STREQB R6, [R0]			@ADDS A ZERO TO THE STRING
		BGT ENC					@SIGNED COMPARISON, FOR SAFETY, IN CASE R8 GOES LOWER THAN 0
		

		
		@VERIFIES THE NECESSITY OF DECRYPTION
		CMP R10, #1
		BNE END					@IF NOT EQUAL, THEN GOTO END OF PROGRAM


		
		@PREPARES DECRYPTION
		LDR R1, =CIPHERTEXT			@R1 := ADDRESS OF THE CIPHERTEXT
		LDR R2, =KEY			@R2 := KEEPS ADDRESS OF THE KEY
		LDR R0, =DECRYPTED
		MOV R8, #8
		SUB R10, R10, R9		@CLEAR THE DECRYPTION FLAG (R10 := 0)
		B ENC
		
		
END:	B END_OK


@=====================================END OF CIPHER SECTION=====================================
		 


@=====================================ENDING SECTION=====================================
END_OK:     
		
		LDR R0, =WARN1
		SWI 0x02
		
		LDR R0, =CLEARTEXT
		SWI 0x02
		
		LDR R0, =WARN2
		SWI 0x02
		
		LDR R0, =DECRYPTED
		SWI 0x02

		
		
   		 
FINISH:   	 EOR R0, R0, R0
