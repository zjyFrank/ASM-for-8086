;换行宏
nextline MACRO
    MOV DL,0DH  ;显示回车
    MOV AH,02H
    INT 21H
    MOV DL,0AH  ;显示换行
    MOV AH,02H
    INT 21H
ENDM

DATA SEGMENT  
    BUF DB  77,217,194,167,231,172,45,30,84,230     ;随机生成n个0-255的数（可重复, n 未知）
        DB  194,36,234,19,67,43,143,42,10,68
        DB  103,96,128,44,172,131,149,177,60,206
        DB  169,104,72,70,216,241,199,229,244,127
        DB  27,186,29,172,15,241,187,221,149,131
;    测试数据（随机生成78个0-255的数字，可重复）
;    BUF DB 222,28,191,31,168,153,63,180,93,137,121,252,146,132,176,107,127,190,195,215
;        DB 83,71,250,94,231,160,164,123,243,228,133,202,3,42,147,7,96,105,162,218,74,3
;        DB 55,189,167,84,74,213,154,85,65,12,233,24,146,211,164,243,135,214,148,189,26
;        DB 119,210,168,182,92,211,161,237,100,206,105,86,178,109,106
    ENDFLAG DB '$#$'                                ;设定结束标志-$#$（输入数据中连续出现'$#$'的概率极低）
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
    MOV CX,SI   ;SI为待排序数字数量
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
;------------------------------------------显示子函数---------------------------------------
DISPLAY PROC
        XOR CX,CX
    LEA SI,BUF
disp_onenum:
    XOR AX,AX
    MOV AL,[SI] ;出口参数
    
;判断结束标志    
    CMP AL,'$'  ;第一个$
    JZ endflag_middle
    JMP notendflag
endflag_middle:
    MOV AL,[SI+1]
    CMP AL,'#'  ;第二个#
    JZ endflag_low
    JMP notendflag
endflag_low:
    MOV AL,[SI+2]
    CMP AL,'$'  ;第三个$
    JZ end_disp
    JMP notendflag

notendflag:  
    MOV DL,16
    DIV DL
    PUSH AX     ;结果AX压栈
    
;显示高位（HEX）    
    CMP AL,9    ;商在AL，即16进制的高位
    JA ischar_high
    ADD AL,30H
    JMP next1
ischar_high:
    ADD AL,37H
next1:    
    MOV DL,AL        
    MOV AH,02H
    INT 21H
    
;显示低位（HEX）    
    POP AX    
    CMP AH,9    ;余数在AH，即16进制的低位
    JA ischar_low
    ADD AH,30H
    JMP next2
ischar_low:
    ADD AH,37H
next2:    
    MOV DL,AH     
    MOV AH,02H
    INT 21H
    
    MOV DL,20H  ;输出空格
    MOV AH,02H
    INT 21H
    INC SI
    INC CX
    CMP CX,10   ;每10个数换行
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
;-------------------------------------------冒泡排序子程序---------------------------------------------
BUBBLE_SORT PROC     
    XOR AX,AX
    MOV AH,CL       ;TOTAL=CL
    SUB AH,1        ;AH=TOTAL-1
    XOR BH,BH       ;令i(BH)=0

for1:
    CMP BH,AH       ;IF i<TOTAL-1
    JAE endfor1
    XOR BL,BL       ;令j(BL)=0
    MOV AL,AH
    SUB AL,BH        ;AL=TOTAL-1-i

    LEA SI,BUF  ;SI指向分数数组

    for2:
        CMP BL,AL   ;IF j<TOTAL-1-i
        JAE endfor2
        
        sort_up:                ;升序
            MOV CL,[SI+1]   
            CMP [SI],CL     
            JA swap         
            JMP notswap 
        swap:   
            MOV DL,[SI]     ;交换
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