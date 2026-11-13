
	ORG 0000H
	AJMP START
	ORG 0030H
	START:        ;程序开始的地方 
	MOV P1,#0FFH  ;P1口全部输出1 （高电平）
	MOV TMOD,#60H ;定时器1计数方式 模式2  
	MOV TH1,#0FEH ;设置初值 10次溢出
	MOV TL1,#0FEH
	SETB TR1       ;启动定时器1 
	MLP1: 
	JNB TF1,MLP1   ;查询溢出标志 为0原地等待
	CPL P1.0       ;改变P1.0口状态
	CLR TF1        ;清除中断标志
	AJMP MLP1       ;跳转到MLP1
	END
