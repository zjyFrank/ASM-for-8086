; multi-segment executable file template.

DATA SEGMENT
    DDVAR DD 0FFF8FFF7H ;˫��(32bit)��28��1
    COUNT DW 0      ;MAX 0FFFFH      
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA  ;
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV AX,DDVAR    ;��16bit��AX
    MOV BX,DDVAR+2  ;��16bit��BX
    XOR CX,CX   ;clear CX
COUNTAX:AND AX,AX   ;�ж�AX�е�1
        JZ COUNTBX
        SHL AX,1    ;����1λ
        JNC COUNTAX ;�жϽ�λ��־(C)��if =0 JMP COUNTAX
        INC CX
        JMP COUNTAX       
COUNTBX:AND BX,BX   ;�ж�BX�е�1
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