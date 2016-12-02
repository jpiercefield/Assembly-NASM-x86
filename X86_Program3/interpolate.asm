.386
.MODEL FLAT

EXTRN computeRecur_proc:NEAR32
EXTRN evalPolynomial_proc:NEAR32

INCLUDE float.h
INCLUDE io.h
INCLUDE sort_points.h


CR	EQU	0Dh                            ; carriage return character
LF	EQU	0Ah                            ; line feed 

PUBLIC interpolate_proc


inputArray  EQU [EBP + 24]  ; The address of index 0 of array (DWORD)
xCoord      EQU [EBP + 20]
sizeOfArray EQU [EBP + 18] 
Degree      EQU [EBP + 16]  ; +'s Are Params
CurrentDeg  EQU [EBP + 14]
CurTimes    EQU [EBP + 12]
CurIndex    EQU [EBP + 10]
InLim       EQU [EBP + 8]
localVar    EQU [EBP - 2]  ; -'s Are Local

.DATA
result REAL4 ?
text BYTE 8 DUP(?)
carriage BYTE " ", 0Dh, 0Ah, 0
Finished BYTE "The result: ", 0
.CODE

interpolate_proc PROC  NEAR32
    push EBP
    mov  EBP, ESP
    pushf

    fld REAL4 PTR [EBX+4]
    fstp result       ; Result now contains Y0, Incase Degree = 0

    mov AX, 1
    mov CurrentDeg, AX
    mov AX, 0
	cmp Degree, AX
    je DoneDegreeZero
    jmp DegreeHigherThanZero
   DoneDegreeZero:
        output carriage
		output Finished
        ftoa result, 5, 8, text
        output text
        jmp FinishedInter
    DegreeHigherThanZero:  
       mov SI, 1
       whileLoop: cmp SI, Degree
            jle InterLoop
            jmp OutputResult
            InterLoop:
                mov AX, 0
                mov CurTimes, AX
                mov AX, 1
                mov InLim, AX
                mov AX, 4
                mov CurIndex, AX
                push inputArray  
                pushw Degree    
                pushw CurrentDeg  
                pushw CurTimes    
                pushw CurIndex
                pushw InLim    
                call computeRecur_proc

                push inputArray
                push xCoord
                pushw CurrentDeg
                call evalPolynomial_proc
              
                fadd result
                fstp result
                               
                inc SI
                mov CurrentDeg, SI
                jmp whileLoop
            OutputResult:
                output carriage
                output Finished
                ftoa result, 5, 8, text
                output text
                jmp FinishedInter
        
    FinishedInter: ; When Completely Done

	popf
    pop EAX
    mov ESP, EBP
    pop EBP

    ret 20

interpolate_proc ENDP


END

