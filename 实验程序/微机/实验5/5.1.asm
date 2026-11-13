ORG 0000H             ; 程序入口地址
LJMP START            ; 跳转到主程序开始位置
ORG 0030H             ; 主程序地址
START: 
       MOV SP,#60H    ; 设置栈指针为0x60，初始化堆栈位置
       MOV SCON,#01010000B ; 设置串口为模式1，8位串行通信
       MOV TMOD,#20H  ; 定时器1工作在模式2，8位自动重装模式
       ORL PCON,#10000000B ; 设置波特率为标准模式的两倍
       MOV TH1,#0F3H  ; 设置定时器1的高位，控制波特率
       MOV TL1,#0F3H  ; 设置定时器1的低位，控制波特率
       SETB TR1       ; 启动定时器1

AGAIN: 
       JNB RI,$       ; 等待接收到数据，检测接收中断标志位RI
       CLR RI         ; 清除接收标志位RI
       MOV A,SBUF     ; 将接收到的数据存入累加器A
       MOV SBUF,A     ; 将累加器A的数据发送回串口，实现回显
       JNB TI,$       ; 等待发送完成，检测发送中断标志位TI
       CLR TI         ; 清除发送标志位TI
       SJMP AGAIN     ; 返回等待接收新的数据
END                   ; 程序结束
