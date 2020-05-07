; multi-segment executable file template.

DATA SEGMENT
    DDVAR DD 0FFF8FFF7H ;双字(32bit)，28个1
    COUNT DW 0      ;MAX 0FFFFH      
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA  ;
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV AX,DDVAR    ;低16bit放AX
    MOV BX,DDVAR+2  ;高16bit放BX
    XOR CX,CX   ;clear CX
COUNTAX:AND AX,AX   ;判断AX中的1
        JZ COUNTBX
        SHL AX,1    ;左移1位
        JNC COUNTAX ;判断进位标志(C)，if =0 JMP COUNTAX
        INC CX
        JMP COUNTAX       
COUNTBX:AND BX,BX   ;判断BX中的1
        JZ NEXT  
        SHL BX,1
        JNC COUNTBX
        INC CX
        JMP COUNTBX                  
NEXT: MOV COUNT, CX
                      
    MOV AH,4CH
    INT 21H    
CODE ENDS
    END START