.NOLIST
.386

EXTRN getInputArray_proc:NEAR32
EXTRN outputArray_proc:NEAR32
EXTRN inputIndexAndMatches_proc:NEAR32
EXTRN findNumCharMatches_proc:NEAR32
EXTRN swap_proc:NEAR32

INCLUDE io.h

;Return Number Of Strings In AL, Also Fills inputArray
getInputArray MACRO inputArray, pt1, pt2, STRLEN, xtra
	IFB <inputArray>
		.ERR <Missing "inputArray" in getInputArray>
	ELSEIFB <pt1>
		.ERR <Missing "pt1" in getInputArray>
	ELSEIFB <pt2>
		.ERR <Missing "pt2" in getInputArray>
	ELSEIFB <STRLEN>
		.ERR <Missing "STRLEN" in getInputArray>
	ELSEIFNB <xtra>
		.ERR <Too many parameters in getInputArray>
	ELSE
        push ebx

			push STRLEN
			lea EBX, pt1
            push EBX
            lea EBX, pt2
            push EBX
			lea EBX, inputArray
            push EBX
            call getInputArray_proc

        pop ebx
	ENDIF
ENDM

outputArray MACRO inputArray, szeAr, STRLEN, xtra
	IFB <inputArray>
		.ERR <Missing "inputArray" in outputArray>
	ELSEIFB <szeAr>
		.ERR <Missing "szeAr" in outputArray>
	ELSEIFB <STRLEN>
		.ERR <Missing "STRLEN" in outputArray>
	ELSEIFNB <xtra>
		.ERR <Too many parameters in outputArray>
	ELSE
		push ebx
	
			push STRLEN
			push szeAr
			lea EBX, inputArray
			push EBX
			call outputArray_proc

		pop ebx
	ENDIF		
ENDM

;Returns: ECX = ((index-1)*STRLEN), AX Contains Matches,
;indexMatch contains ASCII Values of Both
inputIndexAndMatches MACRO pt3, pt4, STRLEN, indexMatch, xtra
	IFB <pt3>
		.ERR <Missing "pt3" in inputIndexAndMatches>
	ELSEIFB <pt4>
		.ERR <Missing "pt4" in inputIndexAndMatches>
	ELSEIFB <STRLEN>
		.ERR <Missing "STRLEN" in inputIndexAndMatches>
	ELSEIFB <indexMatch>
		.ERR <Missing "indexMatch" in inputIndexAndMatches>
	ELSEIFNB <xtra>
		.ERR <Too many parameters in inputIndexAndMatches>
	ELSE
		push ebx
			
			push STRLEN
			lea EBX, pt3
			push EBX
			lea EBX, pt4
			push EBX
			lea EBX, indexMatch
			push EBX
			call inputIndexAndMatches_proc

		pop ebx
	ENDIF
ENDM

;Returns Number of Character Matches in AX
findNumCharMatches MACRO indexString, compareString, STRLEN, xtra
	IFB <indexString>
		.ERR <Missing "indexString" in findNumCharMatches>
	ELSEIFB <compareString>
		.ERR <Missing "compareString" in findNumCharMatches>
	ELSEIFB <STRLEN>
		.ERR <Missing "STRLEN" in findNumCharMatches>
	ELSEIFNB <xtra>
		.ERR <Too many parameters in findNumCharMatches>
	ELSE
		push ebx

			push STRLEN
			mov EBX, indexString
			push EBX
			mov EBX, compareString
			push EBX
			call findNumCharMatches_proc

		pop ebx
	ENDIF
ENDM

swap MACRO source, destination, STRLEN, xtra
    IFB <source>
		.ERR <Missing "source" in swap>
	ELSEIFB <destination>
		.ERR <Missing "destination" in swap>
	ELSEIFB <STRLEN>
		.ERR <Missing "STRLEN" in swap >
	ELSEIFNB <xtra>
		.ERR <Too many parameters in swap>
	ELSE
		push ebx

			push STRLEN
			mov EBX, source
			push EBX
			mov EBX, destination
			push EBX
			call swap_proc

		pop ebx
	ENDIF
ENDM
.NOLISTMACRO
.LIST