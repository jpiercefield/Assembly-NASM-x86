;James Logan Piercefield 
;CSC 3040 - Assembly - Program 4
;Date: 11/14/2016
;Last Updated: 11/16/2016
.386
.MODEL FLAT
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h                           ; header file for input/output
INCLUDE debug.h
INCLUDE fallout_procs.h

STRLEN   EQU   13                      ;Length of string 11 characters  
MAXARRAY EQU   21                      ;Max Length of Array             

.STACK    4096                         ; reserve 4096-byte stack

.DATA 
szeAr         WORD     8  DUP (?)
tmp           WORD     8  DUP (?)
index         WORD     8  DUP (?)
matches       WORD     8  DUP (?)
lowSwap       WORD     8  DUP (?)
string        BYTE     8  DUP (?)
newSzeAr      BYTE     8  DUP (?)
inputArray    BYTE     STRLEN * MAXARRAY DUP (?)
indexMatch    BYTE     STRLEN * 2        DUP (?)
pt1           BYTE     "Enter a string: ", 0
pt2           BYTE     "The number of strings entered is ", 0
pt3           BYTE     "Enter the index for the test password (1-based): ", 0
pt4           BYTE     "Enter the number of exact character matches: ", 0
.CODE
_start:
	getInputArray inputArray, pt1, pt2, STRLEN ;Procedure- Returns InputArray & Size of Array in AL
	movzx AX, AL
	mov newSzeAr, AL 
	itoa string, AX
    output string
	while_loop: 
		mov AL, newSzeAr
		movzx AX, AL	
		mov szeAr, AX		
		outputArray inputArray, szeAr, STRLEN ;Procedure
		mov newSzeAr, 0
		cmp szeAr, 1
		jne begin_hack
		jmp done
		begin_hack: 
			inputIndexAndMatches pt3, pt4, STRLEN, indexMatch ;Procedure
			mov matches, AX      
			mov index, DX
			mov CX, 0 
			mov lowSwap, 0
			hack_loop: cmp CX, szeAr 
				jne tryNewPair
				jmp while_loop
				tryNewPair:
					lea ESI, inputArray
					mov AX, CX
					mov DX, STRLEN
					mul DX
					movzx EAX, AX
					add ESI, EAX			
					lea EDI, inputArray
					mov AX, index
					cmp AX, lowSwap
					je change_index
					jmp keep_index
					change_index:
						mov index, CX
						mov AX, CX
					keep_index:
					dec AX
					mov DX, STRLEN
					mul DX
					movzx EAX, AX
					add EDI, EAX				
					findNumCharMatches EDI, ESI, STRLEN ;Procedure - Number Character Matches
					cmp AX, matches
					je swap_words 
					jmp no_swap
					swap_words: 
						add newSzeAr, 1
						lea EDI, inputArray 
						mov AX, lowSwap
						mov DX, STRLEN
						mul DX
						movzx EAX, AX
						add EDI, EAX        
						swap EDI, ESI, STRLEN ;Procedure - SWAP 
						add lowSwap, 1
						jmp no_swap
					no_swap:
						inc CX
						jmp hack_loop	
	done:

 INVOKE	  ExitProcess, 0                              ; exit with return code 0
PUBLIC _start                                        ; make entry point public
END                                                 ; end of source code