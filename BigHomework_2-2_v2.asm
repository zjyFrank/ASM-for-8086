DATA SEGMENT
 
    str DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' 
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' 
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'  
        DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB',00H  
    substr  DB 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB',00H     ;��Դ��ĩβ��ȡ��Ϊ�Ӵ�

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
           
    XOR AX,AX
    MOV BX,len_sub
    NEG BX
    MOV CX,len_sub
get_len_hash_1:       ;���㳤��Ϊlen_sub��Դ����hashֵ(��һ��) 
    MOV DL,[SI]
    ADD AX,DX
    INC SI 
    LOOP get_len_hash_1
    JMP check
    
get_len_hash_other:     ;����hash�㷨(��������)
    CMP [SI],00H
    JZ notfound
    MOV DL,[SI]         
    ADD AX,DX           ;�Ӻ�һ�� 
    MOV DL,[SI+BX]      ;��ǰһ��
    SUB AX,DX
    
    INC SI
check:
    CMP AX,hash
    JZ check_each_char
    JMP get_len_hash_other

;��hashֵƥ�������£�Դ��/�Ӵ���һ�ַ��ȶ�
check_each_char:
    SUB SI,len_sub    
    LEA DI,substr
    XOR CX,CX
nextchar:
    MOV AL,[DI]    
    CMP [SI],AL     ;�Ƚϵ�һ��
    JZ next1        ;��ͬ�����
    JMP get_len_hash_other;���򣬼�����һ������hash

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
