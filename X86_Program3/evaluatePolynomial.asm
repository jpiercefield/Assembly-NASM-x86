.386
.MODEL FLAT

INCLUDE float.h
INCLUDE io.h

PUBLIC evalPolynomial_proc

inputArray EQU [EBP + 14]
xCoord     EQU [EBP + 10]
CurrentDeg EQU [EBP + 8]

.DATA
tempFloat REAL4 ?
tempFloatTw REAL4 ?
text BYTE "Testing..", 0
text2 BYTE 8 DUP(?)

.CODE

evalPolynomial_proc PROC NEAR32
    push EBP
    mov EBP, ESP
    pushf
   
    fst tempFloat    

    mov CX, 0

    stack_loop: cmp CurrentDeg, CX
        jne TheLoop
        jmp done_stack
    TheLoop:
        fstp tempFloatTw
        inc CX
        jmp stack_loop
    done_stack:

    mov DX, 0
    mov ECX, 0
    fld1
    
    startPoly_loop: cmp CurrentDeg, DX
        jne PolyLoop
        jmp donePoly_loop
    PolyLoop:
        fld REAL4 PTR xCoord
        fsub REAL4 PTR [EBX + ECX]
        fstp tempFloatTw
        fmul tempFloatTw
        add ECX, 8
        add DX, 1
        jmp startPoly_loop
    donePoly_loop:

    fmul tempFloat
    

    popf
    mov ESP, EBP
    pop EBP
    ret 10
evalPolynomial_proc ENDP

END
