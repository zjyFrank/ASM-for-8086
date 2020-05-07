; multi-segment executable file template.

DATA SEGMENT
    STRING DB '    Hello ZJY  ',0   ; E.G. front 4 space��back 2 space 
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
    LEA SI,STRING   ;װ���ַ���ָ��
;�������ַ���
TOTAL:  CMP [SI],0          
        JE END1
        INC CX          
        INC SI
        JMP TOTAL
END1:   MOV TOTAL_CHAR,CX ;�����ַ�˳����ҵ�һ����Ϊspace���ַ�
        XOR CX,CX
        LEA SI,STRING
;����ǰ�ո���     
FRONT:  CMP [SI],20H   
        JNE END2
        INC CX
        INC SI
        JMP FRONT
END2:   MOV FRONT_SPACE,CX
        XOR CX,CX
        LEA SI,STRING 
        MOV BX,TOTAL_CHAR
;�����ո���      
BACK:   CMP [SI+BX-1],20H ;��TOTAL_CHAR-1������ҵ�һ����Ϊspace���ַ� 
        JNE END3
        INC CX
        DEC SI
        JMP BACK 
END3:   MOV BACK_SPACE,CX
        XOR CX,CX
        LEA SI,STRING
;������
    MOV DI,SI           ;Ŀ�Ĵ���ַES:DI��DIָ���ַ����׵�ַ        
    ADD SI,FRONT_SPACE  ;Դ����ַDS:SI��SIָ���׸���Ϊspace���ַ�
    XOR BX,BX
    ADD BX,TOTAL_CHAR   ;ȥ����β�ո���ַ��� BX = TOTAL_CHAR - FRONT_SPACE - BACK_SPACE
    SUB BX,FRONT_SPACE
    SUB BX,BACK_SPACE
    MOV CX,BX
    CLD
    REP MOVSB           ;�ƶ�BX�ֽ�
;����ַ�������Ļ        
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

