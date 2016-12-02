; Plane-Line Intersection: Program 1 - Assembly 3410
; Author: James L. Piercefied
; Date: Start 9/6/2016 revised 9/6/2016

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h                       ; header file for input/output
INCLUDE debug.h

                                    ; simple text replacement
CR	EQU	0Dh                         ; carriage return character
LF	EQU	0Ah                         ; line feed  

.STACK 4096                         ; reserve 4096-byte stack

.DATA                               ; reserve storage for data
PA1           WORD  8 DUP (?)       ; word - 16 bits (2 Bytes) - Need 6 bytes to represent 16-bit integer as text. 6 + CR + LF = 8 bytes
PA2	          WORD  8 DUP (?)       ; word - 0, 2, 4, ..., 65534
PA3           WORD  8 DUP (?)
PB1           WORD  8 DUP (?)
PB2           WORD  8 DUP (?)
PB3           WORD  8 DUP (?)
PC1           WORD  8 DUP (?)
PC2           WORD  8 DUP (?)
PC3           WORD  8 DUP (?)
Pone1         WORD  8 DUP (?)
Pone2         WORD  8 DUP (?)
Pone3         WORD  8 DUP (?)
Ptwo1         WORD  8 DUP (?)
Ptwo2         WORD  8 DUP (?)
Ptwo3         WORD  8 DUP (?)
A1            WORD  8 DUP (?)
A2            WORD  8 DUP (?)
A3            WORD  8 DUP (?)
B1            WORD  8 DUP (?)
B2            WORD  8 DUP (?)
B3            WORD  8 DUP (?)
AB1           WORD  8 DUP (?)
AB2           WORD  8 DUP (?)
AB3           WORD  8 DUP (?)
Nprod         WORD  8 DUP (?)
Dprod         WORD  8 DUP (?)
FX            WORD  8 DUP (?)  ;FinalNumbers
FY            WORD  8 DUP (?)
FZ            WORD  8 DUP (?)
QX            WORD  8 DUP (?)  ;Quotients
QY            WORD  8 DUP (?)
QZ            WORD  8 DUP (?)
Re1           WORD  8 DUP (?)  ;Remainders
Re2           WORD  8 DUP (?)
Re3           WORD  8 DUP (?)
prompt1       BYTE  "Enter the x-coordinate of the point on the plane: ", 0
prompt2       BYTE	"Enter the y-coordinate of the point on the plane: ", 0
prompt3       BYTE	"Enter the z-coordinate of the point on the plane: ", 0
prompt4       BYTE	"Enter the x-coordinate of the point on the line:  ", 0
prompt5       BYTE	"Enter the y-coordinate of the point on the line:  ", 0
prompt6       BYTE	"Enter the z-coordinate of the point on the line:  ", 0
string        BYTE  8 DUP (?)                    ; fill all 8 bytes with unspecified 
coordinOut    BYTE  50 DUP (?)
coordinOut2   BYTE  50 DUP (?)

.CODE
DisplayXYZCoord   MACRO P1, P2, P3               ; A macro for displaying line of (x, y, z)
       output     carriage

       mov        coordinOut, "("
       itoa       coordinOut + 1, P1             ;6 Spaces to display integer
       mov        coordinOut + 7, ","   
       mov        coordinOut + 8, " "
       itoa       coordinOut + 9, P2
       mov        coordinOut + 15, ","
       mov        coordinOut + 16, " "
       itoa       coordinOut + 17, P3
       mov        coordinOut + 23, " "
       mov        coordinOut + 24, ")"
       output     coordinOut

       output     carriage

    ENDM
            
GetCoordinateData MACRO pr1, pr2, pr3, P1, P2, P3   ;A macro to output prompts for data, reads in the input
       output 	  pr1                               ; prompt for x-coord.
	   input      string, 8                         ; read ASCII characters
	   atod       string                            ; Convert to integer (atoi) - Word size. Default result in eax
	   mov	      P1, AX                            ; store in memory
       outputW    AX                                ; outputW (WORD) & outputD (DWORD) 

	   output     pr2                               ; prompt for y-coord.
	   input      string, 8
	   atod       string
	   mov        P2, AX
       outputW    AX	    
    
       output     pr3                              ;Prompt for z-coord.
       input      string, 8
       atod       string
       mov        P3, AX
       outputW    AX
       
       DisplayXYZCoord P1, P2, P3
       
    ENDM

GetPbMinusPa       MACRO PA1, PA2, PA3, PB1, PB2, PB3, A1, A2, A3 ;PB - PA
       atoi     PA1          ;Integer Convert
       atoi     PA2 
       atoi     PA3
       atoi     PB1
       atoi     PB2
       atoi     PB3
       mov      BX, PB1      ;Copy Value of PB1 into A1
       sub      BX, PA1      ;Subtract PA1 from A1
       mov      A1, BX       ;Store in memory
       mov      BX, PB2
       sub      BX, PA2
       mov      A2, BX
       mov      BX, PB3
       sub      BX, PA3
       mov      A3, BX
	   
    ENDM

GetPcMinusPa       MACRO PA1, PA2, PA3, PC1, PC2, PC3, B1, B2, B3 ;PC - PA
       atoi     PA1       ;Integer Convert
       atoi     PA2 
       atoi     PA3
       atoi     PC1
       atoi     PC2
       atoi     PC3
       mov      BX, PC1  ;Copy Value of PC1 into BX
       sub      BX, PA1  ;Subtract PA1 from BX
       mov      B1, BX   ;Store in memory
       mov      BX, PC2
       sub      BX, PA2
       mov      B2, BX
       mov      BX, PC3
       sub      BX, PA3
       mov      B3, BX

    ENDM

FindCrossProduct   MACRO A1, A2, A3, B1, B2, B3, AB1, AB2, AB3    ;Finds aXb, nested PB-PA & PC-PA Macros
       mov      BX, A2                       ;(a_y * b_z) - (a_z * b_y)
       imul     BX, B3
       mov      CX, A3
       imul     CX, B2
       sub      BX, CX
       mov      AB1, BX

       mov      BX, A3                       ;(a_z * b_x) - (a_x * b_z)
       imul     BX, B1
       mov      CX, A1
       imul     CX, B3
       sub      BX, CX
       mov      AB2, BX

       mov      BX, A1                      ;(a_x * b_y) - (a_y * b_x)
       imul     BX, B2
       mov      CX, A2
       imul     CX, B1
       sub      BX, CX
       mov      AB3, BX

    ENDM

ComputeNproduct MACRO PC1, PC2, PC3, Pone1, Pone2, Pone3, AB1, AB2, AB3, Nprod ;Macro for computing Nproduct
       mov      AX, PC1
       sub      AX, Pone1
       imul     AX, AB1

       mov      BX, PC2
       sub      BX, Pone2
       imul     BX, AB2
       add      AX, BX

       mov      BX, PC3
       sub      BX, Pone3
       imul     BX, AB3
       add      AX, BX

       mov      Nprod, AX

    ENDM

ComputeDproduct  MACRO Pone1, Pone2, Pone3, Ptwo1, Ptwo2, Ptwo3, AB1, AB2, AB3, Dprod ; Macro for computer Dproduct
       mov      AX, Ptwo1
       sub      AX, Pone1
       imul     AX, AB1

       mov      BX, Ptwo2     
       sub      BX, Pone2
       imul     BX, AB2
       add      AX, BX

       mov      BX, Ptwo3
       sub      BX, Pone3
       imul     BX, AB3
       add      AX, BX

       mov      Dprod, AX

    ENDM

ParametricStep  MACRO  Pone1, Pone2, Pone3, Ptwo2, Ptwo2, Ptwo3, Nprod, Dprod, FX, FY, FZ
       mov    AX, Dprod
       imul   AX, Pone1

       mov    BX, Nprod
       imul   BX, Pone1
       sub    AX, BX

       mov    BX, Nprod
       imul   BX, Ptwo1
       add    AX, BX
       mov    FX, AX

       mov    BX, Dprod
       imul   BX, Pone2
       
       mov    CX, Nprod
       imul   CX, Pone2
       sub    BX, CX

       mov    CX, Nprod
       imul   CX, Ptwo2
       add    BX, CX
       mov    FY, BX

       mov    CX, Dprod
       imul   CX, Pone3

       mov    DX, Nprod
       imul   DX, Pone3
       sub    CX, DX

       mov    DX, Nprod
       imul   DX, Ptwo3
       add    CX, DX
       mov    FZ, CX
          
    ENDM

FinalDivision MACRO Dprod, FX, FY, FZ, QX, QY, QZ, Re1, Re2, Re3, coordinOut2
     movsx EAX, word ptr [FX]   
     cwd
     idiv Dprod   
     mov QX, AX
     mov FX, DX
     movzx EAX, word ptr [FX]
     imul EAX, 100
     cwd
     idiv Dprod

     cmp AX, 0
     JL  short L1
     jmp short L2 
 L1:
   imul AX, -1
   mov Re1, AX
 L2:
   mov Re1, AX 
     
     movsx EAX, word ptr [FY]   
     cwd
     idiv Dprod   

     mov QY, AX
     mov FY, DX
     movzx EAX, word ptr [FY]
     imul EAX, 100
     cwd
     idiv Dprod
    
     cmp AX, 0
     JL  short L3
     jmp short L4 
 L3:
   imul AX, -1
   mov Re2, AX
 L4:
   mov Re2, AX

     movsx EAX, word ptr [FZ]   
     cwd
     idiv Dprod   

     mov QZ, AX
     mov FZ, DX
     movzx EAX, word ptr [FZ]
     imul EAX, 100
     cwd
     idiv Dprod
    
     cmp AX, 0
     JL  short L5
     jmp short L6 
 L5:
   imul AX, -1
   mov Re3, AX
 L6: 
   mov Re3, AX

     mov      coordinOut2 + 30, ")"
     itoa     coordinOut2 + 24, Re3
     mov      coordinOut2 + 27, "."
     itoa     coordinOut2 + 21, QZ
     mov      coordinOut2 + 20, ","
     itoa     coordinOut2 + 14, Re2
     mov      coordinOut2 + 17, "."
     itoa     coordinOut2 + 11, QY
     mov      coordinOut2 + 10, ","
     itoa     coordinOut2 + 4, Re1
     mov      coordinOut2 + 7, "."
     itoa     coordinOut2 + 1, QX
     mov      coordinOut2, "("
     output   carriage
     output   carriage
     output   coordinOut2
     output   carriage
     
    ENDM

_start:                       ; Main Start of Program                                              
    GetCoordinateData prompt1, prompt2, prompt3, PA1, PA2, PA3                         ; Prompt User for X,Y,Z input, and store information
    GetCoordinateData prompt1, prompt2, prompt3, PB1, PB2, PB3
    GetCoordinateData prompt1, prompt2, prompt3, PC1, PC2, PC3
    GetCoordinateData prompt4, prompt5, prompt6, Pone1, Pone2, Pone3
    GetCoordinateData prompt4, prompt5, prompt6, Ptwo1, Ptwo2, Ptwo3

    GetPbMinusPa PA1, PA2, PA3, PB1, PB2, PB3, A1, A2, A3                              ; Calling macro for finding PB-PA
    GetPcMinusPa PA1, PA2, PA3, PC1, PC2, PC3, B1, B2, B3                              ; Calling macro for finding PC-PA

    FindCrossProduct A1, A2, A3, B1, B2, B3, AB1, AB2, AB3                             ; Calling macro for cross product aXb

    ComputeNproduct PC1, PC2, PC3, Pone1, Pone2, Pone3, AB1, AB2, AB3, Nprod           ; Calling macro to computer Nproduct (numerator)

    ComputeDproduct Pone1, Pone2, Pone3, Ptwo1, Ptwo2, Ptwo3, AB1, AB2, AB3, Dprod     ; Calling macro to compute Dproduct

    ParametricStep Pone1, Pone2, Pone3, Ptwo2, Ptwo2, Ptwo3, Nprod, Dprod, FX, FY, FZ  ; Parametric (Division Last!) adP = adP1 - anP1 + anP2
      
    FinalDivision Dprod, FX, FY, FZ, QX, QY, QZ, Re1, Re2, Re3, coordinOut2
        
	INVOKE	  ExitProcess, 0                 ; exit with return code 0

PUBLIC _start                                ; make entry point public

END                                          ; end of source code