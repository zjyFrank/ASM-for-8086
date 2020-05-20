DATA SEGMENT
    str     DB 'OTrUqq1K2fmYLIvylXIkhQqGBpCuXeDCyI3yP74YORrhkFbvN0tjsuBp'
            DB 'SBG0eitVDsHbWINmIAcwQKcOre1SIzCwI2PbVYxhHEZPVv7PGR6ex0mc'
            DB 'biyCqnyaG8drol0JpG9CTxxcxNMByGktxenw2AuLVRGMFhGBFipySOxA'
            DB 'jMhKhlBiaoUiMTkZF3WQsFeOR0LmSWz0yw8t9dtLS7QugRKBt7bppmHc'
            DB 'yIc1ZC7eLTbSXFUAJyBgXiUQU5m6bf7rBCAhbfJy0Wsu6UsFoGxOda8V'
            DB 'WiCYiuxv5SXKpuzhJ1xF7TNSauxYapNEUAKelPGJNIzacOlgbyc3UWpq'
            DB 'ww0r7mvAVLsZfajn6apqsd5XwlrfIYY6Py8njgTwlZRPODS93mteVtj9'
            DB '3Wxpw1FcD7jU45GL7N2FmmMYvBrfipuQzmdGkGuCTMMLpAE7aVI2xkCm'
            DB 'GS6hSUsI4gqSn61zfeuOz9cxWsdtFrcrkcxC6GpuKUDVFY2NzdYy',00H   ;������ɳ���Ϊ500(<200H)���ַ��� 
    substr  DB 'AcwQKcOre1S',00H     ;��Դ�������ȡ��Ϊ�Ӵ� 
    found   DB 0
    pos     DW 0    ;ƥ��λ��
    hash    DW 0    ;�Ӵ���hashֵ
    len_sub DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    LEA DI,substr   ;�ִ�ָ��
    
    XOR AX,AX 
    XOR CX,CX
    XOR DX,DX
    
;�����Ӵ���hashֵ
get_sub_hash:
    MOV DL,[DI]
    CMP [DI],00H
    JZ end_sub_hash
    ADD AX,DX
    INC DI
    INC CX 
    JMP get_sub_hash 

end_sub_hash:
    MOV len_sub,CX  ;�Ӵ�����  
    MOV hash,AX
    
    LEA SI,str      ;Դ��ָ��
    LEA DI,substr   ;�Ӵ�ָ��
    
;��Դ����ƥ���Ӵ������ַ�        
find_firstchar:     
    CMP [SI],00H
    JZ notfound
    MOV AL,[DI]     ;�Ӵ����ַ�
    CMP AL,[SI]
    JZ firstchar_match 
    INC SI
    JMP find_firstchar
    
;���ƥ�䵽���ַ�    
firstchar_match:    
    XOR AX,AX
    MOV CX,len_sub
    PUSH SI
get_len_hash:       ;���㳤��Ϊlen_sub��Դ����hashֵ 
    MOV DL,[SI]
    ADD AX,DX
    INC SI 
    LOOP get_len_hash 
    
    POP SI
    CMP AX,hash
    JZ check_each_char
    INC SI
    JMP find_firstchar

;��hashֵƥ�������£�Դ��/�Ӵ���һ�ַ��ȶ�
check_each_char:    
    LEA DI,substr
    XOR CX,CX
nextchar:
    MOV AL,[DI]    
    CMP [SI],AL     ;�Ƚϵ�һ��
    JZ next1        ;��ͬ�����
    JMP find_firstchar;������Դ�����ٲ�����һ�����ַ���ͬ�Ĵ�

next1:
    INC CX
    INC SI
    INC DI
    CMP CX,len_sub  ;ȫ��ƥ��
    JZ findout
    JMP nextchar

;ƥ��ɹ�
findout:
    SUB SI,len_sub
    MOV found,0FFH 
    MOV pos,SI
    JMP exit
;ƥ��ʧ��
notfound:
    MOV found,00H
         
exit:    
    MOV AH,4CH
    INT 21H
CODE ENDS
    END START
