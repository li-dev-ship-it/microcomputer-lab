ORG 0000H
	STOP: ORL P1, #00H           ;或运算
	LOOP: MOV P1, #00H           ;电机停止
	JNB P2.0, FOR2 ; 如果p2.0按下正转  
	JNB P2.1, REV2 ; 如果p2.1按下反转
	JNB P2.2, STOP1 ; 如果p2.2按下停止
	JMP LOOP ;反复监测键盘
	
	;正转
	FOR: MOV R0, #00H  ;偏移量
	FOR1: MOV A, R0
	MOV DPTR, #TABLE
	MOVC A, @A+DPTR          ;找到当前正转代码
	JZ FOR ;是否到了结束码00h A为0后正转代码一周循环结束 开始下一次循环
	CPL A            ;取反数据 低电平有效
	MOV P1, A           ;输出到电机
	JNB P2.2, STOP1    ;判断有新的按键按下吗
	JNB P2.1, REV2
	JNB P2.0, FOR2
	CALL DELAY        ;没有则继续执行正转
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
	JNB P2.2, STOP1    ;判断有新的按键按下吗
	JNB P2.1, REV2
	JNB P2.0, FOR2
	CALL DELAY ;转动的速度
	INC R0          ;下一个数据
	JMP REV1        ;跳转到REV1
	
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
	
	DELAY: 
	MOV R1, #150 ;步进电机的转速20ms
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
