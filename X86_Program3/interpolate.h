.NOLIST
.386

EXTRN interpolate_proc:Near32

INCLUDE io.h


interpolate_start MACRO inputArray, xCoord, sizeOfArray, Degree, CurrentDeg, CurTimes, CurIndex, InLim
            push ebx

				lea ebx, inputArray
                push ebx
                push xCoord
                pushw sizeOfArray
                pushw Degree
                pushw CurrentDeg
                pushw CurTimes
                pushw CurIndex
                pushw InLim
                call interpolate_proc

            pop ebx
    ENDM

.NOLISTMACRO
.LIST