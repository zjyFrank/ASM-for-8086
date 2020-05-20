DATA SEGMENT
    str     DB 'OTrUqq1K2fmYLIvylXIkhQqGBpCuXeDCyI3yP74YORrhkFbvN0tjsuBp'
            DB 'SBG0eitVDsHbWINmIAcwQKcOre1SIzCwI2PbVYxhHEZPVv7PGR6ex0mc'
            DB 'biyCqnyaG8drol0JpG9CTxxcxNMByGktxenw2AuLVRGMFhGBFipySOxA'
            DB 'jMhKhlBiaoUiMTkZF3WQsFeOR0LmSWz0yw8t9dtLS7QugRKBt7bppmHc'
            DB 'yIc1ZC7eLTbSXFUAJyBgXiUQU5m6bf7rBCAhbfJy0Wsu6UsFoGxOda8V'
            DB 'WiCYiuxv5SXKpuzhJ1xF7TNSauxYapNEUAKelPGJNIzacOlgbyc3UWpq'
            DB 'ww0r7mvAVLsZfajn6apqsd5XwlrfIYY6Py8njgTwlZRPODS93mteVtj9'
            DB '3Wxpw1FcD7jU45GL7N2FmmMYvBrfipuQzmdGkGuCTMMLpAE7aVI2xkCm'
            DB 'GS6hSUsI4gqSn61zfeuOz9cxWsdtFrcrkcxC6GpuKUDVFY2NzdYy',00H   ;随机生成长度为500(<200H)的字符串 
    substr  DB 'AcwQKcOre1S',00H     ;从源串随机截取作为子串 
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
    
;在源串中匹配子串的首字符        
find_firstchar:     
    CMP [SI],00H
    JZ notfound
    MOV AL,[DI]     ;子串首字符
    CMP AL,[SI]
    JZ firstchar_match 
    INC SI
    JMP find_firstchar
    
;如果匹配到首字符    
firstchar_match:    
    XOR AX,AX
    MOV CX,len_sub
    PUSH SI
get_len_hash:       ;计算长度为len_sub的源串的hash值 
    MOV DL,[SI]
    ADD AX,DX
    INC SI 
    LOOP get_len_hash 
    
    POP SI
    CMP AX,hash
    JZ check_each_char
    INC SI
    JMP find_firstchar

;在hash值匹配的情况下！源串/子串逐一字符比对
check_each_char:    
    LEA DI,substr
    XOR CX,CX
nextchar:
    MOV AL,[DI]    
    CMP [SI],AL     ;比较第一个
    JZ next1        ;相同则继续
    JMP find_firstchar;否则，在源串中再查找下一个首字符相同的串

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
