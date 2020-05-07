; multi-segment executable file template.

DATA SEGMENT
    STRING DB '    Hello ZJY  ',0   ; E.G. front 4 space，back 2 space 
    TOTAL_CHAR DW 0
    FRONT_SPACE DW 0
    BACK_SPACE DW 0 
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,ES:EDATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX
    
    XOR CX,CX       ;clear CX      
    LEA SI,STRING   ;装载字符串指针
;计算总字符数
TOTAL:  CMP [SI],0          
        JE END1
        INC CX          
        INC SI
        JMP TOTAL
END1:   MOV TOTAL_CHAR,CX ;从首字符顺序查找第一个不为space的字符
        XOR CX,CX
        LEA SI,STRING
;计算前空格数     
FRONT:  CMP [SI],20H   
        JNE END2
        INC CX
        INC SI
        JMP FRONT
END2:   MOV FRONT_SPACE,CX
        XOR CX,CX
        LEA SI,STRING 
        MOV BX,TOTAL_CHAR
;计算后空格数      
BACK:   CMP [SI+BX-1],20H ;从TOTAL_CHAR-1倒序查找第一个不为space的字符 
        JNE END3
        INC CX
        DEC SI
        JMP BACK 
END3:   MOV BACK_SPACE,CX
        XOR CX,CX
        LEA SI,STRING
;串操作
    MOV DI,SI           ;目的串地址ES:DI，DI指向字符串首地址        
    ADD SI,FRONT_SPACE  ;源串地址DS:SI，SI指向首个不为space的字符
    XOR BX,BX
    ADD BX,TOTAL_CHAR   ;去除首尾空格的字符数 BX = TOTAL_CHAR - FRONT_SPACE - BACK_SPACE
    SUB BX,FRONT_SPACE
    SUB BX,BACK_SPACE
    MOV CX,BX
    CLD
    REP MOVSB           ;移动BX字节
;输出字符串到屏幕        
    LEA SI,STRING
    MOV [SI+BX],0
    MOV [SI+BX+1],'$'    
    LEA DX,STRING
    MOV AH,09H
    INT 21H

    MOV AH,4CH
    INT 21H    
CODE ENDS
    END START

