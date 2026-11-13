ORG 0000H             ; 程序入口地址
LJMP START            ; 跳转到主程序开始位置
ORG 0030H             ; 主程序地址
START: 
       MOV SP,#60H    ; 设置栈指针为0x60
       MOV R0,#01H    ; 初始化寄存器R0为0x01，用于记录LED状态
       MOV SCON,#01010000B ; 设置串口为模式1，8位串行通信
       MOV TMOD,#20H  ; 定时器1工作在模式2，8位自动重装模式
       ORL PCON,#10000000B ; 设置波特率为标准模式的两倍
       MOV TH1,#0F3H  ; 设置定时器1的高位，控制波特率
       MOV TL1,#0F3H  ; 设置定时器1的低位，控制波特率
       SETB TR1       ; 启动定时器1

AGAIN: 
       JNB RI,$       ; 等待接收数据，检测接收中断标志位RI
       CLR RI         ; 清除接收标志位RI
       MOV A,SBUF     ; 将接收的数据存入累加器A
       MOV A,R0       ; 将寄存器R0的内容移动到累加器A，控制LED状态
       RL A           ; 将累加器A内容循环左移一位，实现LED左移效果
       MOV P1,A       ; 将累加器A的内容输出到P1口，控制LED
       MOV R0,A       ; 保存新的LED状态到R0
       MOV SBUF,A     ; 将接收的数据发送回串口
       JNB TI,$       ; 等待发送完成，检测发送中断标志位TI
       CLR TI         ; 清除发送标志位TI
       SJMP AGAIN     ; 返回等待接收新的数据
END                   ; 程序结束
