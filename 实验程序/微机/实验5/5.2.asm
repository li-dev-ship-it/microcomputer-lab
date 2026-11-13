ORG 0000H             ; 程序入口地址
LJMP START            ; 跳转到主程序开始位置
ORG 0030H             ; 主程序地址
START: 
       MOV SP,#60H    ; 设置栈指针为0x60
       MOV SCON,#01010000B ; 设置串口为模式1，8位串行通信
       MOV TMOD,#20H  ; 定时器1工作在模式2，8位自动重装模式
       ORL PCON,#10000000B ; 设置波特率为标准模式的两倍
       MOV TH1,#0F3H  ; 设置定时器1的高位，控制波特率
       MOV TL1,#0F3H  ; 设置定时器1的低位，控制波特率
       SETB TR1       ; 启动定时器1

       MOV R0,#15     ; R0用于记录即将发送的字符串字符数量
       MOV R1,#00H    ; R1初始化为0，作为字符表的偏移地址
       MOV R2,#11111110B ; R2用于初始化LED状态
       MOV A,R2       ; 将R2的内容载入累加器A
       MOV P1,A       ; 将累加器A的内容输出到P1口，初始化LED
       CLR A          ; 清空累加器A
       MOV DPTR,#ACTAB ; 将DPTR指向字符表ACTAB的首地址

AGAIN: 
       JNB RI,$       ; 等待接收数据，检测接收中断标志位RI
       CLR RI         ; 清除接收标志位RI
       MOV A,SBUF     ; 将接收的数据存入累加器A
       CJNE A,#'T',AGAIN ; 比较接收到的字符是否为'T'，若不是则继续等待

       CLR A          ; 清空累加器A以便开始发送字符串
LOOP:  
       MOV A,R1       ; 将R1的内容载入累加器A，用于读取字符表偏移量
       MOVC A,@A+DPTR ; 从字符表读取一个字符
       MOV SBUF,A     ; 将读取的字符发送到串口
       JNB TI,$       ; 等待发送完成，检测发送中断标志位TI
       CLR TI         ; 清除发送标志位TI
       DJNZ R0,LOOP   ; 递减R0计数器，直到R0为0，表示发送完成

       SJMP AGAIN     ; 返回等待接收新的数据

ACTAB: DB 'Welcome to cumt' ; 字符表，存储"Welcome to cumt"
END                   ; 程序结束
