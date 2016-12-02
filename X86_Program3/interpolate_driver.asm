; Newton's Interpolating Polynomials: Program 3 - Assembly 3410
; Author: James L. Piercefied
; Date: *Start*- 10/22/2016 *Revised*- 10/27/2016

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h                           ; header file for input/output
INCLUDE debug.h
INCLUDE compare_floats.h
INCLUDE interpolate.h
INCLUDE float.h
INCLUDE sort_points.h

                                       ; simple text replacement
CR	EQU	0Dh                            ; carriage return character
LF	EQU	0Ah                            ; line feed  

MAXNBRS   EQU   40                     ; Max size of array - Can have 20 points (X,Y) = 40 Total #'s

.STACK    4096                         ; reserve 4096-byte stack

.DATA                                  ; Reserve storage for data - Order - REAL4(?), DWORD, WORD, BYTE
xCoord        REAL4   0.0          
tempFloat     REAL4   0.0
tolerance     REAL4   0.0001            ; How close 2 numbers need to be in order to be equal
inputArray    DWORD   MAXNBRS  DUP (?) ; Array Storing Points (X=0, Y=1)
CurrentDeg    WORD    8        DUP (?)     
Degree        WORD    8        DUP (?)
sizeOfArray   WORD    8        DUP (?) 
numPoints     WORD    8        DUP (?) ; sizeOfArray/2
CurTimes      WORD    8        DUP (?)
CurIndex      WORD    8        DUP (?)
InLim         WORD    8        DUP (?)
string        BYTE    8        DUP (?) 
prompt1       BYTE    "Enter the x-coordinate of the desired interpolated y. ", 0Dh, 0Ah, 0
prompt2       BYTE    "Enter the degree of the interpolating polynomial. ", 0Dh, 0Ah, 0
prompt3       BYTE    "You may enter up to 20 points, one at a time. ", 0Dh, 0Ah, 0
prompt4       BYTE    "Input q to quit. ", 0Dh, 0Ah, 0
quitStr       BYTE    "q", 0Dh, 0Ah, 0

.CODE
GetInputValues   MACRO
   output    prompt1
   input     string, 8
   output    string
   atof      string, xCoord
   output    carriage
   output    prompt2
   input     string, 8
   output    string
   atod      string         ; Default to EAX
   mov       Degree, AX  
   output    carriage
   output    prompt3
   output    prompt4
   lea EBX, inputArray 
   mov DI, 0     
   inputLoop:
       input string, 8
       cmp string[0], 'q'
       je equalToQuit
       jmp notEqualToQuit
       equalToQuit:
            output quitStr
            jmp done
       notEqualToQuit:
            inc DI
            atof string, tempFloat
            mov EAX, tempFloat
            mov [EBX], EAX
            output string
            output carriage
            cmp DI, 40
            je equalToQuit
            add EBX, 4 
            jmp inputLoop
   done:
   mov sizeOfArray, DI
   mov AX, sizeOfArray
   mov BL, 2
   div BL
   mov numPoints, AX
   mov CurrentDeg, 1 
   mov CurIndex, 4
   mov CurTimes, 0
   mov InLim, 1
ENDM 

_start:
    GetInputValues                                        ; Get Full Input
    sort_points inputArray, xCoord, tolerance, numPoints  ; Sort Array (sort_points.h)
    output carriage 
    print_points inputArray, numPoints                    ; Print Sorted Array                                  
    interpolate_start inputArray, xCoord, sizeOfArray, Degree, CurrentDeg, CurTimes, CurIndex, InLim

    INVOKE	  ExitProcess, 0                              ; exit with return code 0

PUBLIC _start                                             ; make entry point public

END                                          ; end of source code