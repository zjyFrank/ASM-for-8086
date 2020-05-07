; multi-segment executable file template.

DATA SEGMENT
    Buff DW 40 DUP(2,1,0,-1,-2) ;40*5=200 word
    N1 DW 0 ;正数
    N2 DW 0 ;0
    N3 DW 0 ;负数
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX  
    LEA SI,Buff
    LEA AX,Buff
    ADD AX,200*2
CNT:CMP SI,AX   ;全部遍历结束则quit
    JZ DONE
    CMP [SI],0  ;逐个和0比较
    JG POSN
    JE ZERO
    JL NEGN
NEXT:INC SI
     INC SI 
     JMP CNT

POSN: INC N1
      JMP NEXT
ZERO: INC N2
      JMP NEXT
NEGN: INC N3
      JMP NEXT
   
DONE:MOV AH,4CH
     INT 21H
CODE ENDS
    END START
