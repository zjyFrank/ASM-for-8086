; multi-segment executable file template.

data segment
    ; add your data here!
    INPUT DB 0
ends


code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax

    ; add your code here
            

    LEA SI,INPUT
    ; wait for any key....    
TST:    mov ah, 1
        int 21h
        CMP AL,0DH
        JZ NEXTLINE
        MOV INPUT[SI],AL 
        INC SI 
        JMP TST
NEXTLINE:   MOV DL,0DH
            MOV AH,02H
            INT 21H
            MOV DL,0AH
            MOV AH,02H
            INT 21H
            JMP TST

    
EXIT:    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
