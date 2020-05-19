;���к�
nextline MACRO
    MOV DL,0DH  ;��ʾ�س�
    MOV AH,02H
    INT 21H
    MOV DL,0AH  ;��ʾ����
    MOV AH,02H
    INT 21H
ENDM

DATA SEGMENT  
    BUF DB  77,217,194,167,231,172,45,30,84,230     ;�������n��0-255���������ظ�, n δ֪��
        DB  194,36,234,19,67,43,143,42,10,68
        DB  103,96,128,44,172,131,149,177,60,206
        DB  169,104,72,70,216,241,199,229,244,127
        DB  27,186,29,172,15,241,187,221,149,131
;    �������ݣ��������78��0-255�����֣����ظ���
;    BUF DB 222,28,191,31,168,153,63,180,93,137,121,252,146,132,176,107,127,190,195,215
;        DB 83,71,250,94,231,160,164,123,243,228,133,202,3,42,147,7,96,105,162,218,74,3
;        DB 55,189,167,84,74,213,154,85,65,12,233,24,146,211,164,243,135,214,148,189,26
;        DB 119,210,168,182,92,211,161,237,100,206,105,86,178,109,106
    ENDFLAG DB '$#$'                                ;�趨������־-$#$��������������������'$#$'�ĸ��ʼ��ͣ�
    STR1 DB 'Unsort numbers:',0DH,0AH,'$'
    STR2 DB  0DH,0AH,'Sorting... , Please wait',0DH,0AH,'$'
    STR3 DB 'Sorted numbers:',0DH,0AH,'$'
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    CALL DISPLAY_UNSORT
    CALL SORT
    CALL DISPLAY_SORTED
    
    MOV AH,4CH
    INT 21H
         
;************************************************FUNCTION**********************************************
;                              
;*************************************************************************************
;	@FuncName:	    DISPLAY_UNSORT
;	@Description:	Display unsort num in hex with 10 nums each line 
;*************************************************************************************    
DISPLAY_UNSORT PROC
    LEA DX,STR1
    MOV AH,09H
    INT 21H
    CALL DISPLAY
    nextline    
    RET
DISPLAY_UNSORT ENDP
;*************************************************************************************
;	@FuncName:	    SORT
;	@Description:	Bubble sort
;*************************************************************************************
SORT PROC
    LEA DX,STR2
    MOV AH,09H
    INT 21H
    XOR CX,CX  
    MOV CX,SI   ;SIΪ��������������
    CALL BUBBLE_SORT
    nextline
    RET
SORT ENDP
;*************************************************************************************
;	@FuncName:	    DISPLAY_SORTED
;	@Description:	Display sorted num in hex with 10 nums each line 
;************************************************************************************* 
DISPLAY_SORTED PROC
    LEA DX,STR3
    MOV AH,09H
    INT 21H
    CALL DISPLAY 
    RET
DISPLAY_SORTED ENDP 
;------------------------------------------��ʾ�Ӻ���---------------------------------------
DISPLAY PROC
        XOR CX,CX
    LEA SI,BUF
disp_onenum:
    XOR AX,AX
    MOV AL,[SI] ;���ڲ���
    
;�жϽ�����־    
    CMP AL,'$'  ;��һ��$
    JZ endflag_middle
    JMP notendflag
endflag_middle:
    MOV AL,[SI+1]
    CMP AL,'#'  ;�ڶ���#
    JZ endflag_low
    JMP notendflag
endflag_low:
    MOV AL,[SI+2]
    CMP AL,'$'  ;������$
    JZ end_disp
    JMP notendflag

notendflag:  
    MOV DL,16
    DIV DL
    PUSH AX     ;���AXѹջ
    
;��ʾ��λ��HEX��    
    CMP AL,9    ;����AL����16���Ƶĸ�λ
    JA ischar_high
    ADD AL,30H
    JMP next1
ischar_high:
    ADD AL,37H
next1:    
    MOV DL,AL        
    MOV AH,02H
    INT 21H
    
;��ʾ��λ��HEX��    
    POP AX    
    CMP AH,9    ;������AH����16���Ƶĵ�λ
    JA ischar_low
    ADD AH,30H
    JMP next2
ischar_low:
    ADD AH,37H
next2:    
    MOV DL,AH     
    MOV AH,02H
    INT 21H
    
    MOV DL,20H  ;����ո�
    MOV AH,02H
    INT 21H
    INC SI
    INC CX
    CMP CX,10   ;ÿ10��������
    JZ go_nextline
    JMP next3:
go_nextline:
    nextline
    XOR CX,CX
next3:
    JMP disp_onenum
end_disp:
    RET
DISPLAY ENDP
;-------------------------------------------ð�������ӳ���---------------------------------------------
BUBBLE_SORT PROC     
    XOR AX,AX
    MOV AH,CL       ;TOTAL=CL
    SUB AH,1        ;AH=TOTAL-1
    XOR BH,BH       ;��i(BH)=0

for1:
    CMP BH,AH       ;IF i<TOTAL-1
    JAE endfor1
    XOR BL,BL       ;��j(BL)=0
    MOV AL,AH
    SUB AL,BH        ;AL=TOTAL-1-i

    LEA SI,BUF  ;SIָ���������

    for2:
        CMP BL,AL   ;IF j<TOTAL-1-i
        JAE endfor2
        
        sort_up:                ;����
            MOV CL,[SI+1]   
            CMP [SI],CL     
            JA swap         
            JMP notswap 
        swap:   
            MOV DL,[SI]     ;����
            MOV [SI+1],DL   ;[SI]->[SI+1]
            MOV [SI],CL     ;[SI+1]->[SI]
        notswap:
            INC SI
        
        INC BL          ;j++
        JMP for2
    endfor2:
    INC BH              ;i++
    JMP for1 
endfor1:
    RET
BUBBLE_SORT ENDP

CODE ENDS
    END START 