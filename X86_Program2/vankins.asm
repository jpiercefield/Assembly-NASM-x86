; Vankin's Mile: Program 2 - Assembly 3410
; Author: James L. Piercefied
; Date: Start 9/29/2016 revised 10/02/2016

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h                       ; header file for input/output
INCLUDE debug.h

                                    ; simple text replacement
CR	EQU	0Dh                         ; carriage return character
LF	EQU	0Ah                         ; line feed  

MAXNBRS   EQU   100                 ;Max size of array - NxM has to be less than 100 (assigns 100 to MAXNBRS)

.STACK    4096                      ; reserve 4096-byte stack

.DATA                               ;Reserve storage for data - Order - DWORD, WORD, BYTE

inputArray    DWORD    MAXNBRS DUP (?) 
ArrayShift    DWORD    8       DUP (?) 
Nrow          WORD     8       DUP (?)
Mcolumn       WORD     8       DUP (?)
MandNTotal    WORD     8       DUP (?)
string        BYTE     8       DUP (?)
lineOut       BYTE     200     DUP (?)
StrRight      BYTE     "r", 0
StrDown       BYTE     "d", 0

.CODE
GetMandN	MACRO Nrow, Mcolumn   ;(y,x)
    input  string, 8              ;Read ASCII Chars.
    atod   string                 ;Convert to integer
    mov    Nrow, AX
    input  string, 8
    atod   string
    mov    Mcolumn, AX
    ENDM

GetInputGrid MACRO Nrow, Mcolumn, MandNTotal, inputArray
    LOCAL body, whileNotDone, endWhile
    mul   Nrow
    mov   MandNTotal, AX
    mov   DI, 0
    lea EBX, inputArray                         ;"loader changes the 'immediate' to the absolute address"
    whileNotDone: cmp  DI, MandNTotal           ; DI < Total?
          jl  short body                          ; Execute 'body' if so
          jmp endWhile                            ; Else Execute 'endWhile'
    body:
        input string, 8
        atod  string
        mov [ebx], eax
        cmp SI, Mcolumn
        add   ebx, 4
        inc   DI
        jmp  whileNotDone
    endWhile:
    ENDM

DisplayInputGrid MACRO Mcolumn, MandNTotal, inputArray
   LOCAL Mcolumn, MandNTotal, inputArray, whileNotFinish, body, endWhile, NotEndLine, EndLine, theNext
   lea EBX, inputArray
   mov DI, 0
   mov SI, 1
   whileNotFinish: cmp DI, MandNTotal           ;SI < AX?
            jl short body                      ; Execute 'body' if so
            jmp short endWhile                 ; Else Execute 'endWhile'
   body:
        cmp SI, Mcolumn
        jl  short NotEndLine
        jmp short EndLine
        NotEndLine:
            itoa lineOut, [ebx]
            output lineOut
            inc SI
            jmp short theNext
        EndLine:
            mov SI, 1
            itoa lineOut, [ebx]
            output lineOut
            output carriage
        theNext:
        add ebx, 4
        inc DI
        jmp whileNotFinish
   endWhile:
   output carriage 
   ENDM

ComputeOutputGrid MACRO Nrow, Mcolumn, MandNTotal, inputArray
   lea EBX, inputArray
   mov EDI, EBX
   mov AX, 4
   mul MandNTotal
   movzx EAX, AX
   add EBX, EAX
   sub EBX, 4                         ; At Bottom Right Corner of Grid
   mov ArrayShift, EBX
   mov SI, Mcolumn                    ;Column Counter
   whileStillFilling: cmp EBX, EDI    ;Compare to see if finished with last square in grid
            jnl FillSquare
            jmp Finished
   FillSquare:
        cmp SI, 1
        jl  AddESICol
        jmp continueOn
        AddESICol:
            add SI, Mcolumn
            jmp continueOn
        continueOn:
        cmp EBX, ArrayShift           ;(Special Case Right-Bottom Corner)
        je RightBottom
        jmp NotRightBottom
        RightBottom:
            sub EBX, 4
            dec SI
            jmp whileStillFilling
        NotRightBottom:
            cmp SI, Mcolumn            ;Check to see if at far right
            je RightSide
            jmp CheckBottom
            RightSide:                    ;(Special Case Right-Side)
                mov AX, 4                 ;Check square under, see if > 0 if so add it
                mul Mcolumn
                movzx EAX, AX             ;
                mov EDX, EBX              ;EDX = CurrentPos
                add EBX, EAX              ;EBX BelowPos
                cmp DWORD PTR [EBX], 0    
                jg AddToSquare
                jmp DecreaseEBX
                AddToSquare:
                    mov ECX, [EBX]        ;mov BelowVal to ECX
                    mov EBX, EDX          
                    mov EDX, [EBX]        
                    mov EAX, ECX          
                    add EAX, EDX          
                    mov DWORD PTR [EBX], EAX   ;Putting V
                    sub EBX, 4
	                dec SI
                    jmp whileStillFilling
                DecreaseEBX:
                    dec SI
                    mov EBX, EDX
                    sub EBX, 4
                    jmp whileStillFilling
            CheckBottom:                    ;Check to see if at far bottom
                mov AX, 4
                mul Mcolumn 
                movzx EAX, AX
                mov ECX, EAX
                mov EAX, ArrayShift
                sub EAX, ECX
                cmp EBX, EAX
                jge AtBottom
                jmp NotAtBottomOrRight
                AtBottom:
                    dec SI
                    cmp DWORD PTR [EBX + 4], 0
                    jg AddToGrid2
                    jmp DecreaseEBX2
                    AddToGrid2:
                        mov ECX, [EBX]
                        mov EDX, [EBX + 4]
                        mov EAX, ECX
                        add EAX, EDX
                        mov DWORD PTR [EBX], EAX
                    DecreaseEBX2:
                        sub EBX, 4
                        jmp whileStillFilling
                NotAtBottomOrRight:     ;CHECK Right, Bottom See which is bigger value
                    dec SI
                    mov ECX, [EBX + 4]  ;Right = ECX
                    mov AX, 4
                    mul Mcolumn
                    movzx EAX, AX
                    add EAX, EBX 
                    mov EDX, EBX 
                    mov EBX, EAX 
                    mov EAX, [EBX] 
                    mov EBX, EDX  
                    mov EDX, EAX  
                    cmp ECX, EDX   
                    jge AddRight
                    jmp AddBottom
                    AddRight:
                        add ECX, [EBX] 
                        mov DWORD PTR [EBX], ECX
                        sub EBX, 4
                        jmp whileStillFilling
                    AddBottom:                         
                        add EDX, [EBX]      ;CurrentBox Val + Below Val = EDX
                        mov DWORD PTR [EBX], EDX
                        sub EBX, 4
                        jmp whileStillFilling
   Finished:
   ENDM

FindandDisplayPath MACRO Mcolumn, Nrow, inputArray  ;Special cases
   LOCAL whileLoop, NotFinished, StillNotFinished, GoRight, GoDown
   lea EBX, inputArray
   mov DI, 1
   mov SI, 1
   whileLoop: cmp DI, Nrow
        jl NotFinished
        jmp AtBottomRow
        NotFinished:
           cmp SI, Mcolumn
           jl  StillNotFinished
           jmp AtBottomColumn
           StillNotFinished:
                mov ECX, [EBX + 4]     
                mov AX, 4
                mul Mcolumn
                movzx EAX, AX
                mov EDX, EBX
                add EBX, EAX
                mov EAX, [EBX]
                cmp ECX, EAX
                jge GoRight
                jmp GoDown
                GoRight:
                   mov EBX, EDX
                   add EBX, 4
                   inc SI       ;Increment Column
                   output StrRight
                   jmp whileLoop
                GoDown:
                   mov EBX, EDX
                   mov AX, 4
                   mul Mcolumn
                   movzx EAX, AX
                   add EBX, EAX
                   inc DI       ;Inc row
                   output StrDown
                   jmp whileLoop               
           AtBottomColumn:
                mov AX, 4
                mul Mcolumn
                movzx EAX, AX
                add EBX, EAX
                cmp DWORD PTR [EBX], 0
                jge GoDown2
                jmp GoRightEnd
                GoDown2: 
                   output StrDown
                   inc DI
                   jmp whileLoop
                GoRightEnd:
                   output StrRight
                   inc SI
                   jmp DonePath
        AtBottomRow:
            cmp SI, Mcolumn
            jle CheckMore
            jmp DonePath
            CheckMore:
                mov EAX, [EBX + 4]
                cmp DWORD PTR EAX, 0
                jge GoRight2
                jmp GoDownEnd
                GoRight2:
                  output StrRight
                  inc SI
                  jmp whileLoop
                GoDownEnd:
                  output StrDown
                  inc DI
                  jmp DonePath
     DonePath:            
   ENDM

_start:
    GetMandN           Nrow, Mcolumn
    GetInputGrid       Nrow, Mcolumn, MandNTotal, inputArray
    DisplayInputGrid   Mcolumn, MandNTotal, inputArray
    ComputeOutputGrid  Nrow, Mcolumn, MandNTotal, inputArray
    DisplayInputGrid   Mcolumn, MandNTotal, inputArray
    FindandDisplayPath Mcolumn, Nrow, inputArray
    output carriage
    output carriage
    
    INVOKE	  ExitProcess, 0                 ; exit with return code 0

PUBLIC _start                                ; make entry point public

END                                          ; end of source code