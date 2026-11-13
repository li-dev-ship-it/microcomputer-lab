
	;P2.3--减速 
	;P2.4--加速
	ORG 0000H
	MOV R3,#5                    ;相邻步之间的延时决定电机的转速。故控制调用延时函数次数 从而控制加减速
	STOP: ORL P1, #00H           ;或运算
	LOOP: MOV P1, #00H           ;电机停止
	JNB P2.0, FOR2 ; 如果p2.0按下正转  
	JNB P2.1, REV2 ; 如果p2.1按下反转
	JNB P2.2, STOP1 ; 如果p2.2按下停止
	JMP LOOP ;反复监测键盘
	
	
	STOP1: CALL DELAY ;延时按件键消除抖动
	JNB P2.2, $         ;p2.2放开否?
	MOV P1, #00H     ;电机停止
	CALL DELAY
	JMP STOP       ;跳转到STOP
	
	FOR2: CALL DELAY       ;延时
	JNB P2.0, $           ;等待正转按键释放
	CALL DELAY
	JMP FOR
	
	REV2: CALL DELAY   ;延时
	JNB P2.1, $        ;等待反转按键释放
	CALL DELAY     
	JMP REV
	
	
	
	;正转
	FOR: MOV R0, #00H  ;偏移量
	FOR1: MOV A, R0
	MOV DPTR, #TABLE
	MOVC A, @A+DPTR          ;找到当前正转代码
	JZ FOR ;是否到了结束码00h A为0后正转代码一周循环结束 开始下一次循环
	CPL A            ;取反数据 低电平有效
	MOV P1, A           ;输出到电机
	MOV A,R3
	LOOP1:
	JNB P2.2, STOP1    ;判断有新的按键按下吗
	JNB P2.1, REV2
	JNB P2.0, FOR2
	JB P2.3, FOR3      ;判断减速按键是否按下 没有按就跳转 
    JNB P2.3,$         ;等待按键释放
	INC R3              ;R3自动加一
	MOV A,R3            
	CJNE R3,#11,FOR3   ;范围1-10
	DEC A
	DEC R3
	FOR3:
	JB P2.4,FOR4       ;判断加速按键是否按下
	JNB P2.4,$         ;等待按键释放
	DEC R3            ;R3自动减1
	MOV A,R3
	CJNE R3,#0,FOR4   ;范围1-10
	INC A
	INC R3
	FOR4:
	CALL DELAY        ;没有则继续执行正转
	DJNZ ACC,LOOP1
	INC R0            ;下一个数据
	JMP FOR1        ;跳转到FOR1
	
	;反转
	REV: 
	MOV R0, #05H ;反转到table取码指针初值
	REV1: 
	MOV A, R0
	MOV DPTR, #TABLE  ;找到当前反转代码
	MOVC A, @A+DPTR
	JZ REV            ;是否到了结束码00h A为0后正转代码一周循环结束 开始下一次循环
	CPL A            ;取反数据 低电平有效
	MOV P1, A
	MOV A,R3
	LOOP2:
	JNB P2.2, STOP1    ;判断有新的按键按下吗
	JNB P2.1, REV2
	JNB P2.0, FOR2
	JB P2.3, REV3
    JNB P2.3,$
	INC R3
	MOV A,R3
	CJNE R3,#11,REV3   ;范围1-10
	DEC A
	DEC R3
	REV3:
	JB P2.4,REV4
	JNB P2.4,$
	DEC R3
	MOV A,R3
	CJNE R3,#0,REV4   ;范围1-10
	INC A
	INC R3
	REV4:
	CALL DELAY        ;没有则继续执行正转
	DJNZ ACC,LOOP2
	INC R0          ;下一个数据
	JMP REV1        ;跳转到REV1
	
	
	
	DELAY: 
	MOV R1, #30 ;步进电机的转速20ms
	D1: MOV R2, #248
	DJNZ R2, $
	DJNZ R1, D1
	RET
	
	TABLE:
	db 01h,02h,04h,08h ;正转表
	db 00 ;正转结束
	db 01h,08h,04h,02h ;反转
	db 00 ;反转结束
	END
