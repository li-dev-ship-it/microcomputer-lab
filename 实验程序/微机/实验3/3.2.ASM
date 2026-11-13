
	ORG 0000H
	AJMP START
	ORG 001BH
	AJMP IT11      ;定时器1中断入口
	ORG 0030H
	START:         ;主程序入口
	MOV P1, #0FFH       ;P1口输出高电平
	MOV A, #11111010B  
	MOV R1, #3
	MOV R0, #14H       ;十进制为20 乘以定时时间50ms 即总定时时间为1秒    
	ANL TMOD, #0FH   ;TMOD高四位清零   
	ORL TMOD, #10H   ;TMOD第四位置1  定时器1为定时方式且为模式1
	MOV TL1, #0FEH
	MOV TH1, #4BH       ;设置初值 (（10000H-4BFEH）*12/11.0592)us=定时时间 
	ORL IE, #88H        ;EA、ET1置1 开启中断
	SETB TR1           ;启动定时器
	
	LOOP1: 
	CJNE R0, #00H, DISP    ;定时时间到顺序执行 否则跳转到DISP  
	MOV R0, #14H           ;重新给R0赋值  
	INC R1                 ;R1自动加1
	CJNE R1, #0BH, LOOP2   ;限值R1 加到0BH后又回到03H 
	MOV R1, #3
	LOOP2: 
	
	MOV A, R1      
	MOVC A,@A+PC  ;变址寻址 找到对应要点亮的二极管数据
	LJMP DISP
	
	DB 0FAH, 0F5H, 0AFH, 5FH, 0AAH, 55H, 00H, 0FFH
		
	DISP: MOV P1, A
	JMP LOOP1
	
	IT11:
	CLR TR1          ;关闭定时器
	DEC R0         ;自动减一
	MOV TL1, #0FEH ;重置初值
	MOV TH1, #4BH
	SETB TR1          ;启动定时器
	RETI
	
	END
