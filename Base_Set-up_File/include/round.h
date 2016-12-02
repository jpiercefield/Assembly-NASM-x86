.NOLIST     ; turn off listing
.386

EXTRN round_proc:Near32

; the round macro assumes that dividend and divisor are WORDs
; the corrected dividend is in ax

round       	MACRO   dividend, divisor, xtra

                   IFB <dividend>
                      .ERR <missing "dividend" operand in round>
                   ELSEIFB <divisor>
                      .ERR <missing "divisor" operand in round>
                   ELSEIFNB <xtra>
                      .ERR <extra operand(s) in round>
                   ELSE

                      push dividend
                      push divisor
                      call round_proc

                   ENDIF

                ENDM

.NOLISTMACRO ; suppress macro expansion listings
.LIST        ; begin listing