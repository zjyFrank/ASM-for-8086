nextline MACRO
    MOV DL,0DH  ;��ʾ�س�
    MOV AH,02H
    INT 21H
    MOV DL,0AH  ;��ʾ����
    MOV AH,02H
    INT 21H
ENDM

mspace MACRO
    MOV DL,' '  ;��ʾ�ո�
    MOV AH,02H
    INT 21H
ENDM

;����emu8086��֧�ֽṹ�壬��masm�ĵ��Թ��ڷ�������'α��ά����(StuInfo[BX][DI])'ģ��һ���ṹ��(Student[index].prop)
;   Student STRUC 
;	    stu_name    DB  4 DUP(0)
;	    class   	DB  2 DUP(0)
;	    id      	DB 10 DUP(0)
;	    score   	DW  0
;	Student ENDS
DATA SEGMENT
	stu_name    EQU 0
    class   	EQU 5
    id      	EQU 10
    score   	EQU 15
    InfoLen     EQU 20
    StuInfo DB 10 DUP(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','$') 
;----------------------------------------------test data-------------------------------------------    
;    StuInfo DB      'Z','J','Y',' ',' ','2','0','4',' ',' ','9','6','2',' ',' ','9','2','.','1','$'
;            DB      'S','Q',' ',' ',' ','2','0','4',' ',' ','9','2','7',' ',' ','8','9','.','9','$'
;            DB      'G','G','Z',' ',' ','2','0','4',' ',' ','9','6','6',' ',' ','6','5','.','7','$'
;            DB      'Z','Q',' ',' ',' ','2','0','1',' ',' ','9','3','2',' ',' ','7','5','.','4','$'
;            DB      'Q','J','Y',' ',' ','2','0','3',' ',' ','6','6','6',' ',' ','4','9','.','7','$'
;            DB      'W','J','W',' ',' ','2','0','8',' ',' ','2','3','4',' ',' ','4','9','.','8','$'
;            DB      'L','M','H',' ',' ','2','0','7',' ',' ','1','7','7',' ',' ','8','2','.','3','$'
;            DB      'C','A','Q',' ',' ','2','0','4',' ',' ','6','0','5',' ',' ','9','8','.','5','$'
;            DB      'Z','T','G',' ',' ','2','1','1',' ',' ','3','6','8',' ',' ','1','0','0',' ','$'
;    TOTAL   DB 9
;---------------------------------------------------------------------------------------------------    
    TOTAL   DB 0
    SUM     DW 0 
    NUM_DQ  DB 0
    NUM_67  DB 0
    NUM_78  DB 0
    NUM_89  DB 0
    NUM_90  DB 0
    AVER    DB 5 DUP(0)
    i       DB 0
    j       DB 0
    INDEX_ARRAY DW 0,1,2,3,4,5,6,7,8,9
    SCORE_ARRAY DW 10 DUP(0)
    ID_ARRAY    DW 10 DUP(0)
    NAME_ARRAY  DW 10 DUP(0)
    SORT_FLAG DB 0        ;ð�������־�� 1 for ����0 for ����
    SORTTYPE_FLAG   DB 0  ;1 for ѧ�ţ�2 for ����
    IDtoSEARCH      DB 4 DUP(0)
    NAMEtoSEARCH    DB 4 DUP(0)
    MENU    DB  0DH,0AH 
            DB '****************MENU*****************',0DH,0AH ;0DH,0AH=\r\n
            DB '*1.Input Student Info               *',0DH,0AH
            DB '*2.Sort by student ID or Score      *',0DH,0AH
            DB '*3.Show Average Score               *',0DH,0AH
            DB '*4.Show Score Distribution          *',0DH,0AH
            DB '*5.Search Student Info              *',0DH,0AH
            DB '*6.EXIT                             *',0DH,0AH
            DB '*Please enter FUNCTION No.          *',0DH,0AH
            DB '*************************************',0DH,0AH,'$'
    SORT_M  DB  0DH,0AH
            DB ' --------SORT MENU--------- ',0DH,0AH ;0DH,0AH=\r\n
            DB '|1.Sort with student ID    |',0DH,0AH
            DB '|2.Sort with student Score |',0DH,0AH
            DB '|3.EXIT SORT               |',0DH,0AH
            DB '|Please enter FUNCTION No. |',0DH,0AH
            DB ' -------------------------- ',0DH,0AH,'$'
    SEARCH_M    DB  0DH,0AH
            DB ' --------SEARCH MENU-------- ',0DH,0AH ;0DH,0AH=\r\n
            DB '|1.SEARCH with student ID   |',0DH,0AH
            DB '|2.SEARCH with student Name |',0DH,0AH
            DB '|3.EXIT SEARCH              |',0DH,0AH
            DB '|Please enter FUNCTION No.  |',0DH,0AH
            DB ' --------------------------- ',0DH,0AH,'$'
    STR1 DB 0DH,0AH,'Please enter the total number of students : ','$'
    STR2 DB 0DH,0AH,'Illegal input,must be integer below 256 : ','$'
    STR3 DB 0DH,0AH,'Please input student ','$'
    STR_NAME    DB 0DH,0AH,'@Name  : ','$'
    STR_CLASS   DB 0DH,0AH,'@Class: ','$'
    STR_ID      DB 0DH,0AH,'@ID    : ','$'
    STR_SCORE   DB 0DH,0AH,'@Score: ','$'
    STR_TITLE   DB 0DH,0AH,'Rank Name  Class  ID  Score','$'
    STR_AVERAGE DB 0DH,0AH,'Average Score is : ','$'
    STR_DISTRIB DB 0DH,0AH,'Score Distribution','$'
    STR_DQ      DB 0DH,0AH,'Disqualified : ','$'
    STR_67      DB 0DH,0AH,'60<=S<70     : ','$'
    STR_78      DB 0DH,0AH,'70<=S<80     : ','$'
    STR_89      DB 0DH,0AH,'80<=S<90     : ','$'
    STR_90      DB 0DH,0AH,'90<=S<=100   : ','$'
    STR_SEARCH_ID   DB 0DH,0AH,'Please enter the ID to search : ','$'
    STR_SEARCH_NAME DB 0DH,0AH,'Please enter the Name to search : ','$'
    STR_RSLT    DB 0DH,0AH,'Result : ',0DH,0AH,'$' 
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
menu_sel:   
    MOV AH,09H
    LEA DX,MENU
    INT 21H
    
    MOV AH,01H  ;���ڲ���AL
    INT 21H
    
    CMP AL,'1'
    JB menu_sel
    CMP AL,'6'
    JA menu_sel
        
    SUB AL,30H    
    CMP AL,1
    JZ P1
    CMP AL,2
    JZ P2
    CMP AL,3
    JZ P3
    CMP AL,4
    JZ P4
    CMP AL,5
    JZ P5
    CMP AL,6
    JZ P6
    
P1: CALL INFO
    JMP menu_sel
P2: CALL SORT
    JMP menu_sel
P3: CALL AVERAGE
    JMP menu_sel
P4: CALL DISTRIBUTION
    JMP menu_sel   
P5: CALL SEARCH
    JMP menu_sel 
P6: MOV AH,4CH
    INT 21H
;*************************FUNCTION**************************
;
;******************************************************************************************************
;	@FuncName:	    INFO
;	@Description:	Input student info 
;******************************************************************************************************
INFO PROC
    MOV AH,09H
    LEA DX,STR1
    INT 21H
    ;------------------------    
    stu_total:
            XOR  BL,BL   ; ��������������ʽ�ĳ�ֵ
            MOV  CX,10   ;  BL = BL*10+AL  ������������֣�������һ��������
             
        scan:
            MOV AH,01H  ;����
            INT 21H
            CMP AL,0DH  ;�����Իس�����
            JZ save_total
            CMP AL,30H  ;��'0'С�����Ƿ����룩
            JB  illg
            CMP AL,39H  ;��'9'�󣨷Ƿ����룩
            JA  illg
            SUB AL,30H  ;ASCIIתΪ���� 
            XCHG AL,BL  
            MUL CX      ;AL*10  
            XCHG AL,BL
            ADD BL,AL   ;��Ч BL *10 +AL  
            JMP scan
        
        illg:
            MOV AH,09H
            LEA DX,STR2
            INT 21H
            JMP scan
        save_total:    
            MOV TOTAL,BL                       
    ;----------------------------------
    XOR CX,CX
    MOV CL,TOTAL;ѭ������TOTAL��
    XOR BX,BX   ;clear BX
stu_i:    
    MOV AH,09H  ;�������BX��ѧ������Ϣ
    LEA DX,STR3
    INT 21H
    
    INC BX
    PUSH BX    ;PUSH�Ĳ�����������16λ
    ADD BX,30H
    MOV DL,BL
    MOV AH,02H
    INT 21H
    
    MOV DL,':'
    MOV AH,02H
    INT 21H
    
    CALL READNAME
    CALL READCLASS
    CALL READID
    CALL READSCORE
    nextline
    
    POP BX
    LOOP stu_i        
 
    RET 
INFO ENDP
;----------------------------------------------------
NEXTCHAR PROC
    newchar:
        MOV AH,01H
        INT 21H
        CMP AL,0DH
        JZ nameend
        MOV [SI],AL
        INC SI
        JMP newchar
    nameend:
    RET
NEXTCHAR ENDP    
;��������
READNAME PROC
    LEA DX,STR_NAME
    MOV AH,09H
    INT 21H
    SUB BX,31H  ;BX=BX-30H-1H
    MOV AL,BL   ;�������ŵ�AL
    MOV BH,InfoLen
    MUL BH      ;BL*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    MOV DI,stu_name
    LEA SI,StuInfo[BX][DI]  ;ָ���i��ͬѧ����������student[i].name
    CALL NEXTCHAR
    RET
READNAME ENDP
;����༶
READCLASS PROC
    LEA DX,STR_CLASS
    MOV AH,09H
    INT 21H             
    MOV DI,class
    LEA SI,StuInfo[BX][DI]  ;ָ���i��ͬѧ�İ༶����student[i].class
    CALL NEXTCHAR
    RET
READCLASS ENDP
;����ѧ��
READID PROC
    LEA DX,STR_ID
    MOV AH,09H
    INT 21H             
    MOV DI,id
    LEA SI,StuInfo[BX][DI]  ;ָ���i��ͬѧ��ѧ�ţ���student[i].id
    CALL NEXTCHAR
    RET
READID ENDP
;�������
READSCORE PROC
    LEA DX,STR_SCORE
    MOV AH,09H
    INT 21H             
    MOV DI,score
    LEA SI,StuInfo[BX][DI]  ;ָ���i��ͬѧ��ѧ�ţ���student[i].id
    CALL NEXTCHAR
    RET
READSCORE ENDP        
;----------------------------------------------------
;******************************************************************************************************
;	@FuncName:	    SORT
;	@Description:	Sort by student ID(1) or Score(2) 
;******************************************************************************************************                  
SORT PROC
sortmenu_sel:    
    LEA DX,SORT_M
    MOV AH,09H
    INT 21H
    
    MOV AH,01H  ;���ڲ���AL
    INT 21H
    CMP AL,'1'
    JB sortmenu_sel
    CMP AL,'3'
    JA sortmenu_sel
    SUB AL,30H
        
    CMP AL,1
    JZ S1
    CMP AL,2
    JZ S2
    CMP AL,3
    JZ S3
    
S1: CALL SORT_ID
    JMP sortmenu_sel
S2: CALL SORT_SCORE
    JMP sortmenu_sel  
S3: RET

SORT ENDP
;-----------------------------
;��ѧ������ (����)
SORT_ID PROC
    XOR CX,CX
    MOV CL,TOTAL
    XOR BX,BX
    LEA SI,ID_ARRAY    
id_array_append:
    PUSH SI
    MOV SUM,0
    CALL ID2NUM
    POP SI
    MOV DX,SUM
    MOV [SI],DX
    INC SI
    INC SI
    LOOP id_array_append
    
    MOV SORTTYPE_FLAG,1
    MOV SORT_FLAG,1     ;�����־
    CALL BUBBLE_SORT    ;����ð������
    ;��ʾ
    LEA DX,STR_TITLE    
    MOV AH,09H
    INT 21H
    nextline
    LEA SI,INDEX_ARRAY
    
    XOR CX,CX
    MOV CL,TOTAL
    XOR DX,DX       
    MOV DX,1
show_id_sort:    
    ;��ӡrank
    PUSH DX
    ADD DX,30H
    MOV AH,02H
    INT 21H
    mspace
    mspace
    mspace
    mspace  
    mspace
    mspace  ;��ӡ�ո�
    
    MOV AL,[SI]     ;�������ŵ�AL
    MOV BH,InfoLen
    MUL BH          ;[SI]*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    
    LEA DX,StuInfo[BX]  ;ȡ��i��ͬѧ����Ϣ
    MOV AH,09H
    INT 21H
    
    INC SI
    INC SI          ;ָ����һ������
    nextline
    POP DX
    INC DX
    
    LOOP show_id_sort
    ;�����������飬�ȴ���һ��ʹ��
    XOR AX,AX
    XOR CX,CX
    MOV CL,TOTAL
    LEA SI,INDEX_ARRAY
reset_index:
    MOV [SI],AX
    INC AX
    INC SI
    INC SI
    LOOP reset_index
    
    RET
SORT_ID ENDP 
;-----------------------------
;���������򣨽���
SORT_SCORE PROC
    XOR CX,CX
    MOV CL,TOTAL
    XOR BX,BX
    LEA SI,SCORE_ARRAY    
score_array_append:
    PUSH SI
    MOV SUM,0
    CALL STR2NUM
    POP SI
    MOV DX,SUM
    MOV [SI],DX
    INC SI
    INC SI
    LOOP score_array_append
                           
    MOV SORTTYPE_FLAG,2
    MOV SORT_FLAG,0     ;�����־
    CALL BUBBLE_SORT    ;����ð������
    ;��ʾ
    LEA DX,STR_TITLE    
    MOV AH,09H
    INT 21H
    nextline
    LEA SI,INDEX_ARRAY
    
    XOR CX,CX
    MOV CL,TOTAL
    XOR DX,DX       
    MOV DX,1
show_score_sort:    
    ;��ӡrank
    PUSH DX
    ADD DX,30H
    MOV AH,02H
    INT 21H
    mspace
    mspace
    mspace
    mspace  
    mspace
    mspace  ;��ӡ�ո�
    
    MOV AL,[SI]     ;�������ŵ�AL
    MOV BH,InfoLen
    MUL BH          ;[SI]*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    
    LEA DX,StuInfo[BX]  ;ȡ��i��ͬѧ����Ϣ
    MOV AH,09H
    INT 21H
    
    INC SI
    INC SI          ;ָ����һ������
    nextline
    POP DX
    INC DX
    
    LOOP show_score_sort
    ;�����������飬�ȴ���һ��ʹ��
    XOR AX,AX
    XOR CX,CX
    MOV CL,TOTAL
    LEA SI,INDEX_ARRAY
reset_index_1:
    MOV [SI],AX
    INC AX
    INC SI
    INC SI
    LOOP reset_index_1
    
    RET
SORT_SCORE ENDP
;-----------------------------
;ð������(����)
BUBBLE_SORT PROC     
    XOR AX,AX
    MOV AH,TOTAL
    SUB AH,1        ;AH=TOTAL-1
    MOV i,0

for1:
    CMP i,AH        ;IF i<TOTAL-1
    JAE endfor1
    MOV j,0
    MOV AL,AH
    SUB AL,i        ;AL=TOTAL-1-i
    CMP SORTTYPE_FLAG,1
    JE sortby_id
    JMP sortby_score
sortby_id:
    LEA SI,ID_ARRAY     ;SIָ��ѧ������
    JMP next1
sortby_score:
    LEA SI,SCORE_ARRAY  ;SIָ���������
next1:
    LEA DI,INDEX_ARRAY  ;DIָ������������������
    for2:
        CMP j,AL
        JAE endfor2
        
        CMP SORT_FLAG,0
        JE sort_down
        JMP sort_up
sort_down:              ;����
        MOV CX,[SI+2]   
        CMP [SI],CX     ;CMP�����������������ͬʱΪ�洢��
        JB swap         
        JMP notswap
sort_up:                ;����
        MOV CX,[SI+2]   
        CMP [SI],CX     
        JA swap         
        JMP notswap 
swap:   MOV DX,[SI]     ;�����ɼ�
        MOV [SI+2],DX   ;[SI]->[SI+2]
        MOV [SI],CX     ;[SI+2]->[SI]
        MOV CX,[DI+2]   ;��������
        MOV DX,[DI]
        MOV [DI+2],DX   ;[DI]->[DI+2]
        MOV [DI],CX     ;[DI+2]->[DI]
        notswap:
        INC SI
        INC SI
        INC DI
        INC DI
        
        INC j
        JMP for2
    endfor2:
    INC i           ;AL++
    JMP for1 
endfor1:
    RET
BUBBLE_SORT ENDP
;-----------------------------
;ѧ��ת��Ϊ����
ID2NUM PROC
    PUSH BX     ;ѹBX
    XOR AX,AX
    MOV AL,BL   ;�������ŵ�AL
    MOV BH,InfoLen
    MUL BH      ;BL*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    
    MOV DI,id
    LEA SI,StuInfo[BX][DI]  ;ȡ��i��ͬѧ��ѧ��
    POP BX      ;��BX
    INC BX
    
    MOV AL,[SI]     ;ȡѧ���ַ����ĵ�1���ַ�
    SUB AL,30H
    MOV DL,100      ;��Ϊ��λ
    MUL DL
    ADD SUM,AX
    MOV AL,[SI+1]   ;ȡѧ���ַ����ĵ�2���ַ�
    SUB AL,30H
    MOV DL,10       ;��Ϊʮλ
    MUL DL
    ADD SUM,AX      
    MOV AL,[SI+2]   ;ȡѧ���ַ����ĵ�3���ַ�����Ϊ��λ
    SUB AL,30H
    XOR AH,AH
    ADD SUM,AX
     
    RET
ID2NUM ENDP 
;******************************************************************************************************
;	@FuncName:	    AVERAGE
;	@Description:	Show Average Score 
;****************************************************************************************************** 
AVERAGE PROC
    XOR CX,CX
    MOV CL,TOTAL
    XOR BX,BX
    MOV SUM,0
score_sum:
    CALL STR2NUM
    LOOP score_sum
    
    XOR DX,DX
    XOR CX,CX
    MOV AX,SUM
    MOV CL,TOTAL
    DIV CX          ;������DX
    PUSH AX         ;����AX
    
    MOV AL,DL       ;��������AL(8λ��)  
    MOV CL,10
    MUL CL          ;����*10,����AX
                    ;��������AX(8λ��)
    MOV CL,TOTAL 
    DIV CL
    
    CMP AL,5
    POP AX
    JGE roundup   ;5��
    JMP roundoff  ;4��
roundup:          ;С������2λ��������
    ADD AX,1
roundoff:    
    LEA SI,AVER
    MOV DL,100    ;XYZ/100ȡʮλ
    DIV DL        ;����YZ��AH
    ADD AL,30H
    MOV [SI],AL   ;��X��AL
    MOV AL,AH     ;YZ�ŵ�AX��Ϊ������
    XOR AH,AH
    MOV DL,10
    DIV DL
    ADD AL,30H
    MOV [SI+1],AL
    MOV [SI+2],'.'
    ADD AH,30H
    MOV [SI+3],AH
    MOV [SI+4],'$'
    
    LEA DX,STR_AVERAGE
    MOV AH,09H
    INT 21H
    LEA DX,AVER
    MOV AH,09H
    INT 21H
    nextline
    RET
AVERAGE ENDP    
;******************************************************************************************************
;	@FuncName:	    DISTRIBUTION
;	@Description:	Show Score Distribution 
;******************************************************************************************************
DISTRIBUTION PROC
    XOR CX,CX
    MOV CL,TOTAL
    XOR BX,BX
score_distrib:
    MOV SUM,0
    CALL STR2NUM  
    CMP SUM,600
    JB score_dq
    CMP SUM,700
    JB score_67
    CMP SUM,800
    JB score_78
    CMP SUM,900
    JB score_89
    JMP score_90
    
score_dq:
    INC NUM_DQ
    JMP next    
score_67:
    INC NUM_67
    JMP next     
score_78:
    INC NUM_78 
    JMP next 
score_89:
    INC NUM_89 
    JMP next     
score_90:
    INC NUM_90
    JMP next 
next:
    LOOP score_distrib
    
    LEA DX,STR_DQ
    MOV ah,09H
    INT 21H
    MOV DL,NUM_DQ
    ADD DL,30H
    MOV AH,02H
    INT 21H
    
    LEA DX,STR_67
    MOV ah,09H
    INT 21H
    MOV DL,NUM_67
    ADD DL,30H
    MOV AH,02H
    INT 21H
    
    LEA DX,STR_78
    MOV ah,09H
    INT 21H
    MOV DL,NUM_78
    ADD DL,30H
    MOV AH,02H
    INT 21H
    
    LEA DX,STR_89
    MOV ah,09H
    INT 21H
    MOV DL,NUM_89
    ADD DL,30H
    MOV AH,02H
    INT 21H
    
    LEA DX,STR_90
    MOV ah,09H
    INT 21H
    MOV DL,NUM_90
    ADD DL,30H
    MOV AH,02H
    INT 21H
    nextline
    nextline
    RET
DISTRIBUTION ENDP
;�ַ���ת��Ϊ����
STR2NUM PROC
    PUSH BX     ;ѹBX
    XOR AX,AX
    MOV AL,BL   ;�������ŵ�AL
    MOV BH,InfoLen
    MUL BH      ;BL*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    
    MOV DI,score
    LEA SI,StuInfo[BX][DI]  ;ȡ��i��ͬѧ�ĳɼ�
    POP BX      ;��BX
    INC BX
    
    MOV AL,[SI+2]   ;ȡ�ɼ��ַ����ĵ�3���ַ�
    SUB AL,30H
    CMP AL,0
    JZ score_100    ;���Ϊ0��scoreΪ100��
    
    MOV AL,[SI]     ;ȡ�ɼ��ַ����ĵ�1���ַ�
    SUB AL,30H
    MOV DL,100      ;��Ϊ��λ
    MUL DL
    ADD SUM,AX
    MOV AL,[SI+1]   ;ȡ�ɼ��ַ����ĵ�2���ַ�
    SUB AL,30H
    MOV DL,10       ;��Ϊʮλ
    MUL DL
    ADD SUM,AX      
    MOV AL,[SI+3]   ;ȡ�ɼ��ַ����ĵ�4���ַ�����Ϊ��λ
    SUB AL,30H
    XOR AH,AH
    ADD SUM,AX
    JMP not_100
score_100:
    ADD SUM,1000
not_100:        
    RET
STR2NUM ENDP 
;******************************************************************************************************
;	@FuncName:	    SEARCH
;	@Description:	Search by student ID(1) or Name(2) 
;******************************************************************************************************
SEARCH PROC
    searchmenu_sel:    
    LEA DX,SEARCH_M
    MOV AH,09H
    INT 21H
    
    MOV AH,01H  ;���ڲ���AL
    INT 21H
    CMP AL,'1'
    JB searchmenu_sel
    CMP AL,'3'
    JA searchmenu_sel
    SUB AL,30H
        
    CMP AL,1
    JZ SH1
    CMP AL,2
    JZ SH2
    CMP AL,3
    JZ SH3
    
SH1: CALL SEARCH_ID
    JMP searchmenu_sel
SH2: CALL SEARCH_NAME
    JMP searchmenu_sel  
SH3: RET    
SEARCH ENDP    
;-----------------------------
;��ѧ�Ų�ѯѧ����Ϣ 
SEARCH_ID PROC
    MOV SUM,0
    LEA DX,STR_SEARCH_ID
    MOV AH,09H
    INT 21H
    
    LEA SI,IDtoSEARCH
    PUSH SI
    CALL NEXTCHAR
    nextline
    POP SI  
    
    MOV AL,[SI]     ;ȡѧ���ַ����ĵ�1���ַ�
    SUB AL,30H
    MOV DL,100      ;��Ϊ��λ
    MUL DL
    ADD SUM,AX
    MOV AL,[SI+1]   ;ȡѧ���ַ����ĵ�2���ַ�
    SUB AL,30H
    MOV DL,10       ;��Ϊʮλ
    MUL DL
    ADD SUM,AX      
    MOV AL,[SI+2]   ;ȡѧ���ַ����ĵ�3���ַ�����Ϊ��λ
    SUB AL,30H
    XOR AH,AH
    ADD SUM,AX
    PUSH SUM        ;ѹջSUM
    
    XOR CX,CX
    MOV CL,TOTAL
    XOR BX,BX
    LEA SI,ID_ARRAY    
id_array_append_1:
    PUSH SI
    MOV SUM,0
    CALL ID2NUM
    POP SI
    MOV DX,SUM
    MOV [SI],DX
    INC SI
    INC SI
    LOOP id_array_append_1
    
    XOR CX,CX
    MOV CL,TOTAL    
    POP SUM         ;��ջSUM
    XOR AX,AX
    LEA SI,ID_ARRAY
compare_id:                    
    MOV DX,[SI]
    CMP SUM,DX
    JZ findout
    INC SI
    INC SI
    INC AL
    LOOP compare_id
    
findout:
    MOV BH,InfoLen  ;��������AL��
    MUL BH          ;[SI]*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    LEA DX,STR_RSLT
    MOV AH,09H
    INT 21H
    LEA DX,StuInfo[BX]  ;ȡ��i��ͬѧ����Ϣ
    MOV AH,09H
    INT 21H
    
    RET
SEARCH_ID ENDP 
;-----------------------------
;��������ѯѧ����Ϣ
SEARCH_NAME PROC
    MOV SUM,0
    ;����NAMEtoSEARCH
    LEA SI,NAMEtoSEARCH
    MOV CX,4
clear_NAMEtoSEARCH:
    MOV [SI],0000H
    ADD SI,2
    LOOP clear_NAMEtoSEARCH
    
    LEA DX,STR_SEARCH_NAME
    MOV AH,09H
    INT 21H
    
    LEA SI,NAMEtoSEARCH
    PUSH SI
    CALL NEXTCHAR
    nextline
    POP SI  
    
    MOV AL,[SI]     ;ȡ�����ַ����ĵ�1���ַ�
    SUB AL,30H
    MOV DL,100      ;��Ϊ��λ
    MUL DL
    ADD SUM,AX
    MOV AL,[SI+1]   ;ȡ�����ַ����ĵ�2���ַ�
    SUB AL,30H
    MOV DL,10       ;��Ϊʮλ
    MUL DL
    ADD SUM,AX      
    MOV AL,[SI+2]   ;ȡ�����ַ����ĵ�3���ַ�����Ϊ��λ
    
    CMP AL,0
    JZ name_with2word_1
    JMP name_with3word_1
name_with2word_1:
    JMP next3
name_with3word_1:   
    SUB AL,30H
next3:    
    XOR AH,AH
    ADD SUM,AX
    PUSH SUM        ;ѹջSUM
    
    XOR CX,CX
    MOV CL,TOTAL
    XOR BX,BX
    LEA SI,NAME_ARRAY    
name_array_append_1:
    PUSH SI
    MOV SUM,0
    CALL NAME2NUM
    POP SI
    MOV DX,SUM
    MOV [SI],DX
    INC SI
    INC SI
    LOOP name_array_append_1
    
    XOR CX,CX
    MOV CL,TOTAL    
    POP SUM         ;��ջSUM
    XOR AX,AX
    LEA SI,NAME_ARRAY
compare_name:                    
    MOV DX,[SI]
    CMP SUM,DX
    JZ findout
    INC SI
    INC SI
    INC AL
    LOOP compare_name
    
findout_1:
    MOV BH,InfoLen  ;��������AL��
    MUL BH          ;[SI]*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    LEA DX,STR_RSLT
    MOV AH,09H
    INT 21H
    LEA DX,StuInfo[BX]  ;ȡ��i��ͬѧ����Ϣ
    MOV AH,09H
    INT 21H
    
    RET
SEARCH_NAME ENDP
;����ת��Ϊ����
NAME2NUM PROC
    PUSH BX     ;ѹBX
    XOR AX,AX
    MOV AL,BL   ;�������ŵ�AL
    MOV BH,InfoLen
    MUL BH      ;BL*20,ÿ��ѧ������Ϣռ20Byte
    MOV BX,AX
    XOR AX,AX
    
    MOV DI,stu_name
    LEA SI,StuInfo[BX][DI]  ;ȡ��i��ͬѧ������
    POP BX      ;��BX
    INC BX
    
    MOV AL,[SI]     ;ȡ�����ַ����ĵ�1���ַ�
    SUB AL,30H
    MOV DL,100      ;��Ϊ��λ
    MUL DL
    ADD SUM,AX
    MOV AL,[SI+1]   ;ȡ�����ַ����ĵ�2���ַ�
    SUB AL,30H
    MOV DL,10       ;��Ϊʮλ
    MUL DL
    ADD SUM,AX      
    MOV AL,[SI+2]   ;ȡ�����ַ����ĵ�3���ַ�
    CMP AL,' '
    JZ name_with2word
    JMP name_with3word
name_with2word:
    SUB AL,20H      ;�������Ϊ2���֣���ŵ������ֵĵط��Ŀո��Ϊ0
    JMP next2
name_with3word:        
    SUB AL,30H
next2:
    XOR AH,AH
    ADD SUM,AX
        
    RET
NAME2NUM ENDP 

CODE ENDS
    END START