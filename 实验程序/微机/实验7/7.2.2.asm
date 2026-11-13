DAPORT EQU  0FEFFH
		 ORG 0000H
		 AJMP START
		 ORG 0100H
START:  MOV DPTR, #DAPORT
TRI:   MOV  A,#00H

UP:    MOVX @DPTR,A   

       INC  A                ;

       CJNE A,#0FFH,UP

DOWN:  MOVX @DPTR,A   

       DEC  A               

       CJNE A,#00H,DOWN

       AJMP UP         

       END