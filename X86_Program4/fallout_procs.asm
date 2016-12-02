.386
.MODEL FLAT

INCLUDE io.h
INCLUDE debug.h


PUBLIC getInputArray_proc, outputArray_proc, inputIndexAndMatches_proc, findNumCharMatches_proc, swap_proc

.CODE

STRLEN      EQU [EBP + 20]  
pt1         EQU [EBP + 16]  
pt2         EQU [EBP + 12]  
inputArray  EQU [EBP + 8]   
;Returns Number Of Strings in Al, Also Fills inputArray
getInputArray_proc PROC NEAR32
	push EBP
    mov  EBP, ESP
	push EDI
	push ESI
    pushf
    mov Al, 0
	mov EBX, inputArray
	mov ESI, pt1
    mov EDI, pt2 
    output BYTE PTR [ESI]
	input BYTE PTR [EBX], STRLEN
	while_loop: cmp BYTE PTR [EBX], 'x'
		jne AnotherInput
        jmp Done
		AnotherInput:
			INC Al
            output BYTE PTR [EBX]
			add EBX, STRLEN

			output carriage

			output BYTE PTR [ESI]
            input BYTE PTR [EBX], STRLEN
            jmp while_loop
	Done:
		output BYTE PTR [EBX]		
		output carriage
		output carriage
        output BYTE PTR [EDI]

	popf
	pop ESI
	pop EDI
    mov ESP, EBP
    pop EBP
    ret 14
getInputArray_proc ENDP

STRLEN     EQU [EBP + 14]
szeAr      EQU [EBP + 12]
array      EQU [EBP + 8]
outputArray_proc PROC NEAR32
	push EBP
    mov EBP, ESP
	push ECX
    pushf
	output carriage
	output carriage
	mov CX, 0

    mov EBX, inputArray
    output_loop: cmp CX, szeAr
		jne KeepOut
        jmp FinishOut
        KeepOut:
			output carriage
			output BYTE PTR [EBX]			
            add EBX, STRLEN
            inc CX
            jmp output_loop
	FinishOut:
		
    popf
	pop ECX
    mov ESP, EBP
    pop EBP
    ret 8
outputArray_proc ENDP

; Returns: DX = index, AX Contains Matches,
; and indexMatch contains ASCII Values of Both (INDEX(STRLEN)MATCHES(STRLEN))
STRLEN     EQU [EBP + 20]
pt3        EQU [EBP + 16]
pt4        EQU [EBP + 12]
indexMatch EQU [EBP + 8]
inputIndexAndMatches_proc PROC NEAR32
	push EBP
    mov EBP, ESP
	push EDI
    pushf
	
	mov EBX, indexMatch
	mov EDI, pt3
	output carriage
	output BYTE PTR [EDI]

	input BYTE PTR [EBX], STRLEN

	output BYTE PTR [EBX]
	output carriage

	add EBX, STRLEN
	mov EDI, pt4
	output BYTE PTR [EDI]
	input BYTE PTR [EBX], STRLEN
	output BYTE PTR [EBX]

	mov EBX, indexMatch
	atoi BYTE PTR [EBX]
    mov DX, AX
	
	add EBX, STRLEN
	atoi BYTE PTR [EBX]

	popf
	pop EDI
    mov ESP, EBP
    pop EBP
    ret 14
inputIndexAndMatches_proc ENDP


;Num Character Matches in AL
STRLEN     EQU [EBP + 16]
CompareStr EQU [EBP + 12]
IndexStr   EQU [EBP + 8]
findNumCharMatches_proc PROC NEAR32
	push EBP
	mov EBP, ESP
    push ECX
	push EDI
	push ESI
    pushf

	mov EDI, IndexStr
	mov ESI, CompareStr

    cld
    mov CX, STRLEN
	movzx ECX, CX
    sub ECX, 2
	mov AL, 0
	XOR AL, AL
    Again_loop: JCXZ Done
	REPNE CMPSB
        JNE Done
        INC AL
        JMP Again_loop
    Done:

	movzx AX, AL
	
	popf
	pop ESI
	pop EDI
    pop ECX
	mov ESP, EBP
    pop EBP
    ret 10
findNumCharMatches_proc ENDP

STRLEN      EQU [EBP + 16]
source      EQU [EBP + 12]
destination EQU [EBP + 8]
swap_proc PROC NEAR32
	push EBP
	mov EBP, ESP
	push EDI
	push ESI
	push ECX
    pushf

	mov EDI, source
	mov ESI, destination

    mov CX, STRLEN
	movzx ECX, CX
	while_loop: cmp ECX, 2
		jne continue_loop
		jmp Done
		continue_loop:
			lodsb
			dec ESI
			xchg ESI, EDI
			movsb
			dec ESI
			xchg ESI, EDI
			stosb
			dec ECX
			jmp while_loop
	Done:

    popf
	pop ECX
	pop EDI
	pop ESI
    mov ESP, EBP
    pop EBP
    ret 10
swap_proc ENDP

END