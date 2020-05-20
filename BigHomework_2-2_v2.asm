DATA SEGMENT
 
    str DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' 
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' 
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'  
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB',00H  
    substr  DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB',00H     ;从源串末尾截取作为子串

    found   DB 0
    pos     DW 0    ;匹配位置
    hash    DW 0    ;子串的hash值
    len_sub DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    LEA DI,substr   ;字串指针
    
    XOR AX,AX 
    XOR CX,CX
    XOR DX,DX
    
;计算子串的hash值
get_sub_hash:
    MOV DL,[DI]
    CMP [DI],00H
    JZ end_sub_hash
    ADD AX,DX
    INC DI
    INC CX 
    JMP get_sub_hash 

end_sub_hash:
    MOV len_sub,CX  ;子串长度  
    MOV hash,AX
    
    LEA SI,str      ;源串指针
    LEA DI,substr   ;子串指针
           
    XOR AX,AX
    MOV BX,len_sub
    NEG BX
    MOV CX,len_sub
get_len_hash_1:       ;计算长度为len_sub的源串的hash值(第一次) 
    MOV DL,[SI]
    ADD AX,DX
    INC SI 
    LOOP get_len_hash_1
    JMP check
    
get_len_hash_other:     ;快速hash算法(增量更新)
    CMP [SI],00H
    JZ notfound
    MOV DL,[SI]         
    ADD AX,DX           ;加后一个 
    MOV DL,[SI+BX]      ;减前一个
    SUB AX,DX
    
    INC SI
check:
    CMP AX,hash
    JZ check_each_char
    JMP get_len_hash_other

;在hash值匹配的情况下！源串/子串逐一字符比对
check_each_char:
    SUB SI,len_sub    
    LEA DI,substr
    XOR CX,CX
nextchar:
    MOV AL,[DI]    
    CMP [SI],AL     ;比较第一个
    JZ next1        ;相同则继续
    JMP get_len_hash_other;否则，计算下一个串的hash

next1:
    INC CX
    INC SI
    INC DI
    CMP CX,len_sub  ;全部匹配
    JZ findout
    JMP nextchar

;匹配成功
findout:
    SUB SI,len_sub
    MOV found,0FFH 
    MOV pos,SI
    JMP exit
;匹配失败
notfound:
    MOV found,00H
         
exit:    
    MOV AH,4CH
    INT 21H
CODE ENDS
    END START
