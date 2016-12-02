.386
.MODEL FLAT

INCLUDE float.h

PUBLIC computeRecur_proc

inputArray  EQU [EBP + 18]  ; The address of index 0 of array (DWORD)
Degree      EQU [EBP + 16]  ; Word
CurrentDeg  EQU [EBP + 14]   ; Word
CurTimes    EQU [EBP + 12]  ; Word
CurIndex    EQU [EBP + 10]   ; Word
InLim       EQU [EBP + 8]  ; Word

.DATA
varTemp WORD 8 DUP(?)
spot WORD 8 DUP(?)
floatVar REAL4 ?
temp REAL4 ?
floatVar2 REAL4 ?

.CODE

computeRecur_proc  PROC NEAR32 
   push EBP
   mov EBP, ESP
   pushf

   fldz ; Load 0 onto stack
   fstp REAL4 PTR floatVar ; Pop stack, floatVar contains 0
   mov CX, 0
   cmp CurTimes, CX
   je CurTimesIsZero
   jmp CurTimesNotZero
   CurTimesIsZero: 
        ;= (F(Xn+1) - F(Xn)) / (Xn+1 - Xn)
        mov ECX, CurIndex      ;Begin =(F(Xn+1) - F(Xn))
        add ECX, 8
        mov EAX, REAL4 PTR [EBX + ECX]
        mov floatVar, EAX
        fld floatVar
        mov ECX, CurIndex
        fsub REAL4 PTR [EBX + ECX] ;End =(F(Xn+1) - F(Xn))
        fstp floatVar
        mov ECX, CurIndex       ;Begin = /(Xn+1 - Xn)
        add ECX, 4
        fld REAL4 PTR [EBX + ECX]
        mov ECX, CurIndex
        sub ECX, 4
        fsub REAL4 PTR [EBX + ECX]
        fstp floatVar2
        fld floatVar
        fdiv floatVar2      ; End = /(Xn+1 - Xn)     
        mov AX, 1
        cmp Degree, AX
        je DegreeEqual
        jmp DegreeNotEqual
        DegreeEqual:
            jmp Done
        DegreeNotEqual:
            cmp CurrentDeg, AX
            je TheCurDegIsOne
            jmp TheCurDegNotOne
            TheCurDegIsOne:
                jmp Done
            TheCurDegNotOne:
                cmp InLim, AX
                je InLimEquOne
                jmp InLimNotOne
                InLimEquOne:
                    mov AX, InLim
                    inc AX
                    mov InLim, AX
                    mov AX, CurIndex
                    add AX, 8
                    mov CurIndex, AX
                    push inputArray  
                    pushw Degree    
                    pushw CurrentDeg  
                    pushw CurTimes    
                    pushw CurIndex
                    pushw InLim
                    call computeRecur_proc
                    jmp Done ;LOLOL -_- (4 Hour Bug)
                InLimNotOne:
                    mov AX, CurTimes
                    inc AX
                    mov CurTimes, AX
                    push inputArray  
                    pushw Degree    
                    pushw CurrentDeg  
                    pushw CurTimes    
                    pushw CurIndex
                    pushw InLim
                    call computeRecur_proc
                    jmp Done  ;LOLOL -_- (4 Hour Bug)
   CurTimesNotZero:
        fst temp
        mov AX, InLim   
        sub AX, CurTimes
        mov spot, AX
        cmp spot, 1   ; mov 1 To AX first? Compare Spot to AX?
        je ThisOne 
        jmp NotOne
        ThisOne:
	        fxch ST(1)
            jmp FinFx
        NotOne:
            cmp spot, 2
            je ThisTwo
            jmp NotTwo
            ThisTwo: 
                fxch ST(2)
                jmp FinFx
            NotTwo:
                cmp spot, 3
                je ThisThree
                jmp NotThree
                ThisThree:
                    fxch ST(3)
                    jmp FinFx
                NotThree:
                    cmp spot, 4
                    je ThisFour
                    jmp NotFour
                    ThisFour:
                        fxch ST(4)
                        jmp FinFx
                    NotFour:
                        cmp spot, 5
                        je ThisFive
                        jmp NotFive
                        ThisFive:
                            fxch ST(5)
                            jmp FinFx
                        NotFive:
                            cmp spot, 6
                            je ThisSix
                            jmp NotSix
                        ThisSix:
                            fxch ST(6)
                            jmp FinFx
                        NotSix:
                            fxch ST(7)
                            jmp FinFx
        FinFx:
            fstp floatVar
            fld temp
            fsub floatVar 
            fstp floatVar

            mov AX, InLim ;Start finding Xn  
            mov CX, 8 
            mul CX
            mov varTemp, AX
            movzx ECX, varTemp
            fld REAL4 PTR [EBX + ECX] ;End finding Xn
            
            mov AX, InLim        ;Find Xm 
            sub AX, CurTimes
            DEC AX
            mov CX, 8
            mul CX
            mov varTemp, AX
            movzx ECX, varTemp       ;End find Xm
            fsub REAL4 PTR [EBX + ECX]   ; Xn-Xm
            fstp floatVar2
            fld floatVar
            fdiv floatVar2

            mov AX, InLim         
            DEC AX
            cmp CurTimes, AX
            je CurTimesLimCurDeg
            jmp CurTimesNotReachedLim
            CurTimesLimCurDeg:
                mov AX, InLim         
                cmp CurrentDeg, AX            
                jne CurDegNotReachedLim
                jmp Done 
                CurDegNotReachedLim:
                    mov AX, 0
                    mov CurTimes, AX
                    mov AX, InLim    
                    inc AX
                    mov InLim, AX    
                    mov AX, CurIndex                 
                    add AX, 8
                    mov CurIndex, AX
                    push inputArray  
                    pushw Degree    
                    pushw CurrentDeg  
                    pushw CurTimes    
                    pushw CurIndex
                    pushw InLim
                    call computeRecur_proc
                    jmp Done   ; LOLOL -_- (4 Hour Bug)
            CurTimesNotReachedLim:
                mov AX, CurTimes
                inc AX
                mov CurTimes, AX
                push inputArray  
                pushw Degree    
                pushw CurrentDeg  
                pushw CurTimes    
                pushw CurIndex
                pushw InLim
                call computeRecur_proc
                jmp Done   ;LOLOL -_- (4 Hour Bug)
   Done:
        popf
        mov esp, ebp
        pop ebp
        ret 14
computeRecur_proc ENDP

END