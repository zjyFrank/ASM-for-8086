; multi-segment executable file template.

DATA SEGMENT
    a DW 3
    b DW 4
    c DW 5
    CF DW 0
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX
;c<a+b    
        XOR AX,AX
        ADD AX,a
        ADD AX,b
        CMP c,AX
        JL NEXT1
        JMP FAIL
;b<a+c    
NEXT1:  XOR AX,AX
        ADD AX,a
        ADD AX,c
        CMP b,AX
        JL NEXT2
        JMP FAIL
;a<b+c
NEXT2:  XOR AX,AX
        ADD AX,b
        ADD AX,c
        CMP a,AX
        JL SUCCESS
        JMP FAIL        
FAIL:   MOV CF,0
        JMP DONE
SUCCESS:MOV CF,1
DONE:   MOV AH,4CH
        INT 21H
CODE ENDS
    END START
