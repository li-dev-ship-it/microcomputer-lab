BIT_COUNT   	DATA 07FH
		TIMER       	DATA 07EH
		TIMER1      	DATA 07DH
		TEN         	DATA 07CH
		DATA_IN     	DATA 020H
  		DATA_OUT    	DATA 021H
        
  		KEY   	    	BIT P1.3             			;7279的KEY 连接于P1.3
  		CLK   		BIT P1.6             			;7279的CLK 连接于P1.6
  		DAT   		BIT P1.7             			;7279的DATA连接于P1.7
  		CS    		BIT P2.7             			;7279的CS  连接于P2.7
	
  		ORG    		0000H
 		LJMP   		START
 		ORG    		0100H
START:		MOV     	SP       ,  #2FH        	   	;定义堆栈
        	MOV  		P1       ,  #0FFH           		;I/O口初始化	
        	MOV  		TIMER    ,  #50

START_DELAY:  	MOV  		TIMER1   ,  #255
START_DELAY1: 	DJNZ 		TIMER1   ,  START_DELAY1		
                DJNZ 		TIMER    ,  START_DELAY			;延时指令,延时255*50次
                MOV  		DATA_OUT ,  #0BFH 			;发闪烁指令
                CALL 		SEND
                SETB 		CS                  			;复位CS为高电平
 		SETB 		F0
			 
MAIN:       	JB 		KEY,MAIN            			;检测是否有键按下
		JNB  		F0,NEXTKEY
		MOV  		DATA_OUT,#0A4H 
             	CALL 		SEND
             	SETB 		CS                 			 
		CLR  		F0
			 
NEXTKEY:	MOV  		DATA_OUT,#15H ;读键盘指令
             	CALL 		SEND                
             	CALL 		RECEIVE            
             	SETB 		CS
               
                MOV             DPTR,#TAB
                MOV  		A,DATA_IN
                
                MOVC             A,@A+DPTR
               	MOV              R0,A
             	
             				;采集按键号,屏蔽高四位,仅显示低四位0-F
                MOV  		DATA_OUT,#10010000B
             	CALL 		SEND
            	MOV             A,R0
                MOV             DATA_OUT,A;
                 CALL 		SEND 
              	SETB 		CS
WAIT:        	JNB  		KEY,WAIT
             	JMP  		MAIN

						; 发送子程序
SEND:       	MOV   		BIT_COUNT,#8
            	CLR   		CS		
            	CALL  		LONG_DELAY

SEND_LOOP:  	MOV   		C,DATA_OUT.7
            	MOV   		DAT,C
            	SETB  		CLK
            	MOV   		A,DATA_OUT
            	RL    		A
            	MOV   		DATA_OUT,A
            	CALL  		SHORT_DELAY
            	CLR   		CLK
            	CALL  		SHORT_DELAY
            	DJNZ  		BIT_COUNT,SEND_LOOP
            	CLR   		DAT
            	RET
					;接收子程序
RECEIVE:   	MOV    		BIT_COUNT,#8
           	SETB   		DAT
           	CALL 		LONG_DELAY
RECEIVE_LOOP: 	SETB 		CLK
           	CALL   		SHORT_DELAY
           	MOV    		A,DATA_IN
           	RL    		A
           	MOV    		DATA_IN,A
           	MOV   		C,DAT
           	MOV    		DATA_IN.0,C
           	CLR    		CLK
           	CALL   		SHORT_DELAY
           	DJNZ   		BIT_COUNT,RECEIVE_LOOP
           	CLR    		DAT
           	RET
					;延时子程序
LONG_DELAY: 	MOV   		TIMER,#80
DELAY_LOOP: 	DJNZ  		TIMER,DELAY_LOOP
            	RET
SHORT_DELAY:	MOV   		TIMER,#6
SHORT_LP:   	DJNZ  		TIMER,SHORT_LP
            	RET
TAB:  DB 7EH,30H,6DH,79H,33H,5BH,5FH,70H,7FH,7BH,77H,1FH,4EH,3DH,4FH,47H
    
            	END